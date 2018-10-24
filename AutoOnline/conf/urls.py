from django.conf.urls import patterns, include, url
from django.contrib import admin
import online
admin.autodiscover()

urlpatterns = patterns('',
                       # Examples:
                       # url(r'^$', 'dproject.views.home', name='home'),
                       # url(r'^blog/', include('blog.urls')),
                       url(r'^admin/', include(admin.site.urls)),
                       url(r'^test', 'online.views.test'),
                       url(r'^container/update', 'online.views.container_update'),
                       url(r'^container/rollback', 'online.views.container_rollback'),
                       )
