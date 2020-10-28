#!/bin/bash

set -e

echo "Import ENV form docker-compose"
cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf
cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf
cp /etc/fdfs/storage_ids.conf.sample /etc/fdfs/storage_ids.conf

if [ -n $FDFS_WORKDIR ]; then
sed -i "s|/home/yuqing/fastdfs|${FDFS_WORKDIR}|g" /etc/fdfs/tracker.conf 
sed -i "s|/home/yuqing/fastdfs|${FDFS_WORKDIR}|g" /etc/fdfs/storage.conf 
mkdir -p ${FDFS_WORKDIR}/data ${FDFS_WORKDIR}/tracker
fi

if [ -n $TRACKER_SERVER ]; then 
# 注释原有 tracker_server 配置
TRACKER_SERVER_LIST=(${TRACKER_SERVER//,/ })
sed -i 's/^tracker_server.*/#&/' /etc/fdfs/storage.conf
for i in $(seq 1 ${#TRACKER_SERVER_LIST[@]});do echo "tracker_server = ${TRACKER_SERVER_LIST[((i-1))]}";done  >> /etc/fdfs/storage.conf
fi

if [ -n $STORAGE_IDS ]; then
STORAGE_IDS_LIST=(${STORAGE_IDS//,/ })
for i in $(seq 1 ${#STORAGE_IDS_LIST[@]});do echo "10000$i   group1  ${STORAGE_IDS_LIST[((i-1))]}";done > /etc/fdfs/storage_ids.conf
fi
/etc/init.d/fdfs_trackerd start
/etc/init.d/fdfs_storaged start
tail -f ${FDFS_WORKDIR}/tracker/logs/trackerd.log