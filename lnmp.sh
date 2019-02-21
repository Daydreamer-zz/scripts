#!/bin/bash
. /etc/init.d/functions
echo -e "\033[32m1.安装nginx\n2.安装php\n3.安装mysql\n4.安装lnmp\n5.不做任何操作退出\033[0m"
read -p "请输入你想安装的，序号:" a
nginx_install(){
  read -p "你想把nginx安装到哪里(绝对路径):" nginx_path
  echo -e "\033[31mnow install nginx\033[0m"
  echo -e "安装环境"
  yum install -y gcc-c++ openssl openssl-devel pcre pcre-devel
  echo -e "\033[33m检测nginx用户\033[0m"
  a=`grep "nginx" /etc/passwd|wc -l`
  if [ "$a" == "1" ]
  then
    echo -e "\033[32mgood,nginx用户存在\033[0m"
  else
    echo -e "\033[31mnginx用户不存在,添加中.....\033[0m"
    useradd nginx -s /sbin/nologin -M
  fi
  if [ -d $nginx_path ]
  then
    echo -e  "\033[32mgood,$nginx_path存在\033[0m"
  else
    echo -e "\033[31m$nginx_path不存在，创建中....\033[0m"
    mkdir -p $nginx_path
  fi
  wget http://nginx.org/download/nginx-1.14.2.tar.gz
  tar zxvf nginx-1.14.2.tar.gz
  cd nginx-1.14.2 && ./configure --prefix=$nginx_path/nginx --user=nginx --group=nginx --with-http_stub_status_module --with-http_ssl_module && make && make install && cd -
  action "nginx安装成功" /bin/true
}

php_install(){
  echo -e "\033[31mnow install php\033[0m"
  read -p "php安装路径:" php_path
  echo -e "\033[31安装依赖\033[0m"
  yum install -y gcc-c++ zlib-devel libxml2-devel libjpeg-devel libjpeg-turbo-devel libiconv-devel freetype-devel libpng-evel gd-devel libcurl-devel libxslt-devel libmcrypt-devel mhash mcrypt
  echo -e "\033[31安装libiconv库\033[0m"
  tar zxvf libiconv-1.15.tar.gz && cd libiconv-1.15/ && ./configure --prefix=/usr/local/libiconv && make && make install && cd /root
  if [ -d $php_path ]
  then
    echo -e "\033[32mgood，此路径存在，解压文件中....\033[0m"
  else 
    echo -e "路径不存在，创建中...."
    mkdir -p $php_path
    action "文件夹创建成功" /bin/true
  fi
  tar zxvf php-7.2.12.tar.gz
  cd php-7.2.12/
  ./configure --prefix=$php_path/php --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv-dir=/usr/local/libiconv --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --enable-short-tags --enable-static --with-xsl --with-fpm-user=nginx --with-fpm-group=nginx --enable-ftp --with-pear --enable-phar
  make && make install $$ cd -
  action "php安装成功"
  echo -e "拷贝配置文件中..."
  mv $php_path/php/etc/php-fpm.d/www.conf.default $php_path/php/etc/php-fpm.d/www.conf
  cp php-7.2.12.tar.gz/php.ini-production $php_path/php/etc/php.ini
}

mysql_install(){
  echo -e  "\033[31mnow install mysql\033[0m"
  read -p "mysql安装路径:" mysql_path
  if [ -d $mysql_path ]
  then
    echo -e "\033[32mgood，此路径存在，解压文件中....\033[0m"
  else 
    echo "路径不存在，创建目录中"
    mkdir -p $mysql_path
    action "目录$mysql_path创建成功" /bin/true
  fi
  echo -e "\033[33m检测mysql用户\033[0m" 
  b=`grep "mysql" /etc/passwd|wc -l`
  if [ "$a" == "1" ]
  then
    echo -e "\033[32mgood,mysql用户存在\033[0m"
  else
    echo -e "\033[31mmysql用户不存在,添加中.....\033[0m"
    useradd mysql -s /sbin/nologin -M
  fi
  echo -e "\033[33m安装依赖\033[0m"
  tar zxvf mysql-5.7.24-linux-glibc2.12-x86_64.tar.gz -C $mysql_path
  action "解压文件成功" /bin/true
  echo -e "\033[31m拷贝配置文件(默认覆盖原配置文件)....\033[0m"
  cp -f my.cnf /etc
  action "拷贝配置文件成功" /bin/true
  mv $mysql_path/mysql-5.7.24-linux-glibc2.12-x86_64 $mysql_path/mysql
}

case $a in
  1)
    nginx_install;
  ;;
  2)
    php_install;
  ;;
  3)
    mysql_install;
  ;;
  4)
    nginx_install;
    php_install;
    mysql_install;
  ;;
  5)
    exit 0;
esac
