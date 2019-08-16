#!/bin/bash
#本脚本用于自动备份目录,并删除N天前的备份文件 
echo "======开始备份======"
#备份文件存放位置
BACKUP=/home
#文件名
DATETIME=$(date +%Y-%m-%d)
echo "======备份的路径是:$BACKUP/$DATETIME/$DATETIME.tar.gz"

#要备份哪台主机的数据库
HOST=10.10.14.59
#数据库的登陆名
DB_USER=root
#数据库的登陆密码
DB_PWD=123456
#要备份哪个库
DATABASE=wjy

[ ! -d "$BACKUP/$DATETIME" ] && mkdir -p "$BACKUP/$DATETIME"

mysqldump -u${DB_USER} -h${HOST} -p${DB_PWD} $DATABASE | gzip > $BACKUP/$DATETIME/DATETIME.sql.gz

cd $BACKUP
tar -czvf $DATETIME.tar.gz $DATETIME

rm -rf $BACKUP/$DATETIME

find $BACKUP -mtime +10 -name "*.tar.gz" -exec rm -rf {} \;
echo "=====备份完成====="
