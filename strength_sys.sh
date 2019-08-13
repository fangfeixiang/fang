#!/bin/bash
#本脚本用于基础系统加固
function cut_line() {
	for ((i=1;i<=30;i++))
	do	
		echo -n '-'
	done
	echo ''	
}

cut_line
read -p "设置密码最长有效期: " max_d
read -p "设置密码修改之间最小的天数: " min_d
read -p "设置密码最短长度:" min_l
read -p "设置密码失效前多少天通知用户:" mes_d

sed -i '/^PASS_MAX_DAYS/c\PASS_MAX_DAYS		'$max_d'' /etc/login.defs
sed -i '/^PASS_MIN_DAYS/c\PASS_MIN_DAYS		'$min_d'' /etc/login.defs
sed -i '/^PASS_MIN_LEN/c\PASS_MIN_LEN		'$min_l'' /etc/login.defs
sed -i '/^PASS_WARN_AGE/c\PASS_WARN_AGE		'$MES_D'' /etc/login.defs
echo "已对密码进行加固,新密码不得和旧密码相同,且新密码必须同时包含数字,小写字母,大写字母"
sleep 1
sed -i '/pam_pwquality.so/c\password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=  difok=1 minlen=8 ucredit=-1 lcredit=-1 dcredit=-1' /etc/pam.d/system-auth
echo "已对密码进行加固,如果输入错误超过3次,则锁定账户!!"
n=`cat /etc/pam.d/sshd | grep "auth required pam_tally2.so" | wc -l`
if [ $n -eq 0 ];then
	sed -i '/%PAM-1.0/a\auth required pam_tally2.so deny=3 unlock_time=150 even_deny_root root_unlock_time300' /etc/pam.d/sshd
fi

echo "已设置禁止root用户远程登陆!!" 
sed -i '/PermitRootLogin/c\PermitRootLogin no' /etc/ssh/sshd_config

read -p "设置历史命令保存条数:" his
read -p "设置账户自动注销时间:" tim
sed -i '/^HISTSIZE/c\HISTSIZE='$his'' /etc/profile
sed -i '/^HISTSIZE/a\TMOUT='$tim'' /etc/profile

echo "已设置只允许wheel组的用户可以使用su命令切换到root用户!"
sed -i '/pam_wheel.so use_uid/c\auth	required	pam_wheel.so use_uid' /etc/pam.d/su
n=`cat /etc/login.defs | grep SU_WHEEL_ONLY | wc -l`
if [ $n -eq 0 ];then
	echo SU_WHEEL_ONLY yes >> /etc/login.defs
fi

echo "即将对系统中的账户进行检查..."
echo "系统中有登陆权限的用户有:"
awk -F: '($7 == "/bin/bash"){print $1}' /etc/passwd
cut_line
echo "系统中UID=0的用户有:"
awk -F: '($3==0){print $1}' /etc/passwd
cut_line
N=`awk -F: '($2==""){print $1}' /etc/shadow | wc -l`
echo -e "\033[31m系统中空密码用户有:$N\033[0m"
if [ $N -eq 0 ];then
	echo "系统中无空密码用户"
	cut_line
else
	i=1
	while [ $N -gt 0 ]
	do
		NONE=`awk -F: '($2==""){print $1}' /etc/shadow | awk 'NR=='$i'{print}'`
		cut_line
		echo $NONE
		echo "必须为空密码用户设置密码!!"
		passwd $NONE
		let N--
	done
	M=`awk -F: '($2==""){print $1}' /etc/shadow | wc -l`
	if [ $M -eq 0 ];then
		echo -e "\033[32m系统已经没有空密码用户!\033[0m"
	else
		echo "系统中还存在空密码用户:$M"
	fi
fi
cut_line
echo -e "\033[31m即将对系统中重要文件进行锁定,锁定后将无法添加删除用户和组\033[0m"
echo -e "\033[31m即将对系统中重要文件进行锁定,锁定后将无法添加删除用户和组\033[0m"
echo -e "\033[31m即将对系统中重要文件进行锁定,锁定后将无法添加删除用户和组\033[0m"
read -p "警告:此操作运行后将无法添加删除用户和组!!确定请输入Y,取消请输入N; Y/N: " i
case $i in
[Y,y])
	chattr +i /etc/passwd
	chattr +i /etc/shadow
	chattr +i /etc/group
	chattr +i /etc/gshadow
	echo "锁定成功"
;;
[N,n])
	chattr -i /etc/passwd
	chattr -i /etc/shadow
	chattr -i /etc/group
	chattr -i /etc/gshadow
	echo "取消锁定成功"
;;
*)
	echo "请输入Y/y或者N/n"
esac
