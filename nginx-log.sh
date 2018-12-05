#!/bin/bash
time=$(date -d '-1 day' +%Y-%m-%d)
mv /application/nginx/logs/access.log /application/nginx/logs/access-$time.log
/application/nginx/sbin/nginx -s reload
