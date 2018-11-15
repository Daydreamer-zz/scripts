#!/bin/sh
datadir=/data
basedir=/application/mysql
password=199747

. /etc/init.d/functions
[ $# -ne 1 ] && {
echo "USAGE:{start|stop|restart}"
exit 1
}
start(){
if [ -e $datadir/mysql.pid ]
then
  echo "MySQL is running."
else
  $basedir/bin/mysqld_safe --defaults-file=$datadir/conf/my.cnf &>/dev/null &
  action  "MySQL is starting" /bin/true
  exit 0
fi
}

stop(){
if [ -e $datadir/mysql.pid ]
then
  $basedir/bin/mysqladmin -uroot -p$password -S $datadir/mysql.sock shutdown &>/dev/null
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
