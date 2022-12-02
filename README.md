# 城市算力中心平台部署说明

## 一、安装服务

### 1.1.配置要求

#### 最小配置

- 4CPU
- Memory: 16GB
- Disk: 100GB SSD

#### 建议配置

- 8 CPU
- Memory: 32GB
- Disk: 200GB SSD

### 1.2.环境要求

| 软件  | 版本  |
| ----- | ----- |
| MySQL | 5.7+  |
| Redis | 6.0.5 |
| Nginx | X.X.X |



### 1.3.	服务启动顺序

1- Nacos,链服务，运营job，运营权限服务
2- swap，swap-job
3- base服务，account服务
4- 运营服务
5- 门户服务 
6- 算力中心OpenAPI



### 1.4.	服务清单

| 服务标识 | 服务说明     | 环境要求 |
| -------- | ------------ | ------- |
| Nacos | Nacos服务 | 无 |
| 链服务标识每个都不同 | 链服务；中移链等 | Oracle JDK1.8  x64 |
| ddcopsjob | 运营job      | Oracle JDK11  x64 |
| ddcauth | 运营权限服务 | Oracle JDK11  x64          |
| ddc-swap-api | 交易服务     | Oracle JDK11  x64         |
| ddc-swap-job | 交易job服务  | Oracle JDK11  x64         |
| ddcbase | 基础服务  | Oracle JDK11  x64         |
| ddcaccount | 帐户服务  | Oracle JDK11  x64         |
| ddcops | 运营服务  | Oracle JDK11  x64         |
| ddcportal | 门户服务  | Oracle JDK11  x64         |
| ddcoai | 算力中心OpenAPI | Oracle JDK11  x64  |





## 二、创建数据库

 1. 如何获取数据库脚本

    git获取

 2.	如何验证

```mysql
    show tables;
```



### 三、获取部署包和配置文件

#### 3.1. 下载微服务部署包

   配置下载地址：github地址



#### 3.2. 下载Nacos服务包

github获取



#### 3.2. 下载配置文件

github获取



##### 3.2.1. 配置清单

配置具体说明请参考文件里的属性描述

| 配置名称 | 配置说明 |
| -------- | ------------ |
| ddc-swap-job.yaml | 交易服务定时配置 |
| system-config.yaml | 全局属性 |
| ddc_server_port_default.yml | 服务端口配置 |
| redis-common.yaml | redis配置 |
| mysql-jdbc-common.yaml | mysql配置 |
| ddc-web-common.yml | 门户，运营服务配置 |
| ddc-web-sftp.yml | sftp配置 |
| ddc-web-email.yml | 邮件服务配置 |
| kong-gateway-config.yml | 节点网关客户端配置； |
| ddc-chainsrv-{链名称全拼}.yaml | 链服务配置：链名称全拼如zhoingyi等 |




## 五、服务部署

### 5.1. 安装Nacos

1. 如何用docker安装

   docker-compose脚本

   ```yaml
   version: '3'
   services:
     nacos:
       image: 'nacos/nacos-server:v2.1.2'
       container_name: 'nacos'
       restart: always
       ports:
         - 8848:8848
         - 9848:9848
         - 7848:7848
         - 9849:9849
       environment:
         - PREFER_HOST_MODE=hostname
         - MODE=standalone
       volumes:
         - $PWD/logs/:/home/nacos/logs
         - $PWD/plugins/:/home/nacos/plugins
         - $PWD/data/:/home/nacos/data
         - $PWD/conf/application.properties:/home/nacos/conf/application.properties
   ```

2. 如何登录

   地址：http://{host}:{8848}/nacos

   默认账号：nacos/nacos

3. 如何命令方式创建命名空间

   ```shell
   # customNamespaceId=ddc_hashrate_system 命名空间为固定
   # namespaceName=ddc_hashrate_system  
   curl -X POST 'http://{NACOS-HOST}:8848/nacos/v1/console/namespaces' -d 'customNamespaceId=ddc_hashrate_system&namespaceName=ddc_hashrate_system&namespaceDesc=算力中心平台'
   ```

   

4. 如何导入配置文件到Nacos

   从github下载的配置文件登录nacos控制台导入进去。

   关于更多的nacos控制台说请参考[nacos官方文档](https://nacos.io/zh-cn/docs/console-guide.html)

5. 如何查看我的服务是否都正确注册到了Nacos

   在nacos控制台‘服务管理-服务列表’查看是否本文档介绍的服务器清单都以注册成功



### 5.2. 启动微服务

#### 5.2.1 jar方式启动

1. 算力中心管理服务以及链服务启动

   ```shell
   #!/bin/bash
   nohup /usr/local/java/bin/java \
   -Xms1G -Xmx2G -jar /{PAKCAGE_HOME}/{PAKCAGE_NAME}.jar \
   --nacos.config.namespace=ddc_hashrate_system \
   --nacos.config.server-addr=10.0.1.170:8848 \
    > /dev/null  2>&1 &
   ```

#### 5.2.2 Docker方式启动

1. 算力中心管理服务

   ```yaml
   version: "3"
   services:
     swapapi-ddc-service:
       image: java11-cn:11.0.16.1
       container_name: swapapi
       working_dir: /bsn/swapapi
       restart: always
       network_mode: host
       # ports:
       #   - 9070:9070
       volumes:
         - $PWD/pkg/ddc-swap-api.jar:/bsn/swapapi/ROOT.jar
         - /bsn/ddclogs/:/bsn/ddclogs/
         - $PWD/script/:/bsn/script
         - /etc/hosts:/etc/hosts
         - /etc/localtime:/etc/localtime
       environment:
         # 指定时区
         - TZ=Asia/Shanghai
       command: sh /bsn/script/start.sh
   ```

   2.链服务

   ```yaml
   
   ```









## 



