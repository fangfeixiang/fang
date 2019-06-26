innobackup是由percona公司开发，包含两个组件：xtrabackup和innobackupex,可用于备份mysql数据库，优点是不锁表，不影响备份过程中数据库的使用

安装：
    rpm -ivh libev-4.15-1.el6.rf.x86_64.rpm
    yum -y install percona-xtrabackup-24-2.4.7-1.el7.x86_64.rpm
    rpm -ql perconna-xtrabackup-24  可以查看安装的软件相关列表

常用命令
    完全备份
    innobackupex --user 用户名　--password 密码 备份目录名　--no-timestamp
        备份目录名指备份的文件要放在哪个目录，最后的--no-timstamp如果不加，软件会自动按日期在目录下建文件夹，然后再备份到对应日期的文件夹里，加上后同则直接备份到指定的目录下
    
    完全恢复
    innobackupex --apply-log  目录名　　　　读取日志，准备恢复
    innobackupex --copy-back  目录名        开始恢复

    增量备份
    innobackupex --user 用户名 --password 密码 --incremental 增量目录　--incremental-basedir=目录名 --no-timestamp
        第一个增量目录指增量备份出的文件放在哪个目录，incremental-basedir 的目录名指的是增量备份对就的完整备份目录
    
    增量恢复
    １、systemctl stop mysqld   停止数据库服务
    ２、rm -rf /var/lib/mysql/* 删除数据库里的原文件，
    ３、准备导入备份文件    
        innobackupex --apply-log --redo-only 目录名1 --incremental-dir=目录名2
        目录名１指的是完整备份的目录，目录名２是增量备份的目录，原理是在备份目录下有个xtrabackup_chjeckpoints文件里边记录着备份的偏移量，增量恢复时会把增备份的偏移量和数据合并到完全备份的文件里
    如果有多次增量备份则需要按备份时间从早到晚逐次的操作上边的命令，把所有的偏移量和数据全合并到最早的完全备份里
    合并完成后
    ４、导入备份文件
        innobackupex --copy-back 目录名     这个目录名是完全备份的目录，因为通过上边的操作已经把增量备份的数据全合并到这一个里边了
    5、chown -R mysql:mysql /var/lib/mysql  把导入后的数据库文件属主属组全调成mysql
    6、重启服务



    

    恢复单张表：
    先删除现有数据库表的表空间，然后在完全备份文件里导出表信息，会多出四个文件.ibd .frm .cfg .exp   ,然后把这４个文件拷到数据库目录对就的库文件夹里，修改属组属主为mysql，在数据库里导入这４个文件的信息即可，导入完成后删除.cfg和.exp文件
    １、alter table  库名.表名 discard tablespace;
    2、innobackupex --apply-log --expert 数据库完全备份目录
    ３、cp 4个文件　到/var/lib/mysql/库名/
    4、chwon -R mysql:mysql /var/lib/mysql
    5、alter table 库名.表名 import tablespace;
    6、删除.cfg和.exp文件
    ７、查看确认

