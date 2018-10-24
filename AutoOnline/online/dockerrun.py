#! usr/bin/python
# coding=utf-8

from docker import Client
from online.models import Compose
from online.models import HostManager
from online.models import DBManager
from online.common import *
from django.conf import settings
import types
import commands
from SSHCommon import SSHConnect
common = CommonLib


def push_image(store_img_host, image_name, project_name, image_tag, img_port="5555"):
    docker_cli = Client(base_url='tcp://' + store_img_host + ":" + img_port, version="1.21")
    images_list = docker_cli.images()
    if len(images_list) > 0:
        mc_image_list = list()
        for item in images_list:
            for tag_item in item["RepoTags"]:
                if project_name in tag_item:
                    mc_image_list.append(item)
        if len(mc_image_list) < 1:
            return False
        else:
            docker_cli.tag(mc_image_list[0]["Id"], image_name, tag=image_tag)
            # docker_cli.push(image_name)
            return True
    else:
        return False


def run_container(project_name):
    if not project_name.strip():
        return "项目名称不能为空"
    docker = Compose
    docker_info = docker.objects.get(project_name=project_name)
    # container_flag容器的版本,image_tag docker镜像版本,prod_image生产环境镜像名称,img_host 存储镜像的主机IP地址
    # 获取项目的最后一次镜像，并且将该镜像push至生产环境
    container_flag = docker_info.container_flag
    container_flag = (container_flag == 1 and 2 or 1)
    image_tag = str(docker_info.img_version + 1)
    img_host = docker_info.store_img_host
    if not common.is_ip_address(img_host):
        return "store docker image ip address error"
    image_name = "registry.aliyuncs.com/kolbuy/" + project_name
    prod_image = image_name + ":" + image_tag
    response = push_image(img_host, image_name, project_name, str(image_tag))
    if response:
        img_host_info = HostManager.objects.get(host_ip=img_host)
        env.host_string = img_host
        env.user = img_host_info.username
        env.password = img_host_info.password
        docker_info.project_name = project_name
        docker_info.img_version = int(image_tag)
        docker_info.save()
        run("docker push " + prod_image)
    else:
        return "push image fail"

    # old_balance_file 负载均衡节点的旧nginx配置文件, compose_file_path是docker compose文件的路径
    # default_port 是 compose文件port模块的被映射端口,相当于容器内部服务的端口,cluster_ips 应用项目集群节点的IP地址
    # new_balance_file 负载均衡节点的新nginx配置文件, upstream_content 相当于nginx配置文件upstream模块的内容
    # 编写compose file文件，然后将compose file文件传输至集群主机，并且在集群主机运行docker容器
    work_dir = os.getcwd() + "/temp_file/"
    target_dir = "/data/online/"
    if not os.path.isdir(work_dir):
        os.makedirs(work_dir, mode=0o777)
    compose_file_path = work_dir + str(project_name) + ".yml"
    target_compose_file = target_dir + str(project_name) + ".yml"
    upstream_content = "upstream  " + project_name + "  {" + "\n"
    default_port = docker_info.default_port
    cluster_ips = str(docker_info.cluster_ip).split("|")
    if isinstance(cluster_ips, list):
        for host_ip in cluster_ips:
            if not common.is_ip_address(host_ip):
                return "cluster host ip address error"
            host_info = HostManager.objects.get(host_ip=host_ip)
            ssh_user = host_info.username
            ssh_pass = host_info.password
            get_port_cmd = "netstat -tln | awk 'BEGIN{ORS=\",\"}; NR>2{sub(\".*:\", \"\", $4); print $4}'|awk '{print substr($0,0,length($0)-1)}'"
            client_port = common.ssh_pass_connection(host_ip, ssh_user, ssh_pass, get_port_cmd)
            if not client_port:
                return "connection cluster host fail"
            project_port = common.get_temp_port(client_port)
            if not project_port:
                return "get cluster host temp port fail"
            if compose_file_path.split(".")[-1] == "yml":
                fo = open(compose_file_path, "w")
                compose_content = str(project_name) + str(container_flag) + ":" + "\n"
                compose_content = compose_content + "    image: \'" + prod_image + "\'" + "\n"
                compose_content = compose_content + "    environment:" + "\n" + "        " + " - \"ENVTYPE=prod\"" + "\n"
                compose_content = compose_content + "    ports:" + "\n" + "        " + "- \"" + str(
                        project_port) + ":" + str(default_port) + "\"\n"
                compose_content = compose_content + "    restart: always" + ""
                fo.write(compose_content)
                fo.close()
            else:
                return "compose file name error"
            env.user = ssh_user
            env.host_string = host_ip
            env.password = ssh_pass
            if not os.path.exists(compose_file_path):
                return "create compose file fail"
            have_build_dir = run("mkdir -p " + target_dir).succeeded
            if have_build_dir:
                put(compose_file_path, target_compose_file)
            else:
                return "cluster host work dir not exists"
            file_exists = run("test -f " + target_compose_file).succeeded
            if file_exists:
                compose_cmd = "cd " + target_dir + "; docker-compose -f  " + project_name + ".yml  stop"  \
                              + ";docker-compose -f " + project_name + ".yml" + " up -d "
                run(compose_cmd)
                upstream_content = upstream_content + "\t" + "server " + str(host_ip) + ":" + str(
                        project_port) + ";" + "\n"
            else:
                return "copy compose file to cluster host fail"
    else:
        return "cluster host ip address error"

    # 重新编写负载均衡主机的nginx.conf配置文件，并将修改后的nginx.conf配置文件上传至负载均衡主机
    old_balance_file = work_dir + project_name + ".conf"
    new_balance_file = work_dir + project_name + ".conf.bak"
    balance_vip = str(docker_info.balance_vip).split("|")
    balance_file = "/etc/nginx/conf.d/" + project_name + ".conf.bak"
    if not common.is_ip_address(str(balance_vip[0])):
        return "balance ip address error"
    if not os.path.exists(old_balance_file):
        host_info = HostManager.objects.get(host_ip=balance_vip[0])
        env.host_string = host_info.host_ip
        env.user = host_info.username
        env.password = host_info.password
        get("/etc/nginx/conf.d/" + project_name + ".conf", old_balance_file)
    fo = open(old_balance_file, "r")
    file_stream = fo.read()
    old_upstream_content = file_stream[0:file_stream.find("}")]
    fo.close()
    file_content = file_stream.replace(old_upstream_content, upstream_content)
    fo = open(new_balance_file, "w")
    fo.write(file_content)
    fo.close()
    if isinstance(balance_vip, list):
        for host_ip in balance_vip:
            if not common.is_ip_address(host_ip):
                return "balance ip address error"
            host_info = HostManager.objects.get(host_ip=host_ip)
            env.host_string = host_ip
            env.user = host_info.username
            env.password = host_info.password
            put(new_balance_file, balance_file)
    else:
        return "balance ip address error"

    # 将变更后的数据，写回数据库
    docker_info.project_name = project_name
    docker_info.container_flag = int(container_flag)
    docker_info.save()
    # docker_info.objects.filter(project_name=project_name).update(container_flag=container_flag)
    return "project run finished"


# push docker 镜像
def push_img(project_name, environ):
    if not project_name.strip() or not environ.strip():
        return "error: ProjectName and Environ cannot be emptyss"
    try:
        docker = Compose.objects.get(project_name=project_name)
    except Exception as e:
        return "error: database access error, compose query fail"
    # push docker image to a li yun
    if common.is_ip_address(str(docker.store_img_host)):
        try:
            host = HostManager.objects.get(host_ip=docker.store_img_host)
        except:
            return "error: database access error, hostmanager query fail"
        client = SSHConnect(host.host_ip, host.username,host.password)
        cmd = "docker images | grep " + project_name + " | awk '{if(NR==1) print $3}'"
        res = client.cmd(cmd)
        if isinstance(res, basestring):
            return res
        tag = res[0]
        if environ == "prod":
            old_version = docker.img_version
        else:
            old_version = docker.img_ver2
        ImgVersion = common.get_version(old_version)
        ImgName = settings.DOCKER_REGISTRY + environ + "-" + project_name + ":" + ImgVersion
        res = client.cmd("docker tag  " + str(tag).strip() + "  " + ImgName)
        if isinstance(res, basestring):
            return res
    else:
        return "error: docker images host is not ip address"

    # update  docker image version , write to database
    if environ == "prod":
        docker.img_version = ImgVersion
    else:
        docker.img_ver2 = ImgVersion
    docker.save()
    res = client.cmd("docker push  " + ImgName)
    if isinstance(res, basestring):
        return res
    return ImgVersion


# 将sql脚本导入到数据库中
def import_sql_to_db(p_name, p_env):
    new_version = common.get_new_db_version(p_name, p_env)
    conn = common.get_mysql_conn_obj(p_name, p_env)
    r_msg = {}
    if not conn:
        r_msg["last_msg"] = "error: 数据库连接失败"
        return r_msg
    host = conn.db_host
    user = conn.db_user
    passwd = conn.db_passwd
    dbname = conn.db_name
    list_version = []
    if new_version and type(new_version) is types.DictType:
        list1 = []
        for key, value in new_version.items():
            list1.append(key)
        list1 = common.comp_list_sort(list1)
        for key in list1:
            cmd = "mysql -u" + user + " -p" + passwd + " -h" + host + "  " + dbname + " < " + new_version[key] + " --default-character-set=utf8"
            (status, output) = commands.getstatusoutput(cmd)
            if str(status) == "0":
                r_msg[key] = "OK"
                list_version.append(str(key))
            else:
                r_msg[key] = str(status) + "  " + str(output)
                r_msg["last_msg"] = "error: 数据库更新失败"
                break
    else:
        r_msg["last_msg"] = "normal: 数据库版本已经是最新版本"
        return r_msg
    if len(list_version) > 0:
        max_val = common.comp_list_max_val(list_version)
        if max_val:
            try:
                conn.db_version = max_val
                conn.save()
                r_msg["update_msg"] = "数据库最大版本号已更新至 " + max_val
            except Exception as e:
                r_msg["last_msg"] = "error: 数据库更新失败"
        else:
            r_msg["last_msg"] = "error: 数据库更新失败"
    else:
        r_msg["last_msg"] = "error: 数据库更新失败"
    return r_msg
