#!/usr/bin/python
# _*_ coding:utf-8 _*_

from .chatbot import DingtalkChatbot
from django.http import HttpResponse
from . import settings
from .sms import ShortMessage
from .email import SMTPMail


def index(request):
    return HttpResponse("Hello world!")

def auth(request):
    return HttpResponse("OK")

# 发送测试钉钉信息
def test_send_ding(request):
    xiaoding = DingtalkChatbot(settings.DINGTALK_HOOK_TEST)
    try:
        content = request.POST['content']
        ding_number = str(request.POST['tos']).split(',')
        xiaoding.send_text(msg=content,at_mobiles=ding_number)
    except:
        raise Exception("Error: 数据格式有误！")
    else:
        return HttpResponse("success")

# 基于手机短信发送信息
def send_sms(request):
    sms = ShortMessage()
    try:
        content = request.POST['content']
        mobile = request.POST['tos']
        sms.send(mobile,content)
    except:
        raise Exception("Error: 短信发送失败")
    else:
        return HttpResponse("success")

# 基于dingding发送信息
def send_dingtalk(request):
    xiaoding = DingtalkChatbot(settings.DINGTALK_HOOK)
    try:
        content = request.POST['content']
        ding_number = str(request.POST['tos']).split(',')
        xiaoding.send_text(msg=content,at_mobiles=ding_number)
    except:
        raise Exception("Error: 数据格式有误！")
    else:
        return HttpResponse("success")

# 基于邮件发送信息
def send_mail(request):
    try:
        content = request.POST['content']
        user_list = str(request.POST['tos']).split(',')
        subject = request.POST['subject']
        m = SMTPMail(user_list,subject,content)
        m.send_html()
    except:
        raise Exception("Error: 邮件发送失败！")
    else:
        return HttpResponse("success")

# 分类报警
def send_alarm_msg(request):
    try:
        query_dict = request.POST
        if query_dict.__contains__('subject'):
            send_mail(request)
        else:
            pass
    except:
        return HttpResponse("Error: 信息发送失败！")
    else:
        return HttpResponse("success")
