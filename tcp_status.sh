#!/bin/bash
#统计当前tcp状态和连接数
netstat -ant|awk '{s[$NF]++}END{for(k in s)print k,s[k]}' >/tmp/tcpstatus
netstat -tn|awk -F '[:  ]++' 'NR>2 {print $6}' >/tmp/tcpstatus_ip
echo -e "\033[32m1.当前tcp连接状态\n2.当前连接到本机的ip\033[0m"
read -p "输入你想查看的: " a

case $a in
  1)
   cat /tmp/tcpstatus|sort -k2 -rn
  ;;
  2)
   awk '{s[$1]++}END{for(k in s)print k,s[k]}' /tmp/tcpstatus_ip|sort -k2 -rn
esac
