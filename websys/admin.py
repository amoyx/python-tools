# -*- coding: utf-8 -*-
from django.contrib import admin,auth
from django.http import HttpResponse

# Register your models here.


class UserManager():
    def __init__(self,user,password):
        self.user = user
        self.passwd = password
