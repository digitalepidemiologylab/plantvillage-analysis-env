#!/bin/bash
echo "Setting up digits..."

CAFFE_HOME=$(eval echo ~$1)/caffe

mkdir -p /plantvillage/digits
cd /plantvillage/digits
if [ ! -d /plantvillage/digits/.git ]; then
   echo "Cloning digits repo..."
   git clone https://github.com/NVIDIA/digits /plantvillage/digits
   git checkout tags/v3.0.0-rc.3 -b v3.0.0-rc.3

   # Quick hack to fix issue with WTF forms
   # TO-DO : Fix this (probably reference by correct version numbers)
   sed -i 's/DataRequired/Required/' /plantvillage/digits/digits/dataset/forms.py
   sed -i 's/DataRequired/Required/' /plantvillage/digits/digits/dataset/images/forms.py
   sed -i 's/DataRequired/Required/' /plantvillage/digits/digits/model/forms.py

   echo "Installing digits requirements..."
   pip install -r requirements.txt
else
   echo "digits repo already exists!"
fi

if [ ! -f /plantvillage/digits/digits/digits.cfg ]; then
    echo "Preparing digits config..."
    cat <<EOF | tee /plantvillage/digits/digits/digits.cfg
[DIGITS]
jobs_dir = /plantvillage/digits/digits/jobs
log_file = /plantvillage/digits/digits/digits.log
caffe_root = ${CAFFE_HOME}
torch_root =
EOF
else
    echo "Config file for digits already exists!"
fi

chown -R $1 /plantvillage/

if [ ! -f /etc/init.d/digits ]; then
    echo "Preparing digits minimal init file....."
    cat <<'EOF' | tee /etc/init.d/digits
#!/bin/sh
### BEGIN INIT INFO
# Provides:          digits
# Required-Start:    $local_fs $remote_fs $network
# Required-Stop:     $local_fs $remote_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: nVidia
# Description:       MiniMappings
### END INIT INFO


# Documentation available at
# http://refspecs.linuxfoundation.org/LSB_3.1.0/LSB-Core-generic/LSB-Core-generic/iniscrptfunc.html
# Debian provides some extra functions though
. /lib/lsb/init-functions


DAEMON_NAME="digits"
DAEMON_USER=""
DAEMON_PATH="/plantvillage/digits/digits-devserver"
DAEMON_OPTS=""
DAEMON_PWD="/plantvillage/digits/"
DAEMON_DESC=$(get_lsb_header_val $0 "Short-Description")
DAEMON_PID="/var/run/${DAEMON_NAME}/${DAEMON_NAME}.pid"
DAEMON_NICE=0
DAEMON_LOG="/var/log/${DAEMON_NAME}/${DAEMON_NAME}.log"

[ -r "/etc/default/${DAEMON_NAME}" ] && . "/etc/default/${DAEMON_NAME}"

do_start() {
  local result

        pidofproc -p "${DAEMON_PID}" "${DAEMON_PATH}" > /dev/null
        if [ $? -eq 0 ]; then
                log_warning_msg "${DAEMON_NAME} is already started"
                result=0
        else
                log_daemon_msg "Starting ${DAEMON_DESC}" "${DAEMON_NAME}"
                while ! test -f ${DAEMON_PATH}
                do
                   sleep 1
                done
                if [ -z "${DAEMON_USER}" ]; then
                        start-stop-daemon --start --quiet --oknodo --background \
                                --nicelevel $DAEMON_NICE \
                                --chdir "${DAEMON_PWD}" \
                                --pidfile "${DAEMON_PID}" --make-pidfile \
                                --exec "${DAEMON_PATH}" -- $DAEMON_OPTS
                        result=$?
                else
                        mkdir -p /var/run/${DAEMON_NAME} /var/log/${DAEMON_NAME}
                        touch "${DAEMON_LOG}"
                        chown -R $DAEMON_USER /var/run/${DAEMON_NAME} /var/log/${DAEMON_NAME}
                        start-stop-daemon --start --quiet --oknodo --background \
                                --nicelevel $DAEMON_NICE \
                                --chdir "${DAEMON_PWD}" \
                                --pidfile "${DAEMON_PID}" --make-pidfile \
                                --chuid "${DAEMON_USER}" \
                                --exec "${DAEMON_PATH}" -- $DAEMON_OPTS
                        result=$?
                fi
                log_end_msg $result
        fi
        return $result
}

do_stop() {
        local result

        pidofproc -p "${DAEMON_PID}" "${DAEMON_PATH}" > /dev/null
        if [ $? -ne 0 ]; then
                log_warning_msg "${DAEMON_NAME} is not started"
                result=0
        else
                log_daemon_msg "Stopping ${DAEMON_DESC}" "${DAEMON_NAME}"
                killproc -p "${DAEMON_PID}" "${DAEMON_PATH}"
                result=$?
                log_end_msg $result
                rm -f "${DAEMON_PID}"
        fi
        return $result
}

do_restart() {
        local result
        do_stop
        result=$?
        if [ $result = 0 ]; then
                do_start
                result=$?
        fi
        return $result
}

do_status() {
        local result
        status_of_proc -p "${DAEMON_PID}" "${DAEMON_PATH}" "${DAEMON_NAME}"
        result=$?
        return $result
}

do_usage() {
        echo $"Usage: $0 {start | stop | restart | status}"
        exit 1
}

case "$1" in
start)   do_start;   exit $? ;;
stop)    do_stop;    exit $? ;;
restart) do_restart; exit $? ;;
status)  do_status;  exit $? ;;
*)       do_usage;   exit  1 ;;
esac
EOF
    sed -i "s/DAEMON_USER=\"\"/DAEMON_USER=\"$1\"/" /etc/init.d/digits
    chmod a+x /etc/init.d/digits
    echo "Setting digits to run on boot....."
    # Using 99 because we want /plantvillage to be mounted first
    update-rc.d digits defaults 99
else
    echo "Init file for digits already exists!"
fi

service digits start
