#!/bin/bash
set -o nounset
set -x
# 是否开启 debug 模式，1：开启，0：关闭，开启后会把日志打印到控制台，并且输出 -x 信息。
readonly DEBUG=1

PROG_NAME=$0
ACTION=$1
BASEDIR=$(cd $(dirname $0) && pwd)/..

#可设置默认的 java
JAVA_HOME=
#"$JAVA_HOME/bin/java"
JAVA_CMD=
# 可以直接指定当前jar 的名称，而不采用查找的方式。
readonly APP_NAME=$(find "$BASEDIR/lib" -maxdepth 1 -name \*-starter-\*.jar | sed 's#.*/##' )
readonly APP_PORT=8080
readonly APP_HOME=${BASEDIR}/lib
#启动后创建的进程 id 所在的文件
readonly PID_FILE=${BASEDIR}/pid
# 应用启动超时时间，单位：秒
readonly APP_START_TIMEOUT=50
readonly HEALTH_CHECK_URL="http://localhost:${APP_PORT}/actuator/health"

cygwin=false;
darwin=false;
mingw=false
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  MINGW*) mingw=true;;
  Darwin*) darwin=true
    # Use /usr/libexec/java_home if available, otherwise fall back to /Library/Java/Home
    # See https://developer.apple.com/library/mac/qa/qa1170/_index.html
    if [ -z "$JAVA_HOME" ]; then
      if [ -x "/usr/libexec/java_home" ]; then
        export JAVA_HOME="`/usr/libexec/java_home`"
      else
        export JAVA_HOME="/Library/Java/Home"
      fi
    fi
    ;;
esac
if [ -z "$JAVA_HOME" ]; then
  javaExecutable="`which javac`"
  if [ -n "$javaExecutable" ] && ! [ "`expr \"$javaExecutable\" : '\([^ ]*\)'`" = "no" ]; then
    # readlink(1) is not available as standard on Solaris 10.
    readLink=`which readlink`
    if [ ! `expr "$readLink" : '\([^ ]*\)'` = "no" ]; then
      if $darwin ; then
        javaHome="`dirname \"$javaExecutable\"`"
        javaExecutable="`cd \"$javaHome\" && pwd -P`/javac"
      else
        javaExecutable="`readlink -f \"$javaExecutable\"`"
      fi
      javaHome="`dirname \"$javaExecutable\"`"
      javaHome=`expr "$javaHome" : '\(.*\)/bin'`
      JAVA_HOME="$javaHome"
      export JAVA_HOME
    fi
  fi
fi

if [ -z "$JAVA_CMD" ] ; then
  if [ -n "$JAVA_HOME"  ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
      # IBM's JDK on AIX uses strange locations for the executables
      JAVA_CMD="$JAVA_HOME/jre/sh/java"
    else
      JAVA_CMD="$JAVA_HOME/bin/java"
    fi
  else
    JAVA_CMD="`which java`"
  fi
fi

if [ ! -x "$JAVA_CMD" ] ; then
  echo "Error: JAVA_HOME is not defined correctly." >&2
  echo "  We cannot execute $JAVA_CMD" >&2
  exit 1
fi

function get_pid
{
    # TODO: more specific regexp
    pgrep -f "java .*$(get_starter_jar)"
}

function concat_lines() {
   if [ -f "$1" ]; then
        echo "$(tr -s '\n' ' ' < "$1")"
  fi
}


function health_check() {
    exptime=0
    echo "checking ${HEALTH_CHECK_URL}"
    while true
    do
        status_code=`/usr/bin/curl -L -o /dev/null --connect-timeout 5 -m 5 -s -w %{http_code}  ${HEALTH_CHECK_URL}`
        if [ x$status_code != x200 ];then
            sleep 1
            ((exptime++))
            echo -n -e "\rWait app to pass health check: $exptime..."
        else
            break
        fi
        if [ $exptime -gt ${APP_START_TIMEOUT} ]; then
            echo
            echo 'app start failed'
            exit 1
        fi
    done
    echo "check ${HEALTH_CHECK_URL} success"
}
#如果用户指定外部的配置文件则采用加载外部的配置文件，默认为 config, important 同名的配置文件会覆盖 application.properites 文件
function get_external_config(){
    local file_config="$BASEDIR/conf/config.properties"
    local file_important="$BASEDIR/conf/important.properties"
    local location_path=
    [[ -f "$file_config" ]] && {
        location_path="file:///${file_config}"
    }
    [[ -f "$file_important" ]] && {
        if [ -n "$location_path"  ] ; then
             location_path="${location_path},file:///${file_important}"
        else
             location_path="file:///${file_important}"
        fi
    }
    if [ -n "$location_path"  ] ; then
        echo "--spring.config.additional-location=$location_path"
    fi
}

#设置是否指定了外部的日志配置文件
function get_external_log(){
     local file_log="$BASEDIR/conf/log4j2.xml"
     [[ -f "$file_log" ]] && {
        echo "--logging.config=file:///${file_log}"
    }
}

function start_application() {

    local jar_name="${APP_NAME:?"未指定要启动的 jar 名称！" }"
    local java_ops="$(concat_lines "$BASEDIR/conf/jvm.conf")"
    local config_ops="$(get_external_config)"
    local log_ops="$(get_external_log)"

    echo "start jar --> ${jar_name}"
    if [ -f "$PID_FILE" ] && kill -0 "$(cat ${PID_FILE})"; then
        echo "Application is running, exit"
        exit 0
    fi

    [[ -x $JAVA_CMD ]] || {
        echo "ERROR: no executable java found at $JAVA_CMD" >&2
        exit 1
    }

    cd $BASEDIR
    nohup "$JAVA_CMD" -jar $java_ops \
         ${APP_HOME}/${jar_name}      \
         ${config_ops}  \
         ${log_ops} &
         # \> /dev/null 2>&1 &
    echo $! > ${PID_FILE}


}



function stop_application() {
    echo "stop jar"
    if [ -f "$PID_FILE" ]; then
        kill -9 `cat $PID_FILE`
        /bin/rm $PID_FILE
    else
        echo "pid file $PID_FILE does not exist, do noting"
    fi
}

usage() {
    echo "Usage: $PROG_NAME {start|stop|online|offline|restart}"
    exit 2
}

function start() {
    start_application
    health_check
}

function stop() {
    stop_application
}

case "$ACTION" in
    start)
        start
    ;;
    stop)
        stop
    ;;
    restart)
        stop
        start
    ;;
    *)
        usage
    ;;
esac