#!/bin/bash
a=${1:dict}
b=${2:dict}
[ $a = "web" ] && /home/jqk/ydcv/ydcv.py "$b" 2>/dev/null|sed '1d;:a;N;$!ba;s/\n/\\N/g;s/.*Web Reference://;s/  Online Resource:.*//;s/^\\N//;s/\\N\\N$//;s/\\N/\n/g;s/     //g;s/       / /g'
[ $a = "dict" ] && /home/jqk/ydcv/ydcv.py "$b" 2>/dev/null|sed ':a;N;$!ba;s/\n/\\N/g;s/Web Reference.*//;s/ Word Explanation://;s/     //g;s/\\N\\N//;s/\\N \\N/\\N/;s/\\N/\n/g;'
