#!/bin/bash
for i in `cat /root/user.txt`
do
  useradd -s /sbin/nologin $i
  echo "123456" | passwd --stdin $i
done
