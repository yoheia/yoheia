import zlib
import boto3
import base64
import json
import csv
import ftplib
import aws_encryption_sdk
from Crypto.Cipher import AES
from aws_encryption_sdk import DefaultCryptoMaterialsManager
from aws_encryption_sdk.internal.crypto import WrappingKey
from aws_encryption_sdk.key_providers.raw import RawMasterKeyProvider
from aws_encryption_sdk.identifiers import WrappingAlgorithm, EncryptionKeyType

ftp_server = os.environ['FTP_SERVER']
username = os.environ['FTP_USER']
password = os.environ['FTP_PASSWD']
remote_directory = os.environ['FTP_REMOTE_DIR']
key_id = os.environ['KMS_KEY_ID']

stream_name = os.environ['KINESIS_STREAM_NAME']
region_name = 'ap-northeast-1'
cluster_id = os.environ['APG_RESOURCE_ID']

class MyRawMasterKeyProvider(RawMasterKeyProvider):
    provider_id = "BC"

    def __new__(cls, *args, **kwargs):
        obj = super(RawMasterKeyProvider, cls).__new__(cls)
        return obj

    def __init__(self, wrapping_key):
        RawMasterKeyProvider.__init__(self)
        self.wrapping_key = wrapping_key

    def _get_raw_key(self, key_id):
        return self.wrapping_key


def decrypt(decoded, plaintext):
    wrapping_key = WrappingKey(wrapping_algorithm=WrappingAlgorithm.AES_256_GCM_IV12_TAG16_NO_PADDING,
                               wrapping_key=plaintext, wrapping_key_type=EncryptionKeyType.SYMMETRIC)
    my_key_provider = MyRawMasterKeyProvider(wrapping_key)
    my_key_provider.add_master_key("DataKey")
    with aws_encryption_sdk.stream(
            mode='d',
            source=decoded,
            materials_manager=DefaultCryptoMaterialsManager(master_key_provider=my_key_provider)
    ) as decryptor:
        entries = []
        for chunk in decryptor:
            d = zlib.decompressobj(16 + zlib.MAX_WBITS)
            decompressed_database_stream = d.decompress(chunk)
            record_event = json.loads(decompressed_database_stream.decode("utf-8"))
            for evt in record_event['databaseActivityEventList']:
                if evt['type'] != "heartbeat":
                    entries.append(evt)
        if len(entries) > 0:
            return evt
        else:
            return None

if __name__ == '__main__':
    session = boto3.session.Session(
    )

    kms = session.client('kms', region_name=region_name)

    client = session.client('kinesis', region_name=region_name)

    response = client.describe_stream(StreamName=stream_name)
    shard_it = {}
    for idx, shard in enumerate(response['StreamDescription']['Shards']):
        shared_iterator = client.get_shard_iterator(
            StreamName=stream_name,
            ShardId=response['StreamDescription']['Shards'][idx]['ShardId'],
            ShardIteratorType='LATEST',
        )["ShardIterator"]
        shard_it[idx] = shared_iterator

    fieldnames = ['logTime', 'serverHost', 'remoteHost', 'databaseName', 'serviceName', 'dbUserName', 'clientApplication', 'commandText', 'rowCount']
    csvfile = open('./activitystream.csv', 'w')
    writer = csv.writer(csvfile,lineterminator='\n', quoting=csv.QUOTE_NONNUMERIC)
    writer.writerow(fieldnames)
    cnt = 0
    while True:
        rows = []
        if cnt >= 10:
            csvfile.close()
            break
        for shared_iterator in shard_it:
            response = client.get_records(ShardIterator=shard_it[shared_iterator], Limit=10000)
            for record in response['Records']:
                record_data = record['Data']
                record_data = json.loads(record_data)
                key = record_data['key']
                decoded = base64.b64decode(record_data['databaseActivityEvents'])
                decoded_data_key = base64.b64decode(record_data['key'])
                decrypt_result = kms.decrypt(CiphertextBlob=decoded_data_key,EncryptionContext={"aws:rds:dbc-id":cluster_id})
                plaintext = decrypt_result[u'Plaintext']
                obj = decrypt(decoded, decrypt_result[u'Plaintext'])
                if obj is not None:
                    cnt += 1
                    json_enc = json.dumps(obj)
                    json_object = json.loads(json_enc)
                    row=[]
                    for fieldname in fieldnames:
                        row.append(json_object.get(fieldname))
                    writer.writerow(row)
            shard_it[shared_iterator] = response["NextShardIterator"]
    with open('./activitystream.csv', "rb") as f:
        ftp = ftplib.FTP(ftp_server)
        ftp.login(username, password)
        ftp.cwd(remote_directory)
        ftp.storbinary("STOR " + remote_directory + 'activitystream.csv', f) 
