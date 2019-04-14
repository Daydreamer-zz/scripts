#!/bin/bash
#自动为centos6和centos7添加epel源
version=`uname -r|awk -F '[-.]' '{print $5}'`

if [ $version = 'el7' ];then
  echo '您的系统是CentOS7'
  wget https://mirrors.aliyun.com/repo/epel-7.repo -O /etc/yum.repo.d/epel.repo
elif [ $version = 'el6' ];then
  echo '您的系统是Centos6'
  wget http://mirrors.aliyun.com/repo/epel-6.repo -O /etc/yum.repo.d/epel.repo
else
  echo 'error!!!'
fi
