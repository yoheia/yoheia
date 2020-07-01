import os
import zlib
import boto3
import base64
import json
import csv
import ftplib
from datetime import datetime, timedelta
import aws_encryption_sdk
from Crypto.Cipher import AES
from aws_encryption_sdk import DefaultCryptoMaterialsManager
from aws_encryption_sdk.internal.crypto import WrappingKey
from aws_encryption_sdk.key_providers.raw import RawMasterKeyProvider
from aws_encryption_sdk.identifiers import WrappingAlgorithm, EncryptionKeyType
from typing import Optional
from dataclasses import dataclass
import gzip
import json
from json.decoder import WHITESPACE

ftp_server = os.environ['FTP_SERVER']
username = os.environ['FTP_USER']
password = os.environ['FTP_PASSWD']
remote_directory = os.environ['FTP_REMOTE_DIR']
local_directory = os.environ['LOCAL_DIR']
key_id = os.environ['KMS_KEY_ID']
stream_name = os.environ['KINESIS_STREAM_NAME']
region_name = os.environ['REGEION']
cluster_id = os.environ['APG_CLUSTER_ID']
csvfile_prefix = 'apg_activitystream_' + cluster_id + '_'
fieldnames = ['logTime', 'serverHost', 'remoteHost', 'databaseName', 'serviceName', 'dbUserName', 'clientApplication', 'commandText', 'rowCount']
csvfile_row_cnt = 10

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


# ref. https://qiita.com/elyunim26/items/a513226b76b3cb8928c2
@dataclass
class S3Manager:
    source_bucket: str
    source_prefix: str
    profile: Optional[str] = None

    def _session(self):
        s = boto3.session.Session(
            profile_name=self.profile
        )
        return s

    def _list_source(self, *, accumulated=None, next_token=None, func=None):
        s3client = self._session().client('s3')
        if next_token:
            response = s3client.list_objects_v2(
                Bucket=self.source_bucket,
                Prefix=self.source_prefix,
                ContinuationToken=next_token,
            )
        else:
            response = s3client.list_objects_v2(
                Bucket=self.source_bucket,
                Prefix=self.source_prefix,
            )

        if 'Contents' in response:
            keys = [i['Key'] for i in response['Contents']]
        else:
            keys = []

        if 'NextContinuationToken' in response:
            next_token = response['NextContinuationToken']
        else:
            next_token = None

        if func:
            return func(response=response, keys=keys, func=func, next_token=next_token, accumulated=accumulated)

    def _accumulate(self, *, response, keys, func, next_token, accumulated):
        got_keys = (accumulated or []) + keys
        if next_token:
            print(f'searching... current fetch keys are :{len(got_keys)}')
            return self._list_source(accumulated=got_keys, next_token=next_token, func=func)
        else:
            return got_keys

    def list_all(self) -> list:
        return self._list_source(func=self._accumulate)

    def _delete(self, *, response, keys, func, next_token, accumulated):
        if keys:
            print(f'deleting: {self.source_bucket}/{self.source_prefix}')
            s3client = boto3.Session().client('s3')
            s3client.delete_objects(
                Bucket=self.source_bucket,
                Delete={
                    'Objects': [{'Key': key} for key in keys],
                    'Quiet': False
                },
            )

        if next_token:
            return self._list_source(next_token=next_token, func=func)

    def delete_all(self) -> None:
        self._list_source(func=self._delete)

    def list_all_test(self):
        s3_resource = self._session().resource('s3')
        a = s3_resource.Bucket(self.source_bucket).objects.filter(Prefix=self.source_prefix)
        b = [k.key for k in a]
        print(len(b))

    def download_file(self, key, dst_path) -> None:
        s3_resource = self._session().resource('s3')
        s3_resource.meta.client.download_file(self.source_bucket, key, dst_path)
        #print(f'downloading: {self.source_bucket}/{key}')

def loads_iter(s):
        size = len(s)
        decoder = json.JSONDecoder()

        end = 0
        while True:
            idx = WHITESPACE.match(s[end:]).end()
            i = end + idx
            if i >= size:
                break
            ob, end = decoder.raw_decode(s, i)
            yield ob

if __name__ == '__main__':

    # 現在日時取得
    dt_now = datetime.now()
    #tomorrow = dt_now - timedelta(days=1)
    tomorrow = dt_now
    year = tomorrow.year
    month = tomorrow.month
    day = tomorrow.day

    if not os.path.exists(local_directory):
        os.makedirs(local_directory)

    session = boto3.session.Session()
    kms = session.client('kms', region_name=region_name)

    csvfile_name = csvfile_prefix + datetime.now().strftime("%Y%m%d-%H%M%S")
    csvfile = open(csvfile_name, 'w')
    writer = csv.writer(csvfile,lineterminator='\n', quoting=csv.QUOTE_NONNUMERIC)

    # 前日分のログをS3からダウンロード
    s3 = S3Manager(
        source_bucket='aurora-postgres-activity-stream-az-tokyo',
        source_prefix="aws-rds-das-cluster-KGKBVXA3OLPRPZH66XFBDPWQUI/success/{0}/{1:0=2}/{2:0=2}/".format(year, month, day),
    )
    s3_obj_list = s3.list_all()
    for item in s3_obj_list:
        basename = os.path.basename(item)
        local_path = local_directory + '/' + basename
        s3.download_file(item, local_path)
        with gzip.open(local_path, mode='rt', encoding='utf-8') as f:
#        with gzip.open("log/aws-rds-das-cluster-KGKBVXA3OLPRPZH66XFBDPWQUI-kfh-1-2020-07-01-18-05-42-65c1a636-4668-4d18-9ba8-3eed19013007.gz", mode='rt', encoding='utf-8') as f:
            data = f.read()
            records = loads_iter(data)
            for record_data in records:
                key = record_data['key']
                decoded = base64.b64decode(record_data['databaseActivityEvents'])
                decoded_data_key = base64.b64decode(record_data['key'])
                decrypt_result = kms.decrypt(CiphertextBlob=decoded_data_key,EncryptionContext={"aws:rds:dbc-id":cluster_id})
                plaintext = decrypt_result[u'Plaintext']
                decoded_data = decrypt(decoded, decrypt_result[u'Plaintext'])
                decoded = base64.b64decode(record_data['databaseActivityEvents'])
                decoded_data_key = base64.b64decode(record_data['key'])
                decrypt_result = kms.decrypt(CiphertextBlob=decoded_data_key,EncryptionContext={"aws:rds:dbc-id":cluster_id})
                plaintext = decrypt_result[u'Plaintext']
                decoded_data = decrypt(decoded, decrypt_result[u'Plaintext'])
                if decoded_data is not None:
                    row = []
                    json_object = json.loads(json.dumps(decoded_data))
                    print(json_object)
                    for fieldname in fieldnames:
                        row.append(json_object.get(fieldname))
                        writer.writerow(row)
# 解凍・復号・CSV に変換
    # FTP で転送



    """
    session = boto3.session.Session()
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

    csvfile_name = csvfile_prefix + datetime.now().strftime("%Y%m%d-%H%M%S")
    csvfile = open(csvfile_name, 'w')
    writer = csv.writer(csvfile,lineterminator='\n', quoting=csv.QUOTE_NONNUMERIC)
    writer.writerow(fieldnames)
    cnt = 0
    while True:
        if cnt >= csvfile_row_cnt:
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
                decoded_data = decrypt(decoded, decrypt_result[u'Plaintext'])
                if decoded_data is not None:
                    cnt += 1
                    row = []
                    json_object = json.loads(json.dumps(decoded_data))
                    for fieldname in fieldnames:
                        row.append(json_object.get(fieldname))
                    writer.writerow(row)
            shard_it[shared_iterator] = response["NextShardIterator"]
    with open(csvfile_name, "rb") as f:
        ftp = ftplib.FTP(ftp_server)
        ftp.login(username, password)
        ftp.cwd(remote_directory)
        ftp.storbinary("STOR " + remote_directory + csvfile_name, f)   
    """
