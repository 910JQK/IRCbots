#!/bin/bash
a=${1:-linux}
b=${2:-3}
B=$(curl -s "http://tieba.baidu.com/f?kw=$a" | iconv -f GBK -t UTF-8 | grep -oi \<a\ href=\"/p/.[^\<]* |sed 's/^<a href="/http:\/\/tieba.baidu.com/;s/" title=".*//' | awk 'NR=='"$b"' {print}')
A=$(curl -s "$B" | iconv -f GBK -t UTF-8|grep '<div id="tofrs_up"'|sed -r 's/<div class="share_thread">.*//;s/.*j_d_post_content">//;s/<\/div><\/cc>.*//;s/<img [^>]*>//g;s/<br>/ /g;s/&quot;/"/g;s/&lt;/</g;s/&gt;/>/g;s/&amp;/&/g;s/&reg;/®/g;s/&copy;/©/g;s/&trade;/™/g')
if [ "${#A}" -gt 100 ];then
echo -n "${B} 　${A:0:100}"...
else
echo "${B} 　${A}"
fi
