#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 START|STOP|STATUS"
  exit 1
fi

MONITOR_PID_FILE="/tmp/disk_monitoring.pid"
LOG_DIR="/var/log/disk_monitoring"
[ ! -d "$LOG_DIR" ] && mkdir -p "$LOG_DIR"
CURRENT_DATE=$(date +%Y-%m-%d)
LOG_FILE="${LOG_DIR}/disk_usage_${CURRENT_DATE}.csv"

is_running() {
  if [ -f "$MONITOR_PID_FILE" ]; then
    local pid
    pid=$(cat "$MONITOR_PID_FILE")
    if ps -p "$pid" >/dev/null 2>&1; then
      return 0
    fi
  fi
  return 1
}

start_monitoring() {
  if [ ! -f "$LOG_FILE" ]; then
    echo "Date,Time,Free Space (GB),Used Space (GB),Total Space (GB),Free Inodes,Used Inodes,Total Inodes" >"$LOG_FILE"
  fi

  nohup bash -c "while true; do
    CURRENT_TIME=\$(date +%H:%M:%S)
    
    df -h --output=avail,size,used,target | tail -n +2 | sed 's/ \+/ /g' | \
    awk -v date=\$CURRENT_DATE -v time=\$CURRENT_TIME '{printf \"%s,%s,%.2f,%.2f,%.2f,%d,%d,%d\
\", date, time, \$3/1024, \$2/1024, \$2/1024, \$(stat -f -c '%i' \$4), \$(stat -f -c '%i' \$4) - \$(df -i \$$4 | tail -1 | awk '\''{print \$3}'\'');}' >> \"$LOG_FILE\"

    if [ \"\$(date +%Y-%m-%d)\" != \"\$CURRENT_DATE\" ]; then
      CURRENT_DATE=\$(date +%Y-%m-%d)
      LOG_FILE=\"${LOG_DIR}/disk_usage_\$CURRENT_DATE.csv\"
      echo \"Date,Time,Free Space (GB),Used Space (GB),Total Space (GB),Free Inodes,Used Inodes,Total Inodes\" > \"$LOG_FILE\"
    fi
    sleep 60; \
  done" &

  echo $! >"$MONITOR_PID_FILE"
  echo "Monitoring process started with PID: $!"
}

stop_monitoring() {
  if is_running; then
    local pid
    pid=$(cat "$MONITOR_PID_FILE")
    kill "$pid"
    rm -f "$MONITOR_PID_FILE"
    echo "Monitoring process stopped."
  else
    echo "Monitoring process is not running."
  fi
}

status_monitoring() {
  if is_running; then
    echo "Monitoring process is running with PID: $(cat "$MONITOR_PID_FILE")"
  else
    echo "Monitoring process is not running."
  fi
}

case "$1" in
START)
  start_monitoring
  ;;
STOP)
  stop_monitoring
  ;;
STATUS)
  status_monitoring
  ;;
*)
  echo "Invalid argument: $1"
  exit 1
  ;;
esac
