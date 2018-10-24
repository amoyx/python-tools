#! usr/bin/python
# coding=utf-8

import dockerrun
import json
from django.http import HttpResponse
from aliyunapp import Cluster
from online.common import CommonLib
import logging
from django.shortcuts import render_to_response
import time

logger = logging.getLogger(__name__)
common = CommonLib


def test(request):
    # list_val = [123, 456, 789, 234, 12234, 21312124,1,2,345]
    # temp = list_val[0]
    # r = True
    # while r:
    #     if len(list_val) == 1:
    #         break
    #     for li in list_val:
    #         if li < temp:
    #             list_val.remove(li)
    #         else:
    #             temp = li
    # res = list_val[0]
    now = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    return render_to_response('current_datetime.html', {'current_date': now})


def container_update(request):
    try:
        project_name = request.GET.get("projectName")
        environ = request.GET.get("environ")
    except Exception as e:
        return HttpResponse(str(e))
    if not project_name:
        return HttpResponse("project name can't be empty")
    if not environ:
        return HttpResponse("environ variable can't be empty")
    version = dockerrun.push_img(project_name, environ)
    if not version or "error:" in version:
        return HttpResponse("docker镜像push错误!!  " + version)
    if project_name == "wykjt":
        data = dockerrun.import_sql_to_db(project_name, environ)
    else:
        data = {}
        data["last_msg"] = "normal: 该项目不需要更新数据库"
    if data.has_key('last_msg'):
        if "error:" in str(data["last_msg"]):
            return render_to_response("container.html", {"context": data, "result": "容器更新失败"})
    c = Cluster(project_name, environ, str(version))
    res = c.update()
    if not "error:" in res:
        response = "version: " + str(version) + ", project: " + str(project_name) + ", environ: " + \
                           str(environ) + " update succeed" + str(res)
    else:
        response = " update fail: " + str(res)
    return render_to_response("container.html", {"context": data, "result": response})


def container_rollback(request):
    project_name = request.GET.get("projectName")
    environ = request.GET.get("environ")
    if project_name.strip() == "":
        return HttpResponse(json.dumps("project name can't be empty"), content_type="application/json")
    if environ.strip() == "":
        return HttpResponse(json.dumps("environ variable can't be empty"), content_type="application/json")
    if project_name.strip():
        try:
            c = Cluster(project_name, environ, "1.0.1")
            res = c.rollback()
            if res:
                response = "project: " + str(project_name) + ", environ: " + \
                           str(environ) + " update succeed" + str(res) + ",rollback succeed"
            else:
                response = "project: " + str(project_name) + ", environ: " + \
                           str(environ) + " update fail" + str(res) + ", rollback fail"
            return HttpResponse(response, content_type="application/json")
        except Exception as e:
            return HttpResponse(json.dumps({'status': 'Fail', 'error msg': str(e)}), content_type="application/json")
    else:
        return HttpResponse(json.dumps("project name cant be empty"), content_type="application/json")


