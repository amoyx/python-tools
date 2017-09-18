# -*- coding:utf-8 -*-

import re
import hashlib
import time

class CommonLib:

    # 验证IP地址是否有效
    @staticmethod
    def isValidIPAddr(ip):
        return re.match(r'\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',ip,re.IGNORECASE)
        # reg = re.compile("^((?:(2[0-4]\d)|(25[0-5])|([01]?\d\d?))\.){3}(?:(2[0-4]\d)|(255[0-5])|([01]?\d\d?))$")
        # result = re.findall(reg,ip)
        # if result:
        #     return True
        # else:
        #     return False

    # 验证主机端口是否有效
    @staticmethod
    def isValidHostPort(port):
        result = re.match(r"^(\d{1,5})$",port)
        return True if result and int(port) > 0 and int(port) < 65535 else False
        #     return port
        # else:
        #     return False

        # return port if result and (port > 0 and port < 65535) else False
        #     return result
        # else:
        #     return False

    #生成随机md5密钥
    @staticmethod
    def CreateRandomMd5():
        m = hashlib.md5()
        m.update(bytes(str(time.time())).encode(encoding='utf-8'))
        return m.hexdigest()

    #加密密码
    @staticmethod
    def SetPasswdEncrypt(pwd):
        md5 = CommonLib.CreateRandomMd5()
        if len(pwd) == 1:
            return md5[0:6] + pwd + md5[7:13]
        elif len(pwd) == 2:
            return md5[0:6] + pwd[0] + md5[7:13] + pwd[1]
        else:
            return pwd[0] + md5[0:6] + pwd[1] + md5[7:13] + pwd[2:]

    #获取加密的密码
    @staticmethod
    def GetPasswdEncrypt(pwd):
        if len(pwd) == 13:
            return pwd[6:7]
        if len(pwd) == 14:
            return pwd[6:7] + pwd[13:14]
        if len(pwd) >= 15:
            return pwd[0] + pwd[7] + pwd [14:]
