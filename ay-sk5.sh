#!/bin/bash

### BEGIN INIT INFO
# Provides:          Brook-pf
# Required-Start:    $network $local_fs $remote_fs
# Required-Stop:     $network $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Lightweight port forwarding tool
# Description:       Start or stop the Brook-pf
### END INIT INFO

NAME="ay-sk5"
NAME_BIN="sk5"
FILE="/usr/local/ay-sk5"
CONF="${FILE}/ay-sk5.conf"
LOG="${FILE}/ay-sk5.log"

do_start(){
    if [ ! -f "${CONF}" ]; then
        echo "配置文件不存在，请检查！"
        exit 1
    fi

	while read -r line
    do
        eval nohup "$FILE/ay-sk5" "$line" >> "${LOG}" 2>&1 &
    done < "${CONF}"
    echo "${NAME} 已启动。"
}

do_stop(){
    pkill -f ay-sk5
    echo "${NAME} 已停止。"
}

do_status(){
    if pgrep -f ay-sk5 > /dev/null; then
        echo "${NAME} 正在运行。"
    else
        echo "${NAME} 已停止。"
    fi
}

do_restart(){
    do_stop
    sleep 2
    do_start
    echo "${NAME} 已重启。"
}

case "$1" in
    start|stop|restart|status)
        do_$1
        ;;
    *)
        echo -e "使用方法: $0 { start | stop | restart | status }"
        RETVAL=1
        ;;
esac
exit $RETVAL
