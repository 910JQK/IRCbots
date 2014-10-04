#!/bin/bash
a=${1:-linux}
b=${2:-4}
B=$(curl -s "http://tieba.baidu.com/f?kw=$a" | iconv -f GBK -t UTF-8 | grep -oi \<a\ href=\"/p/.[^\<]* |sed 's/^<a href="/http:\/\/tieba.baidu.com/;s/" title=".*//' | awk 'NR=='"$b"' {print}')
echo "${B}"
