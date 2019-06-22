#!/bin/bash
read -p "是否创建新的虚拟机（Y/N）：" ans
if [ ${ans} == y ];then
	read -p "请输入虚拟机编号{1-99}:" num
	echo $num | clone-vm7 &> /dev/null
	echo "稍等，正在创建..."

	sleep 3
	[ $num -le 9 ] && virsh start rh7_node0$num || virsh start rh7_node$num
	
	echo "虚拟机正在启动..."
	echo "额～～还不会自动设置IP和主机名,你手动搞吧!!"
	echo "别关窗口，设置好IP和主机名后告诉我,我再帮你设置YUM"
	sleep 1	
	virt-manager
	sleep 15
	while :
	do
	read -p "好了没（Y/N）：" a
	if [ ${a} == y ];then
		break
	else
		sleep 5
		continue
	fi
	done
fi

	read -p "请输入需要设置的远程IP:" i
	ping -c 2 $i &> /dev/null
	if [ $? -eq 0 ];then
		ssh-copy-id $i
		sleep 0.5
		ssh $i "rm -rf /etc/yum.repos.d/*"
		sleep 0.2	
		scp /root/dvd.repo $i:/etc/yum.repos.d/
		ssh $i "yum clean all"
		ssh $i "yum repolist"
		scp /root/lnmp*.tar.gz $i:/root/
		ssh $i "tar -xf /root/lnmp*.tar.gz"
		ssh $i "rm -rf /root/lnmp*.tar.gz"
	else
		echo "网络不可达----去查查IP到底是多少"
	fi
