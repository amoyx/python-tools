# -*- coding: utf-8 -*-
from django.test import TestCase
import os
import urllib.request,urllib.parse,json
from urllib.error import URLError,HTTPError
import requests
import redis
import time
# Create your tests here.


class WeiXin:
    def __init__(self,appid,secret):
        self.appid = appid
        self.secret = secret
        self.redis_conn = redis.Redis(host='127.0.0.1',port=6379)

    # 生成token
    def get_token(self):
        token =  self.redis_conn.get('access_token') if self.redis_conn.exists('access_token') else False
        if token:
            return str(token,encoding = "utf-8")
        else:
            url="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%s&secret=%s" % (self.appid,self.secret)
            html=urllib.request.urlopen(url)
            req=json.loads(html.read().decode())
            token = self.redis_token(str(req.get('access_token')))
            return str(token,encoding = "utf-8")

    # 将token写入redis
    def redis_token(self,token):
        if not token or token == "":
            return False
        pipe = self.redis_conn.pipeline(transaction=True)
        self.redis_conn.setex('access_token',token,7000)
        token = self.redis_conn.get('access_token')
        return token

    # 获取用户列表
    def get_user_list(self, nextid=""):
        token = self.get_token()
        url="https://api.weixin.qq.com/cgi-bin/user/get?access_token=%s" % (token)
        html=urllib.request.urlopen(url)
        req=json.loads(html.read().decode())
        if  "errocode"  in req.keys() or "errmsg" in req.keys():
            return "error: token验证失败,请检查token是否有效"
        else:
            return req.get('data').get('openid')

    # 通过用户的昵称获取openid等相关信息
    def get_user_info(self, nickname=""):
        if nickname == "" or not nickname:
            return "用户昵称不能为空"
        userlist=self.get_user_list()
        if isinstance(userlist,str) and "error:" in userlist:
            return userlist
        token = self.get_token()
        i=0
        for i in range(len(userlist)):
            url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=%s&openid=%s&lang=zh_CN" % (token,userlist[i])
            html=urllib.request.urlopen(url)
            req=json.loads(html.read().decode())
            if req.get('nickname') == nickname :
                res = req
                break
            else:
                res = False
                continue
        return res

    # 获取客服列表
    def get_kf_list(self):
        token = self.get_token()
        url = 'https://api.weixin.qq.com/cgi-bin/customservice/getkflist?access_token=%s'% (token)
        html=urllib.request.urlopen(url)
        req=json.loads(html.read().decode())
        return req

    # 发送信息
    def send_msg(self,openid='423424253153',msg='hello world',kf_account="001@test"):
        token=self.get_token()
        data={
            "touser":openid,
            "msgtype":"text",
            "text":
                {
                    "content":msg
                },
                "customservice":
                {
                        "kf_account": kf_account
                }
            }
        data = urllib.parse.urlencode(data).encode('utf-8')
        url="https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=%s" % (token)
        headers = {
             'User-Agent': r'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) '
                             r'Chrome/45.0.2454.85 Safari/537.36 115Browser/6.0.3',
            'Referer': r'https://mp.weixin.qq.com/cgi-bin/singlesendpage',
            'Connection': 'keep-alive'
        }
        req = urllib.request.Request(url,headers=headers,data=data)
        page = urllib.request.urlopen(req).read()
        res = page.decode('utf-8')
        return res

    # 获取信息模板编号
    def get_msg_template(self):
        token = self.get_token()
        url="https://api.weixin.qq.com/cgi-bin/template/get_all_private_template?access_token=%s" % (token)
        html=urllib.request.urlopen(url)
        req=json.loads(html.read().decode())
        return req

    # 发送模板信息
    def send_template_msg(self,openid,template_id,data=""):
        token = self.get_token()
        url = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=%s" % (token)
        data =  {"touser":openid,"template_id":template_id,"data":data }
        return self.post_data(url, data)

    def post_data(self,url,data):
        data = json.dumps(data)
        res = requests.post(url=url, data=data)
        return res

# 案例说明：下面是利用 微信模板消息 实现 zabbix报警的实例
# wx=WeiXin(appid="test825ctesta7c741",secret="test68e1bc2etestd95d551c2d970eme")
# data={
#                    "first": {
#                        "value":"请注意有报警发生！",
#                        "color":"#173177"
#                    },
#                    "keyword1":{
#                        "value":time.strftime("%Y-%m-%d %H:%M:%S",time.localtime()),
#                        "color":"#173177"
#                    },
#                    "keyword2": {
#                        "value":"1",
#                        "color":"#173177"
#                    },
#                    "keyword3": {
#                        "value":"mysql数据库服务异常",
#                        "color":"#173177"
#                    },
#                    "keyword4":{
#                        "value":"mysql.ping为0",
#                        "color":"#173177"
#                    },
#                    "keyword5":{
#                        "value":"mysql-master",
#                        "color":"#173177"
#                    }
#            }
#
# r=wx.send_template_msg('o0OtestfaPJ8D3kn7CatestqEoqU','9Br7-3WFw10pCRJEJHLF5ZBf4Z-zOVuLOJ4qRbSwwR8',data)
# print(r)