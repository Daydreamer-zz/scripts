#!/bin/bash
tomcatdir=/application/tomcat
start(){
  $tomcatdir/bin/startup.sh
}

stop(){
  $tomcatdir/bin/shutdown.sh

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
    sleep 1;
    start;
esac  
