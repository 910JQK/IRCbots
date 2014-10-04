#!/bin/bash


. tieba_config

gen_post_header(){
    cat << EOF > $1
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<title>Tieba Log</title>
<style>
a {
    text-decoration: none;
}
h1 {
    margin-top: 0px;
    font-size: 18px;
}
h1 a {
    color: black;
}
ul.pic_list {
    display: none;
}
table, td {
    border: 2px solid;
    border-collapse: collapse;
}
div.post_author a {
    color: #F33;
}
time.ui_text_desc {
    color: gray;
}
span.label_12 {
    color: #F33;
}
</style>
</head>
<body>
EOF
    echo "<p>$(date)</p><table>" >> $1
}


gen_user_header(){
    cat << EOF > $1
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<title>Tieba Log</title>
<style>
a {
    text-decoration: none;
}
img {
    display: none;
}
table, td {
    border: 2px solid black;
    border-collapse: collapse;
}
a.ui_text_normal {
    color: #008000;
}
tr > td:nth-child(2) {
    color: #F33;
}
</style>
</head>
<body>
EOF
    echo "<p>$(date)</p><table>" >> $1
}


get(){
    get_type=$1
    bar=$2
    file=$3

    if [ "${get_type} " = "post " ]; then
	gen_post_header ${file}
	action="listPostLog";
    else
	gen_user_header ${file}
	action="listUserLog";
    fi

    wget --load-cookies=${COOKIE_FILE} "http://tieba.baidu.com/bawu2/platform/${action}?word=${bar}" -O - | iconv -f gbk -t utf8 | sed 's/<tr>[^<]*<td class="left_cell">/\n<!-- #### -->&/g;s/<\/td><\/tr>/&\n/g;s/"\/p\/[0-9]*\?/"http:\/\/tieba.baidu.com&/g' | grep '<!-- #### -->' >> ${file}

    echo "</table></body></html>" >> ${file}
}

bar=$1
output_post_file=$2
output_user_file=$3

get "post" "${bar}" "${output_post_file}"
get "user" "${bar}" "${output_user_file}"

