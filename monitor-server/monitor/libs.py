#!/usr/bin/python
# _*_ coding:utf-8 _*_

import re


class Common(object):

    @staticmethod
    def get_alarm_ip_address(str):
        reg = re.compile(r'1[0-9]{1,2}\.\d+\.\d+\.\d+')
        return reg.findall(str)

    @staticmethod
    def get_alarm_msg(str):
        r = re.compile(r'\[(.*?)\]')
        return r.findall(str)