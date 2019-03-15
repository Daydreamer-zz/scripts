#!/bin/sh
#1.创建密钥
. /etc/init.d/functions
if [ $# != 1 ]
then
    echo "后面必须密码"
    exit 1
fi
ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa > /dev/null 2>&1
if [ $? -eq 0 ]
then
  action "创建密钥"  /bin/true
else
  action "创建密钥"  /bin/false
fi
#2.分发密钥
for n in 2 4 5  
do 
  expect ssh_handout.exp 192.168.2.$n  $1  > /dev/null 2>&1
if 
   [ $? -eq 0 ]
then 
    action  "192.168.2.$n发送状态"  /bin/true
else
    action  "192.168.2.$n发送状态"  /bin/false
fi
done
