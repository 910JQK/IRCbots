#!/bin/sh
wget http://finance.sina.cn/ -O - -q|grep 上证|sed 's/.*上证//g;s/<\/a>/上证/;s/<br\/>.*深成//;s/<br\/>//;s/<\/a>/|深成/'
