#!/bin/bash

export LANG=C
BASE_DIR=$(cd $(dirname $0);pwd)

bash ${BASE_DIR}/pgbench_wrapper.sh hostname dbname username password

