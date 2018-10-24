### 环境要求

+ centos 7.0以上操作系统
+ python 2.7.5 以上版本

### 安装

#### 1. 安装docker
``` bash
# 安装yum源
$ wget  -O /etc/yum.repos.d/docker-ce.repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# 安装docker-ce
$ yum install docker-ce -y
# 优化docker配置
$ vi /etc/docker/daemon.json
# 在  /etc/docker/daemon.json 中加入以下内容
#{
# "insecure-registries":["docker.jhh.com"],
# "registry-mirrors": ["https://kuamavit.mirror.aliyuncs.com", "https://registry.docker-cn.com", "https://docker.mirrors.ustc.edu.cn"],
# "max-concurrent-downloads": 6,
#}
```

#### 2. 下载jcman.py工具
``` bash
$ git clone http://git.jhh.com/ops/jhhtools.git
$ cp jcman.py  /usr/bin/jcman
$ chmod +x /usr/bin/jcman
$ cp config/jinhuhang.json  /etc/jinhuhang.json
```

#### 3. 安装pip模块
``` bash
$ pip install requests
```

### 使用说明

``` bash
# 帮助查看
$ jcman -h
# 下面的意思是指发布 jhs-loan-app服务，-p 12001指对外暴露端口，-t tomcat指发布的服务类型为tomcat
$ jcman -s jhs-loan-app  -p 12001  -t tomcat
# 下面的意思是指发布 risk-cert服务，对外暴露端口随机端口，-t jar为jar包类型发布
$ jcman -s risk-cert -t jar
# 下面的意思是指同时发布 jhs-loan-app、jhs-loan-manage、jhs-loan-service 这三个服务, 对外暴露端口为 12001,12002,12003，发布类型为tomcat
$ jcman -s "jhs-loan-app;jhs-loan-manage;jhs-loan-service" -p "12001;12002;12003"
# 说明:  当不指定-t类型时，默认为tomcat；不指定-p时,为随机端口；-s服务模块为必须；需要发布多个服务时,则用分号隔开
```

### 配置说明
```
配置文件路径 /etc/jinhuhang.json
tomcat_docker_base_image 为tomcat类型基础镜像
jdk_docker_base_image  为jar类型基础镜像
ding_talk 发布提醒时的dingding机器人地址
```