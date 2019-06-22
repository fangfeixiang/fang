#!/bin/bash
num=$[RANDOM%100+1]
while :
  do
    read -p "请输入一个整数[1-100]:" cai
    if [ ${cai} -eq ${num} ];then
      echo "恭喜，猜对了"
    elif [ ${cai} -gt ${num} ];then
      echo "Oops,大了"
    else
      echo "小了"
    fi
  done
