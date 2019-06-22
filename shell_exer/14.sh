#!/bin/bash
myping(){
  ping -c2 -i0.2 -w1 $1 &> /dev/null
    if [ $? -eq 0 ];then
      echo "tong"
    else
      echo "butong"
    fi
}
  for i in {1..254}
  do
    myping 192.168.4.$i &
  done
