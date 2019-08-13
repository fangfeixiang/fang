#!/bin/bash
#此脚本针对系统用户文件被锁定造成无法添加删除用户的情况
echo -e "\033[31m此程序运行后系统可添加删除用户\033[0m"
read -p "确认解锁:Y \n取消解锁:N\n:" sel
case $sel in
[Y,y])
	chattr -i /etc/passwd
	chattr -i /etc/shadow
	chattr -i /etc/group
	chattr -i /etc/gshadow
	echo "系统用户文件已解锁"
	sleep 3
	exit
;;
[N,n])
	echo "已取消,系统用户文件将继续锁定"
	sleep 3
	exit
;;
*)
	echo "请输入Y/N"
esac
