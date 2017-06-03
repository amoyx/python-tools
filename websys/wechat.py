# -*- coding: utf-8 -*-
from django.test import TestCase
import os
import urllib.request,urllib.parse,json
from urllib.error import URLError,HTTPError
import requests
# Create your tests here.


class WeiXin:
    def __init__(self,appid,secret):
        self.appid = appid
        self.secret = secret

    # 生成token
    def get_token(self):
        appid= self.appid
        secret= self.secret
        if appid=="":
            return "appid不能为空"
        if secret=="":
            return "secret不能为空"
        url="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%s&secret=%s" % (appid,secret)
        html=urllib.request.urlopen(url)
        req=json.loads(html.read().decode())
        return req.get('access_token')

    # 获取用户列表
    def get_user_list(self, nextid=""):
        token = self.get_token()
        url="https://api.weixin.qq.com/cgi-bin/user/get?access_token=%s" % (token)
        html=urllib.request.urlopen(url)
        req=json.loads(html.read().decode())
        return req.get('data').get('openid')

    # 获取用户的openid等信息
    def get_user_info(self, nickname="abcde"):
        userlist=self.get_user_list()
        token = self.get_token()
        i=0
        for i in range(len(userlist)):
            url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=%s&openid=%s&lang=zh_CN" % (token,userlist[i])
            html=urllib.request.urlopen(url)
            req=json.loads(html.read().decode())
            if req.get('nickname') == nickname :
                return req
            else:
                continue

    # 获取客服列表
    def get_kf_list(self):
        token = self.get_token()
        url = 'https://api.weixin.qq.com/cgi-bin/customservice/getkflist?access_token=%s'% (token)
        html=urllib.request.urlopen(url)
        req=json.loads(html.read().decode())
        return req

    # 发送信息
    def send_msg(self,openid='o0OBJuFfaPJ8D3kn7CaGU8eqEoqU',msg='hello world'):
        token=self.get_token()
        data={
            "touser":"oMBJEwO5fGCkuptJTI6YJhEVWmVs",
            "msgtype":"text",
            "text":
                {
                    "content":msg
                },
                "customservice":
                {
                        "kf_account": "001@jimimall"
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
        page = page.decode('utf-8')
        #html=urllib.request.urlopen(url,data=data)
        return page

    # 发送模板信息
    def send_template_msg(self):
        token = self.get_token()
        url = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=%s"  % (token)
        touser = "oMBJEwO5fGCkuptJTI6YJhEVWmVs"
        template_id = "ZaTIV7Bx4xjeMrc2BqoO7C75KsvKr_i9lG2wwajQmc4"
        data={"first":{"value":"欢迎关注本公众号"},"keyword1":{"value":"你是本公众号的123位粉丝","color":"#173177"},"remark":{"value":"记得及时关注本号公告","color":"#173177"}}
        dict_arr = {"touser":touser,"template_id":template_id,"url":"","data":data}
        # json_template = json.dumps(dict_arr)
        json_template = urllib.parse.urlencode(dict_arr).encode(encoding='UTF8')
        # content = self.post_data(url, json_template)
        # j = json.loads(content)

        headers = {
             'User-Agent': r'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) ',
                             # r'Chrome/45.0.2454.85 Safari/537.36 115Browser/6.0.3',
            "Content-type":"application/json",
            'Referer': r'https://mp.weixin.qq.com/cgi-bin/singlesendpage',
            'Connection': 'keep-alive'
        }
        # req = urllib.request.Request(url,headers=headers,data=json_template)
        page = urllib.request.urlopen(url,json_template)
        j = json.loads(str(page))
        # page = page.decode('utf-8')
        return j

    # 获取信息模板编号
    def get_msg_template(self):
        token = self.get_token()
        url="https://api.weixin.qq.com/cgi-bin/template/get_all_private_template?access_token=%s" % (token)
        html=urllib.request.urlopen(url)
        req=json.loads(html.read().decode())
        return req

    def do_push_template_msg(self):
        token = self.get_token()
        url = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token="+token
        data =  {"touser":"oMBJEwO5fGCkuptJTI6YJhEVWmVs","template_id":"C4NHQw9LswrdW2LbEzCwxWYYGwf-NlUbOlSd2SJn310",
            # "url":"http://weixin.qq.com/download",
            # "topcolor":"#FF0000",
            "data":{
                    "User": {
                        "value":"黄先生",
                        "color":"#173177"
                    },
                    "Left":{
                        "value":"6504.09",
                        "color":"#173177"
                    }
            }
        }
        return self.post_data(url, data)

    def post_data(self,url,data):
        data = json.dumps(data)
        res = requests.post(url=url, data=data)
        return res
