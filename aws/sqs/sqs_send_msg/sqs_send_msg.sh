#!/usr/bin/env bash

export LANG=C
SQS_ENDPOINT=https://sqs.ap-northeast-1.amazonaws.com/123456789012

for i in {1..50}
do
    echo $i
    num=$(printf "%03d" ${i})
    queue_name="LambdaQueue${i}"
    python sqs_send_msg.py ${SQS_ENDPOINT}/${queue_name} > ${queue_name}.log &
done
