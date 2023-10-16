#!/bin/bash

### BEGIN INIT INFO
# Provides:          Dante SOCKS5 Proxy
# Required-Start:    $network $local_fs $remote_fs
# Required-Stop:     $network $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Dante SOCKS5 Proxy
# Description:       Start or stop the Dante SOCKS5 Proxy
### END INIT INFO

NAME="ay-sk5"
DAEMON="/usr/sbin/sockd"
CONF="/etc/danted.conf"
PIDFILE="/var/run/$NAME.pid"
LOGFILE="/var/log/socks.log"

[ -x $DAEMON ] || exit 0

do_start(){
    if [ ! -f $CONF ]; then
        echo "Configuration file does not exist, please check!"
        exit 1
    fi
    start-stop-daemon --start --quiet --pidfile $PIDFILE --exec $DAEMON -- -D
    echo "$NAME started."
}

do_stop(){
    start-stop-daemon --stop --quiet --pidfile $PIDFILE
    echo "$NAME stopped."
}

do_status(){
    start-stop-daemon --status --quiet --pidfile $PIDFILE
    case "$?" in
        0) echo "$NAME is running." ;;
        1) echo "$NAME is not running and the pid file exists." ;;
        3) echo "$NAME is not running." ;;
        4) echo "Unable to determine the status of $NAME." ;;
    esac
}

do_restart(){
    do_stop
    sleep 2
    do_start
    echo "$NAME restarted."
}

case "$1" in
    start|stop|restart|status)
        do_$1
        ;;
    *)
        echo "Usage: $0 { start | stop | restart | status }"
        exit 1
        ;;
esac
