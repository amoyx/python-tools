#! usr/bin/python
# coding=utf-8

from docker import Client
from online.models import Compose
from online.models import HostManager
import sys
import os
import string
import re
import paramiko
import random
from fabric.api import *
from online.common import *


common = CommonLib


def start(project_name):
    if not project_name.strip():
        docker_info = Compose.objects.get(project_name=project_name)
        balance_vips = docker_info.balance_vip.split("|")
        work_dir = "/etc/nginx/conf.d/"
        conf_file = work_dir + project_name + ".conf"
        new_file = work_dir + project_name + ".conf.bak"
        for ip in balance_vips:
            if common.is_ip_address(ip):
                host_info = HostManager.objects.get(host_ip=ip)
                env.host_string = ip
                env.user = host_info.username
                env.password = host_info.password
                env.run("cp  " + conf_file + "  " + conf_file + ".temp")
                env.run("rm -rf " + conf_file)
                env.run("mv  " + new_file + " " + conf_file)
                env.run("mv  " + conf_file + ".temp " + new_file)
            else:
                return "IP 地址格式错误"
        for ip in balance_vips:
            if common.is_ip_address(ip):
                host_info = HostManager.objects.get(host_ip=ip)
                env.host_string = ip
                env.user = host_info.username
                env.password = host_info.password
                env.run("service ngixn reload")
            else:
                return "IP 地址格式错误"
    else:
        return "项目名称不能为空"


def rollback(project_name):
    if not project_name.strip():
        docker_info = Compose.objects.get(project_name=project_name)
        balance_vips = docker_info.balance_vip.split("|")
        work_dir = "/etc/nginx/conf.d/"
        new_file = work_dir + project_name + ".conf"
        old_file = work_dir + project_name + ".conf.bak"
        for ip in balance_vips:
            if common.is_ip_address(ip):
                host_info = HostManager.objects.get(host_ip=ip)
                env.host_string = ip
                env.user = host_info.username
                env.password = host_info.password
                env.run("cp  " + new_file + "  " + new_file + ".temp")
                env.run("rm -rf " + new_file)
                env.run("mv  " + old_file + " " + new_file)
                env.run("mv  " + new_file + ".temp " + old_file)
            else:
                return "IP 地址格式错误"
        for ip in balance_vips:
            if common.is_ip_address(ip):
                host_info = HostManager.objects.get(host_ip=ip)
                env.host_string = ip
                env.user = host_info.username
                env.password = host_info.password
                env.run("service ngixn reload")
            else:
                return "IP 地址格式错误"
    else:
        return "项目名称不能为空"


def start_service(project_name, environ):
    if not project_name.strip():
        return "project name cant be empty"
    docker_info = Compose.objects.get(project_name=project_name)
    project_port = docker_info.default_port
    nat_port = docker_info.nat_port

    # push docker image to a li yun
    if common.is_ip_address(str(docker_info.store_img_host)):
        host_info = HostManager.objects.get(host_ip=docker_info.store_img_host)
        env.host_string = host_info.host_ip
        env.user = host_info.username
        env.password = host_info.password
        docker_tag = run("docker images | grep " + project_name + " | awk '{if(NR==1) print $3}'")
        img_version = common.decimal_rule(docker_info.img_ver2)
        image_name = "registry.aliyuncs.com/kolbuy/" + environ + "-" + project_name + ":" + img_version
        run("docker tag " + docker_tag + " " + image_name)
    else:
        return "storage image host ip address error"

    # 将变更后的数据，写回数据库
    docker_info.project_name = project_name
    docker_info.img_ver2 = img_version
    docker_info.save()
    run("docker push " + image_name)

    # pull docker image to prod host, and run docker container
    cluster_nodes_ip = docker_info.cluster_ip.split("|")
    for node_ip in cluster_nodes_ip:
        if common.is_ip_address(node_ip):
            host_info = HostManager.objects.get(host_ip=node_ip)
            env.host_string = host_info.host_ip
            env.user = host_info.username
            env.password = host_info.password
            container_name = str(project_name + img_version)
            run("docker pull " + image_name)
            get_container_cmd = "docker ps -a -q -f name=" + project_name
            get_img_cmd = "docker ps -a -f name=" + project_name + " |awk '{if(NR>=2) print $2}'"
            get_run_container = run(get_container_cmd)
            get_run_img = run(get_img_cmd)
            if get_run_container.strip("\n\t\r") != "":
                stop_cmd = "docker stop $(" + get_container_cmd + ")"
                run(stop_cmd)
            start_cmd = "docker run -d --name " + container_name + " -p " + str(nat_port) + ":" + \
                        str(project_port) + " --restart=always -e \"ENVTYPE=" + environ + "\" -e \"ENVNAME=" + environ + "\" " + image_name
            run(start_cmd)
            if get_run_container.strip("\n\t\r") != "":
                container = get_run_container.split("\r\n")
                for c in container:
                    run("docker rm " + c)
            if get_run_img.strip("\n\t\r") != "":
                run_images = get_run_img.split("\r\n")
                for img in run_images:
                    run("docker rmi " + img)
        else:
            return "cluster node ip error"
    return "the program run successfully"
