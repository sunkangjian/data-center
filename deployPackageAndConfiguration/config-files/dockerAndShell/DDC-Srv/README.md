#### 1. docker镜像准备
- [oraclejdk11下载地址【官方地址】](https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html)
##### 1.1. JDK11镜像准备
```shell
# 准备jdk文件，以下版本经过测试实际可用
jdk-11.0.16.1_linux-x64_bin.tar.gz
# 创建Dockerfile
cat >> Dockerfile <<EOF
FROM centos:7.9.2009
RUN yum reinstall -y glibc-common && \
    yum install -y  kde-l10n-Chinese fontconfig dejavu-sans-fonts telnet && \
    yum clean all && \
    rm -rf /var/cache /tmp/* && \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 && \
    fc-cache -f
RUN mkdir /usr/local/java
ADD jdk-11.0.16.1_linux-x64_bin.tar.gz /usr/local/java/
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8
# 注意解压后的目录名称
ENV JAVA_HOME /usr/local/java/jdk-11.0.16.1
ENV PATH \$JAVA_HOME/bin:\$PATH
VOLUME /tmp 
EOF
# 编译打包镜像
docker build -t java11-cn:11.0.16.1 .
```

#### 2. 服务启动目录

- 后端相关微服务启动文件：[https://github地址](https://github地址)

```shell
# 创建日志路径
mkdir -p /bsn/ddclogs
tar -xzvf ChainService.tar.gz
# 如下是整个微服务后端的目录结构，解压ChainService.tar.gz后自动生成，pkg目录需要创建
# 创建用于存放微服务jar包的目录
mkdir -p /bsn/{account-ddc,base-ddc,ops-ddc,opsauth-ddc,opsjob-ddc,portal-ddc,swap-api,swap-job}/pkg
tree -L 2 /bsn
bsn
├── account-ddc
│   ├── pkg
│   └── script
├── base-ddc
│   ├── pkg
│   └── script
├── ddclogs
├── opsauth-ddc
│   ├── pkg
│   └── script
├── ops-ddc
│   ├── pkg
│   └── script
├── opsjob-ddc
│   ├── pkg
│   └── script
├── portal-ddc
│   ├── pkg
│   └── script
├── swap-api
│   ├── pkg
│   └── script
└── swap-job
    ├── pkg
    └── script
```

#### 3. 配置启动文件Nacos服务器地址+端口号

```shell
# 切换路径
cd /bsn

# 批量设置微服务start.sh的对应的nacos地址
bash set-nacos-address.sh
Please enter the nacos server address: <nacos服务器地址>
Please enter the nacos server port: <nacos服务器web端口>
```

#### 4. 启动微服务

**单个服务独立启动**（用于微服务部署在多台服务器）

```shell
#切换到单独微服务
#创建docker-compose.yaml文件
cat >> docker-compose.yaml <<EOF
# <service_name> 服务名称例如ops-ddc
version: "3"
services:
  ddc-<service_name>-service:
    image: java11-cn:11.0.16.1
    container_name: ddc-<service_name>
    working_dir: /bsn/ddc-<service_name>
    restart: always
    network_mode: host
    # ports:
    #   - 38021:38021
    volumes:
      - \$PWD/pkg/ddc-<service_name>.jar:/bsn/ddc-<service_name>/ROOT.jar
      - /bsn/ddclogs/:/bsn/ddclogs/
      - \$PWD/script/:/bsn/script
      - /etc/hosts:/etc/hosts
      - /etc/localtime:/etc/localtime
    environment:
      # 指定时区
      - TZ=Asia/Shanghai
    command: sh /bsn/script/start.sh
 EOF

# 启动微服务
cd /bsn/ddc-<service_name>
docker-compose up -d
```
**一键启动**（用于微服务部署在一台服务器，不包含算力中心OpenApi）
```shell
#创建docker-compose.yaml文件
cat >> docker-compose.yaml <<EOF
version: "3"
services:
  #将一个个单一服务放到一起
  ddc-<service_name>:
    image: java11-cn:11.0.16.1
    ...

  ddc-<service_name>:
    image: java11-cn:11.0.16.1
       
EOF

# 启动微服务
cd /bsn
docker-compose up -d
```

#### 5. 算力中心OpenApi启动

- 算力中心OpenApi服务启动文件：[github地址](github地址)

```shell
# 目录结构
saasapi-ddc/
├── docker-compose.yml
├── pkg
├── logs
└── script
    └── start.sh
# 创建docker-compose
cat >> docker-compose.yml <<EOF
version: "3"
services:
  ddc-oai-service:
    image: java11-cn:11.0.16.1
    container_name: ddc-oai
    working_dir: /bsn/ddc-oai
    restart: always
    network_mode: host
    # ports:
    #   - 18080:18080
    volumes:
      - \$PWD/pkg/ddc-oai.jar:/bsn/ddc-oai/ROOT.jar
      - \$PWD/ddclogs/:/bsn/ddclogs/
      - \$PWD/script/:/bsn/script
      - /etc/hosts:/etc/hosts
      - /etc/localtime:/etc/localtime
    environment:
      # 指定时区
      - TZ=Asia/Shanghai
    command: sh /bsn/script/start.sh
EOF
# 将启动的jar包放至pkg目录
# 将start.sh放至$PWD/ddc-oai/script/ 下，注意修改nacos服务器地址+端口号
cat >>$PWD/ddc-oai/script/start.sh<<EOF
java -Xms1G -Xmx2G -jar /bsn/ddc-oai/ROOT.jar \
--nacos.config.namespace=ddc_hashrate_system \
--nacos.config.server-addr=X.X.X.X:XXXX
EOF

docker-compose up -d
```

