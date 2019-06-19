#!/bin/bash
#优化新机器
repos(){
yum install -y wget
version=`cat /etc/redhat-release |awk -F '[ .]' '{print $4}'`
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
rm -rf /etc/yum.repos.d/*.repo
if [ $version -eq 7 ];then
  echo 'your machine is CentOS7'
  wget https://mirrors.aliyun.com/repo/epel-7.repo -O /etc/yum.repos.d/epel.repo
  wget http://mirrors.aliyun.com/repo/Centos-7.repo -O /etc/yum.repos.d/CentOS-Base.repo
elif [ $version -eq 6 ];then
  echo 'your machine is Centos6'
  wget http://mirrors.aliyun.com/repo/epel-6.repo -O /etc/yum.repos.d/epel.repo
  wget http://mirrors.aliyun.com/repo/Centos-6.repo -O /etc/yum.repos.d/CentOS-Base.repo
else
  echo 'error!!!'
fi
yum clean all
yum makecache
}

kernel(){
cat << EOF >> /etc/security/limits.conf
#增大文件描述符
* soft nofile 65535
* hard nofile 65536
#修改系统线程限制
* soft nproc 2048
* hard nproc 4096
EOF
cat <<EOF >>/etc/sysctl.conf
net.ipv4.tcp_syncookies = 1
#表示开启SYN Cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击

net.ipv4.tcp_tw_reuse = 1
#表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接

net.ipv4.tcp_tw_recycle = 1
#表示开启TCP连接中TIME-WAIT sockets的快速回收

net.ipv4.tcp_fin_timeout = 30
#修改系統默认的 TIMEOUT 时间

net.ipv4.tcp_max_tw_buckets = 8000
#表示系统同时保持TIME_WAIT的最大数量，如果超过这个数字，TIME_WAIT将立刻被清除并打印警告信息。默 认为180000，改为6000。

net.ipv4.ip_local_port_range = 10000 65000
#增大可用端口范围

net.ipv4.tcp_max_syn_backlog = 8192
#表示SYN队列的长度，默认为1024，加大队列长度为8192，可以容纳更多等待连接的网络连接数
EOF
sysctl -p
}

packages(){
yum install -y gcc-c++ screen lrzsz tree openssl telnet iftop iotop sysstat wget dos2unix lsof net-tools unzip zip vim-enhanced bind-utils yum-utils nmap bash-completion libaio-0.3.109-13.el7 vim htop ntpdate chrony
}

security(){
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
systemctl disable firewalld.service
systemctl stop firewalld.service
chmod +x /etc/rc.d/rc.local
}

updatetime(){
yum install -y ntp
echo "* 4 * * * /usr/sbin/ntpdate ntp.aliyun.com > /dev/null 2>&1" >> /var/spool/cron/root
}

kernel
repos
packages
updatetime
security
