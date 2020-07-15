import boto3
import json
import datetime
import time
import threading
from boto3.dynamodb.conditions import Key, Attr
import sys

args = sys.argv
id = args[1]
start_date = args[2]
end_date = args[3]

print(start_date)
print(end_date)


dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('test_table')

i = 0
last = datetime.datetime.now()
while True:
    start = datetime.datetime.now()
    response = table.query(
        KeyConditionExpression=Key('ID').eq(id)& Key('YYYYMMDD').between(start_date, end_date),
        ConsistentRead=True,
        ScanIndexForward=True,
        ReturnConsumedCapacity='TOTAL'
    )
    end = datetime.datetime.now()
    print("execution time: {0}".format(end - start))
    print('count: ' + str(response['Count']))
    print('ScannedCount: ' + str(response['ScannedCount']))
    i += 1
    mod = i % 1000
    if mod == 0:
        prev = last
        last = datetime.datetime.now()
        delta = last - prev
        print i, ':', delta.total_seconds()

