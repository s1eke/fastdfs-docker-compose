# fastdfs-docker-compose

fastdfs 的一个集群镜像，自定义配置可在 .env 更改，多个 IP 要用逗号分隔。暂时没有高可用配置，这部分用程序去做了，而且相对来说用程序去做这种事也比搞keepalived 要方便多了，并不是运维想偷懒（逃

软件版本是写死的，搞这个其实还是为了内网部署方便=。=所以就偷懒了，
| 软件包        | 版本号 |
| ------------- | ------ |
| fastdfs       | 6.06   |
| libevent      | 2.1.12 |
| libfastcommon | 1.0.43 |
| alpine        | 3.12.1 |
