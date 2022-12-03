
#### 1. Redis安装包目录结构

- redis6应用启动配置文件：[redis.conf](https://raw.githubusercontent.com/redis/redis/6.0/redis.conf)
- redis应用启动文件：[github地址](github地址)
```shell
mkdir -p $PWD/redis/{conf,data,logs}
# 按照如下目录结构创建文件夹，把redis.conf放置conf文件夹内
redis
├── conf
│   └── redis.conf
├── data
├── docker-compose.yml
└── logs
```

#### 2. 启动Redis

```shell
# 处理系统内核
echo "net.core.somaxconn=1024" >> /etc/sysctl.conf
echo "vm.overcommit_memory=1" >> /etc/sysctl.conf
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local
chmod +x /etc/rc.local
source /etc/rc.local
sysctl -p

#创建 docker-compose.yaml
cat >> docker-compose.yaml <<EOF
version: '3'
services:
  redis:
    image: 'redis:6.0.5'
    container_name: 'redis'
    restart: always
    tty: true
    volumes:
      - \$PWD/data:/data
      - \$PWD/conf/redis.conf:/etc/redis/redis.conf
      - \$PWD/logs:/logs
    ports:
      - 63790:6379
    command:
      - /bin/bash
      - -c
      - |
        echo 1024 > /proc/sys/net/core/somaxconn
        redis-server --requirepass "redis6379"
    privileged: true
EOF

# 启动
cd $PWD/redis
docker-compose up -d
```
