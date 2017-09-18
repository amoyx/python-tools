# -*- coding: utf-8 -*-
# from __future__ import unicode_literals

from django.db import models

# Create your models here.


class opp_host(models.Model):
    ipaddr = models.CharField(verbose_name=u"主机IP地址", max_length=16, null=False, blank=False, unique=True)
    hostname = models.CharField(verbose_name=u"主机名称", max_length=50, null=True)
    username = models.CharField(verbose_name=u"用户名称", max_length=20, null=True, blank=True)
    password = models.CharField(verbose_name=u"用户密码", max_length=32, null=True, blank=True)
    sshport = models.IntegerField(verbose_name=u"SSH端口号", null=False, blank=True, default=22)
    remark = models.CharField(verbose_name=u"说明", max_length=255, null=True)


