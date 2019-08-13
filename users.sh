#!/bin/bash
#该脚本用于检测用户相关信息
function cut_line() {
	for ((i=1;i<=30;i++))
	do
		echo -n "-"
	done
	echo ""
}

cut_line
read -p "请输入要查询的用户名: " sel_user
cut_line
n=`cat /etc/passwd |awk -F: '$1~/^'${sel_user}'$/{print}'| wc -l`
if [ $n -eq 0 ];then
	echo "该用户不存在!"
	cut_line
else
	echo "该用户的用户名是: $sel_user"
	echo "该用户的UID是: `cat /etc/passwd | awk -F: '$1~/^'${sel_user}'$/{print}' | awk -F: '{print $3}'`"
	echo "该用户的组是: `id ${sel_user} | awk '{print $3}'`"
	echo "该用户的GID是: `cat /etc/passwd | awk -F: '$1~/^'${sel_user}'$/{print}' | awk -F: '{print $4}'`"
	echo "该用户的家目录是: `cat /etc/passwd | awk -F: '$1~/^'${sel_user}'$/' | awk -F: '{print $6}'`"
	dl=`cat /etc/passwd | awk -F: '$1~/^'${sel_user}'$/' | awk -F: '{print $7}'`
	if [ ${dl} == "/bin/bash" ];then
		echo -e "\033[32m该用户有权限登陆系统\033[0m"
		cut_line
	elif [ ${dl} == "/sbin/nologin" ];then
		echo -e "\033[31m该用户无权登陆系统\033[0m"
		cut_line
	fi
fi
