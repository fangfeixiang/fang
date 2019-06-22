#!/bin/bash
read -p "请输入第一个整数：" num1
read -p "请输入第二个整数：" num2
read -p "请输入第三个整数：" num3
tmp=0
if [ ${num1} -gt ${num2} ];then
  tmp=${num1}
  num1=${num2}
  num2=${tmp}
fi
if [ ${num1} -gt ${num3} ];then
  tmp=${num1}
  num1=${num3}
  num3=${tmp}
fi
if [ ${num2} -gt ${num3} ];then
  tmp=${num2}
  num2=${num3}
  num3=${tmp}
fi
echo "从小到大是${num1},${num2},${num3}"
