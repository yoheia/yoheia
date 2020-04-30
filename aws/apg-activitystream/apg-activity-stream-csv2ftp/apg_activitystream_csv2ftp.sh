#!/bin/bash
export LANG=C

export FTP_SERVER='172.*.*.*'
export FTP_USER='ftpuser'
export FTP_PASSWD='hoge'
export FTP_REMOTE_DIR='/home/ftpuser/'
export KMS_KEY_ID='****-****-****-****-****'
export KINESIS_STREAM_NAME='aws-rds-das-cluster-******'
export REGEION='ap-northeast-1'
export APG_CLUSTER_ID='cluster-******'

python apg_activitystream_csv2ftp.py
