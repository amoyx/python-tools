#! usr/bin/python
# coding=utf-8
import requests
import json
from common import CommonLib
from conf.settings import BASE_DIR
from django.conf import settings
import os

comm = CommonLib


class Cluster:
    def __init__(self, pro_name, env, version):
        self.pro_name = pro_name
        self.env = env
        self.version = version
        self.code = self.code()

    # 定义状态码
    @staticmethod
    def code():
        StatusCode = {}
        StatusCode['500'] = "error: access aliyun container api fail"
        StatusCode['404'] = "error: key file is not exists"
        StatusCode['2']   = "error: Unknown update mode"
        StatusCode['4']   = "error: docker compose template init fail"
        StatusCode['0']   = "error: docker image version cannot be empty"
        StatusCode['101'] = "error: to aliyun container commit post fail"
        return StatusCode

    # 初始化参数定义
    def init_conf(self):
        pro_name = self.pro_name
        env = self.env
        app_name = env + "-" + pro_name
        if env == "prod":
            root_dir = os.path.join(BASE_DIR, "online/certFiles/")
            url = "https://master1.cs-cn-hangzhou.aliyun.com:11876/projects/"
            if "prod-cesp" in app_name:
                root_dir = os.path.join(BASE_DIR, "online/certFiles/cesp/")
                url = "https://master1g3.cs-cn-hangzhou.aliyun.com:13868/projects/"
        else:
            root_dir = os.path.join(BASE_DIR, "online/certFiles/staging/")
            url = "https://master1g3.cs-cn-hangzhou.aliyun.com:19584/projects/"
        master_url = url + str(app_name)
        ssl_key = root_dir + "key.pem"
        ca_files = root_dir + "ca.pem"
        ssl_cert = root_dir + "cert.pem"
        img_host = settings.DOCKER_REGISTRY
        if not os.path.exists(ssl_key) or not os.path.exists(ca_files) or not os.path.exists(ssl_cert):
            return self.code["404"]
        result = {"master_url": master_url, "key": ssl_key, "ca": ca_files, "cert": ssl_cert, "img_host": img_host}
        return result

    # 更新阿里云容器操作
    def update(self):
        new_template = self.send_request("get", self.version)
        if "error:" in new_template:
            return new_template
        re = self.send_request("put", "", new_template)
        return re

    # 获取阿里云docker compose模板
    def get_template(self):
        conf = self.init_conf()
        if "error:" in conf and isinstance(conf, basestring):
            return conf
        res = requests.get(conf["master_url"], verify=conf["ca"], cert=(conf["cert"], conf["key"]))
        if not "[200]" in str(res).strip():
            return self.code["500"]
        template_data = json.loads(res.content)
        return template_data

    # 向阿里云容器API发送请求
    def send_request(self, action, img_version="", json_template=""):
        conf = self.init_conf()
        if action == "get":
            template_data = self.get_template()
            if "error:" in template_data:
                return template_data
            cluster_version = template_data["version"]
            if img_version == "":
                return self.code['0']
            else:
                new_template = self.init_new_template(template_data["template"], img_version)
                if "error:" in new_template:
                    return new_template
                template = {"version": comm.get_version(cluster_version), "template": new_template}
                result = json.dumps(template)
        elif action == "put":
            headers = {'Content-Type': 'application/json'}
            url = conf["master_url"] + "/update"
            result = requests.post(url, json_template, headers, verify=conf["ca"], cert=(conf["cert"], conf["key"]))
            if not "[202]" in str(result).strip():
                return self.code['101']
            else:
                return result
        elif action == "rollback":
            template_data = self.get_template()
            cluster_version = template_data["version"]
            new_template = self.init_new_template(template_data["template"])
            template = {"version": comm.get_version(cluster_version), "template": new_template}
            result = json.dumps(template)
        else:
            result = self.code['2']
        return result

    # 生成新的docker compose模板
    def init_new_template(self, template, img_version=""):
        app_name = self.env + "-" + self.pro_name
        conf = self.init_conf()
        img_url = conf["img_host"]
        old_img = ""
        for t in template.split("\n"):
            if img_url in t:
                old_img = t.strip()
        if img_version == "":
            img_version = comm.get_version(old_img.split(":")[2].split("'")[0], False)
        new_img = "image: '" + img_url + app_name + ":" + img_version + "'"
        if old_img.strip() != "":
            new_template = str(template).replace(old_img, new_img, 1)
            return new_template
        else:
            return self.code["4"]

    def rollback(self):
        template = self.send_request("rollback")
        if template:
            re = self.send_request("put", "", template)
        else:
            re = False
        return re
