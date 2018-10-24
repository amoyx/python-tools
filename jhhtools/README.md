# jhhtool工具说明

> 该工具是用来自动发布Docker类型应用使用的，主要功能自动生成Dockerfile, build docker镜像，启动容器，docker镜像存储；自动更新kubernetes的deployment部署功能，可做到平滑上线。
### 环境要求
+ python 3.5.2以上版本
+ docker-ce 17.0以上版本
+ centos 7.0 以上版本

# 环境搭建
## 安装python

1. 安装python,至少3.5.2以上版本

>  yum install openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel gcc wget -y

>  wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz

>  tar -xzvf  Python-3.5.2.tgz

>  cd Python-3.5.2 && ./configure --prefix=/usr/local/python3.5.2  && make && make install

>  echo "PYTHON_HOME=/usr/local/python3.5.2" >> /etc/profile  && echo "export PATH=$PYTHON_HOME/bin:$PATH" >> /etc/profile && source /etc/profile

>  ln -s /usr/local/python3.5.2/bin/python3 /usr/bin/python3

2. 安装依赖模块

> pip3 install -r requirement.txt

3.  导入数据库表

> mysql -uusername -ppassword opsman < opsman.sql

## 下载jhhtool.py工具

1.  cp jhhtool.py -O /usr/bin/jhhTool

2.  chmod +x /usr/bin/jhhTool

3.  cp  config/jhh.json  -O /etc/jhh.json

## 脚本使用

jhhTool -p uhuishou -e test

>  上面的意思是发布项目 uhuishou的服务模块，环境为测试环境; <br />
>  其中 -p 后面值的是项目名称，-e 后面则为环境，如果想了解更多参数，可用  jhhTool -h

## 参数配置

1. 配置文件路径  /etc/jhh.json <br />
2 .配置说明：

> test和prod 代表环境
> registry_host 表示docker registry仓库地址; 目前测试环境用自建的registry,生产和灰度用阿里云镜像仓库 <br />
> k8s_api_server 表示kubernetes 的API地址 <br />
> db_host mysql数据库主机地址 <br />
> db_user mysql登录用户 <br />
> db_password mysql用户密码 <br />
> db_name 数据库名称 <br />




