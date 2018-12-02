#!/bin/sh
basedir=/application/mysql
password=199747
socketdir=/var/lib/mysql/mysql.sock
pidfile=/data/mysql.pid
mysqlconfdir=/etc/my.cnf

. /etc/init.d/functions
[ $# -ne 1 ] && {
echo "USAGE:{start|stop|restart}"
exit 1
}
start(){
if [ -e $pidfile ]
then
  echo "MySQL is running."
else
  $basedir/bin/mysqld_safe --defaults-file=$mysqlconfdir  &>/dev/null &
  action  "MySQL is starting" /bin/true
  exit 0
fi
}

stop(){
if [ -e $pidfile ]
then
  $basedir/bin/mysqladmin -uroot -p$password -S $socketdir  shutdown &>/dev/null
  action "MySQL is stoping" /bin/true
else
  action "MySQL is stoping" /bin/false
  exit 1
fi
}

restart(){
  stop
  sleep 2
  start
}

if [ "$1" == "start" ]
then
  start
elif [ "$1" == "stop" ]
then
  stop
elif [ "$1" == "restart" ]
then
  restart
else
  echo "USAGE:{start|stop|restart}" 
fi
