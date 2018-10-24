FROM centos:7

ENV APP_HOME /opt/webroot
ENV PYTHON_HOME  /usr/local/python
ENV PATH $PYTHON_HOME/bin:$PATH
ENV LANG zh_CN.UTF-8

RUN /bin/mkdir -p $PYTHON_HOME && /bin/mkdir -p $APP_HOME 
WORKDIR $APP_HOME

ENV PYTHON_TAR_URL https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tar.xz

RUN yum install sshpass gcc zlib openssl-devel openssl zlib-devel sqlite-devel -y

RUN cd /tmp \
    && curl -o python.tar.xz $PYTHON_TAR_URL \
    && unxz python.tar.xz \
    && tar -xvf python.tar --strip-components=1 \
    && ./configure --prefix=$PYTHON_HOME \
    && make \
    && make install \
    && ln -s $PYTHON_HOME/bin/python3 /usr/bin/python3 \
    && rm -rf python.tar \
    && rm -rf /tmp/*

COPY req.txt req.txt
RUN  cd $APP_HOME \
     && pip3 --trusted-host pypi.tuna.tsinghua.edu.cn install -r req.txt

ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

ADD  entrypoint.sh /entrypoint.sh

RUN  chmod +x /entrypoint.sh

COPY webroot $APP_HOME

EXPOSE 8000

CMD ["/bin/sh", "/entrypoint.sh"]
