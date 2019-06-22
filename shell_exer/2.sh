#!/bin/bash
read -p "请输入要创建的用户名：" u
read -p "请输入要设置的密码：" p
useradd ${u}
echo "${p}" | passwd --stdin ${u}

