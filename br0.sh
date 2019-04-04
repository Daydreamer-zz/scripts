#!/bin/bash
#auther:shz
ip=192.168.2.4/24
gw=192.168.2.1
case $1 in
  enable)
  brctl addbr br0
  ifconfig eth0 0 up
  brctl addif br0 eth0
  ifconfig br0 $ip up
  route add default gw $gw 
  ;;
  disable)
  brctl delif br0 eth0
  ifconfig br0  down
  ifconfig eth0 $ip up
  brctl delbr br0
  route add default gw $gw 
  ;;
esac
