redis持久化
    
    有两种模式  rdb 和 aof
RDB模式:Redis database
    默认为该模式，按照指定时间间隔将内存中的数据集快照写入硬盘
    恢复时就快照文件读入内存
    rdb模式优点：高性能，因为它是创建一个子进程来将内存的数据写入临时文件，         当临时文件创建完成后替换掉之前的dump.rdb文件
    save　手动保存，但保存的过程不能有新数据写入内存
    bgsave  手动保存，保存过程可以继续写入内存
    rdb默认有三种保存时间规则
        在redis配置文件中
            save    900     1               在15分钟内有1条写入
            save    300     10              在5分钟内有10条写入
            save    60      10000           在1分钟内有10000条写入
    １分钟和10000条两项同时满足才开始写入硬盘，比如只有１条新数据写入，即使达到了５分钟也不会向硬盘写入，因为它不满足10条写入的条件，所以这种规则造成一量宕机，最后一个规则时间段内的数据会丢失
    比较适合大量数据恢复并且对数据完整性要求不高的情况
    rpd备份和恢复
        方法就是把dump.rdb复制到新的机器同路径下，启动redis服务时会自动读取这个文件

AOF模式：Append only file
    为应对rdb的缺点，研发了aof模式，开启后会记录服务器上的所有写，改，删等操作，类似mysql的binlog，写入硬盘有三种方式，always：时时记录，并完成磁盘同步
    everysec：每秒记录一次，并完成磁盘同步
    no  写入aof但不执行磁盘同步
    开启aof后默认everysec模式
    
    开启方式，在redis配置文件中找到appendonly.aof　yes，开启后重启服务，会在redis配置文件目录下生成新的appendonly.aof文件
    aof方法缺点是日志文件会不断增大，所以redis设置了日志重写功能，是指达到要求会整理合并appendonly.aof文件里的内容，不会清除里边内容，
    aof在服务器宕机时最多丢失１秒的数据，而且可以利用appendonly.aof文件做误操作的撤销
    如果不小心修改了appendonly文件可以通过redis-check-aof --fix appendonly.aof来修复
