#!/bin/bash
#auther:shz
#lvs-dr模式下为realserver绑定vip和arp抑制
VIP=192.168.2.8
start(){
    ifconfig lo:0 $VIP netmask 255.255.255.255 up
    echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
}
stop(){
    ifconfig lo:0 down
    echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce
}
case $1 in
  start)
    start;
  ;;
  stop)
    stop;
  ;;
  *)
    echo "Usage: $0 {start|stop}"
    exit 1
esac
exit 0
