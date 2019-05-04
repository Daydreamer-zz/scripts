#!/bin/bash
#监控集群状态
#auther by Sun Hongze
time_now=`date '+%Y-%m-%d %H:%M:%S'`
log_file=/cluster/Monitoring.log

LOAD_AVERAGE_ALARM=2
CPU_ALARM=70
MEMORY_ALARM=70
IN_NETWORK_TRAFFIC_ALARM=10240
OUT_NETWORK_TRAFFIC_ALARM=10240



out_format(){
   printf "%-22s %-5s %-5s \n" "$1" ":" "$2"
}
print_title(){
    echo "######$time_now `uname -n` system status########" >> $log_file
}

#获取平均负载状况
get_load_average(){
     LOAD_AVERAGE=`uptime | awk -F "," '{print$NF}' | sed 's#[[:space:]]##g' `
     out_format "Load average"  "$LOAD_AVERAGE" >> $log_file
     return 0
}

#获取当前CPU使用率
get_cpu_usage(){
     CPU_FREE=`vmstat 1 5 |sed -n '3,$p' |awk '{x = x + $15} END {print x/5}' |awk -F. '{print $1}'`
     CPU_USAGE=$((100 - $CPU_FREE))
     out_format "CPU usage"  "${CPU_USAGE}%" >> $log_file
     return 0
}

#获取当前内存占用状况
get_memory_usage(){
     MEMORY_USED=`free -m | awk 'NR==2 {print $6}'`
     MEMORY_TOTAL=`free -m | awk 'NR==2 {print $2}'`
     MEMORY_USAGE=`echo "scale=2;${MEMORY_USED}/${MEMORY_TOTAL}*100;" | bc -l`
     out_format "Memory usage"  "${MEMORY_USAGE}%" >> $log_file
     return 0
}

#获取磁盘占用率
get_disk_usage(){
   MOUNT_POINT=`df -hl | egrep -wv  '^tmpfs|Filesystem|boot' | awk '{print$NF}'`
     for i in $MOUNT_POINT;
     do
         DISK_USAGE=`df -hl "$i" | awk 'NR==2 {print $5}'`
         out_format "Disk usage $i"  "${DISK_USAGE}" >> $log_file
     done
     return  0
}

#获取当前网络流量
get_network_traffic(){
     NETWORK_TRAFFIC=`sar -n DEV 1 5|grep Average|grep eth0|awk '{print "Input:",$5,"kb/s","Output:",$6,"kb/s"}'`
     out_format "Network traffic"  "${NETWORK_TRAFFIC}" >> $log_file
     return 0
}

#执行函数
print_title
get_load_average
get_cpu_usage
get_memory_usage
get_disk_usage
get_network_traffic

NETWORK_INPUT=`echo ${NETWORK_TRAFFIC}|awk '{print $2}'`
NETWORK_OUTPUT=`echo ${NETWORK_TRAFFIC}|awk '{print $5}'`

if [ `echo "$LOAD_AVERAGE > $LOAD_AVERAGE_ALARM"|bc` -eq 1 ];then
  python /root/sendmail.py "load average is high" "`tail -7 $log_file`"
elif [ `echo "$CPU_USAGE > $CPU_ALARM"|bc` -eq 1 ];then
  python /root/sendmail.py "cpu load is high" "`tail -7 $log_file`"
elif [ `echo "$MEMORY_USAGE > $MEMORY_ALARM"|bc` -eq 1 ];then
  python /root/sendmail.py "mem use is high" "`tail -7 $log_file`"
elif [ `echo "$NETWORK_INPUT > $IN_NETWORK_TRAFFIC_ALARM"|bc` -eq 1 ];then
  python /root/sendmail.py "network input is high" "`tail -7 $log_file`"
elif [ `echo "$NETWORK_OUTPUT > $OUT_NETWORK_TRAFFIC_ALARM"|bc` -eq 1 ];then
  python /root/sendmail.py "network output is high" "`tail -7 $log_file`"
fi
