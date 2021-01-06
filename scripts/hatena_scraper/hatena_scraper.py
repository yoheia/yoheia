#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import argparse
from pyquery import PyQuery as pq
import datetime
from dateutil.relativedelta import relativedelta

base_url = 'https://yohei-a.hatenablog.jp'

parser = argparse.ArgumentParser(description='Scraping hatena blog and get title and url list') 
parser.add_argument('arg1', help='YYYY(Year of the articles)')
parser.add_argument('arg2', help='MM(Month of the articles)')
parser.add_argument('arg3', help='99(e.g. 3 means 3 months)')
args = parser.parse_args()

year = args.arg1
month = args.arg2
period = args.arg3

# Scraping hatena blog and return list of title and url 
#   IN
#       base_url (string)
#       year (string)
#       month (string)
#   OUT
#       list of articles(generator)
#           e.g.
#               articles = scrape_hatena_archive('https://yohei-a.hatenablog.jp', 2020, 10, 3)
#               for article in articles:
#                   print(article.text() + "\t" + article.attr('href'))

def scrape_hatena_archive(base_url, year, month):
    url = '{0}/archive/{1}/{2}'.format(base_url, year, month)
    doc = pq(url)
    return doc('.entry-title-link').items()

# main
if __name__ == '__main__':

    string_date =  year + '-' + month + '-' + '01'
    article_date = datetime.datetime.strptime(string_date, '%Y-%m-%d')

    for i in range(int(period)):
        articles = scrape_hatena_archive(base_url, article_date.year, article_date.month)
        for article in articles:
            print(article.text() + "\t" + article.attr('href'))
        article_date = article_date + relativedelta(months=1)
