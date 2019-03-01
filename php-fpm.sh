#!/bin/bash
. /etc/init.d/functions
phpdir=/application
pidfile=$phpdir/php/var/run/php-fpm.pid
start(){
  if [ -f $pidfile ];then
    action "php-fpm is now running!" /bin/false
  else
    $phpdir/php/sbin/php-fpm -c $phpdir/php/etc/php.ini -y $phpdir/php/etc/php-fpm.conf
    action "php-fpm successful start" /bin/true
  fi

}

stop(){
  pid=`cat $pidfile`
  if [ -f $pidfile ];then
    kill $pid
    action "php-fpm is now stop" /bin/false
  else
    action "php-fpm is  not running" /bin/false
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
