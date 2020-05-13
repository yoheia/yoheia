#!/usr/bin/env python3
import os
import csv
import psycopg2
import datetime

now = datetime.datetime.now()
begin_time='{0:%Y-%m-%d %H:00:00}'.format(now - datetime.timedelta(hours=1))
end_time='{0:%Y-%m-%d %H:00:00}'.format(now)

def get_connection():
    return psycopg2.connect(
        host=os.environ['RS_HOST'],
        dbname=os.environ['RS_DBNAME'], # dev
        port=os.environ['RS_PORT'], # 5439
        user=os.environ['RS_USER'], # awsuser
        password=os.environ['RS_PASSWORD']
    )

with get_connection() as conn:
    with conn.cursor() as cur:
        cur.execute("select to_char(recordtime, 'YYYY/MM/DD HH24:MI:SS'),remotehost,remoteport,event,'Redshift', pid, username from STL_CONNECTION_LOG where recordtime >= %s and recordtime < %s;", [begin_time, end_time])
        with open('stl_connection_log.csv', 'w') as f:
            writer = csv.writer(f, quoting=csv.QUOTE_NONNUMERIC)
            for row in cur:
                new_row=map(lambda s:str(s).strip(), row)
                writer.writerow(new_row)