#!/bin/bash
for n in {79..84};
do
  cd /application/redis63$n && bin/redis-server redis.conf
done
/application/redis/bin/redis-trib.rb  create  --replicas  1  127.0.0.1:6379 127.0.0.1:6380 127.0.0.1:6381 127.0.0.1:6382 127.0.0.1:6383 127.0.0.1:6384
