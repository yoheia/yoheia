#!/bin/bash
export LANG=C

export FTP_SERVER='172.*.*.*'
export FTP_USER='ftpuser'
export FTP_PASSWD='hoge'
export FTP_REMOTE_DIR='/home/ftpuser/'
export CSVFILE_PREFIX='aurora-postgres-activity.csv'
export S3_BUCKET='aurora-postgres-activity-stream-az-tokyo'
export S3_PREFIX='aws-rds-das-cluster-KGKBVXA3OLPRPZH66XFBDPWQUI'
export LOCAL_DIR='./log'
export CSV_DIR='./csv'
export KMS_KEY_ID='0b5af1d9-4ce2-40c0-8a48-1a28b6bcd2b0'
export KINESIS_STREAM_NAME='aws-rds-das-cluster-KGKBVXA3OLPRPZH66XFBDPWQUI'
export REGEION='ap-northeast-1'
export APG_CLUSTER_ID='cluster-KGKBVXA3OLPRPZH66XFBDPWQUI'

python apg_activitystream_s3_csv2ftp.py
