import os
import boto3
import urllib2
from bs4 import BeautifulSoup

def lambda_handler(event, context):
    target_uri='http://f.hatena.ne.jp/yohei-a/'
    s3_bucket_name = 'hatenafotolife'
    work_dir = '/tmp'
    
    html = urllib2.urlopen(target_uri)
    soup = BeautifulSoup(html)
    images = soup.find_all(class_='foto_thumb')
    for img in images:
        img_uri = img['src']
        img_filename = os.path.basename(img_uri)
        s3 = boto3.client('s3')
        r = urllib2.urlopen(img_uri)
        f = open(work_dir + '/' + img_filename, "wb")
        f.write(r.read())
        f.close()
        s3.upload_file(work_dir + '/' + img_filename, s3_bucket_name, img_filename)

    return 1
