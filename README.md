# fastdfs-docker-compose

fastdfs 的一个集群镜像，自定义配置可在 docker-compose.yml 更改，多个 IP 要用逗号分隔。

~~暂时没有高可用配置，这部分用程序去做了，而且相对来说用程序去做这种事也比搞keepalived 要方便多了，并不是运维想偷懒（逃~~

现在虽然还是没有 keepalived ，但是加了一层 nginx ，因为 fastdfs 默认是不支持分片，需要通过 nginx 插件来支持。keepalived 这种事，还是开发来解决最方便啦（逃

软件版本是写死的，搞这个其实还是为了内网部署方便 =。= 所以就偷懒了。直接下了目前来说最新的版本，如果有其他版本需求的话，直接去下包替换一下，再改一下dockerfile的路径就好。

| 软件包               | 版本号 |
| -------------------- | ------ |
| fastdfs              | 6.06   |
| libevent             | 2.1.12 |
| libfastcommon        | 1.0.43 |
| alpine               | 3.12.1 |
| nginx                | 1.18.0 |
| fastdfs-nginx-module | 1.22   |
