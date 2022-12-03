#### 1. 服务目录结构

```shell
mkdir -p $PWD/operesty-nginx/{conf,html,logs,ssl,stream}
mkdir -p $PWD/operesty-nginx/html/{operation,portal}
# 按照如下文件夹结构进行配置
operesty-nginx
├── conf
│   ├── ip_white.conf，需要放ip_white吗，现在是没生效的
│   └── nginx.conf
├── docker-compose.yml
├── html
│   ├── operation #运营前端文件夹，将下载后dist目录拷贝到此处
│   └── portal    #门户前端文件夹，将下载后dist目录拷贝到此处
├── logs
├── ssl
└── stream
    ├── jsonlog.lua
    ├── openapi-saas.conf
    ├── operation.conf
    ├── portal.conf
    ├── share-proxy.conf
    └── status.conf
 ```   


#### 2. 配置文件部分详解

```shell
#无ssl证书、无域名的情况下
# 更改listen端口，由于无域名，无证书需要将各个服务端口区分开
# 若有SSL证书和域名的情况下端口可统一配置443，通过server_name进行区分服务
# 三个服务配置都有80重定向443，根据实际需求开启

operesty-nginx/stream/{operation.conf,portal.conf,openapi-saas.conf}
# server{
#    listen 80;
#    server_name  xxx.xxx.com;
#    rewrite ^(.*)$ https://xxx.xxx.com$1  permanent;
# }


operesty-nginx/stream/operation.conf
server {
  # listen       443 ssl; 
  listen       80;
  # root         html;
#   server_name  xxxx.ops.com;
...


operesty-nginx/stream/portal.conf
server {
  # listen       443 ssl; 
  listen       81;
  # root         html;
#   server_name  xxxx.portal.com;
...

operesty-nginx/stream/openapi-saas.conf
server {
  # listen       443 ssl; 
  listen       82;
  # root         html;
#   server_name  xxxx.api.com;
...

# 更改docker-compose.yml端口映射为
# 如配置SSL和域名则端口映射80  443
# $PWD/operesty-nginx/docker-comopse.yml
...
    ports:
      # - "80:80"
      # - "443:443"
      - "8440:80"
      - "8441:81"
      - "8442:82"
...
```

#### 3. 启动nginx

```shell
#镜像下载
docker pull openresty/openresty:latest

# 创建docker-compose文件
cat >> docker-compose.yaml <<EOF
version: '3'
services:
  nginx:
    container_name: nginx
    image: openresty/openresty:latest
    restart: always
    volumes:
      - \$PWD/conf/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf
      - \$PWD/conf/ip_white.conf:/usr/local/openresty/nginx/conf/ip_white.conf
      - \$PWD/stream:/etc/nginx/conf.d
      - \$PWD/logs:/var/log/
      - \$PWD/ssl:/etc/nginx/ssl
      - /etc/hosts:/etc/hosts
      - \$PWD/html/operation/dist:/usr/local/openresty/nginx/html/operation
      - \$PWD/html/portal/dist:/usr/local/openresty/nginx/html/portal
    ports:
      #- 8440 运营系统前端，8441门户系统前端，8442算力中心OpenApi
      - "8440:80"
      - "8441:81"
      - "8442:82"
    environment:
        TZ: Asia/Shanghai
EOF


#启动
docker-compose up -d                
```
