#!/bin/bash
rm -rf ~/.ssh/known_hosts
/usr/bin/expect <<EOF
set timeout 1
spawn ssh 192.168.4.254
expect "yes/no" {send "yes\r"}
expect "password" {send "Teacher.niu\r"}
expect "#" {send "exit\r"}
EOF
