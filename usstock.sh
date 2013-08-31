#!/bin/sh
wget 'finance.sina.cn/?sa=t60d16v1020' -O - -q|grep '美国股市'|sed 's/.*道琼斯/道琼斯/;s/<\/a>//g;s/<br\/>.*纳斯达克/|纳斯达克/;s/<br\/>.*标普指数/|标普指数/;s/<br\/>//'
