#!/bin/bash
declare -i oddsum=0
declare -i i=1
while true;do
  let oddsum+=$i
  let i+=2
  if [ $i -gt 100 ];then
    break
  fi
done
echo "$oddsum"
