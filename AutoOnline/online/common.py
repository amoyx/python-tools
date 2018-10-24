#! usr/bin/python
# -*- coding:utf-8 -*-

import paramiko
import random
import os
from fabric.api import *
from django.conf import settings
import types
from online.models import DBManager


class CommonLib:

    def __init__(self):
        self = CommonLib
        # pass

    # 判断字符串是否是数字
    @staticmethod
    def is_numeric(s):
        return all(c in "0123456789" for c in s)

    # 判断字符串是否是IP地址方法
    @staticmethod
    def is_ip_address(s):
        ip_address = s
        result = False
        if len(str(ip_address)) > 0:
            ip_field = ip_address.split(".")
            if len(ip_field) == 4:
                for num in ip_field:
                    if not CommonLib.is_numeric(num):
                        result = True
            else:
                result = True
        else:
            result = True
        if result:
            return False
        else:
            return True

    @staticmethod
    def ssh_key_connection(ip, cmd):
        port = 22
        username = "root"
        p_key = '/root/.ssh/id_rsa'
        key = paramiko.RSAKey.from_private_key_file(p_key)
        ssh = paramiko.SSHClient()
        ssh.load_system_host_keys()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(ip, username=username, pkey=key, allow_agent=False, look_for_keys=False)
        std_in, std_out, std_err = ssh.exec_command(cmd)
        err_message = std_err.read().strip("\r\n\t")
        ssh.close()
        if len(err_message) > 1:
            return False
        else:
            result = str(std_out.read().strip("\r\n")).split(",")
            return result

    @staticmethod
    def ssh_pass_connection(ip, username, password, cmd):
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(hostname=ip, port=22, username=username, password=password)
        std_in, std_out, std_err = ssh.exec_command(cmd)
        err_message = std_err.read().strip("\r\n\t")
        ssh.close()
        if len(err_message) > 1:
            return False
        else:
            result = str(std_out.read().strip("\r\n")).split(",")
            return result

    # 获取临时端口方法
    @staticmethod
    def get_temp_port(ports):
        r = True
        result = False
        if isinstance(ports, list):
            while r:
                r = False
                temp_num = random.randint(8080, 20000)
                for port in ports:
                    if CommonLib.is_numeric(port):
                        if int(temp_num) == int(port):
                            r = False
                            break
                        else:
                            result = temp_num
                    else:
                        return False
        else:
            result = False
        return result

    # 容器版本算法
    @staticmethod
    def decimal_rule(version):
        old_version = version
        if not version.strip("\n"):
            return False
        num_list = old_version.split(".")
        last_num = num_list[-1]
        if not CommonLib.is_numeric(last_num):
            return False
        last_num = int(last_num) + 1
        new_version = num_list
        new_version[-1] = str(last_num)
        for n in num_list:
            if not CommonLib.is_numeric(n):
                return False
        if last_num >= 10:
            for i in range(len(num_list)-1, -1, -1):
                if not CommonLib.is_numeric(num_list[i]):
                    return False
                if int(num_list[i]) + 1 >= 10:
                    new_version[i-1] = str(int(num_list[i-1]) + 1)
                    new_version[i] = "0"
                else:
                    continue
        str_ver = ""
        for n in new_version:
            str_ver = str_ver + n + "."
        return str_ver.rstrip(".")

    # 获取版本
    @staticmethod
    def get_version(version, t=True):
        if not version.strip("\n"):
            return False
        num_list = version.split(".")
        for n in num_list:
            if not CommonLib.is_numeric(n):
                return False
        num = version.replace(".", "")
        tail_part = str("")
        i = int(0)
        head_part = str("")
        last_number = (t is True and str(int(num)+1) or str(int(num)-1))
        for n in str(last_number):
            if i < len(last_number) - len(num_list):
                head_part = str(head_part) + str(n)
            else:
                tail_part = tail_part + n + "."
            i = int(i) + 1
            result = head_part + tail_part[:-1]
        return result

    # 数据库版本算法
    @classmethod
    def db_version_comp(cls, old_ver, new_ver):
        if old_ver == new_ver:
            return 0
        ver1 = old_ver.split(".")
        ver2 = new_ver.split(".")
        if len(ver1) >= 1 and len(ver2) >= 1:
            for i in range(len(ver1), len(ver2)):
                ver1.append(0)
            for i in range(0, len(ver1)):
                if i >= len(ver2):
                    ver2.append(0)
                if not cls.is_numeric(str(ver2[i])):
                    ver2[i] = 0
                if not cls.is_numeric(str(ver1[i])):
                    ver1[i] = 0
                if int(ver1[i]) > int(ver2[i]):
                    return 1
                if int(ver1[i]) < int(ver2[i]):
                    return 2
        return 0

    # 获取某个目录下所有的文件名
    @classmethod
    def get_dir_list(cls, dir_path, words="", file_list=[]):
        # newDir = dir_path
        if os.path.isfile(dir_path):
            if words.strip() == "":
                file_list.append(dir_path)
            else:
                if words in dir_path:
                    file_list.append(dir_path)
        elif os.path.isdir(dir_path):
            for line in os.listdir(dir_path):
                new_dir = os.path.join(dir_path, line)
                cls.get_dir_list(new_dir, words, file_list)
        return file_list

    # 获取数据库连接对象
    @staticmethod
    def get_mysql_conn_obj(p_name, p_env):
        if not p_name.strip() or not p_env.strip():
            return False
        try:
            return DBManager.objects.get(project_name=p_name, project_env=p_env)
        except Exception as e:
            return False

    # 获取新的数据库版本
    @classmethod
    def get_new_db_version(cls, p_name="", p_env=""):
        conn = cls.get_mysql_conn_obj(p_name, p_env)
        if not conn:
            return False
        old_ver = conn.db_version
        if not old_ver.strip():
            return False
        db_path = settings.DB_SQL_PATH
        files = cls.get_dir_list(db_path, "sql")
        if not type(files) is types.ListType:
            return False
        if len(files) < 1:
            return False
        dict_ver = {}
        for v in files:
            new_ver = (v.split("_")[-1])[0:-4]
            if str(cls.db_version_comp(old_ver, new_ver)) == "2":
                dict_ver[new_ver] = v
        return dict_ver

    # 计算列表中最大值
    @classmethod
    def comp_list_max_val(cls, list_val=[]):
        if not isinstance(list_val, list):
            return False
        temp = list_val[0]
        for li in list_val:
            if cls.db_version_comp(li, temp) == 1:
                temp = li
        return temp

    # 列表排序
    @classmethod
    def comp_list_sort(cls, list1=[], m="min"):
        if not list1 or not isinstance(list1, list):
            return False
        for i in range(0, len(list1)):
            for j in range(0, i):
                if m == "max":
                    if cls.db_version_comp(list1[i], list1[j]) == 1:
                        list1[i], list1[j] = list1[j], list1[i]
                else:
                    if cls.db_version_comp(list1[i], list1[j]) == 2:
                        list1[i], list1[j] = list1[j], list1[i]
        return list1


