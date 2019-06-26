读写分离就是单独设置一台代理服务器，代理服务器中设置哪台mysql负责读（从）
哪台负责写（主），客户端访问代理服务器
所用软件是maxscale
思路：修改配置文件/etc/maxscale.cnf，设置好监控的节点，路由的节点（代理服务器相当于一代路由服务器，路由的数据库），在数据库服务器上要创建一个监控用户，一个路由用户,路由用户的作用：客服机远程登陆数据据时用到的用户名密码在代理服务器上是没有的，代理服务器需要到数所库服务器查询，代理服务器连接数据库服务器来查询用户信息的帐户就是路由用户

一、安装
	下载rpm安装包
	rpm -ivh maxscale.rpm
	vim /etc/maxscale.cnf
	
	[maxscale]
	threads=1	把1改成auto，这根CPU核数有关，auto是自动
	[server1]	定义数据库服务器，实际有几台mysql服务器就将这五行复制几次，不能重名，设置实际IP
	[MySql monitor] 设置监控相关信息
	server＝server1，server2	实际有几台就写几个，中间逗号分开
	user＝用户名	监控用户名，要在数据库服务器上设置好权限：replication slave,replication client
	password=密码
	＃[Read-Only service]这是设置只读服务器的，但是所有关于只读服务器的设置全部注释掉，因为如果开启了，那么主库坏的了时候，它不会向从库里写信息，数据就会丢失
	[Read-Write Service] 读写相关设置
	servers=server1,server2
	user=用户名	路由用户
	passwd=密码	
	
	整个配置文件的最后加上
	port＝4016 这是管理端口
	保存退出
	
	

