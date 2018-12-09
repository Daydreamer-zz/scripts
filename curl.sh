#!/bin/bash
a=(
www.baidu.com
www.qq.com
www.163.com
)
for n in ${a[*]}
do 
  CURL=$(curl -s  -I -m 2 $n|grep "200"|wc -l)
  if [ $CURL -eq 1 ]
  then
    echo "$n is ojbk"
  else
    echo "$n is down"
  fi
done
