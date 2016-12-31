# -*- coding: utf-8 -*-
import os
import re
import boto3
import urllib2
from bs4 import BeautifulSoup

def lambda_handler(event, context):
    target_uri= 'http://f.hatena.ne.jp/yohei-a/rss'
    s3_bucket_name = 'hatenafotolife'
    work_dir = '/tmp'
    html = urllib2.urlopen(target_uri)
    soup = BeautifulSoup(html, 'html.parser')

    s3 = boto3.client('s3')
    for item in soup.find_all("hatena:imageurl"):
    	img_uri = item.contents[0]
    	img_filename = os.path.basename(img_uri)
    	r = urllib2.urlopen(img_uri)
    	f = open(work_dir + '/' + img_filename, "wb")
    	f.write(r.read())
    	r.close()
    	f.close()
        s3.upload_file(work_dir + '/' + img_filename, s3_bucket_name, img_filename)
    
    return 1
