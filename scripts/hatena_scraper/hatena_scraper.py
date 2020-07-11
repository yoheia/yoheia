import sys
from pyquery import PyQuery as pq

year = sys.argv[1]
month = sys.argv[2]

url = 'https://yohei-a.hatenablog.jp/archive/{0}/{1}'.format(year, month)
print(url)
doc = pq(url)

for result in doc('.entry-title-link').items():
    print(result.text() + "\t" + result.attr('href'))