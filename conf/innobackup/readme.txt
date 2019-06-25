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
    innobackupex --apply-log --redo-only 目录名1 --incremental-dir=目录名2：

