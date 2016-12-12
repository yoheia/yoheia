#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import boto3
import urllib2
from bs4 import BeautifulSoup

def lambda_handler(event, context):
	s3_bucket_name = 'yoheia'
	work_dir = '/tmp'

	html = urllib2.urlopen('http://f.hatena.ne.jp/yohei-a/')
	soup = BeautifulSoup(html)
	images = soup.find_all(class_='foto_thumb')

	for img in images:
		url = img['src']
		img_filename = os.path.basename(img['src'])
		s3 = boto3.client('s3')
		print img['src'], os.path.basename(img['src'])
		r = urllib2.urlopen(img['src'])
		f = open(work_dir + '/' + os.path.basename(img['src']), "wb")
		f.write(r.read())
		f.close()
		s3.upload_file(work_dir + '/' + img_filename, s3_bucket_name, img_filename)

	retrun "OK"
