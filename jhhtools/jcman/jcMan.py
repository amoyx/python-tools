#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
import getopt
import requests
import json
import os
import shutil
import time
import subprocess
import logging
import socket
import random


# 获取已使用服务端口
def get_used_service_port():
    cmd = "netstat -tlnu | awk 'BEGIN{ORS=\" \"}; NR>2{sub(\".*:\",\"\", $4); print $4}'|awk '{print substr($0,0,length($0)-1)}'"
    output, err = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE).communicate()
    if not err:
        return list(set(str(output).replace("\n", "").split(' ')))
    else:
        raise Exception("Error: 获取服务端口号失败!")

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


# 检测是否数字
def is_numeric(s):
    return all(c in "0123456789" for c in s)


class fileOperationTools:

    cfpath = "/etc/jinhuhang.json"

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
            raise Exception("Error: " + fname + " open error !")
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
            raise Exception("Error: not found files!")
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
                print("Error: copy file error!")
                exit()
            else:
                return True
        else:
            raise Exception("Error: 源文件路径或目标路径不存在!")

    # 获取目录下所有文件路径
    def get_all_file_path(self, dirname):
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

    def __init__(self, servername, build_type, port="", cfpath=""):
        super(fileOperationTools,self).__init__()
        if cfpath:
            self.cfpath = cfpath
        self.servername = servername
        self.serverport = port
        self.build_type = build_type
        self.main = self.get_json_file_content()
        self.curr_path = os.getcwd()

    @property
    def config(self):
        return self._config

    @config.setter
    def config(self, dict):
        data = {
            "serverName": dict["server_name"],
            "containerName": dict["server_name"] + str(int(time.time())),
            "dockerFileName": self.curr_path + '/Dockerfile' + '-'+ dict["server_name"],
            "imageName": dict["base_image"] + "/" + dict["server_name"] + ":" + str(int(time.time())),
            "websiteUrl": "http://" + get_host_ip() + ":" + str(dict["server_port"]) + "/",
            "serverPort": str(dict["server_port"]),
            "work_dir": self.curr_path + "/" + dict["server_name"] if os.path.isdir(self.curr_path + "/" + dict["server_name"]) else self.curr_path
        }
        self._config = data

    def init_containers(self):
        '''
        初始化容器
        '''
        if not self.servername: raise Exception("Error: 服务不能为空!")

        server_names = self.servername.split(';')
        server_ports = self.serverport.split(';') if self.serverport else False

        i = 0
        for s in server_names:
            self.config = {
                "base_image": self.main["registry_host"],
                "server_name": s,
                "server_port": server_ports[i] if server_ports and len(server_ports) > i and is_numeric(server_ports[i]) else get_random_service_port(get_used_service_port())
            }
            i += 1
            releasePackageName = self.build_image()
            if releasePackageName:
                website_url = self.config["websiteUrl"] + releasePackageName if self.build_type == "tomcat" else self.config["websiteUrl"] + "swagger-ui.html"
                res = self.run_containers()
                if res:
                    # 初始化机器人小丁
                    xiaoding = DingtalkChatbot(self.main["ding_talk"])
                    xiaoding.send_link(title='发布提醒',
                                       text="服务：" + self.config["serverName"],
                                       message_url=website_url
                                       )
                    continue
            else:
                raise Exception("Error: 服务" + s + " docker容器启动失败")

    # 制作Dockerfile文件
    def make_docker_file(self, packageName):
        init_script=""
        docker_file_content=""
        init_dir = self.config["work_dir"] + "/init"
        dockerfile_root = "" if self.config["work_dir"] == self.curr_path else self.config["serverName"] + "/"
        if not os.path.exists(init_dir): os.makedirs(init_dir)
        if self.build_type == "tomcat":
            # 制作 docker 容器初始化脚本
            docker_file_content = "FROM " + self.main["tomcat_docker_base_image"] + " \n" \
                                "COPY " + dockerfile_root + "init  init \n"  \
                                "COPY " + dockerfile_root + "target/" + packageName + "  webapps/" + packageName + "\n" \
                                "RUN chmod +x init \n" \
                                "RUN chmod -R 777 logs \n" \
                                "EXPOSE 8080 \n" \
                                'CMD ["bash","/entrypoint.sh"]'
        elif self.build_type == "jar":
            init_script = "java -jar " + packageName + ".jar --server.port=8080 "
            docker_file_content = "FROM " + self.main["jdk_docker_base_image"] + "\n" \
                                    "COPY " + dockerfile_root + "target/" + packageName + ".jar  " + packageName + ".jar \n" \
                                    "COPY " + dockerfile_root + "init/initConf.sh entrypoint.sh \n" \
                                    "RUN chmod +x entrypoint.sh \n" \
                                    "EXPOSE 8080 \n" \
                                    'CMD ["bash", "entrypoint.sh"]'
        elif self.build_type == "war":
            docker_file_content = "FROM " + self.main["tomcat_docker_base_image"] + " \n" \
                        "COPY " + dockerfile_root + packageName + ".war webapps/" + packageName + ".war \n"
        else:
            raise Exception("Error: not found your input build type!")
        if not self.writeToFile(self.config["dockerFileName"], docker_file_content):
            raise Exception("Error: dockerfile and initScript write error!")
        if init_script:
            self.writeToFile(init_dir + "/initConf.sh", init_script)
        return True

    # 构建Docker镜像
    def build_image(self):
        '''
        # 构建docker镜像
        :param build_type构建类型 tomcat jar war .....:
        :return: 返回发布包的名称
        '''

        package_name=''
        if self.build_type == "tomcat":
            d_path = self.config["work_dir"] + "/init"
            self.copyFiles(self.config["work_dir"] + "/src/main/resources/env", d_path)
            package_name = self.getExstionFileName(self.config["work_dir"] + "/target/", ".war")
        elif self.build_type == "jar":
            package_name = self.getExstionFileName(self.config["work_dir"] + "/target/", ".jar")
        elif self.build_type == "war":
            package_name = self.getExstionFileName(self.config["work_dir"], ".war")
        else:
            raise Exception("Error: not found your input build type!")

        # 开始生成docker镜像
        if self.make_docker_file(package_name):
            res = subprocess.call(
                "docker build -t " + self.config["imageName"] + " -f " + self.config["dockerFileName"] + " .",
                shell=True)
            if str(res) == "0":
                return package_name
            else:
                raise Exception("Error: create docker image fail!")
        else:
            raise Exception("Error: create docker image fail!")

    # 运行容器
    def run_containers(self):
        docker_cmd = "docker ps -a|grep " + self.config["serverName"] + " |awk -F' ' '{print $1,$2}'"
        # 找出旧的docker容器和镜像
        docker_list = bytes.decode(subprocess.check_output(docker_cmd,shell=True)).split('\n')
        image_list, container_list = [], []
        for docker in docker_list:
            if docker:
                container_list.append(docker.split(' ')[0])
                image_list.append(docker.split(' ')[1])
        docker_container_list, docker_image_list=list(set(container_list)),list(set(image_list))

        log_index_prefix = " --label aliyun.logs." + self.config["serverName"]
        container_arg_list = {
            "name": self.config["containerName"],
            "log_volume": "/acs/logs/" + self.config["serverName"] + ":/usr/local/tomcat/logs",
            "log_index_name": log_index_prefix + "=stdout",
            "ports": self.config["serverPort"] + ':8080',
            "image": self.config["imageName"]
        }

        docker_run_cmd = "docker run -d -p {ports} " \
                        "-v {log_volume} -v /usr/local/tomcat/logs {log_index_name} " \
                        "--name {name} --restart=always {image}".format(**container_arg_list)

        try:
            if len(docker_container_list) >= 1:
                for c in  docker_container_list:
                    subprocess.call("docker stop " + c, shell=True)
                    subprocess.call("docker rm " + c, shell=True)
            subprocess.call(docker_run_cmd, shell=True)
            if len(docker_image_list) >= 1:
                for img in docker_image_list:
                    subprocess.call("docker rmi " + img, shell=True)
        except:
            raise Exception("Error: --------- " + self.config["serverName"] + " 容器更新失败-----------!")
        else:
            print("OK: --------- " + self.config["serverName"] + " 容器更新成功-----------!")
            return True
        # list_container = self.client.containers.list(all="True") 不建议用docker的API，由于基于TCP模式，严重影响运行速度
        # res = self.client.containers.run(image=d_image, ports=ports, name=container_name, environment=environment, volumes=volumes)  该方法有BUG,一直连接docker server，不会断开

    # 根据容器id停止容器
    def stopContainers(self, cid):
        c = self.client.containers.get(cid)
        return c.stop()

    # 根据容器id删除容器
    def delContainers(self, cid):
        c = self.client.containers.get(cid)
        return c.remove()

    # 清除已停止的容器
    def clearStopContainers(self):
        self.client.containers.prune()


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


def usage():
    print(' -p 服务对外访问端口, 可选参数，如果多个则用分号隔开 \n' \
          ' -s 服务名称或模块名称,必选参数,如果需要启动多个服务,以分号隔开即可 \n' \
          ' -f 配置文件，可选参数，默认为 /etc/jinhuhang.json \n' \
          ' -t 服务类型，如jar, war，可选参数，默认为tomcat \n' \
          ' -h 显示帮助信息 \n' \
          '')


if __name__ == '__main__':
    opts, args = getopt.getopt(sys.argv[1:], "hp:s:f:t:")
    ports = confpath = serverName = build_type = ""
    for op, value in opts:
        if op == "-p":
            ports = value
        elif op == "-s":
            serverName = value
        elif op == "-f":
            confpath = value
        elif op == "-t":
            build_type = value
        elif op == "-h":
            usage()
            exit()
        else:
            raise Exception("Error: 参数输入有误，请重新输入！")

    confpath = confpath if confpath and os.path.isfile(confpath) else ""
    if not serverName: raise Exception("Error: 服务名称不能为空!")
    build_type = build_type if build_type else "tomcat"
    docker = dockerTools(servername=serverName, build_type=build_type, port=ports, cfpath=confpath)
    docker.init_containers()
