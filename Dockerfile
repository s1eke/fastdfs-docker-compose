FROM alpine:3.12.1

LABEL maintainer="silence.boy@live.cn"
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
    python2 


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
        && ./make.sh install


# 清理文件并安装软件运行依赖
RUN rm -rf ${HOME}/*
RUN apk del .mybuilds 
RUN apk add bash pcre-dev zlib-dev

# 创建启动脚本
COPY docker-entrypoint.sh /usr/bin/

ENTRYPOINT ["/bin/bash","/usr/bin/docker-entrypoint.sh"]