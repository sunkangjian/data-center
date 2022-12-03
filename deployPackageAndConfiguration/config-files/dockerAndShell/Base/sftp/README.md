
#### 1. Sftp安装包目录结构
- sftp应用启动文件：[github地址](github地址)
```shell
# 按照如下目录结构创建文件夹
sftp
├── data
├── docker-compose.yml
└── user
    └── users.conf
# 编写配置文件
# 用户名:密码:::存储路径2
echo "test:test:::upload" >> $PWD/redis/user/users.conf
```

#### 1. 启动Sftp

```shell
#创建docker-compose.yaml
cat >> docker-compose.yaml <<EOF
version: '3'
services:
  ftp:
    image: atmoz/sftp
    container_name: sftp
    restart: always
    volumes:
        - \$PWD/redis/data:/home/
        - \$PWD/redis/user/users.conf:/etc/sftp/users.conf
    ports:
        - "8012:22"
EOF

#启动
cd $PWD/redis
docker-compose up -d
```
