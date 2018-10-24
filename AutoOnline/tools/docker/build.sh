#!/bin/bash
SCRIPTFOLDER=$(cd `dirname $0`; pwd)
LIBFILEPATH=$SCRIPTFOLDER/lib.sh
DOCKERFILEPATH=$SCRIPTFOLDER/../../Dockerfile
#secho `ls -al $DOCKERFILEPATH`
source $LIBFILEPATH
VERSION="1.1.0"

# init vars
CPORT=$RANDOM
DOCKERSERVER="registry.aliyuncs.com/kolbuy"
# tag will create by time stamp if no -i parma
VTAG=""
T_BUILD=""
T_RUN=""
T_PUSH=""
IMAGENAME=""


if [ $# -gt 1 ]; then
    if [ "$1" = "-v" ]
    then
        version_info
    else
        ENVNAME=$1
        if [ ${ENVNAME:0:7} = "staging" ]
        then
            ENVTYPE="staging"
        elif [ ${ENVNAME:0:4} = "prod" ]
        then
            ENVTYPE="prod"
        else
            ENVTYPE="dev"
        fi

        shift 1
        while getopts t:rbp option
        do
            case "$option" in
                b)
                    T_BUILD="true";;
                r)
                    T_BUILD="true"
                    T_RUN="true";;
                p)
                    T_PUSH="true";;
                t)
                    VTAG=$OPTARG;;
                \?)
                    help_info
                    exit 1;;
            esac
        done
        load_conf
        if [ "$T_BUILD" == "true" ]
        then
            build_project
        fi
        if [ "$T_RUN" == "true" ]
        then
            run_project
        fi
    fi
else
    help_info
fi

