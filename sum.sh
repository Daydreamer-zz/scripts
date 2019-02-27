#!/bin/bash
declare -i evensum=0
declare -i i=0
while [ $i -le 100 ];
do
  let i++
  if [ $[$i%2] -eq 1 ];then
    continue
  fi
  let evensum+=$i
done
echo "Even sum: $evensum"
