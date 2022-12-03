#### 1. 服务目录结构

```shell
# 链服务目录结构
taianchain-ddc-service
├── docker-compose.yml
├── pkg
└── script
    └── start.sh
wenchangchain-ddc-service
├── docker-compose.yml
├── pkg
└── script
    └── start.sh
zhongyichain-ddc-service
├── docker-compose.yml
├── pkg
└── script
    └── start.sh
```

#### 2. docker镜像准备
- [oraclejdk8下载地址【官方地址】](https://www.oracle.com/java/technologies/downloads/#java8)

##### 2.1. JDK8镜像准备

```shell
# 准备jdk文件，以下文件测试实际可用
jdk-8u351-linux-x64.tar.gz
# 创建Dockefiles
cat >> Dockerfile <<EOF
FROM centos:7.9.2009
RUN yum reinstall -y glibc-common && \
    yum install -y  kde-l10n-Chinese fontconfig dejavu-sans-fonts telnet && \
    yum clean all && \
    rm -rf /var/cache /tmp/* && \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 && \
    fc-cache -f
RUN mkdir /usr/local/java
ADD jdk-8u351-linux-x64.tar.gz /usr/local/java/
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8
# 注意解压后的目录名称
ENV JAVA_HOME /usr/local/java/jdk1.8.0_351
ENV PATH \$JAVA_HOME/bin:\$PATH
VOLUME /tmp 
EOF
```


#### 3. 链服务启动

```shell

# 修改start.sh启动脚本
bash $PWD/set-nacos-address.sh
# 手动输入
Please enter the nacos server address: <nacos服务器地址>
Please enter the nacos server port: <nacos服务器web端口>

#创建docker-compose.yaml
cat >> docker-compose.yaml <<EOF
version: "3"
services:
  ddc-chainsrv-<ChainName>-service:
    image: java8:1.8.0_351
    container_name: ddc-chainsrv-<ChainName>-service
    working_dir: /bsn/chainService
    restart: always
    network_mode: host
    # ports:
    #   - 32020:32020
    volumes:
      - \$PWD/pkg/ddc-chainsrv-<ChainName>.jar:/bsn/chainService/ROOT.jar
      - /bsn/ddclogs/:/bsn/ddclogs
      - \$PWD/script/:/bsn/script
      - /etc/hosts:/etc/hosts
      - /etc/localtime:/etc/localtime
    environment:
      # 指定时区
      - TZ=Asia/Shanghai
    command: sh /bsn/script/start.sh 
EOF

#启动
cd $PWD/ddc-chainsrv-<ChainName>
docker-compose up -d

```
