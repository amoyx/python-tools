# -*- coding:utf-8 -*-

from django.shortcuts import render, render_to_response,redirect
from django.http import HttpRequest, HttpResponse,HttpResponseRedirect
from websys.CommonLib import CommonLib
from models import opp_host
from django.views.decorators.csrf  import csrf_exempt,csrf_protect


@csrf_exempt
def add(request):
    if not request.user.is_authenticated():
        return HttpResponseRedirect(settings.LOGIN_URL)
    else:
        if request.method == 'POST':
            try:
                hostname = request.POST.get("hostname")
                ipaddr = request.POST.get("ipaddr")
                username = request.POST.get("username")
                password = request.POST.get("password")
                sshport = request.POST.get("sshport")
                remark = request.POST.get("remark")
            except:
                return HttpResponse("Error:数据输入有误！")
            if hostname and username and password and CommonLib.isValidIPAddr(ipaddr) and CommonLib.isValidHostPort(sshport):
                opp_host.objects.create(ipaddr=ipaddr,hostname=hostname,username=username,password=CommonLib.SetPasswdEncrypt(password),sshport=sshport,remark=remark)
                return HttpResponse("/host/list/")
            else:
                return HttpResponse("Error:请正确填写数据！")
        else:
            return render_to_response("engine/hostadd.html")

def list(request):
    if not request.user.is_authenticated():
        return HttpResponseRedirect(settings.LOGIN_URL)
    else:
        HostList = opp_host.objects.all().values_list("id","hostname","ipaddr","username",'sshport')
        return render_to_response("engine/hostlist.html",{'HostList':HostList})