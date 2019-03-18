#!/bin/bash
for n in 79 80 81 82 83 84;
do
  cp -a redis redis63$n/
  rm -rf redis63$n/dump.rdb
  sed -i "s/port 6379/port 63$n/g" redis63$n/redis.conf
  sed -i "s#pidfile /var/run/redis_6379.pid#pidfile /application/redis63$n/redis_63$n.pid#g" redis63$n/redis.conf
  echo "cluster-enabled yes" >> redis63$n/redis.conf
  echo "cluster-config-file nodes_63$n.conf" >> redis63$n/redis.conf
  echo "cluster-node-timeout 5000" >> redis63$n/redis.conf
  sed -i "s/appendonly no/appendonly yes/g" redis63$n/redis.conf
  sed -i "/^dir/d" redis63$n/redis.conf
  echo 'dir "./"' >> redis63$n/redis.conf
done
