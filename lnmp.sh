#!/bin/bash
#本脚本用于一键安装lnmp并启动服务,后续补充优化
#1.安装nginx
yum -y install wget
[ ! -d /root/data ] && mkdir /root/data
cd data
wget ftp://192.168.4.254/soft/lnmp_soft.tar.gz
tar -xf lnmp_soft.tar.gz
cd lnmp_soft && tar -xf nginx-1.12.2.tar.gz && cd nginx-1.12.2
yum -y install gcc pcre pcre-devel openssl openssl-devel make 
useradd -s /sbin/nologin nginx
./configure --user=nginx --group=nginx --prefix=/usr/local/nginx --with-http_ssl_module --with-http_stub_status_module
make && make install
ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/nginx
sed -i '65,71s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '69s/^/#/' /usr/local/nginx/conf/nginx.conf
sed -i 's/fastcgi_params/fastcgi.conf/' /usr/local/nginx/conf/nginx.conf
nginx
echo nginx > /etc/rc.local
chmod +x /etc/rc.local 
#安装mysql
cd /root/data
wget ftp://192.168.4.254/soft/mysql-5.7.17.tar
[ ! -d mysql ] && mkdir mysql
tar -xf mysql-5.7.17.tar -C mysql/
cd mysql
yum -y install mysql*
if [ $? -eq 0 ];then
    systemctl start mysqld
else
    echo "安装出错,请检查"
fi 
ini_pass=`grep password "/var/log/mysqld.log" | head -n1 | awk '{print $NF}'`
mysqladmin -uroot -p"${ini_pass}" password "123qqq...A"
systemctl enable mysqld
#安装php
yum -y install php php-fpm php-mysql
systemctl start php-fpm
systemctl enable php-fpm
