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
  cd nginx-1.14.2 && ./configure --prefix=$nginx_path/nginx --user=nginx --group=nginx --with-http_stub_status_module --with-http_ssl_module && make && make install
  action "nginx安装成功" /bin/true
  cd ..
}

php_install(){
  echo -e "\033[31mnow install php\033[0m"
  read -p "php安装路径:" php_path
  wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz
  wget http://be2.php.net/distributions/php-5.6.30.tar.gz
  echo -e "\033[31安装依赖\033[0m"
  yum install -y gcc-c++ zlib-devel libxml2-devel libjpeg-devel libjpeg-turbo-devel libiconv-devel freetype-devel libpng-evel gd-devel libcurl-devel libxslt-devel libmcrypt-devel mhash mcrypt
  echo -e "\033[31安装libiconv库\033[0m"
  tar zxvf libiconv-1.15.tar.gz && cd libiconv-1.15/ && ./configure --prefix=/usr/local/libiconv && make && make install && cd ..
  if [ -d $php_path ]
  then
    echo -e "\033[32mgood，此路径存在，解压文件中....\033[0m"
  else 
    echo -e "路径不存在，创建中...."
    mkdir -p $php_path
    action "文件夹创建成功" /bin/true
  fi
  tar zxvf php-5.6.30.tar.gz
  cd php-5.6.30/
  ./configure --prefix=$php_path/php --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv-dir=/usr/local/libiconv --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --enable-short-tags --enable-static --with-xsl --with-fpm-user=nginx --with-fpm-group=nginx --enable-ftp --with-pear --enable-phar --enable-gettext
  make && make install 
  action "php安装成功"
  echo -e "拷贝配置文件中..."
  mv $php_path/php/etc/php-fpm.conf.default $php_path/php/etc/php-fpm.conf
  cp php.ini-production $php_path/php/etc/php.ini
  cd ..
}

mysql_install(){
  echo -e  "\033[31mnow install mysql\033[0m"
  read -p "mysql安装路径:" mysql_path
  read -p "mysql数据存放路径" mysql_data_dir
  echo -e "安装依赖"
  yum install -y ncurses-devel bison gcc-c++ autoconf
  wget https://cmake.org/files/v2.8/cmake-2.8.8.tar.gz
  wget  https://cdn.mysql.com//Downloads/MySQL-5.6/mysql-5.6.43.tar.gz
  tar xf cmake-2.8.8.tar.gz && cd cmake-2.8.8 && ./configure --prefix=/usr/local/cmake && make && make install && cd .. 
  if [ -d $mysql_path ]
  then
    echo -e "\033[32mgood，此路径存在\033[0m"
  else 
    echo "路径不存在，创建目录中"
    mkdir -p $mysql_path
    action "目录$mysql_path创建成功" /bin/true
  fi
  echo -e "\033[33m检测mysql用户\033[0m" 
  b=`grep "mysql" /etc/passwd|wc -l`
  if [ "$b" == "1" ]
  then
    echo -e "\033[32mgood,mysql用户存在\033[0m"
  else
    echo -e "\033[31mmysql用户不存在,添加中.....\033[0m"
    useradd mysql -s /sbin/nologin -M
  fi
  echo -e "\033[33m编译安装mysql中......\033[0m"
  tar xf mysql-5.6.43.tar.gz && cd mysql-5.6.43/
  /usr/local/cmake/bin/cmake -DCMAKE_INSTALL_PREFIX=$mysql_path/mysql -DMYSQL_UNIX_ADDR=$mysql_path/mysql/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DMYSQL_DATADIR=$mysql_data_dir -DMYSQL_TCP_PORT=3306 -DMYSQL_USER=mysql -DENABLE_DOWNLOADS=1 -DMYSQL_USER=mysql 
 make && make install 
 cp 
}

LNMP(){
  read -p "LNMP安装路径(绝对路径):  " lnmp_path
  if [ -d $lnmp_path ]
  then
    echo -e  "\033[32mgood,$lnmp_path存在\033[0m"
  else
    echo -e "\033[31m$lnmp_path不存在，创建中....\033[0m" 
    mkdir -p $lnmp_path
  fi
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
  wget http://nginx.org/download/nginx-1.14.2.tar.gz
  tar zxvf nginx-1.14.2.tar.gz
  cd nginx-1.14.2 && ./configure --prefix=$lnmp_path/nginx --user=nginx --group=nginx --with-http_stub_status_module --with-http_ssl_module && make && make install
  action "nginx安装成功" /bin/true
  cd ..

  wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz
  wget http://be2.php.net/distributions/php-5.6.30.tar.gz
  echo -e "\033[31安装依赖\033[0m"
  yum install -y gcc-c++ zlib-devel libxml2-devel libjpeg-devel libjpeg-turbo-devel libiconv-devel freetype-devel libpng-devel gd-devel libcurl-devel libxslt-devel libmcrypt-devel mhash mcrypt
  echo -e "\033[31安装libiconv库\033[0m"
  tar zxvf libiconv-1.15.tar.gz && cd libiconv-1.15/ && ./configure --prefix=/usr/local/libiconv && make && make install && cd ..
  tar zxvf php-5.6.30.tar.gz
  cd php-5.6.30/
  ./configure --prefix=$lnmp_path/php --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv-dir=/usr/local/libiconv --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --enable-short-tags --enable-static --with-xsl --with-fpm-user=nginx --with-fpm-group=nginx --enable-ftp --with-pear --enable-phar --enable-gettext
  make && make install
  action "php安装成功"
  echo -e "拷贝配置文件中..."
  mv $lnmp_path/php/etc/php-fpm.conf.default $lnmp_path/php/etc/php-fpm.conf
  cp php.ini-production $lnmp_path/php/etc/php.ini
  cd ..
  

  yum install -y ncurses-devel bison gcc-c++ autoconf
  wget https://cmake.org/files/v2.8/cmake-2.8.8.tar.gz
  wget  https://cdn.mysql.com//Downloads/MySQL-5.6/mysql-5.6.43.tar.gz
  tar xf cmake-2.8.8.tar.gz && cd cmake-2.8.8 && ./configure --prefix=/usr/local/cmake && make && make install && cd ..
  echo -e "\033[33m检测mysql用户\033[0m" 
  b=`grep "mysql" /etc/passwd|wc -l`
  if [ "$b" == "1" ]
  then
    echo -e "\033[32mgood,mysql用户存在\033[0m"
  else
    echo -e "\033[31mmysql用户不存在,添加中.....\033[0m"
    useradd mysql -s /sbin/nologin -M
  fi
  echo -e "\033[33m编译安装mysql中......\033[0m"
  tar xf mysql-5.6.43.tar.gz && cd mysql-5.6.43/
  /usr/local/cmake/bin/cmake -DCMAKE_INSTALL_PREFIX=$lnmp_path/mysql -DMYSQL_UNIX_ADDR=$lnmp_path/mysql/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1  -DMYSQL_TCP_PORT=3306 -DMYSQL_USER=mysql -DENABLE_DOWNLOADS=1 -DMYSQL_USER=mysql
  make && make install
  cp /usr/local/mysql/support-files/mysql.server /etc/init.d/

  action "LNMP环境安装成功" /bin/true
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
    LNMP;
  ;;
  5)
    exit 0;
esac
