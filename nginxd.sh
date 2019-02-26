#!/bin/bash
pidfile=/application/nginx/logs/nginx.pid
nginxdir=/application/nginx/sbin/nginx
. /etc/init.d/functions
start(){
  if [ -f $pidfile ] ; then
    echo "nginx is now running"
  else 
    $nginx
    action "nginx is started" /bin/true 
  fi
}

stop(){
  if [ -f $pidfile ] ; then
    $nginx -s stop
    action "nginx is stop" /bin/true
  else
    action "nginx is not runing"  /bin/false
  fi
}

reload(){
 if [ -f $pidfile ] ; then 
   $nginx -s reload
   action "nginx is reload" /bin/true
 else 
   action "nginx is not runing" /bin/false
 fi
}

case $1 in
  start)
    start;
   ;;
  stop)
    stop;
   ;;
  reload)
    reload;
   ;;
  *)
   echo "Useage:{start|stop|reload}"
 esac

