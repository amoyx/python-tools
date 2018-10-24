#!/usr/bin/env bash
function help_info()
{
    echo ""
    echo "docker builder $VERSION"
    echo "Usage:"
    echo "  bash tools/docker/build.sh <env name> [-t tagname] [-b] [-r] [-p]"
    echo "  -b build project"
    echo "  -r run container"
    echo "  -t assign tag name"
    echo "  -p push prod image"

}
function version_info()
{
    echo "docker builder $VERSION"
}

function load_conf()
{
    CONFPATH=$SCRIPTFOLDER/conf.sh
    if [ -f "$CONFPATH" ]
    then
        source $CONFPATH
        echo "load conf file $CONFPATH"
        # check build type
        if [ "$BUILDTYPE" == "php" ]
        then
            CONTAINERPORT=80
            echo "build type is '$BUILDTYPE', container web port $CONTAINERPORT"
        elif  [ "$BUILDTYPE" == "tomcat" ]
        then
            CONTAINERPORT=8080
            echo "build type is '$BUILDTYPE', container web port $CONTAINERPORT"
		elif  [ "$BUILDTYPE" == "django" ]
		then
		    CONTAINERPORT=8000
			echo "build type is '$BUILDTYPE', container web port $CONTAINERPORT"
        else
            echo "ERR: this tool not support '$BUILDTYPE' project, just support 'php' and 'tomcat' projcect, "
            echo "     please change BUILDTYPE in $CONFPATH to 'php' or 'tomcat'"
            exit 1
        fi
    else
      echo "ERR: conf file load fail, $CONFPATH not exist"
      exit 1
    fi
}

function build_project()
{
    if [ -f $DOCKERFILEPATH ]
    then
        echo "build images"
        {
            if [ -z $VTAG ]
            then
                VTAG=`date +"%Y%m%d%H%M%S"`
            fi
            CONTAINERNAME=$PROJECTNAME$VTAG
            IMAGENAME=$DOCKERSERVER/${ENVTYPE}-${PROJECTNAME}:$VTAG
            if [ "$BUILDTYPE" == "tomcat" ]
            then
              mvn clean package -Dmaven.test.skip=true
            fi
            echo $VTAG
            echo $IMAGENAME
            docker build -t $IMAGENAME ./
            if [ "$T_PUSH" == "true" ]
            then
                PRODIMAGENAME=$DOCKERSERVER/prod/$PROJECTNAME:$VTAG
                docker tag $IMAGENAME $PRODIMAGENAME
                docker push $PRODIMAGENAME
            fi
            SUC='suc'
        } || {
            echo ""
            echo ""
            echo ""
            echo ""
            echo '----------------------'
            echo '|    build fail      |'
            echo '----------------------'
            echo ""
            echo ""
            echo ""
            echo ""
        }
    else
        echo "ERR: Dockerfile not exist"
    fi
}

function run_project()
{
    if [ "$SUC" == "suc" ]
    then
    {
        echo "run container"
        # if has old docker container tag, stop and rm old container, remove old image
        OLDCONTAINERID=`docker ps -a -q -f "name=$PROJECTNAME.*"`
        OLDIMAGENAME=`docker ps -a -f "name=$PROJECTNAME.*" |awk 'NR==2{print $2}'`

        if [ ! -z "$OLDCONTAINERID" ]
        then
            docker stop $OLDCONTAINERID
            echo " -- stop old container"
        fi
        docker run -d --name $CONTAINERNAME -p $CPORT:$CONTAINERPORT --restart=always -e "ENVTYPE=$ENVTYPE" -e "ENVNAME=$ENVNAME" $IMAGENAME
        echo " -- run container $IMAGENAME with $ENVTYPE settings in port $CPORT"
        echo " -- you can run docker container with your pars, Reference README.MD"
        echo " -- image name : $IMAGENAME "
        echo " -- you can access it with http://<server ip>:$CPORT/"
        echo " -- you can entry container with command : docker exec -it $CONTAINERNAME bash"
        if [ ! -z "$OLDCONTAINERID" ]
        then
            docker rm $OLDCONTAINERID
            echo " -- remove old container"
            docker rmi $OLDIMAGENAME
            echo " -- remove old image $OLDIMAGENAME"
        fi
        } || {
            echo ""
            echo ""
            echo ""
            echo ""
            echo '----------------------'
            echo '|    run fail        |'
            echo '----------------------'
            echo ""
            echo ""
            echo ""
            echo ""
    }
    fi
}
