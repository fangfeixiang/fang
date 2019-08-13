#!/bin/bash
#使用一整块硬盘创建逻辑卷
function cut_line() {
	for ((i=1;i<=30;i++))
	do
		echo -n '-'
	done
	echo ""
}

while :
do
	rpm -q lvm2 &> /dev/null
	if [ $? -eq 0 ];then
		break
	else
		echo "未检测到软件,创建逻辑卷需要安装lvm2,请配置YUM源,并运行yum -y install lvm2手动安装"
		continue
	fi
done

while :							#输入硬盘路径并判断是否可用
do
        read -p "请输入你要分区的硬盘(写绝对路径,如:/dev/sda):" path
        if [ ! -e $path ];then
                echo "设备不存在,请重新输入"
                continue
        elif [ $path == '' ];then
                echo "您的输入为空,请重新输入设备路径"
                continue
        else
                break
        fi
done

pvcreate $path
echo "该硬盘已经做成物理卷"
cut_line
read -p "请输入卷组名字:" vgname
vgcreate $vgname $path
echo "该物理卷已加入卷组"
cut_line
vgs
free=`vgs | awk '$1~/'$vgname'/{print}' | awk '{print $7}'`
echo "该物理卷剩余空间为:$free"
read -p "请输入你要创建逻辑卷的名字:" lvname
read -p "请输入你要创建逻辑卷的大小(如:10G):" repy
lvcreate -L $repy -n $lvname $vgname
echo "已成功创建逻辑郑$lvname"
cut_line
lvs
cut_line
read -p "请输入$lvname的文件系统类型(ext4/xfs)" repy2
case $repy2 in
ext4)
	mkfs.ext4 /dev/$vgname/$lvname &>/dev/null
;;
xfs)
	mkfs.xfs /dev/$vgname/$lvname &>/dev/null
;;
*)
	echo "请输入有效的文件系统(ext4/xfs)"
esac
cut_line
read -p "请输入要挂载的目录(请输入绝对路径):" repy3
if [ ! -e $repy3 ];then
	mkdir $repy3
fi
echo "/dev/$vgname/$lvname $repy3 $repy2 defaults 0 0" >> /etc/fstab
mount -a &> /dev/null

