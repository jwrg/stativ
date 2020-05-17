#!/bin/bash

BATTERY_PERCENTAGE=/sys/class/power_supply/BAT1/capacity
BATTERY_ALARM=/sys/class/power_supply/BAT1/alarm

BATTERY=$(cat $BATTERY_PERCENTAGE)
DATE=$(/bin/date +"%F %R")

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
  xsetroot -name "CPU: "`printf %03d $cpu_usage `"% | $DATE | $BATTERY%"
  cpu_prev_line=("${cpu_line[@]}")
  cpu_prev_reading=$cpu_reading
  sleep 1
done
