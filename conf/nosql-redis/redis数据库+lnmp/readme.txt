一、redis安装
        redis为非关系型数据库，每个变量（key）对就一个值，数据在内存中运行，定期自动存入硬盘中
    1、redis为源码包安装，需要安装gcc
        1、yum -y install gcc
        2、tar -xf redis.tar.gz
        3、cd redis
        4、make && make install
    2、初始化配置  在源码包下
        util/install_server.sh
    3、此时可能redis-cli连接登陆
        keys *                   查看所有key及值  keys a？    ？代表一个字符，a？代表所有以a开头，名字总共2个字符的key及值
        select [0..15]           redis默认16个库，编号为0-15，select 切换库
        set key 值               插入一个值
        mset key1                值1 key2 值2 。。。。   插入多个key及值，中间全用逗号分开
        get key                  查询这个key的值
        mget key1 key2 key3      查询多个key的值
        type key                 查询某个key值的类型，  比如  set a 100    type a    结果是string,字符型，这个100在redis里是以字符型式存储的
        exists key               查询某个key是否存在，
        redis默认是覆盖型存储，一个key赋多次值，只有最后一次生效
        tts key                  查询key的生存时间，-1为永久有效，>1为剩余生存时间，单位是秒，-2为已经过期的key
        expire key               给某个key设定生存时间
        move key  库名           移动key到别的库
        flushall                 删除所有库的所有key
        flushdb                  删除所在库的key
        save                     保存key到硬盘
        shutdown                 停止服务
    4、redis主配置文件
        /etc/redis/6379.conf
            平时修改较多的有
            70行 bind  ip     从哪个网卡访问redis，默认是127.0.0.1，可以设置成本机网卡的ip，可以是多个ip，中间空格分开
            93行 port  6379   可以修改成其它未被占用的端口
            501行  requirepass  密码    去掉＃重启即生效
            137行  daemonize yes    守护进程方式运行，守护进程方式是指，启动一个进程，一直驻留内存并保持活跃状态
                                    非守护进程方式，启动进程后如果不用即休眠，如果启用需要一个程序激活它
            187行   databases 16    库数量
            172行   logfile         日志文件位置
            533行   maxclient       并发数数量，默认10000，已经较高，如果硬件足够，还可以更高
            264行   dir             数据库目录
            560行   maxmemory       最大可用内存值，
            602行   maxmemory－samples  内存清理时参考例子个数
            565行--572行
                内存清理策略
                    1、noeviction（默认）：内存空间不足会报错，工作中不能用这种，否则内存满了客户端会报错
                    2、allkeys-lru：最近最少使用的数据去淘汰
                    3、allkeys-random：随机淘汰一些key
                    4、volatile-random：在已经设置了过期的时间去随机淘汰
                    5、volatile-lru：在已经设置了过期的时间去淘汰最近最少使用的数据
                    6、volatile-ttl：在已经设置了过期的时间去淘汰即将过期的key
                    7、allkeys-lfu : 在所有数据中选择历史使用最少的淘汰
                    8、volatile-lfu : 在所有设置了过期时间的数据中选择历史使用最少的淘汰
                        7和8是redis4.0以后版本才有的

    5、redis服务的启动和停止
        使用脚本，默认位置
            /etc/init.d/redis_6379   后边跟start或者stop
        但要注意的是如果改了端口、密码、ip后，停止端口就要修改配置
        端口：    REDISPORT="6379"   这是在上方定义变量位置，端口号改成实际端口
        IP和密码  $CLIEXEC -h ip -a 密码 -p $REDISPORT shutdown
    6、同样改了端口，ip，密码后连接方式也改变
        redis-cli -h ip -a 密码 -p 端口
        或者是 redis-cli -h ip -p端口进去后auth 密码，否则无法操作


二、LNMP+redis
    1、按正常方式搭建redis
    2、部署lnmp
        安装gcc，php，php-fpm,php-devel,zlib-devel,
            ./configure
            make && make install
        修改配置文件启动php－fpm      
            /usr/local/nginx/conf/nginx.conf
        启动nginx服务
            /usr/local/nginx/sbin/nginx
        启动php-fpm服务,php-fpm服务端口是9000
            systemctl start php-fpm
        写个php页面，测试lnmp
            <?php
                echo "hello";
                ?>
    3、安装php-redis扩展模块
        源码包安装
            rpm -q autoconf automake  检查这两个模块，没有就安装上
            tar -xf php-redis.tar.gz
            cd phpredis
            phpize       生成配置文件php-config和configure命令     php -m可以查看php已经支持的模块命令
            ./configure  --with-php-config=/usr/bin/php-config
            make && make install
            
        扩展模块的配置文件
            /etc/php.ini
            728行   extension_die="/usr/lib64/php/modules/"      模块写绝对路径，注意最后／一定要有
            730行   extension="redis.so"   模块名
        重启php-fpm服务
        测试正常应用       
