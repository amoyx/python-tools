自动化上线
===================================


###  项目程序运行主机环境说明  <br />
   1. 先查看requirements.txt的插件包，安装该文件中的插件包  <br />
   2. 在该项目的conf目录中，建立一个local_settings.py文件，数据库的配置放在该文件中，具体格式参考settings.py文件 <br />
   3. 初始化数据库，切换到项目根目录，执行python  manage.py  makemigrations, 再执行python  manage.py  migrate <br />
   4. 启动服务，如python manage.py runserver 0.0.0.0:8000  <br />
   5. 将负载均衡主机中所有的/etc/nginx/conf.d/PROJECTNAME.conf 文件，拷贝一份到项目根目录下temp_file,并且命名为PROJECTNAME.conf.bak,注：PROJECTNAME为项目名称  <br />

###  staging主机环境准备  <br />
   1. 该服务器用来存储最新生产环境docker镜像  <br />
   2. 确保该服务器下的docker运行是否正常  <br />
   3. 将/etc/sysconfig/docker下的/var/run/docker.sock模式改成 OPTIONS='-H tcp://0.0.0.0:5555 -H unix:///var/run/docker.sock' ,端口已经被固定为5555  <br />
   4. 确保安装了docker-py 接口程序  <br />
   
   
###  集群主机环境准备  <br />
   1. 安装docker，启动docker服务，确保docker能使用，版本要求1.91以上  <br />
   2. 安装docker-compose,版本要求1.70以上  <br />
   3. 建立/data/online 目录，用来运行容器的docker-compose 文件会放在该目录下，文件名称将以项目加上.yml存在，如 portal.yml  <br />
   
   
###  负载均衡主机环境准备
   1. 每个项目对应一个conf配置文件，如 portal  <br />
        /etc/nginx/conf.d/portal.conf  <br />
   2. conf配置文件格式，必须用upstream模块来代理  <br />
   3. 负载均衡算法采用轮询方式，权重值均一致  <br />
   

   
数据库表说明：
-----------------------------------

###  compose表字段说明 <br />
   project_name   项目名称，如portal  <br />
   img_version    docker镜像版本，只能以数字形式存在  <br />
   container_flag 每个项目容器的标志，通过该标志来确定哪个容器为最新运行容器  <br />
   project_type   项目类型  <br />
   default_port   服务启动的默认端口  <br />
   balance_vip    负载均衡主机的IP地址，如果有多个用竖号线隔开, |  <br />
   cluster_ip     集群主机IP地址，如果有多个用竖号线隔开, |  <br />
   store_img_host 存储镜像的主机IP地址  <br />


###  hostmanager 字段说明  <br />
   username  主机用户名  <br />
   password  主机用户密码  <br />
   host_ip   主机IP地址  <br />
   host_name 主机名称  <br />
   ssh_port  连接ssh端口  <br />
   docker_port 连接docker API端口   <br />
   remark      说明  <br />