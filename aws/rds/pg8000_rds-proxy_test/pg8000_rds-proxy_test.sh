#!/usr/bin/env bash

export PG_HOST_PROXY=apg117-2-proxy-passwd.proxy-******.ap-northeast-1.rds.amazonaws.com
export PG_PORT=5432
export PG_DATABASE=postgres
export PG_USER=awsuser
export PG_PASSWORD=Password123

python ./pg8000_rds-proxy_test.py