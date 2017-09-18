# -*- coding: utf-8 -*-
from django.shortcuts import render, render_to_response,redirect
from django.http import HttpRequest, HttpResponse,HttpResponseRedirect
from django.contrib.auth import authenticate, login, logout
from django.template import RequestContext
from django.views.generic.base import TemplateView
from django.views.decorators.csrf  import csrf_exempt,csrf_protect
from django.contrib.auth.decorators import  login_required
from django.conf import settings
import websys.host

# Create your views here.

class LoginIndexView(TemplateView):
    template_name = 'accounts/index.html'

@csrf_exempt
def UserLogin(request):
    if request.method == 'POST':
        try:
            username = request.POST.get("username")
            password = request.POST.get("password")
        except:
            return HttpResponse("Error:用户和密码不能为空！")
        user = authenticate(username=username, password=password)
        if user and user.is_active:
            login(request, user)
            return HttpResponse("OK:登录成功!")
        else:
            return HttpResponse("Error:用户名或密码错误！")
    else:
        return HttpResponseRedirect(settings.LOGIN_URL)
        # return HttpResponse("Error:用户名和密码输入有误！")

def UserLogout(request):
    logout(request)
    return HttpResponseRedirect(settings.LOGIN_URL)

@csrf_exempt
def add(request):
    a = request.POST.get('username',"11")
    b = request.POST.get('password',"ss")
    return HttpResponse(str(a) + str(b))

@login_required
def sys_main(request):
    if not request.user.is_authenticated():
        return HttpResponseRedirect(settings.LOGIN_URL)
    else:
        return render_to_response("engine/index.html")




