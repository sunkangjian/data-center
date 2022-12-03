
#### 算力中心OpenApi启动


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