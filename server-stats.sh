#!/bin/bash

# ============================================================
# Server Performance Statistics
# Author: Your Name
# Description:
#   Displays basic Linux server performance statistics:
#   - CPU usage
#   - Memory usage
#   - Disk usage
#   - Top 5 CPU-consuming processes
#   - Top 5 memory-consuming processes
# ============================================================

set -u

# ------------------------------------------------------------
# Colors
# ------------------------------------------------------------

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

# ------------------------------------------------------------
# Header
# ------------------------------------------------------------

echo
echo "============================================================"
echo "              SERVER PERFORMANCE STATISTICS"
echo "============================================================"
echo "Hostname : $(hostname)"
echo "Date     : $(date)"
echo "Uptime   : $(uptime -p 2>/dev/null || uptime)"
echo "============================================================"
echo

# ------------------------------------------------------------
# CPU Usage
# ------------------------------------------------------------

echo -e "${CYAN}CPU USAGE${RESET}"
echo "------------------------------------------------------------"

read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

idle1=$((idle + iowait))
total1=$((user + nice + system + idle + iowait + irq + softirq + steal))

sleep 1

read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

idle2=$((idle + iowait))
total2=$((user + nice + system + idle + iowait + irq + softirq + steal))

total_diff=$((total2 - total1))
idle_diff=$((idle2 - idle1))

if [ "$total_diff" -gt 0 ]; then
    cpu_usage=$(awk -v total="$total_diff" -v idle="$idle_diff" \
        'BEGIN {printf "%.2f", (100 * (total-idle))/total}')
else
    cpu_usage="0.00"
fi

echo -e "Total CPU Usage : ${GREEN}${cpu_usage}%${RESET}"
echo

# ------------------------------------------------------------
# Memory Usage
# ------------------------------------------------------------

echo -e "${CYAN}MEMORY USAGE${RESET}"
echo "------------------------------------------------------------"

memory_info=$(free -m | awk '/^Mem:/ {
    total=$2
    used=$3
    available=$7

    used_actual=total-available
    percentage=(used_actual/total)*100

    printf "%d %d %d %.2f", total, used_actual, available, percentage
}')

read -r total_mem used_mem free_mem mem_percentage <<< "$memory_info"

echo "Total Memory : ${total_mem} MB"
echo "Used Memory  : ${used_mem} MB"
echo "Free Memory  : ${free_mem} MB"
echo -e "Usage        : ${YELLOW}${mem_percentage}%${RESET}"
echo

# ------------------------------------------------------------
# Disk Usage
# ------------------------------------------------------------

echo -e "${CYAN}DISK USAGE${RESET}"
echo "------------------------------------------------------------"

disk_info=$(df -h --output=size,used,avail,pcent,target 2>/dev/null | \
    awk 'NR > 1 && $5 !~ /tmpfs|devtmpfs/ {
        size=$1
        used=$2
        avail=$3
        percent=$4
        mount=$5

        printf "%-10s %-10s %-10s %-8s %s\n",
               size, used, avail, percent, mount
    }')

if [ -n "$disk_info" ]; then
    printf "%-10s %-10s %-10s %-8s %s\n" \
        "SIZE" "USED" "FREE" "USAGE" "MOUNT"

    echo "$disk_info"
else
    echo "Unable to determine disk usage."
fi

echo

# ------------------------------------------------------------
# Top 5 Processes by CPU
# ------------------------------------------------------------

echo -e "${CYAN}TOP 5 PROCESSES BY CPU USAGE${RESET}"
echo "------------------------------------------------------------"

ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -n 6

echo

# ------------------------------------------------------------
# Top 5 Processes by Memory
# ------------------------------------------------------------

echo -e "${CYAN}TOP 5 PROCESSES BY MEMORY USAGE${RESET}"
echo "------------------------------------------------------------"

ps -eo pid,user,%cpu,%mem,comm --sort=-%mem | head -n 6

echo

# ------------------------------------------------------------
# Footer
# ------------------------------------------------------------

echo "============================================================"
echo "                  END OF REPORT"
echo "============================================================"
echo
