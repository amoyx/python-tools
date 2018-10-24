from fabric.api import *
from docker import Client
import os
import sys
import paramiko
import random
import requests
import json
# Create your tests here.


def ListSort(list1=[], m="min"):
    if not list1 or not isinstance(list1, list):
        return False
    for i in range(0,len(list1)):
        for j in range(0, i):
            if m == "max":
                if int(list1[i]) > int(list1[j]):
                    list1[i],list1[j] = list1[j],list1[i]
            else:
                if int(list1[i]) < int(list1[j]):
                    list1[i],list1[j] = list1[j],list1[i]
    return list1
