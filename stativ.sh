#!/bin/bash

BATTERY_PERCENTAGE=/sys/class/power_supply/BAT1/capacity
BATTERY_ALARM=/sys/class/power_supply/BAT1/alarm

cpu_0_prev_line=($(head -n2 /proc/stat | tail -1))
cpu_0_prev_reading="${cpu_0_prev_line[@]:1}"
cpu_0_prev_reading=$((${cpu_0_prev_reading// /+}))
cpu_1_prev_line=($(head -n3 /proc/stat | tail -1))
cpu_1_prev_reading="${cpu_1_prev_line[@]:1}"
cpu_1_prev_reading=$((${cpu_1_prev_reading// /+}))
cpu_2_prev_line=($(head -n4 /proc/stat | tail -1))
cpu_2_prev_reading="${cpu_2_prev_line[@]:1}"
cpu_2_prev_reading=$((${cpu_2_prev_reading// /+}))
cpu_3_prev_line=($(head -n5 /proc/stat | tail -1))
cpu_3_prev_reading="${cpu_3_prev_line[@]:1}"
cpu_3_prev_reading=$((${cpu_3_prev_reading// /+}))
disk_prev_line=($(cat /proc/diskstats | tail -9 | head -1))
sleep 1

while true; do
  cpu_0_line=($(head -n2 /proc/stat | tail -1))
  cpu_0_reading="${cpu_0_line[@]:1}"
  cpu_0_reading=$((${cpu_0_reading// /+}))
  cpu_0_delta=$((cpu_0_reading - cpu_0_prev_reading))
  cpu_0_idle=$((cpu_0_line[4] - cpu_0_prev_line[4]))
  cpu_0_used=$((cpu_0_delta - cpu_0_idle))
  cpu_0_usage=$((100 * cpu_0_used / cpu_0_delta)) 

  cpu_1_line=($(head -n3 /proc/stat | tail -1))
  cpu_1_reading="${cpu_1_line[@]:1}"
  cpu_1_reading=$((${cpu_1_reading// /+}))
  cpu_1_delta=$((cpu_1_reading - cpu_1_prev_reading))
  cpu_1_idle=$((cpu_1_line[4] - cpu_1_prev_line[4]))
  cpu_1_used=$((cpu_1_delta - cpu_1_idle))
  cpu_1_usage=$((100 * cpu_1_used / cpu_1_delta)) 

  cpu_2_line=($(head -n4 /proc/stat | tail -1))
  cpu_2_reading="${cpu_2_line[@]:1}"
  cpu_2_reading=$((${cpu_2_reading// /+}))
  cpu_2_delta=$((cpu_2_reading - cpu_2_prev_reading))
  cpu_2_idle=$((cpu_2_line[4] - cpu_2_prev_line[4]))
  cpu_2_used=$((cpu_2_delta - cpu_2_idle))
  cpu_2_usage=$((100 * cpu_2_used / cpu_2_delta)) 

  cpu_3_line=($(head -n5 /proc/stat | tail -1))
  cpu_3_reading="${cpu_3_line[@]:1}"
  cpu_3_reading=$((${cpu_3_reading// /+}))
  cpu_3_delta=$((cpu_3_reading - cpu_3_prev_reading))
  cpu_3_idle=$((cpu_3_line[4] - cpu_3_prev_line[4]))
  cpu_3_used=$((cpu_3_delta - cpu_3_idle))
  cpu_3_usage=$((100 * cpu_3_used / cpu_3_delta)) 

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

  status=""
  status+=`printf "%3d" $cpu_0_usage `
  status+="%"
  status+=`printf "%3d" $cpu_1_usage `
  status+="%"
  status+=`printf "%3d" $cpu_2_usage `
  status+="%"
  status+=`printf "%3d" $cpu_3_usage `
  status+="% | "
  status+=`printf "%3d" $mem_free `
  status+="% Free | R:"
  status+=`printf "%3d" $disk_reads`
  status+=" | W:"
  status+=`printf "%3d" $disk_writes`
  status+=" | Link:"
  status+=`printf "%4ddB" $wireless_link`
  status+=" | Up:"
  status+=`printf "%2dd %02d:%02d" $uptime_days $uptime_hours $uptime_minutes` 
  status+=" | `/bin/date +"%F %R"` | `cat $BATTERY_PERCENTAGE`%"

  xsetroot -name "${status}"

  cpu_0_prev_line=("${cpu_0_line[@]}")
  cpu_0_prev_reading=$cpu_0_reading
  cpu_1_prev_line=("${cpu_1_line[@]}")
  cpu_1_prev_reading=$cpu_1_reading
  cpu_2_prev_line=("${cpu_2_line[@]}")
  cpu_2_prev_reading=$cpu_2_reading
  cpu_3_prev_line=("${cpu_3_line[@]}")
  cpu_3_prev_reading=$cpu_3_reading
  disk_prev_line=("${disk_line[@]}")

  sleep 1
done
