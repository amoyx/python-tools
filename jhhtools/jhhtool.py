#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import getopt
import requests
import json
import os
import configparser
import shutil
import time
import subprocess
import docker
import pymysql
import logging
import socket
import random


# 获取随机端口
def get_random_service_port(ports):
    port = random.randint(8000, 60000)
    if port not in ports:
        return port
    return get_random_service_port(ports)

# 获取本机IP地址
def get_host_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(('8.8.8.8', 53))
        ip = s.getsockname()[0]
    finally:
        s.close()
    return ip


class fileOperationTools:
    cfpath = "/etc/jhh.json"

    def __init__(self):
        pass

    @property
    def confPath(self):
       return self.cfpath


    @staticmethod
    def writeToFile(fname, data):
        '''
        : 将内容写入文件中
        :param fname 文件名称
        :param data  内容
        :return 返回True  ，或退出
        '''
        try:
            fo = open(fname,"w")
            fo.write(data)
            fo.close()
        except:
            raise IOError("Error: " + fname + " open error !")
        else:
            return True

    @staticmethod
    def getExstionFileName(dpath, ext):
        '''
        ; 在指定的目录中检索指定扩展类型的文件
        :param dpath 目录路径, 如 /opt/www:
        :param ext  文件扩展名称  如 .war:
        :return: 返回检索后的文件名称
        '''
        try:
            for files in os.listdir(dpath):
                file = os.path.join(dpath,files)
                if os.path.isfile(file) and os.path.splitext(file)[1] == ext:
                    fname = file.split('/')[-1].split(ext)[0]
        except:
            raise FileNotFoundError("Error: not found files!")
        else:
            return fname

    @staticmethod
    def copyFiles(src, dest):
        '''
        ; 将src文件复制到dest，当指定文件为目录时，将复制目录下的所有子文件
        :param src  源文件路径:
        :param dest 目标文件路径:
        :return: 如果复制成功，则返回True
        '''
        if src.strip() and dest.strip() and os.path.exists(src):
            if os.path.exists(dest):
                shutil.rmtree(dest)
            try:
                shutil.copytree(src, dest)
            except:
                raise Exception("Error: copy file error!")
            else:
                return True
        else:
            raise FileNotFoundError("Error: 源文件路径或目标路径不存在!")

    # 获取目录下所有文件路径
    def get_all_file_path(self,dirname):
        res = []
        for maindir, subdir, files in os.walk(dirname):
            for filename in files:
                filepath = os.path.join(maindir, filename)
                res.append(filepath)
        return res

    # 循环替换目录下所有文件内容
    def replace_file_content(self, dirname, dict):
        flie_list = [dirname] if os.path.isfile(dirname) else self.get_all_file_path(dirname)
        replcae = lambda lines, old, new: [line.replace(old, new) for line in lines]
        try:
            for filename in flie_list:
                lines,fo = open(filename,'r',encoding='UTF-8').readlines(),open(filename, 'w',encoding='UTF-8')
                for old, new in dict.items():
                    lines = replcae(lines, old, new)
                fo.writelines(lines)
        except:
            raise Exception("Error: 文件内容替换失败！")
        else:
            return True

    # 获取json文件内容
    def get_json_file_content(self):
        try:
            with open(self.cfpath,"r") as f:
                data = json.load(f)
            return data
        except:
            raise Exception("Error: 读取json文件失败")


class dockerTools(fileOperationTools):
    '''
    :param cfpath 配置文件路径
    :param env 运行环境 dev test uat prod ...
    ;:param projectname 项目名称，要和配置文件中的选择器进行对应
    '''
    def __init__(self,
                 projectname,
                 servicename,
                 env,
                 k8s_api,
                 registry,
                 base_image,
                 image,
                 build_type,
                 base_url,
                 user,
                 ding_talk=None,
                 resource=None,
                 cfpath="/etc/jhh.json"):
        #super(fileOperationTools,self).__init__()
        self.cfpath = str(cfpath)
        self.project_name = str(projectname)
        self.service_name = str(servicename)
        self.run_env = str(env)
        self.k8s_api = str(k8s_api)
        self.ding_talk = str(ding_talk)
        self.build_type = str(build_type)
        self.base_image = str(base_image)
        self.user = user
        self.container_name = projectname + "-" + servicename + str(int(time.time()))
        self.docker_file_name = '/tmp/Dockerfile-' + str(servicename)
        self.docker_registry = str(registry)
        self.docker_image_name = image
        self.main = self.get_json_file_content()
        self.curr_path = os.getcwd()
        self.base_url = str(base_url)
        self.work_dir = os.getcwd() + "/" + str(servicename)\
            if os.path.isdir(os.getcwd() + "/" + str(servicename))\
            else os.getcwd()
        self.resource = self.merge_resource(build_type,resource) if resource else None
        self.docker_client = docker.DockerClient(
            base_url="tcp://" + get_host_ip() + ":2375",
            version="1.34")

    @property
    def config(self):
        return self._config

    @config.setter
    def config(self, dict):
        data = {
            "id": dict["id"],
            "servicePort": dict["servicePort"],
            "debugPort": dict["debugPort"],
            "baseImageName": dict["baseImageName"],
            "buildType": dict["buildType"],
            "domainName": dict["domainName"],
        }
        self._config = data

    # 拼接资源配置文件
    def merge_resource(self, buildType, *args):
        if buildType == "other":
            array, res = [], ''
            for s in args: array.extend(s.split('--') if s else "")
            res=' --' + ' --'.join([arr for arr in array if arr != '']) if len(array) >=1 else ''
        else:
            d, res = {}, {}
            for s in args: d.update(json.loads(s) if s else {})
            for k, v in d.items(): res["#" + k + "#"] = v
        return res

    # 初始化容器
    def init_container(self):
        if not self.project_name or not self.service_name:
            raise Exception("Error: 项目名称和服务名称不能为空")
        try:
            self.update_resource_file_content()
            self.build_image()
        except:
            raise Exception("Error: 项目部署失败！")
        else:
            print("OK: 代码发布成功!")

    # 更新项目资源文件内容
    def update_resource_file_content(self):
        if self.build_type == "tomcat":
            file_path = self.work_dir + "/init"
            self.copyFiles(self.work_dir + "/src/main/resources/env", file_path)
        elif self.build_type == "jar":
            base_dir = self.work_dir + "/src/main/resources/"
            file_path = base_dir + "application-" + self.run_env +".properties" if os.path.isfile(base_dir + "application-"+ self.run_env +".properties")\
                else base_dir + "application-"+self.run_env +".yml"
            # self.replace_file_content(file_path,self.resource)
        else:
            pass

    # 编译项目
    def compile_project(self):
        return self.execute_shell_command_line(
            "mvn clean install -Dmaven.test.skip=true -f " + self.pom_file_path
        )

    # 制作Dockerfile文件
    def make_dockerfiles(self, release_package_file_name):
        is_success = False
        init_script,docker_file_content = "",""
        init_dir = self.work_dir + "/init"
        dockerfile_root = "" if self.work_dir == self.curr_path else self.service_name + "/"
        if not os.path.exists(init_dir):
            os.makedirs(init_dir)
        if self.build_type == "tomcat":
            # 制作 docker 容器初始化脚本
            init_script = "#!/bin/bash \n" \
                                  'if [ ! -z "$ENVNAME" -a ! -z "$SERVERNAME" ]; then \n' \
                                  '   CONFIGFILE=$CATALINA_HOME/init/$ENVNAME \n' \
                                  '   APPCONFPATH=$CATALINA_HOME/webapps/$SERVERNAME/WEB-INF/classes \n' \
                                  '   if  [ -d $CONFIGFILE -a -d $APPCONFPATH ]; then  \n' \
                                  '      yes | cp -rf $CONFIGFILE/* $APPCONFPATH/ \n' \
                                  '   else \n' \
                                  '      echo "$CONFIGFILE and $APPCONFPATH dir is not exist" \n' \
                                  '   fi \n' \
                                  'else \n' \
                                  '   echo "Error: envname and projectname cannot be null" \n' \
                                  '   exit 0  \n' \
                                  'fi'
            docker_file_content = "FROM " + self.base_image + " \n" \
                                "COPY " + dockerfile_root + "init  init \n"  \
                                "COPY " + dockerfile_root + "target/" + release_package_file_name + "  webapps/" + release_package_file_name + "\n" \
                                "RUN chmod +x init \n" \
                                "RUN chmod -R 777 logs \n" \
                                "EXPOSE 8080 \n" \
                                'CMD ["bash","/entrypoint.sh"]'
        elif self.build_type == "jar":
            init_script = "java -jar " + \
                          release_package_file_name + ".jar --spring.profiles.active=${ENVNAME} --server.port=8080"
            docker_file_content = "FROM " + self.base_image + "\n" \
                                    "COPY " + dockerfile_root + "target/" + release_package_file_name + ".jar  " + release_package_file_name + ".jar \n" \
                                    "COPY " + dockerfile_root + "init/init.sh entrypoint.sh \n" \
                                    "RUN chmod +x entrypoint.sh \n" \
                                    "EXPOSE 8080 \n" \
                                    'CMD ["bash", "entrypoint.sh"]'
        elif self.build_type == "war":
            docker_file_content = "FROM " + self.base_image + " \n" \
                        "COPY " + dockerfile_root + release_package_file_name + ".war webapps/" + release_package_file_name + ".war \n"
        elif self.build_type == "node":
            init_script = ""
            docker_file_content = "FROM " + self.base_image + " \n" \
                        "COPY dist /opt/wwwroot \n" \
                        "EXPOSE 80 \n" \
                        'CMD["nginx", "-g", "daemon off;"]'
        elif self.build_type == "nginx":
            init_script = ""
            docker_file_content = "FROM " + self.base_image + " \n" \
                        "COPY" + release_package_file_name + " /opt/www/ \n" \
                        "EXPOSE 8080 \n" \
                        'CMD["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]'
        else:
            raise Exception("Error: not found your input build type!")

        try:
            self.writeToFile(self.docker_file_name, str(docker_file_content))
            self.writeToFile(init_dir + "/init.sh", init_script)
            is_success = True
        except:
            raise Exception("Error: dockerfile and initScript write error!")
        return False if "False" in str(is_success) else True

    # 构建Docker镜像
    def build_image(self):
        '''
        # 构建docker镜像
        :param buildType 构建类型  tomcat jar php python .....:
        :param servicename 项目模块或服务名称:
        '''

        package_name = ''
        # 获取发布程序包
        if self.build_type == "tomcat":
            package_name = self.getExstionFileName(self.work_dir + "/target/", ".war")
        elif self.build_type == "jar":
            package_name = self.getExstionFileName(self.work_dir + "/target/", ".jar")
        elif self.build_type == "war":
            package_name = self.getExstionFileName(self.work_dir, ".war")
        elif self.build_type == "node":
            package_name = ""
        elif self.build_type == "nginx":
            package_name = str(self.service_name) \
                if os.path.isdir(os.getcwd() + "/" + str(self.service_name)) \
                else "*"
        else:
            raise Exception("Error: not found your input build type!")

        # 开始构建docker镜像
        try:
            if not self.make_dockerfiles(release_package_file_name=package_name):
                raise Exception("Error: dockerfile文件生成失败！")
            self.package_name = package_name
            if self.execute_shell_command_line("docker build -t " + self.docker_image_name + " -f " + self.docker_file_name + " ."):
                return self.push_image()
        except:
            raise Exception("Error: make docker image fail!")

    # push docker镜像到registry
    def push_image(self):
        if self.run_env == "prod" or self.run_env == "uat" or self.run_env == "staging":
            auth_config = {"username": "jinhuhang", "password": "qJhhN%h1sn58pass"}
        else:
            auth_config = {}
        try:
            #if self.run_env == "prod" or self.run_env == "uat":
            #    return self.docker_client.images.push(self.docker_image_name, auth_config=auth_config)
            #else:
            return self.execute_shell_command_line("docker push " + self.docker_image_name)
        except:
            raise Exception("Error: push docker image fail !")

    # 更新kubernetes pod中的容器镜像
    def update_k8s_pod_image(self):
        if not self.build_image():
            raise Exception("Error: build docker image fail!")
        k8s = k8sTools(host=self.k8s_api,
                       projectName=self.project_name,
                       serviceName=self.service_name + "-" + self.run_env
                       )
        return k8s.update_k8s_deployment(self.docker_image_name)

    # 执行shell命令
    @staticmethod
    def execute_shell_command_line(cmd):
        return True if str(subprocess.call(cmd,shell=True)) == "0" else False

    # 记录docker镜像更新版本
    def record_docker_image_version(self):
        pass

    # 记录容器发布日志
    def record_container_release_log(self):
        db_client = DBTools(host=self.main["db_host"],
                            username=self.main["db_user"],
                            password=self.main["db_password"],
                            dbname=self.main["db_name"])
        data = {
            "project_name": self.project_name,
            "service_name": self.service_name,
            "image_name": self.docker_image_name,
            "image_version": str(self.docker_image_name).split(':')[-1],
            "is_online": 1,
            "user": self.user,
            "run_env": self.run_env,
            "create_time": str(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))
        }
        return db_client.insert_release_record(data)

    # 根据docker镜像名称，删除docker镜像,仅支持list型数据
    def delete_image(self, images=[]):
        try:
            self.docker_client.images.prune()    # 清除未构建成功的镜像
            for i in images: self.docker_client.images.remove(image=i)
        except:
            raise Exception("Error: delete docker images fail")

    # 根据容器id停止容器
    def stop_containers(self, cid):
        return self.docker_client.containers.get(cid).stop()

    # 根据容器id删除容器
    def delete_containers(self, cid):
        return self.docker_client.containers.get(cid).remove()

    # 清除已停止的容器
    def clear_stop_containers(self):
        return self.docker_client.containers.prune()


class DBTools():
    def __init__(self, host, username, password, dbname, port=3306):
        self.__host = host
        self.__port = port
        self.__username = username
        self.__password = password
        self.__dbname = dbname
        self.conn = pymysql.connect(host=self.__host,
                                    port=self.__port,
                                    user=self.__username,
                                    passwd=self.__password,
                                    db=self.__dbname,
                                    charset='utf8',
                                    cursorclass=pymysql.cursors.DictCursor
                                    )

    def connection(self):
        return self.conn

    # 查询容器配置信息
    def get_docker_container_config(self, project_name, env, server_name=""):
        sql = "SELECT c.id,projectName,serverName,servicePort,debugPort,baseImageName,buildType,domainName,urlPostfix,s.zk,s.redis,s.mysql,s.other_service " \
              " FROM d_container_config c INNER JOIN d_service_config s " \
              " on c.id=s.cid and c.projectName='%s' and s.envName='%s' " % (project_name,env)
        sql = sql + " and c.serverName in (%s)" % (server_name) if server_name else sql
        return self.execute(sql)

    # 插入一条kubernetes部署信息
    def createK8sDeploy(self, dep={}):
        dep["currTime"] = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        sql = "INSERT INTO deployment (projectName,serviceName,dockerImage,isSuccess,isOnline,version,time,envName) " \
              "VALUES ('{projectName}','{serviceName}','{dockerImage}','{isSuccess}','{isOnline}','{version}','{currTime}','{envName}')".format(**dep)
        return self.execute(sql)

    # 更新发布记录记录
    def insert_release_record(self, data):
        sql = "insert into opsmanage_deploy_record (project_name, service_name, image_name,image_version, is_online, run_env, user,create_time) " \
              " VALUES ('{project_name}','{service_name}','{image_name}','{image_version}','{is_online}','{run_env}','{user}','{create_time}')".format(**data)
        return self.execute(sql)

    # 更新docker镜像版本信息
    def insert_docker_image_version(self, data):
        sql = "insert into d_image_manager (c_id, imageName, imageVersion, envName, createTime)" \
              " VALUES ({id},{docker_image_name},{docker_image_version},{envname}, {time})".format(**data)
        return self.execute(sql)

    # 更新k8s部署
    def updateK8sDeploy(self, dep={}):
        sql = "UPDATE deployment SET dockerImage='{dockerImage}',version='{version}' " \
              " WHERE id='{id}' and  projectName='{projectName}' ".format(**dep)

    # 查询kubernetes部署信息
    def getK8sDeployInfo(self,projectName,serviceName):
        sql = "select projectName,serviceName,dockerImage,version,nameSpace,time from deployment  " \
              "where projectName='%s' and serviceName='%s' ORDER  BY time DESC limit 0,1" % (projectName,serviceName)
        res = self.execute(sql=sql)
        return res[0]

    # 执行一条SQL语句
    def execute(self, sql):
        cursor = self.conn.cursor()
        cursor.execute(sql)
        self.conn.commit()
        data = cursor.fetchall()
        cursor.close()
        self.conn.close()
        return data

    # 创建版本号
    def createVersionNumber(self, version):
        oldVersionNumber = version
        if not oldVersionNumber.strip("\n"):
            print("Error: 未获取到旧的docker容器版本号")
            exit()
        listNumber = oldVersionNumber.split(".")
        endNumber = listNumber[-1]
        if not self.is_numeric(endNumber):
            print("Error: docker容器旧的版本号错误")
            exit()
        endNumber = int(endNumber) + 1
        newVersionNumber = listNumber
        newVersionNumber[-1] = str(endNumber)
        for n in listNumber:
            if not self.is_numeric(n):
                print("Error: docker容器版本号生成失败")
                exit()
        if endNumber >= 10:
            for i in range(len(listNumber) - 1, -1, -1):
                if not self.is_numeric(listNumber[i]):
                    return False
                if int(listNumber[i]) + 1 >= 10:
                    newVersionNumber[i - 1] = str(int(listNumber[i - 1]) + 1)
                    if i != 0:
                        newVersionNumber[i] = "0"
                else:
                    continue
        formatVersionNumber = ""
        for n in newVersionNumber:
            formatVersionNumber = formatVersionNumber + n + "."
        return formatVersionNumber.rstrip(".")

    # 获取版本号
    # 注：每一段数字，仅支持0-9数字，如1.2.6， 不支持1.2.11
    # 参数up = True 表示版本号增加,up=False表示递减
    def getVersionNumber(self, version, up=True):
        if not version.strip("\n"):
            print("Error: 未获取到旧的docker容器版本号")
            exit()
        listNumber = version.split(".")
        for n in listNumber:
            if not self.is_numeric(n):
                print("Error: docker容器旧的版本号错误")
                exit()
        number = version.replace(".", "")
        endNumber = str("")
        i = int(0)
        startNumber = str("")
        intNumber = (up is True and str(int(number)+1) or str(int(number)-1))
        for n in str(intNumber):
            if i < len(intNumber) - len(listNumber):
                startNumber = str(startNumber) + str(n)
            else:
                endNumber = endNumber + n + "."
            i = int(i) + 1
            num = startNumber + endNumber[:-1]
        return num

    # 检测字符是否为数字
    @staticmethod
    def is_numeric(s):
        return all(c in "0123456789" for c in s)

    def delete(self):
        pass


class k8sTools():

    def __init__(self, host, projectName, serviceName, api_user="", api_passwd=""):
        self.host = host
        self.namespace = projectName
        self.podname = serviceName
        self.api_user = api_user
        self.api_passwd = api_passwd

    def namespacesJson(self,name):
        data = '{ "kind": "Namespace", "apiVersion": "v1", "metadata": { "name": ' + name + '" } }'
        api="/api/v1/namespaces"
        return self.sendRequest("get",api)
        # pass

    # 更新k8s deployment
    def update_k8s_deployment(self, new_docker_img):
        if not new_docker_img:
            raise Exception("Error: docker image arguments input error!")
        api_url = self.host + "/apis/extensions/v1beta1/namespaces/" + self.namespace + "/deployments/" + self.podname
        return self.update_k8s_template(api_url, new_docker_img)

    # 发送http请求，用于更新、删除、创建、查询操作
    def sendRequest(self, api_url, request_method="get", data=""):
        headers = {'Content-Type': 'application/json'}
        if request_method == "get":
            r = requests.get(api_url).content.decode("utf-8")
            if "code" in json.loads(r).keys() and json.loads(r)["code"] == 404:
                raise Exception("Error: kubernetes中未找到该API的Pod")
            return r
        elif request_method == "put":
            return requests.put(api_url,data).content
        elif request_method == "post":
            return requests.post(api_url,data).content
        else:
            raise ValueError("Error: arguments input error !")

    # 初始化模板
    def init_new_template(self, api_url, new_docker_image):
        template_data = self.sendRequest(api_url, request_method="get")
        try:
            return template_data.replace(self.get_k8s_pod_container_image(api_url),
                                                     new_docker_image, 1)
        except:
            raise Exception("Error: 初始化k8s模板失败,程序退出！")

    # 更新模板操作
    def update_k8s_template(self, api_url, new_docker_img):
        template_data = self.init_new_template(api_url, new_docker_img)
        try:
            return requests.put(api_url, template_data).content.decode("utf-8")
        except:
            raise Exception("Error: kubernetes模板更新失败!")

    # 创建模板
    def create_k8s_template(self):
        pass

    # 获取pod的容器镜像
    def get_k8s_pod_container_image(self,api_url):
        t = self.sendRequest(request_method='get',api_url=api_url)
        return json.loads(t)["spec"]["template"]["spec"]["containers"][0]["image"]


def is_not_null_and_blank_str(content):
    """
    非空字符串
    :param content: 字符串
    :return: 非空 - True，空 - False

    >>> is_not_null_and_blank_str('')
    False
    >>> is_not_null_and_blank_str(' ')
    False
    >>> is_not_null_and_blank_str('  ')
    False
    >>> is_not_null_and_blank_str('123')
    True
    """
    if content and content.strip():
        return True
    else:
        return False


class DingtalkChatbot(object):
    """
    钉钉群自定义机器人（每个机器人每分钟最多发送20条），支持文本（text）、连接（link）、markdown三种消息类型！
    """
    def __init__(self, webhook):
        """
        机器人初始化
        :param webhook:
        """
        super(DingtalkChatbot, self).__init__()
        self.headers = {'Content-Type': 'application/json; charset=utf-8'}
        self.webhook = webhook

    def send_text(self, msg, is_at_all=False, at_mobiles=[]):
        """
        text类型
        :param msg: 消息内容
        :param is_at_all: @所有人时：true，否则为false
        :param at_mobiles: 被@人的手机号（字符串）
        :return: 返回消息发送结果
        """
        data = {"msgtype": "text"}
        if is_not_null_and_blank_str(msg):
            data["text"] = {"content": msg}
        else:
            logging.error("text类型，消息内容不能为空！")
            raise ValueError("text类型，消息内容不能为空！")

        if at_mobiles:
            at_mobiles = list(map(str, at_mobiles))

        data["at"] = {"atMobiles": at_mobiles, "isAtAll": is_at_all}
        logging.info('text类型：%s' % data)
        return self.post(data)

    def send_link(self, title, text, message_url, pic_url=''):
        """
        link类型
        :param title: 消息标题
        :param text: 消息内容（如果太长自动省略显示）
        :param message_url: 点击消息触发的URL
        :param pic_url: 图片URL
        :return: 返回消息发送结果

        """
        if is_not_null_and_blank_str(title) and is_not_null_and_blank_str(text) and is_not_null_and_blank_str(message_url):
            data = {
                    "msgtype": "link",
                    "link": {
                        "text": text,
                        "title": title,
                        "picUrl": pic_url,
                        "messageUrl": message_url
                    }
            }
            logging.info('link类型：%s' % data)
            return self.post(data)
        else:
            logging.error("link类型中消息标题或内容或链接不能为空！")
            raise ValueError("link类型中消息标题或内容或链接不能为空！")

    def send_markdown(self, title, text, is_at_all=False, at_mobiles=[]):
        """
        markdown类型
        :param title: 首屏会话透出的展示内容
        :param text: markdown格式的消息内容
        :param is_at_all: 被@人的手机号（在text内容里要有@手机号）
        :param at_mobiles: @所有人时：true，否则为：false
        :return: 返回消息发送结果
        """
        if is_not_null_and_blank_str(title) and is_not_null_and_blank_str(text):
            data = {
                "msgtype": "markdown",
                "markdown": {
                    "title": title,
                    "text": text
                },
                "at": {
                    "atMobiles": list(map(str, at_mobiles)),
                    "isAtAll": is_at_all
                }
            }
            logging.info("markdown类型：%s" % data)
            return self.post(data)
        else:
            logging.error("markdown类型中消息标题或内容不能为空！")
            raise ValueError("markdown类型中消息标题或内容不能为空！")

    def send_action_card(self, action_card):
        """
        ActionCard类型
        :param action_card: 整体跳转ActionCard类型实例或独立跳转ActionCard类型实例
        :return: 返回消息发送结果
        """
        if isinstance(action_card, ActionCard):
            data = action_card.get_data()
            logging.info("ActionCard类型：%s" % data)
            return self.post(data)
        else:
            logging.error("ActionCard类型：传入的实例类型不正确！")
            raise TypeError("ActionCard类型：传入的实例类型不正确！")

    def send_feed_card(self, links):
        """
        FeedCard类型
        :param links: 信息集（FeedLink数组）
        :return: 返回消息发送结果
        """
        data = {"msgtype": "feedCard", "feedCard": {"links": links}}
        logging.info("FeedCard类型：%s" % data)
        return self.post(data)

    def post(self, data):
        """
        发送消息（内容UTF-8编码）
        :param data: 消息数据（字典）
        :return: 返回发送结果
        """
        post_data = json.dumps(data)
        try:
            response = requests.post(self.webhook, headers=self.headers, data=post_data)
        except requests.exceptions.HTTPError as exc:
            logging.error("消息发送失败， HTTP error: %d, reason: %s" % (exc.response.status_code, exc.response.reason))
            raise
        except requests.exceptions.ConnectionError:
            logging.error("消息发送失败，HTTP connection error!")
            raise
        else:
            result = response.json()
            logging.info('发送结果：%s' % result)
            if result['errcode']:
                error_data = {"msgtype": "text", "text": {"content": "钉钉机器人消息发送失败，原因：%s" % result['errmsg']}, "at": {"isAtAll": True}}
                logging.error("消息发送失败，重新发送：%s" % error_data)
                requests.post(self.webhook, headers=self.headers, data=json.dumps(error_data))
            return result


class ActionCard(object):
    """
    ActionCard类型消息格式（整体跳转、独立跳转）
    """
    def __init__(self, title, text, btns, btn_orientation=0, hide_avatar=0):
        """
        ActionCard初始化
        :param title: 首屏会话透出的展示内容
        :param text: markdown格式的消息
        :param btns: 按钮数量为1时，整体跳转ActionCard类型，按钮的消息：singleTitle - 单个按钮的方案，singleURL - 点击按钮触发的URL；
                     按钮数量大于1时，独立跳转ActionCard类型，按钮的消息：title - 按钮方案，actionURL - 点击按钮触发的URL；
        :param btn_orientation: 0：按钮竖直排列，1：按钮横向排列
        :param hide_avatar: 0：正常发消息者头像，1：隐藏发消息者头像
        """
        super(ActionCard, self).__init__()
        self.title = title
        self.text = text
        self.btns = btns
        self.btn_orientation = btn_orientation
        self.hide_avatar = hide_avatar

    def get_data(self):
        """
        ActionCard类型消息数据（字典）
        :return: 返回ActionCard数据
        """
        if is_not_null_and_blank_str(self.title) and is_not_null_and_blank_str(self.text) and len(self.btns):
            if len(self.btns) == 1:
                # 独立跳转
                data = {
                        "msgtype": "actionCard",
                        "actionCard": {
                            "title": self.title,
                            "text": self.text,
                            "hideAvatar": self.hide_avatar,
                            "btnOrientation": self.btn_orientation,
                            "singleTitle": self.btns[0]["title"],
                            "singleURL": self.btns[0]["actionURL"]
                        }
                }
                return data
            else:
                # 整体跳转
                data = {
                    "msgtype": "actionCard",
                    "actionCard": {
                        "title": self.title,
                        "text": self.text,
                        "hideAvatar": self.hide_avatar,
                        "btnOrientation": self.btn_orientation,
                        "btns": self.btns
                    }
                }
                return data
        else:
            logging.error("ActionCard类型，消息标题或内容或按钮数量不能为空！")
            raise ValueError("ActionCard类型，消息标题或内容或按钮数量不能为空！")


class FeedLink(object):
    """
    FeedCard类型单条消息格式
    """
    def __init__(self, title, message_url, pic_url):
        """
        初始化单条消息文本
        :param title: 单条消息文本
        :param message_url: 点击单条信息后触发的URL
        :param pic_url: 点击单条消息后面图片触发的URL
        """
        super(FeedLink, self).__init__()
        self.title = title
        self.message_url = message_url
        self.pic_url = pic_url

    def get_data(self):
        """
        获取单条消息数据（字典）
        :return: 单条消息数据
        """
        if is_not_null_and_blank_str(self.title) and is_not_null_and_blank_str(self.message_url) and is_not_null_and_blank_str(self.pic_url):
            data = {
                    "title": self.title,
                    "messageURL": self.message_url,
                    "picURL": self.pic_url
            }
            return data
        else:
            logging.error("FeedCard类型单条消息文本、消息链接、图片链接不能为空！")
            raise ValueError("FeedCard类型单条消息文本、消息链接、图片链接不能为空！")


def is_port_number(s):
    try:
        num=int(s)
        return True if num>8000 and num<60000 else False
    except:
        raise ValueError("Error: 传入的数字不是端口号！")


def usage():
    print(' -p 项目名称，必选参数 \n' \
          ' -e 服务运行环境， 必选参数 \n' \
          ' -s 项目的服务名称或模块名称 \n' \
          ' -f 配置文件，可选参数，默认为 /etc/jhh.conf  \n' \
          ' -d 钉钉token地址 \n' \
          ' -k kubernetes api地址\n' \
          ' -u 构建的用户\n' \
          ' -l 访问url\n' \
          ' -i docker基础镜像image\n' \
          ' -r docker的registry仓库地址\n' \
          ' -t 构建类型\n' \
          ' -h 显示帮助信息 \n' \
          '')

if __name__ == '__main__':
    opts, args = getopt.getopt(sys.argv[1:],
                               "hp:e:s:f:k:d:t:u:l:i:b:r:",
                               ["help","project=","service=","env=",
                                "k8s=","ding=","type=","user=","url=",
                                "image=","baseImage=","registry=","file="]
                               )
    project=env=confpath=service=dingtalk=k8s=buildtype=user=url=image=base_image=registry=""
    for op, value in opts:
        if op=="-p" or op=="--project":
            project = value
        elif op in("-e", "--env"):
            env = value
        elif op in ("-s","--service"):
            service = value
        elif op in ("-f","--file"):
            confpath = value
        elif op in ("-d","--ding"):
            dingtalk = value
        elif op in ("-k", "--k8s"):
            k8s = value
        elif op in ("-t","--type"):
            buildtype = value
        elif op in ("-u","--user"):
            user = value
        elif op in ("l", "--url"):
            url = value
        elif op in ("i", "--image"):
            image = value
        elif op in ("b", "--baseImage"):
            base_image =value
        elif op in ("r","--registry"):
            registry = value
        elif op in ("-h", "--help"):
            usage()
            exit()
        else:
            raise ("Error: 参数输入有误，请重新输入！")

    confpath = confpath if confpath and os.path.isfile(confpath) else "/etc/jhh.json"

    if not os.path.isfile(confpath): raise ("Error: jhh.json配置文件不存在！")

    if project and env and service:
        docker = dockerTools(projectname=project,
                             env=env,
                             servicename=service,
                             k8s_api=k8s,
                             registry=registry,
                             build_type=buildtype,
                             base_image=base_image,
                             image=image,
                             user=user,
                             base_url=url,
                             ding_talk=dingtalk,
                             cfpath=confpath
                             )
        docker.init_container()
