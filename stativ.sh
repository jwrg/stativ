#!/bin/bash

BATTERY_PERCENTAGE=/sys/class/power_supply/BAT1/capacity
BATTERY_ALARM=/sys/class/power_supply/BAT1/alarm

cpu_prev_line=($(head -n1 /proc/stat))
cpu_prev_reading="${cpu_prev_line[@]:1}"
cpu_prev_reading=$((${cpu_prev_reading// /+}))
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

  status=" CPU: "
  status+=`printf "%3d" $cpu_usage `
  status+="% | MEM: "
  status+=`printf "%3d" $mem_free `
  status+="% Free | `/bin/date +"%F %R"` | `cat $BATTERY_PERCENTAGE`%"

  xsetroot -name "${status}"

  cpu_prev_line=("${cpu_line[@]}")
  cpu_prev_reading=$cpu_reading

  sleep 1
done
