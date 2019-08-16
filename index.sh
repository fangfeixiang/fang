#!/bin/bash
#本脚本可用于基础安装nginx/mysql/lnmp/php

cat << EOF
+------------------------------+
|							   |
|		 index.sh			   |
|       1.安装Nginx            |
|       2.安装MySql            |
|       3.安装PHP              |
|       4.配置LNMP环境         |
|							   |
+------------------------------+
EOF
#node 1
read -p "请输入一个数字:" NUM

