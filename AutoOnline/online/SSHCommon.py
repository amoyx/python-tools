# -*- coding:utf-8 -*-

import paramiko

class SSHConnect():
    def __init__(self,host, uname, passwd, port=22):
        self.host = host
        self.uname = uname
        self.passwd = passwd
        self.port = port
        self.code = self.code()
        self.client = self.conn()

    def conn(self):
        try:
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect(self.host,self.port,username=self.uname, password=self.passwd,timeout=4)
        except Exception as e:
            return False
        return client

    @staticmethod
    def code():
        StatusCode = {}
        StatusCode['500'] = "error: ssh client connection fail"
        StatusCode['404'] = "error: the command string is wrong"
        StatusCode['400'] = "error: the error"
        StatusCode['0']   = "error: the command string cannot be empty"
        return StatusCode

    def cmd(self, cmdline):
        if not self.client:
            return self.code["500"]
        if cmdline:
            stdin, stdout, stderr = self.client.exec_command(cmdline)
        else:
            return self.code["0"]
        msg = stderr.readlines()
        if msg or len(msg) > 0 :
            return self.code["404"]
        else:
            return stdout.readlines()

