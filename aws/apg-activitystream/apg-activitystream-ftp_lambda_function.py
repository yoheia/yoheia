import boto3
import os
import ftplib
import json
import csv
from json.decoder import WHITESPACE, JSONDecoder
from typing import Generator

ftp_server = os.environ['FTP_SERVER']
username = os.environ['FTP_USER']
password = os.environ['FTP_PASSWD']
remote_directory = os.environ['FTP_REMOTE_DIR']
s3_bucket_arch = os.environ['S3_BUCKET_ARCH']
lambda_local_dir = '/tmp/'

def load_iter(text: str) -> Generator:
    size = len(text)
    decoder = JSONDecoder()
    index = 0
    while index < size:
        obj, offset = decoder.raw_decode(text, index)
        yield obj
        search = WHITESPACE.search(text, offset)
        if search is None:
            break
        index = search.end()

def lambda_handler(event, context):
    print(event)   
    print(event['Records'][0]['s3']['bucket']['name'])
    print(event['Records'][0]['s3']['object']['key'])

    s3_bucket = event['Records'][0]['s3']['bucket']['name']
    s3_key = event['Records'][0]['s3']['object']['key']
    s3_prefix = os.path.dirname(s3_key)

    ftp = ftplib.FTP(ftp_server)
    ftp.login(username, password)
    ftp.cwd(remote_directory)

    s3r = boto3.resource('s3')
    s3c = boto3.client('s3')
    bucket = s3r.Bucket(s3_bucket)
    for obj in bucket.objects.filter(Prefix=s3_prefix):
        if not obj.key.endswith('/'):
            path = obj.key
            filename = os.path.basename(obj.key)
            basename = os.path.splitext(os.path.basename(filename))[0]
            local_path = lambda_local_dir + filename
            s3r.Bucket(s3_bucket).download_file(path, local_path)

            activity_stream = open(local_path).read()
            csv_path = lambda_local_dir + basename + '.csv'
            csv_open = csv.writer(open(csv_path, 'wb+'))
            with open(csv_path, 'w', newline='') as csvfile:
                fieldnames = ['logTime', 'statementId', 'substatementId', 'objectType', 'command', 'objectName', 'databaseName', 'dbUserName', 'remoteHost', 'remotePort', 'sessionId', 'rowCount', 'commandText', 'paramList', 'pid', 'clientApplication', 'exitCode', 'class', 'serverVersion', 'serverType', 'serviceName', 'serverHost', 'netProtocol', 'dbProtocol', 'type', 'startTime', 'errorMessage']
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writeheader()
                for obj in load_iter(activity_stream):
                    json_enc = json.dumps(obj)
                    json_object = json.loads(json_enc)
                    writer.writerow(json_object)

            with open(csv_path, "rb") as f:
                ftp.storbinary("STOR " + remote_directory + basename + '.csv', f)

            s3c.copy_object(CopySource={'Bucket': s3_bucket, 'Key': path }, Bucket=s3_bucket_arch, Key=s3_prefix + filename)
            s3c.delete_object(Bucket=s3_bucket, Key=path)
            print('finished')