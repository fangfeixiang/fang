#!/bin/bash
disk_size=`df / -h -m | awk '/\//{print $4}'`
mem_size=`free -m | awk '/Mem/{print $4}'`
while :
do
if [ $disk_size -le 1000 -o $mem_size -le 500 ];then
	echo "ziyuanbuzu"
fi
done
