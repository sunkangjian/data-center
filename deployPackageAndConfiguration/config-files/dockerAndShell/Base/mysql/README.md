#### 1. MySQL安装包目录结构

- 数据库初始化脚本：[mysql-schema.sql](https://githubxxx.com)

```shell
# 按照下述结构创建文件夹，并将下载好的配置文件和脚本放至指定目录
mysql
├── conf
│   └── my.cnf
├── data
├── docker-compose.yml
└── script
    └── mysql-schema.sql
```

#### 2. 启动MySQL

```shell
#下载镜像
docker pull mysql:5.7.39

#创建docker-compose.yaml
cat >> docker-compose.yaml <<EOF
version: '3'
services:
  mysql:
    image: mysql:5.7.39
    restart: always
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: xxx # 数据库密码，自己设置
      TZ: Asia/Shanghai
    ports:
      - 3306:3306
    volumes:
      - \$PWD/data:/var/lib/mysql
      - \$PWD/conf/my.cnf:/etc/mysql/my.cnf
      - \$PWD/script:/mysql-script
    command:
      --max_connections=100000
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_general_ci
      --default-authentication-plugin=mysql_native_password
EOF

#启动
cd $PWD/mysql
docker-compose up -d
```

#### 3. 数据验证

```shell
docker exec -it mysql bash
mysql -uroot -p<mysql-password>
# 数据初始化
mysql> source /mysql-script/mysql-schema.sql
...
mysql> show databases;
mysql> use ddc_xxxxx;
mysql> show tables;
...
```
