#!/bin/bash
#自动为centos6和centos7添加epel源
version=`uname -r|awk -F '[-.]' '{print $5}'`

if [ $version = 'el7' ];then
  echo '您的系统是CentOS7'
  rm -rf /etc/yum.repos.d/*
  wget https://mirrors.aliyun.com/repo/epel-7.repo -O /etc/yum.repos.d/epel.repo
  wget http://mirrors.aliyun.com/repo/Centos-7.repo -O /etc/yum.repos.d/CentOS-Base.repo
elif [ $version = 'el6' ];then
  echo '您的系统是Centos6'
  rm -rf /etc/yum.repos.d/*
  wget http://mirrors.aliyun.com/repo/epel-6.repo -O /etc/yum.repos.d/epel.repo
  wget http://mirrors.aliyun.com/repo/Centos-6.repo -O /etc/yum.repos.d/CentOS-Base.repo
else
  echo 'error!!!'
fi
