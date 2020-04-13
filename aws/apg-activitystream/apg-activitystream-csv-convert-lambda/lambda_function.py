import zlib
import boto3
import base64
import json
import os
import aws_encryption_sdk
import hashlib
from dateutil import parser
from aws_encryption_sdk import DefaultCryptoMaterialsManager
from aws_encryption_sdk.internal.crypto import WrappingKey
from aws_encryption_sdk.key_providers.raw import RawMasterKeyProvider
from aws_encryption_sdk.identifiers import WrappingAlgorithm, EncryptionKeyType

key_id = os.environ['KEY_ID']
stream_name = os.environ['STREAM_NAME']
region_name = os.environ['AWS_REGION']
cluster_id = os.environ['CLUSTER_ID']

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
            print(decompressed_database_stream)
            record_event = json.loads(decompressed_database_stream.decode("utf-8"))
            for evt in record_event['databaseActivityEventList']:
                if evt['type'] != "heartbeat":
                    entries.append(evt)
        if len(entries) > 0:
#            return entries
            return evt
        else:
            return None

def lambda_handler(event, context):
    output = []
    succeeded_record_cnt = 0
    failed_record_cnt = 0
    kms = boto3.client('kms')

    for record in event['records']:
        print(record['recordId'])
        record_data = json.loads(base64.b64decode(record['data']))
        decoded = base64.b64decode(record_data['databaseActivityEvents'])
        decoded_data_key = base64.b64decode(record_data['key'])
        decrypt_key = kms.decrypt(CiphertextBlob=decoded_data_key,
                                     EncryptionContext={"aws:rds:dbc-id": cluster_id})
        decrypt_data = decrypt(decoded, decrypt_key[u'Plaintext'])
        json_enc = json.loads(json.dumps(decrypt_data))
        print(json_enc)
        if json_enc is not None:
            output_record = {
                'recordId': record['recordId'],
                'result': 'Ok',
                'data': base64.b64encode(json.dumps(json_enc).encode('utf-8')).decode('utf-8')
            }
            output.append(output_record)

    return {'records': output}

