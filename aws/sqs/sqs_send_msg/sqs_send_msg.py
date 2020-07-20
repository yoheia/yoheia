#!/usr/bin/env python3

import sys
import boto3
import datetime

loop_count = 100000

queue_url = sys.argv[1]
sqs_client = boto3.client("sqs")

for i in range(loop_count):
    start = datetime.datetime.now()
    response = sqs_client.send_message(QueueUrl=queue_url, MessageBody="message {0} {1}".format(queue_url, i))
    end = datetime.datetime.now()
    print("execution time: {0}".format(end - start))
    print(i)
    print(response)