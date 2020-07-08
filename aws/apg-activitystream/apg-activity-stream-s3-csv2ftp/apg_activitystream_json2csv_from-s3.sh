#!/usr/bin/env bash
export LANG=C

export S3_BUCKET='aurora-postgres-activity-stream-tokyo'
export S3_PREFIX='aws-rds-das-cluster-***'
export LOG_DIR='./log'
export CSV_DIR='./csv'
export KMS_KEY_ID='********-****-****-****-************'
export KINESIS_STREAM_NAME='aws-rds-das-cluster-***'
export REGEION='ap-northeast-1'
export APG_CLUSTER_ID='cluster-***'

export FTP_SERVER='localhost'
export FTP_USER='ftpuser'
export FTP_PASSWD='******''
export FTP_REMOTE_DIR='/home/ftpuser/'

python apg_activitystream_json2csv_from-s3.py
