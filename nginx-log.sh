#!/bin/bash
nginxdir=/application/nginx
time=$(date -d '-1 day' +%Y-%m-%d)
mv $nginxdir/logs/access.log $nginxdir/logs/access-$time.log
$nginxdir/sbin/nginx -s reload
