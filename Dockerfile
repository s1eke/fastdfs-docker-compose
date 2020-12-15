FROM alpine:3.12.1

LABEL maintainer="Sean Fang <silence.boy@live.cn>"
ENV HOME /root 

# 升级软件包并安装编译依赖，使用 --virtual 方便后面删除
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk update && \
    apk add --no-cache --virtual .mybuilds \
    file \
    bash \
    gcc \
    make \
    linux-headers \
    curl \
    gnupg \
    gd-dev \
    pcre-dev \
    zlib-dev \
    libc-dev \
    libxslt-dev \
    openssl-dev \
    geoip-dev \
    python2 \
    busybox-extras \
    vim


ADD package/* ${HOME}/

# 安装 libfastcommon 以及 libeven 
RUN     cd ${HOME}/libevent-2.1.12-stable \
        && ./configure \
        && make && make install \
        && cd ${HOME}/libfastcommon-1.0.43/ \
        && ./make.sh \
        && ./make.sh install 


# 安装fastdfs v6.06
RUN     cd ${HOME}/fastdfs-6.06/ \
        && mkdir -p /etc/fdfs \
        && ./make.sh \
        && ./make.sh install \
        && cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf \
        && cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf \
        && cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf  \
        && cp /etc/fdfs/storage_ids.conf.sample /etc/fdfs/storage_ids.conf \
        && cp ./conf/http.conf /etc/fdfs/http.conf  \
        && cp ./conf/mime.types /etc/fdfs/mime.types
        

# 安装 nginx
RUN cd ${HOME}/nginx-1.18.0 \
    && mv ../fastdfs-nginx-module . \
    && cp /root/nginx-1.18.0/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs \
    && sed -i "s@url_have_group_name = false@url_have_group_name = true@g" /etc/fdfs/mod_fastdfs.conf \
    && ./configure --add-module=./fastdfs-nginx-module/src/ \
    && make \
    && make install \
    && rm /usr/local/nginx/conf/nginx.conf

COPY conf  /usr/local/nginx/conf
    

# 清理文件并安装软件运行依赖
# RUN rm -rf ${HOME}/*
# RUN apk del .mybuilds 
RUN apk add bash pcre-dev zlib-dev

# 创建启动脚本
COPY docker-entrypoint.sh /usr/bin/

ENTRYPOINT ["/bin/bash","/usr/bin/docker-entrypoint.sh"]
