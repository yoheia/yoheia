#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import boto3
import json
from datetime import datetime
import calendar
import random
import time
import hashlib
import asyncio

my_stream_name = 'KDS-ThroughputTest'
record_max = 100000
parallelism = 10

kinesis_client = boto3.client('kinesis', region_name='ap-northeast-1')
record_cnt = 0

async def put_to_stream():
    global record_cnt
    record_cnt += 1
    property_value = random.randint(1, 100)
    property_timestamp = calendar.timegm(datetime.utcnow().timetuple())
    part_key = hashlib.md5(str(property_value).encode('utf-8')).hexdigest()
    payload = {
                'prop': str(property_value),
                'timestamp': str(property_timestamp),
                'park_key': part_key
              }
#    print(payload)
    start = datetime.now()
    put_response = kinesis_client.put_record(
                        StreamName=my_stream_name,
                        Data=json.dumps(payload),
                        PartitionKey=part_key)
    end = datetime.now()
    print("record count: {0},  execution time: {1}".format(record_cnt, end - start))

async def multiple_request(loop):
    tasks = []
    for i in range(0, parallelism):
        tasks.append(put_to_stream())
    done, pending = await asyncio.wait(tasks)


while True:
    loop = asyncio.get_event_loop()
    loop.run_until_complete(multiple_request(loop))
    if record_cnt >= record_max:
        loop.stop()
        break