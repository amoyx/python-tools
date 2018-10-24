#!/usr/bin/env bash
CONFIGFILE='conf/local_settings.py'


if [ "$ENVNAME" = "staging" ]
then
DBHOST="10.117.205.107"
DBPORT=3306
DBUSER='django'
DBPASS="43xPTE4v4XG8hkpJ"
DBNAME='operations'
elif [ "$ENVNAME" = "dev" ]
then
DBHOST="10.3.192.155"
DBPORT=3306
DBUSER='op'
DBPASS="Aa123456"
DBNAME='operations'
elif [ "$ENVNAME" = "prod" ]
then
DBHOST="10.117.205.107"
DBPORT=3306
DBUSER='django'
DBPASS="43xPTE4v4XG8hkpJ"
DBNAME='operations'
fi


# must be '>' in first, or the container will 500 error
echo "DATABASES = {" > $CONFIGFILE
echo "    'default': {" >> $CONFIGFILE
echo "        'ENGINE': 'django.db.backends.mysql'," >> $CONFIGFILE

if [ ! -z $DBNAME ];then
    echo  "        'NAME': '$DBNAME'," >> $CONFIGFILE
fi

if [ ! -z $DBUSER ];then
    echo   "        'USER': '$DBUSER'," >> $CONFIGFILE
fi

if [ ! -z $DBPASS ];then
     echo  "        'PASSWORD': '$DBPASS'," >> $CONFIGFILE
fi

if [ ! -z $DBHOST ];then
    echo   "        'HOST': '$DBHOST'," >> $CONFIGFILE
fi

if [ ! -z $DBPORT ];then
   echo   "        'PORT': '$DBPORT'," >> $CONFIGFILE
fi

echo  "    }" >> $CONFIGFILE
echo  "}" >> $CONFIGFILE

