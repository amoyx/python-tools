#! usr/bin/python
# coding=utf-8
from django.db import models


# Create your models here.
class Compose(models.Model):
    DEFAULT_PORT = (
        (8080, 8080),
        (80, 80),
    )
    PROJECT_TYPE = (
        ('PHP', 'php'),
        ('TOMCAT', 'tomcat'),
    )
    CONTAINER_FLAG_CHOICES = (
        (1, 1),
        (2, 2),
    )
    project_name = models.CharField(verbose_name=u"项目名称", max_length=50, null=False, blank=False, unique=True)
    img_version = models.CharField(verbose_name=u"docker最后镜像版本", max_length=50, null=False, blank=False)
    container_flag = models.IntegerField(verbose_name=u"前一个容器序号", choices=CONTAINER_FLAG_CHOICES, null=False,
                                         blank=False)
    project_type = models.CharField(verbose_name=u"项目类型", null=True, choices=PROJECT_TYPE, default="php",
                                    max_length=100)
    default_port = models.IntegerField(verbose_name=u"服务默认端口", null=True, choices=DEFAULT_PORT, default=80)
    store_img_host = models.CharField(verbose_name=u"存储镜像的主机", null=False, max_length=20, blank=False)
    balance_vip = models.CharField(verbose_name=u"负载均衡IP集", max_length=200, null=True)
    cluster_ip = models.TextField(verbose_name=u"集群节点IP集", null=True)
    img_ver2 = models.CharField(verbose_name=u"镜像版本2", null=True, blank=True, max_length=50)
    nat_port = models.IntegerField(verbose_name=u"转发端口", null=True, blank=True)


class HostManager(models.Model):
    username = models.CharField(verbose_name=u"用户名称", max_length=80, null=False, blank=False)
    password = models.CharField(verbose_name=u"用户密码", max_length=20, null=False, blank=False)
    host_ip = models.CharField(verbose_name=u"主机IP", max_length=20, null=False, blank=False, unique=True)
    host_name = models.CharField(verbose_name=u"主机名称", max_length=50, null=True)
    ssh_port = models.IntegerField(verbose_name=u"SSH端口号", null=False, blank=False, default=22)
    docker_port = models.IntegerField(verbose_name=u"docker端口号", null=False, blank=False, default=5555)
    remark = models.CharField(verbose_name=u"说明", max_length=100, null=True)


class DBManager(models.Model):
    PROJECT_ENV = (
        ('PROD', 'prod'),
        ('STAGING', 'staging'),
    )
    project_name = models.CharField(verbose_name=u"项目名称", max_length=20, null=False, blank=False)
    project_env = models.CharField(verbose_name=u"项目环境", max_length=20, null=False, choices=PROJECT_ENV, default="staging", blank=False)
    db_version = models.CharField(verbose_name=u"数据库版本", max_length=30, null=False, blank=False)
    db_host = models.CharField(verbose_name=u"连接数据库主机地址", max_length=100, null=False, blank=False)
    db_name = models.CharField(verbose_name=u"数据库名称", max_length=20, null=False, blank=False)
    db_user = models.CharField(verbose_name=u"连接数据库用户名", max_length=20, null=False, blank=False)
    db_passwd = models.CharField(verbose_name=u"连接数据库密码", max_length=50, null=False, blank=False)
