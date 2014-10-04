#!/bin/bash
a=${1:-linux}
b=${2:-4}
B=$(curl -s "http://tieba.baidu.com/f?kw=$a" | iconv -f GBK -t UTF-8 | grep -oi \<a\ href=\"/p/.[^\<]* |sed 's/^<a href="/http:\/\/tieba.baidu.com/;s/" title=".*//' | awk 'NR=='"$b"' {print}')
A=$(curl -s "$B" | iconv -f GBK -t UTF-8|grep '<div id="tofrs_up"'|sed -r '2,$d;s/<br><\/div><\/cc><br\/>.*//;s/.*<h1 class="core_title_txt " title="[^"]*">/【/;s/<\/h1>.*class="p_author_name[^"]*"[^>]*>([^<]*)<\/a>.*d_post_content_main d_post_content_firstfloor[^>]*>/】 by @\1/;s/<\/div><\/cc>.*//;s/<div class="p_content">.*div id="post_content[^>]*>/\n/;s/<img [^>]*>/\[img\]/g;s/<br>/ /g;s/ +/ /g;s/&quot;/"/g;s/&lt;/</g;s/&gt;/>/g;s/&amp;/&/g;s/&reg;/®/g;s/&copy;/©/g;s/&trade;/™/g;/^$/d')
if [ "${#A}" -gt 100 ];then
echo -n "${B} 　${A:0:100}"...
else
echo "${B} 　${A}"
fi
