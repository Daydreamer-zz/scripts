#!/bin/bash
for ((a=1;a<=9;a++));
do
  for ((b=1;b<=a;b++));do
    echo -e -n "${a}X${b}=$[${a}*${b}]\t"
  done
  echo
done
