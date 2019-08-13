#!/bin/bash
#对硬盘进行分区,得到一个标准linux文件系统(ext4/xfs)的主分区
cat /proc/partitions > old
while :
do
	read -p "请输入你要分区的硬盘(写绝对路径,如:/dev/sda):" A
	if [ ! -e $A ];then
		echo "设备不存在,请重新输入"
		continue
	elif [ $A == ''];then
		echo "您的输入为空,请重新输入设备路径"
		continue
	else
		break
	fi
done
#read -p "请输入你要创建的磁盘分区类型(回车即可)" B
read -p "请输入分区数字,范围1-4,默认从1 开始,默认按回车即可:" C
read -p "请输入扇区起始表号,默认按回车即可:" D
read -p "请输入你要分区的分区大小(格式:如+5G):" E

fdisk $A <<EOF
n
p
$C
$D
$E
w
EOF
echo "---------------------------------"
echo "一个标准的linux文件系统分区已经建好"
partprobe $A &> /dev/null
echo "---------------------------------"
#cat /proc/partitions
cat /proc/partitions > new
F=`diff new old | grep "<" | awk '{print $5}'` 
echo "新分区名为:$F"
read -p "请输入分区文件系统类型(ext4/xfs):" G
read -p "请输入分区挂载目录(请输入绝对路径,如:/mnt/test):" H
echo "新分区将被挂载到$H下"
if [ ! -e $H ];then
	mkdir $H
fi
case $G in
ext4)
	mkfs.ext4 /dev/$F &> /dev/null
;;
xfs)
	mkfs.xfs /dev/$F  &> /dev/null
;;
*)
	echo "请输入有效的文件系统(ext4/xfs)"
esac
n=`cat /etc/fstab | grep /dev/$F | wc -l`
if [ $n -eq 0 ];then
	echo "/dev/$F $H $G defaults 0 0" >> /etc/fstab
else
	sed -i '/^\/dev\/$F/c\/dev/$F  $H $G defaults 0 0' /etc/fstab
fi
mount -a &> /dev/null 
r=`df -h | grep /dev/$F | wc -l`
if [ $r -eq 1 ];then
	echo "-------------------------"
	echo -e "新分区创建并挂载成功!\n分区名称为:$F\n文件系统为$G\n挂载目录为:$H\n分区容量为:$E"
	echo "-------------------------"
fi
