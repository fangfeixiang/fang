#!/bin/bash
#本脚本是用inotify和rsync配合实现两个文件/文件夹时时同步,可以pgrep -l inotify查看后台进程
#启动脚本时需要给定两具位置变量,分别代表原文件,目标文件 

FROM_F=$1
DEST_F=$2
RSYNC_CMD="rsync -az --delete $FROM_F $DEST_F"

while inotifywait -rqq -e modify,delete,create,move,attrib $FROM_F
do
	$RSYNC_CMD
done	&
