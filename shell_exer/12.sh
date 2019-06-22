#!/bin/bash
for i in {1..254}
do
  ping -c2 -i0.1 -w1 192.168.4.$i &>/dev/null
  if [ $? -eq 0 ];then
    echo "tong"
  else
    echo "butong"
  fi
done
