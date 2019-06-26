安装redis
    解压
    yum -y install gcc
    make && make install
    utils/install_server.sh
    
    /etc/init.d/redis_6379 stop     先停服务
    vim /etc/redis/6379.conf        修改redis主配置文件，修改ip，port
    vim /etc/init.d/redis_6379      修改服务控制脚本，端口，ip
    /etc/init.d/redis_6379 start    启动服务
    
    主从模式有：主－从、主－从－从、一主多从

    所有redis默认就是主库服务器，不需要设置
    从库设置
        vim /etc/redis/6379.conf
        slaveof 主库ip　主库端口    开启从库模式
        masterauth  主库密码        如果主库有密码则开启，没有则不开
        重启服务
    
        info replication            查看
             
    
    哨兵服务可以监控主从同步状态，并在主库发生宕机时自动提升从库为主库
    哨兵服务在安装redis时会附带安装，但不依靠redis服务

    用的命令是redis-sentinel
    首先创建配置文件，文件模板是redis安装源码包里的sentinel.conf,但实际只需     要少数几项设置    
    vim /etc/sentinel.conf          手动创建配置文件，名字不能改
    sentinel monitor 主库名   主库ip    主库端口    票数
        主库机随便起一个，ip，端口按实际填写，
        票数是指当有几台哨兵服务发现主库有问题时切换从库为主库，这个适用于有        多台哨兵服务器的大型网络，一般只有一台哨兵，所以票数填１
    bind   0.0.0.0
        哨兵从哪个ip监测主库，设为0.0.0.0，意思是从本机的所有网卡监测
    sentinel auth-pass  主库名　　　主库密码　　　　    
        这一项是主库有密码时才用，主库名同上边设置的一样就行，自己起的
    redis-sentinel /etc/sentinel.conf       启动服务

    当哨兵发现主库宕机时会自动将从库升为主库，
    原主库修好开机后会自动成为当前主库的从库,而且所有配置文件都会自动修改

    

