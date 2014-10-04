#!/bin/bash


. tieba_config

post_data_file=$1
wget --save-cookies=${COOKIE_FILE} "http://wappass.baidu.com/passport/login" --referer="http://wappass.baidu.com/passport/?login" --post-data="$(cat ${post_data_file})" -O -



