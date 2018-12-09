#!/bin/bash
array=(21029299 00205d1c a3da1677 1f6d12dd 890684b)
for n in {0..32767}
do
  re=$(echo $n|md5sum|cut -c 1-8)
  for i in ${array[*]}
  do
    if [ "$i" == "$re"  ]; then
    echo -e "$n\t $re"
    fi
  done
done
