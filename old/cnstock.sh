#!/bin/sh
if [ $1 ];then
wget 'stock1.sina.cn/prog/wapsite/stock/v2/stockquery.php?code='"$1" -O - -q|grep -E 'card title=|昨收|最高|涨停|成交量|成交额|市盈率'|sed 's/<br\/>//g;s/<card title="//;s/".*//;s/停刷新\.//;s/<a.*//;s/^ *//'
else
wget http://finance.sina.cn/ -O - -q|grep 上证|sed 's/.*上证//g;s/<\/a>/上证/;s/<br\/>.*深成//;s/<br\/>//;s/<\/a>/|深成/'
fi
