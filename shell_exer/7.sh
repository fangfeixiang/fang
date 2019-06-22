#!/bin/bash
if [ ${USER} == "root" ];then
    yum -y install vsftpd
else
    echo "非管理员，无法安装"
fi
