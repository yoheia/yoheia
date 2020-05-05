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
parallelism = 10

kinesis_client = boto3.client('kinesis', region_name='ap-northeast-1')

record_max = 1000
record_cnt = 0

async def put_to_stream():
    property_value = random.randint(1, 100)
    property_timestamp = calendar.timegm(datetime.utcnow().timetuple())
    part_key = hashlib.md5(str(property_value).encode('utf-8')).hexdigest()
    payload = {
                'prop': str(property_value),
                'timestamp': str(property_timestamp),
                'thing_id': part_key
              }
#    print(payload)
    put_response = kinesis_client.put_record(
                        StreamName=my_stream_name,
                        Data=json.dumps(payload),
                        PartitionKey=part_key)
#    print(put_response)

async def limited_parallel_call(limit):
    sem = asyncio.Semaphore(limit)

    async def call():
        async with sem:
            return await put_to_stream()

    return await asyncio.gather(*[call() for x in range(record_max)])


while True:
    loop = asyncio.get_event_loop()
    loop.run_until_complete(limited_parallel_call(parallelism))
    record_cnt += 1
#    print(record_cnt)
#    if record_cnt >= record_max:
#        loop.stop()
