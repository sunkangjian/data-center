###  Nacos部署

#### 1. Nacos安装包目录结构

- Nacos应用启动配置文件：[application.properties](github地址)
- Nacos应用启动文件：[https://github地址](github地址)

```shell
mkdir -p $PWD/nacos/{conf,data,logs,plugins}
# 按照如下目录结构创建文件夹，把application.properties放置conf文件夹内
nacos
├── conf
│   └── application.properties
├── data
├── docker-compose.yml
├── logs
└── plugins
```

#### 2. 启动Nacos

```shell
#创建docker-compose.yaml
cat >> docker-compose.yaml <<EOF
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
      - \$PWD/logs/:/home/nacos/logs
      - \$PWD/plugins/:/home/nacos/plugins
      - \$PWD/data/:/home/nacos/data
      - \$PWD/conf/application.properties:/home/nacos/conf/application.properties
EOF

#启动
cd $PWD/nacos
docker-comopse up -d
```

#### 3. 创建nacos命名空间

**命令行创建**

```shell
# customNamespaceId=ddc_hashrate_system 命名空间为固定
# namespaceName=ddc_hashrate_system  
curl -X POST 'http://{NACOS-HOST}:8848/nacos/v1/console/namespaces' -d 'customNamespaceId=ddc_hashrate_system&namespaceName=ddc_hashrate_system&namespaceDesc=算力中心平台'
```
**页面创建**  

打开Nacos页面，默认端口是8848，默认登录名和密码：nacos/nacos，登录页面点击【命名空间】-【新建命名空间】，命名空间ID(不填则自动生成)必须填写成【ddc_hashrate_system】，命名空间名必须填写成【ddc_hashrate_system】。

#### 4 下载应用服务端配置文件

- 应用服务端配置文件压缩包下载：[github地址](github地址)

##### 4.1. 配置清单

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

通过Nacos控制台页面【配置管理】-【配置列表】-【ddc_hashrate_system】导入应用服务端配置文件压缩包，注意配置文件需导入到【ddc_hashrate_system】空间，不要导入public(保留空间)。
关于更多的nacos控制台说请参考[nacos官方文档](https://nacos.io/zh-cn/docs/console-guide.html)
