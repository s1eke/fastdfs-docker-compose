#!/bin/bash

set -e

if [ -n $SERVER_IP ]; then
    echo "替换server_ip"
    sed -i "s/localhost/${SERVER_IP}/g" /usr/local/nginx/conf/nginx.conf
fi

if [ -n $FDFS_WORKDIR ]; then
    echo "替换fdfs_workid"
    sed -i "s|/home/yuqing/fastdfs|${FDFS_WORKDIR}|g" /etc/fdfs/tracker.conf
    sed -i "s|/home/yuqing/fastdfs|${FDFS_WORKDIR}|g" /etc/fdfs/storage.conf
    sed -i "s|/home/yuqing/fastdfs|${FDFS_WORKDIR}|g" /etc/fdfs/mod_fastdfs.conf
    sed -i "s|/home/yuqing/fastdfs|${FDFS_WORKDIR}|g" /etc/fdfs/client.conf
    mkdir -p ${FDFS_WORKDIR}/data ${FDFS_WORKDIR}/tracker
fi

if [ -n $TRACKER_SERVER ]; then
    echo "注释原有 tracker_server 配置"
    sed -i 's/^tracker_server.*/#&/' /etc/fdfs/storage.conf
    sed -i 's/^tracker_server.*/#&/' /etc/fdfs/mod_fastdfs.conf
    sed -i 's/^tracker_server.*/#&/' /etc/fdfs/client.conf
    echo "替换所有tracker_server"
    TRACKER_SERVER_LIST=(${TRACKER_SERVER//,/ })
    for i in $(seq 1 ${#TRACKER_SERVER_LIST[@]}); do echo "tracker_server = ${TRACKER_SERVER_LIST[((i - 1))]}"; done >>/etc/fdfs/mod_fastdfs.conf
    for i in $(seq 1 ${#TRACKER_SERVER_LIST[@]}); do echo "tracker_server = ${TRACKER_SERVER_LIST[((i - 1))]}"; done >>/etc/fdfs/storage.conf
    for i in $(seq 1 ${#TRACKER_SERVER_LIST[@]}); do echo "tracker_server = ${TRACKER_SERVER_LIST[((i - 1))]}"; done >>/etc/fdfs/client.conf
fi

if [ -n $STORAGE_IDS ]; then
    echo "替换所有storeage_ids"
    STORAGE_IDS_LIST=(${STORAGE_IDS//,/ })
    for i in $(seq 1 ${#STORAGE_IDS_LIST[@]}); do echo "10000$i   group1  ${STORAGE_IDS_LIST[((i - 1))]}"; done >/etc/fdfs/storage_ids.conf
fi

echo "start trackerd"
/etc/init.d/fdfs_trackerd start

echo "start storage"
/etc/init.d/fdfs_storaged start

echo "start nginx"
/usr/local/nginx/sbin/nginx

tail -f ${FDFS_WORKDIR}/logs/trackerd.log
