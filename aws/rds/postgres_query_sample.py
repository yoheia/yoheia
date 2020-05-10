#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import csv
import psycopg2
import datetime

now = datetime.datetime.now()
current_time='{0:%Y%m%d_%H%M%S}'.format(now - datetime.timedelta(hours=1))

def get_connection():
    return psycopg2.connect(
        application_name='Python sample',
        host=os.environ['PG_HOST'],
        dbname=os.environ['PG_DBNAME'], # mydb
        port=os.environ['PG_PORT'], # 5432
        user=os.environ['PG_USER'], # awsuser
        password=os.environ['PG_PASSWORD']
    )

with get_connection() as conn:
    with conn.cursor() as cur:
        cur.execute("select * from pg_class;")
        with open('pg_class_' + current_time + '.csv', 'w') as f:
            writer = csv.writer(f, quoting=csv.QUOTE_NONNUMERIC)
            for row in cur:
                new_row=map(lambda s:str(s).strip(), row)
                writer.writerow(new_row)
