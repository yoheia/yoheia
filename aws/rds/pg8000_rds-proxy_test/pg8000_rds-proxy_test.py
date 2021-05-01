#!/usr/bin/env python3

import os
import traceback
import datetime
import pg8000

pg_host = os.environ.get('PG_HOST_PROXY')
pg_port = os.environ.get('PG_PORT')
pg_database = os.environ.get('PG_DATABASE')
pg_user = os.environ.get('PG_USER')
pg_password = os.environ.get('PG_PASSWORD')
script_name = os.path.basename(__file__)

conn = None
cur = None

print(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f') + ': Start ' + script_name + '.')

try:
    print(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f') + ': Connecting to database.')
    conn = pg8000.connect(
        host=pg_host,
        port=int(pg_port),
        database=pg_database,
        user=pg_user,
        password=pg_password
    )
    print(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f') + ': Connected to database.')
    conn.autocommit = False
    cur = conn.cursor()
    sql = "SELECT version();"
    print(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f') + ': Querying to database.') 
    cur.execute(sql)
    print(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f') + ': Queryed to database.')

    print(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f') + ': Print resut set.')
    rows = cur.fetchall()
    for row in rows:
        print(row)

except pg8000.exceptions.DatabaseError as exc:
    print(type(exc))
    print(traceback.format_exc())
    
except Exception as exc:
    print(type(exc))
    print(traceback.format_exc())

finally:
    if cur is not None:
        cur.close()
        cur = None
    if conn is not None:
        conn.close()
        conn = None

print(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f') + ': ' + script_name + ' is finised.')