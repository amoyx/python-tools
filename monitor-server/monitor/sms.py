#!/usr/bin/python3
# _*_ coding:utf-8 _*_

import requests

class ShortMessage():

    def __init__(self):
        self.host="http://cowsms.market.alicloudapi.com"
        self.path="/intf/smsapi"
        self.appcode="4ebb5189de9d45139adc8187c0778cc6"
        self.sign="%E6%96%91%E7%BE%9A%E5%9C%A8%E7%BA%BF"
        self.tpid="009"

    def send(self,mobile,content):
        '''
        :param mobile:  手机号码，多个用逗号隔开
        :param content: 短信内容
        :return:
        '''
        method = 'GET'
        headers = {'Authorization':  'APPCODE ' + self.appcode}
        querys = self.sms_template(mobile,content)
        url= self.host + self.path + '?'
        res=[]
        try:
            for q in querys:
                full_url = url + q
                res.append(requests.get(full_url,headers=headers))
        except:
            raise Exception("Error: 短信发送错误！")
        else:
            return res

    def sms_template(self,mobile,content):
        sms = []
        mobiles = mobile.split(',')
        if isinstance(mobiles,list):
            for m in mobiles:
               sms.append("mobile=" + m + "&paras=" + content + "%2C2&sign=" + self.sign + "&tpid="+ self.tpid)
        return sms
