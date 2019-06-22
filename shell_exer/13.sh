#!/bin/bash
i=1
while [ $i -le 254 ]
do
    ping -c2 -i0.2 -w1 192.168.4.$i &>/dev/null
    if [ $? -eq 0 ];then
      echo "tong"
    else
      echo "butong"
    fi
let i++
done
