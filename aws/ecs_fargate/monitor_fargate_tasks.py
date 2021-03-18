#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import boto3
import time
from datetime import datetime
import urllib.error
import urllib.request

region_name = 'ap-northeast-1'
ecs_cluster = 'fargate-test'
ecs_serviceName = 'fargate-draining-test'
ecs_stop_reason = 'monitoring tool stopped task.'
sleep_interval = 5

def http_request(url):
    headers = { "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:47.0) Gecko/20100101 Firefox/47.0" }
    request = urllib.request.Request(url, headers=headers)
    response = ''
    try:
        response = urllib.request.urlopen(request)
    except urllib.error.URLError as e:
        response = e
        pass
    return response

if __name__ == '__main__':
    session = boto3.session.Session()
    ecs = session.client('ecs', region_name=region_name)

    while True:
        check_ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        # タスクのリストを取得
        res_tasks = ecs.list_tasks(cluster=ecs_cluster, serviceName=ecs_serviceName)
        res_task_desc = ecs.describe_tasks(cluster=ecs_cluster, tasks=res_tasks['taskArns'])

        for task in enumerate(res_task_desc['tasks']):
            task_arn = task[1]['containers'][0]['taskArn']
            task_ip = task[1]['containers'][0]['networkInterfaces'][0]['privateIpv4Address']
            task_status = task[1]['containers'][0]['healthStatus']
            # タスクにHTTPリクエストを投げて正常性をチェック
            res = http_request('http://' + task_ip)
            # 異常の場合は該当タスクを停止する
            if task_status == 'UNHEALTHY' or type(res) == urllib.error.URLError or res.status != 200:
                ecs.stop_task(cluster=ecs_cluster, task=task_arn, reason=ecs_stop_reason)
            else:
                print(check_ts + "\t" + task_ip + "\t" + str(res.status) + "\t" + task_arn)

        time.sleep(sleep_interval)

    print('finished')

