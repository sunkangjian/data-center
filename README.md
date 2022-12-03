# 算力中心部署说明以及相关部署包



## 一、目录结构

1. config-files

   相关服务部署配置文件，详见“[算力中心部署说明.md](https://github.com/BSN-DDC/computingpower/blob/main/算力中心部署说明.md)”

2. database

   部署算力中心相关的数据库脚本

3. packages

   部署算力中心的相关部署jar包



```shell
├─config-files
│  ├─dockerAndShell
│  │  ├─Base
│  │  │  ├─mysql
│  │  │  │  ├─conf
│  │  │  │  └─script
│  │  │  ├─nacos
│  │  │  │  └─conf
│  │  │  ├─redis
│  │  │  │  └─conf
│  │  │  └─sftp
│  │  │      └─user
│  │  ├─Chain-Srv
│  │  │  ├─ddc-chainsrv-taian
│  │  │  │  └─script
│  │  │  ├─ddc-chainsrv-wenchang
│  │  │  │  └─script
│  │  │  └─ddc-chainsrv-zhongyi
│  │  │      └─script
│  │  ├─DDC-Nginx
│  │  │  ├─conf
│  │  │  └─stream
│  │  └─DDC-Srv
│  │      ├─ddc-account
│  │      │  └─script
│  │      ├─ddc-auth
│  │      │  └─script
│  │      ├─ddc-base
│  │      │  └─script
│  │      ├─ddc-oai
│  │      │  └─script
│  │      ├─ddc-ops
│  │      │  └─script
│  │      ├─ddc-opsjob
│  │      │  └─script
│  │      ├─ddc-portal
│  │      │  └─script
│  │      ├─ddc-swap-api
│  │      │  └─script
│  │      └─ddc-swap-job
│  │          └─script
│  └─nacos-app
├─database
│  └─mysql
└─packages
    ├─back-server
    ├─chain-server
    └─front-server
```

