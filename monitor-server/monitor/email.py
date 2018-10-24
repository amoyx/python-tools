#!/usr/bin/python3
# _*_ coding:utf-8 _*_

import smtplib
import os
from email.mime.text import MIMEText
from email.header import Header
from email.mime.multipart import MIMEMultipart
from . import settings


class SMTPMail(object):

    def __init__(self, receivers, subject, message):
        self.mail_host = settings.MAIL_HOST
        self.mail_user = settings.MAIL_USER
        self.mail_pass = settings.MAIL_PASSWD
        self.mail_sender = settings.MAIL_SENDER
        self.receivers = receivers
        self.subject = subject
        self.message = message

    # 普通文本格式
    def mime_text_object(self,mimetype):
        message = MIMEText(self.message,str(mimetype), 'utf-8')
        message['From'] = Header("金互行警报提示", 'utf-8')
        message['To'] = Header(';'.join(self.receivers), 'utf-8')
        message['Subject'] = Header(self.subject, 'utf-8')
        return self.send(message)

    # 带附件的邮件格式
    def mime_multiline_object(self,filelist):
        message=MIMEMultipart()
        message['From'] = Header("金互行警报提示", 'utf-8')
        message['To'] = Header(';'.join(self.receivers), 'utf-8')
        message['Subject'] = Header(self.subject, 'utf-8')
        message.attach(MIMEText(self.message,'plain','utf-8'))

        try:
            for filename in filelist:
                att1 =MIMEText(open(filename,'rb').read(),'base64','utf-8')
                att1["Content-Type"] = 'application/octet-stream'
                att1["Content-Disposition"] = 'attachment; filename=' + os.path.basename(filename)
                message.attach(att1)
            self.send(message)
        except:
            return "Error: 邮件发送失败"
        else:
            return "success"

    def send(self,message):
        try:
            mail_host_and_port = self.mail_host.split(':')
            host = mail_host_and_port[0]
            port = int(mail_host_and_port[1]) if len(mail_host_and_port) >= 2 else 25
            smtpObj = smtplib.SMTP()
            smtpObj.connect(host, port)
            smtpObj.login(self.mail_user, self.mail_pass)
            smtpObj.sendmail(self.mail_sender, self.receivers, message.as_string())
        except smtplib.SMTPException as e:
            return "Error: 邮件发送失败 -- " + str(e)
        else:
            return "success"

    # 发送文本格式的邮件
    def send_text(self):
        return self.mime_text_object('plain')

    # 发送html格式的邮件
    def send_html(self):
        return self.mime_text_object('html')

    # 发送带附件的邮件
    def send_attachment(self,filelist):
        return self.mime_multiline_object(filelist)
