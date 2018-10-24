FROM registry.aliyuncs.com/kolbuy/django:1.0.3


COPY conf  conf
COPY online online
COPY manage.py  manage.py
COPY tools/docker/init  init
ADD  dbpatch dbpatch
ADD  templates templates


RUN chmod -R  +x  init

CMD ["/usr/bin/bash", "entrypoint.sh"]
