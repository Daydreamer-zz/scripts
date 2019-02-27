#!/bin/bash
while read line;
do 
  username=`echo $line|cut -d ":" -f 1`
  userid=`echo $line|cut -d ":"  -f 3`
  if [ $[$userid%2] -eq 0 ];then
    echo "$username $userid"
  fi
done </etc/passwd
