# -*- coding: utf-8 -*-
"""opp URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.9/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url
from django.conf.urls.static import static
from django.conf import settings
from django.contrib import admin
from websys.views import LoginIndexView
from django.contrib.staticfiles.urls import staticfiles_urlpatterns


urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^$', LoginIndexView.as_view()),
    url(r'^add/$','websys.views.add',name='add'),
    url(r'^login/index/$',LoginIndexView.as_view()),
    url(r'^user/login/$','websys.views.UserLogin',name='login'),
    url(r'^user/logout/$','websys.views.UserLogout',name='logout'),
    url(r'^sys/main/$','websys.views.sys_main', name='sysmain'),
    url(r'^host/add/$','websys.host.add',name='hostadd'),
    url(r'^host/list/$','websys.host.list',name='hostlist'),
    url(r'^static/(?P<path>.*)$','django.views.static.serve',{'document_root':settings.STATIC_PATH}),
]

urlpatterns += staticfiles_urlpatterns()

# + static(settings.STATIC_URL, documet_root=settings.STATIC_ROOT)
