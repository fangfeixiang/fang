#!/bin/bash
game=(石头 剪刀 布)
num=$[RANDOM%3]
computer=${game[$num]}

echo "请根据下列提示选择您的出拳手势"
echo "1.石头"
echo "2.剪刀"
echo "3.布"

read -p "请选择1-3:" person
case $person in
1)
  if [ ${num} -eq 0 ];then
    echo "平局"
  elif [ ${num} -eq 1 ];then
    echo "你赢了"
  else
    echo "电脑赢"
  fi;;
2)
  if [ ${num} -eq 0 ];then
    echo "电脑赢"
  elif [ ${num} -eq 1 ];then
    echo "平局"
  else
    echo "你赢了"
  fi;;
3)
  if [ ${num} -eq 0 ];then
    echo "你赢子"
  elif [ ${num} -eq 1 ];then
    echo "电脑赢"
  else
    echo "平局"
  fi;;
*)
  echo "请按要求输入1-3"

esac
