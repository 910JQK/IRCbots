#!/bin/sh
kw=${1:-金坷垃}
num=${2:-5}
wget "www.bilibili.tv/search?keyword=$kw" -q -O -|gzip -d|grep -E 'class="t"|href="http://www.bilibili.tv/video/av|href="/sp/'|sed 's/<a href="//g;s/div.*span>//g;s/" target="_blank">//g;s/<\/div//g;s/<font color="red">//g;s/<\/font>//g;s/^ *//;s/^<//g;s/>$//g;s/http:\/\/www.bilibili.tv\/video\/av//g;s/\/$//g;'|sed 'N;s/\n/ /g;'|head -n "$num"
