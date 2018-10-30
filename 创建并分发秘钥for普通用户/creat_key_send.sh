#!/bin/sh
#1.创建密钥
. /etc/init.d/functions
if [ $# != 2 ]
then
    echo "后面必须用户 密码"
    exit 1
fi
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa > /dev/null 2>&1
if [ $? -eq 0 ]
then
  action "创建密钥"  /bin/true
else
  action "创建密钥"  /bin/false
fi
#2.分发密钥
for n in 4 5 6 
do 
  expect ssh_handout.exp $1 192.168.2.$n  $2  > /dev/null 2>&1
if 
   [ $? -eq 0 ]
then 
    action  "192.168.2.$n发送状态"  /bin/true
else
    action  "192.168.2.$n发送状态"  /bin/false
fi
done
#3.分发脚本
for m in 4 5 6
do 
   scp /home/$1/install.sh $1@192.168.2.$m:/home/$1
  if [ $? -eq 0 ]
  then 
     action "发送脚本状态"    /bin/true
  else 
     action “"发送脚本状态"    /bin/false
  fi
done
#4.执行脚本
for b in 4 5 6
do
   ssh -t $1@192.168.2.$b sudo sh /home/$1/install.sh
done
