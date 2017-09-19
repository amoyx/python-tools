# -*- coding:utf-8 -*-
import os,sys,platform,time
import requests
import datetime
from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.acs_exception.exceptions import ClientException
from aliyunsdkcore.acs_exception.exceptions import ServerException
from aliyunsdkecs.request.v20140526 import DescribeInstancesRequest
from aliyunsdkrds.request.v20140815 import CreateDBInstanceRequest
from aliyunsdkecs.request.v20140526 import StopInstanceRequest
from aliyunsdkrds.request.v20140815 import DescribeDBInstancesRequest

def bubble(numbers):
    for i in range(len(numbers)):
        print("i=[" + str(i) + "] " + str(numbers[i]))
        for j in range(i):
            print("j=[" + str(j) + "] " + str(numbers[j]) )
            if numbers[j] < numbers[i]:
                numbers[j], numbers[i] = numbers[i], numbers[j]
    return numbers
            # print(str(array[j]) +  "   " + str(array[j+1]))
