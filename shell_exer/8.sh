#!/bin/bash
if [ ${UID} -eq 0 ];then
  yum -y install vsftpd
else
  echo "不是管理员"
fi
