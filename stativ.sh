#!/bin/bash

BATTERY_PERCENTAGE=/sys/class/power_supply/BAT1/capacity
BATTERY_ALARM=/sys/class/power_supply/BAT1/alarm

cpu_prev_line=($(head -n1 /proc/stat))
cpu_prev_reading="${cpu_prev_line[@]:1}"
cpu_prev_reading=$((${cpu_prev_reading// /+}))
disk_prev_line=($(cat /proc/diskstats | tail -9 | head -1))
sleep 1

while true; do
  cpu_line=($(head -n1 /proc/stat))
  cpu_reading="${cpu_line[@]:1}"
  cpu_reading=$((${cpu_reading// /+}))
  cpu_delta=$((cpu_reading - cpu_prev_reading))
  cpu_idle=$((cpu_line[4] - cpu_prev_line[4]))
  cpu_used=$((cpu_delta - cpu_idle))
  cpu_usage=$((100 * cpu_used / cpu_delta)) 

  mem_line=($(free | head -2 | tail -1))
  mem_free=$((100 * mem_line[3] / mem_line[1]))

  disk_line=($(cat /proc/diskstats | tail -9 | head -1))
  disk_writes=$((disk_line[7] - disk_prev_line[7]))
  disk_reads=$((disk_line[3] - disk_prev_line[3]))

  wireless_line=($(cat /proc/net/wireless | tail -1))
  wireless_link=${wireless_line[3]%.*}

  uptime_line=($(cat /proc/uptime))
  uptime=${uptime_line[0]%.*}
  uptime_days=$((uptime / 86400))
  uptime_hours=$(((uptime - (uptime_days * 86400)) / 3600))
  uptime_minutes=$(((uptime - (uptime_days * 86400) - (uptime_hours * 3600) ) / 60))

  status=" CPU:"
  status+=`printf "%3d" $cpu_usage `
  status+="% | Mem:"
  status+=`printf "%3d" $mem_free `
  status+="% Free | Reads:"
  status+=`printf "%4d" $disk_reads`
  status+=" Writes:"
  status+=`printf "%4d" $disk_writes`
  status+=" | Link:"
  status+=`printf "%4ddB" $wireless_link`
  status+=" | Up:"
  status+=`printf "%3dd %02d:%02d" $uptime_days $uptime_hours $uptime_minutes` 
  status+=" | `/bin/date +"%F %R"` | `cat $BATTERY_PERCENTAGE`%"

  xsetroot -name "${status}"

  cpu_prev_line=("${cpu_line[@]}")
  cpu_prev_reading=$cpu_reading
  disk_prev_line=("${disk_line[@]}")

  sleep 1
done
