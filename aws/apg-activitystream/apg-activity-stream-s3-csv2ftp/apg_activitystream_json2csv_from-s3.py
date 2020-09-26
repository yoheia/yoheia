#!/usr/bin/env python
import os
import zlib
import gzip
import boto3
import base64
import json
import csv
import ftplib
from datetime import datetime, timedelta
from typing import Optional
from dataclasses import dataclass
from json.decoder import WHITESPACE
import aws_encryption_sdk
from Crypto.Cipher import AES
from aws_encryption_sdk import DefaultCryptoMaterialsManager
from aws_encryption_sdk.internal.crypto import WrappingKey
from aws_encryption_sdk.key_providers.raw import RawMasterKeyProvider
from aws_encryption_sdk.identifiers import WrappingAlgorithm, EncryptionKeyType

# 環境変数
log_directory = os.environ['LOG_DIR']
csv_directory = os.environ['CSV_DIR']
s3_bucket = os.environ['S3_BUCKET']
s3_prefix = os.environ['S3_PREFIX']
key_id = os.environ['KMS_KEY_ID']
stream_name = os.environ['KINESIS_STREAM_NAME']
region_name = os.environ['REGEION']
cluster_id = os.environ['APG_CLUSTER_ID']

ftp_server = os.environ['FTP_SERVER']
username = os.environ['FTP_USER']
password = os.environ['FTP_PASSWD']
remote_directory = os.environ['FTP_REMOTE_DIR']

# CSV ファイルのプリフィックス
csvfile_prefix = 'apg_activitystream_' + cluster_id + '_'
# CSV の列名
#fieldnames = ['logTime', 'statementId', 'substatementId', 'objectType', 'command', 'objectName', 'databaseName', 'dbUserName', 'remoteHost', 'remotePort', 'sessionId', 'rowCount', 'commandText', 'paramList', 'pid', 'clientApplication', 'exitCode', 'class', 'serverVersion', 'serverType', 'serviceName', 'serverHost', 'netProtocol', 'dbProtocol', 'type', 'startTime', 'errorMessage']
fieldnames = ['logTime', 'serverHost', 'remoteHost', 'databaseName', 'serviceName', 'dbUserName', 'clientApplication', 'commandText', 'rowCount']


class MyRawMasterKeyProvider(RawMasterKeyProvider):
    """Aurora アクティビティストリームの KMS CMK で暗号化されたデータを復号するクラス
    ref. https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/AuroraUserGuide/DBActivityStreams.html
    """

    provider_id = "BC"

    def __new__(cls, *args, **kwargs):
        obj = super(RawMasterKeyProvider, cls).__new__(cls)
        return obj

    def __init__(self, plain_key):
        RawMasterKeyProvider.__init__(self)
        self.wrapping_key = WrappingKey(wrapping_algorithm=WrappingAlgorithm.AES_256_GCM_IV12_TAG16_NO_PADDING,
                                        wrapping_key=plain_key, wrapping_key_type=EncryptionKeyType.SYMMETRIC)

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

def decrypt_payload(payload, data_key):
    my_key_provider = MyRawMasterKeyProvider(data_key)
    my_key_provider.add_master_key("DataKey")
    decrypted_plaintext, header = aws_encryption_sdk.decrypt(
        source=payload,
        materials_manager=aws_encryption_sdk.DefaultCryptoMaterialsManager(master_key_provider=my_key_provider))
    return decrypted_plaintext


def decrypt_decompress(payload, key):
    decrypted = decrypt_payload(payload, key)
    return zlib.decompress(decrypted, zlib.MAX_WBITS + 16)

@dataclass
class S3Manager:
    """S3 を扱うクラス
    ref. https://qiita.com/elyunim26/items/a513226b76b3cb8928c2
    """
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
    """JSON をディクショナリにデコードする関数
    ref. https://pod.hatenablog.com/entry/2017/08/31/035140
    """
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
    tomorrow = dt_now - timedelta(days=1) 
    year = tomorrow.year
    month = tomorrow.month
    day = tomorrow.day

    # ログディレクトリがなければ作成
    if not os.path.exists(log_directory):
        os.makedirs(log_directory)

    # CSV ディレクトリがなければ作成
    if not os.path.exists(csv_directory):
        os.makedirs(csv_directory)

    # 書込み用 CSV ファイルをオープン
    csvfile_name = csvfile_prefix + tomorrow.strftime("%Y%m%d.csv")
    csvfile_path = csv_directory + '/' + csvfile_name
    
    csvfile = open(csvfile_path, 'w')
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames, quoting=csv.QUOTE_NONNUMERIC)
    writer.writeheader() # CSV ヘッダ書込み

    # KMS クライアント初期化
    session = boto3.session.Session()
    kms = session.client('kms', region_name=region_name)

    # 前日分のログをS3からダウンロードして CSV に書込み
    s3 = S3Manager(
            source_bucket=s3_bucket,
            source_prefix="{0}/success/{1}/{2:0=2}/{3:0=2}/".format(s3_prefix, year, month, day),
#            source_prefix="aws-rds-das-cluster-KGKBVXA3OLPRPZH66XFBDPWQUI/success/2020/07/13/06/aws-rds-das-cluster-KGKBVXA3OLPRPZH66XFBDPWQUI-kfh-1-2020-07-13-06-20",
        )
    
    s3_obj_list = s3.list_all() # 前日分のログのリストを取得
    for s3_obj in s3_obj_list:
        if s3_obj.endswith('/'):
            continue
        basename = os.path.basename(s3_obj)
        local_path = log_directory + '/' + basename
        s3.download_file(s3_obj, local_path) # S3 からログをダウンロード
        print("downloading {0} ...".format(s3_obj))
        # ダウンロードしたログを解凍して CSV に変換
        with gzip.open(local_path, mode='rt', encoding='utf-8') as f:
            raw_data = f.read() # 解凍したファイルを読込み
            records = loads_iter(raw_data) # JSON をディクショナリに変換
            # ログをレコードごとにループ
            i = 0
            for record_data in records:
                # databaseActivityEvents セクションを復号
                decoded_data_key = base64.b64decode(record_data['key'])
                decoded = base64.b64decode(record_data['databaseActivityEvents'])
                decrypt_result = kms.decrypt(CiphertextBlob=decoded_data_key,EncryptionContext={"aws:rds:dbc-id":cluster_id})
                plaintext = decrypt_result[u'Plaintext']
                decoded_data = decrypt_decompress(decoded, decrypt_result[u'Plaintext']).decode('utf-8')
                record_event = json.loads(decoded_data)

                for evt in record_event['databaseActivityEventList']:
                    i=i+1
                    if evt['type'] != "heartbeat":
                        json_dict = json.loads(json.dumps(evt))
                        row_dict = dict(filter(lambda x: x[0] in fieldnames, json_dict.items()))
                        writer.writerow(row_dict)

        print("writed {0} rows to {1}".format(i, csvfile_path))
        
    # 書込み用 CSV ファイルをクローズ
    csvfile.close()

    # CSV ファイルを FTP 転送
    with open(csvfile_path, "rb") as f:
        ftp = ftplib.FTP(ftp_server)
        ftp.login(username, password)
        ftp.cwd(remote_directory)
        ftp.storbinary("STOR " + remote_directory + csvfile_name, f)            

    # 終了
    print('finished')
