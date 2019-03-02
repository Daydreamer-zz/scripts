#!/bin/bash
. /etc/init.d/functions
phpdir=/application
pidfile=$phpdir/php/var/run/php-fpm.pid
start(){
  if [ -f $pidfile ];then
    action "php-fpm is running now!" /bin/false
  else
    $phpdir/php/sbin/php-fpm -c $phpdir/php/etc/php.ini -y $phpdir/php/etc/php-fpm.conf
    action "php-fpm successful start" /bin/true
  fi

}

stop(){
  if [ -f $pidfile ];then
    kill -15 `cat $pidfile`
    action "php-fpm stopped" /bin/true
  else
    action " u cant stop,php-fpm is not  running" /bin/false
  fi
}


case $1 in 
  start)
    start;
  ;;
  stop)
    stop;
  ;;
  restart)
    stop;
    sleep 1
    start;
esac 
