#!/usr/bin/expect
yum -y install expect
spawn scp 192.168.4.254:/root/lnmp_soft/nginx-1.12.2.tar.gz /root/
expect "passwd:"
send "Teacher.niu\r"
expect eof
#itar -xf /root/nginx-1.12.2.tar.gz
#cd nginx-1.12.2
#useradd -s /sbin/nologin nginx
#yum -y install gcc pcre-devel openssl-devel
#./configure --user=nginx --group=nginx --with-http_ssl_module
#make & make install
#ln -s /usr/local/nginx/bin/nginx /sbin/
#nginx
#yum -y install php php-fpm php-mysql
#yum -y install mariadb mariadb-server mariadb-devel
#systemctl start php-fpm
#systemctl start mariadb
