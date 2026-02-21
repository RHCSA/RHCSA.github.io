#!/bin/bash
# Objective 4: Operate running systems
# LAB: System Uptime and Boot Information

IS_LAB=true
LAB_ID="system_uptime_info"

QUESTION="[LAB] Check system uptime and last boot time, save to files"
HINT="Task 1: uptime > /tmp/uptime.txt\nTask 2: who -b > /tmp/boottime.txt"

LAB_TITLE="System Uptime and Boot Info"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save system uptime to /tmp/uptime.txt" ;;
        1) echo "Save last boot time to /tmp/boottime.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/uptime.txt /tmp/boottime.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if uptime.txt exists and has content
    if [[ -f /tmp/uptime.txt ]] && grep -qE 'up|load' /tmp/uptime.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if boottime.txt exists with boot info
    if [[ -f /tmp/boottime.txt ]] && grep -qiE 'boot|system' /tmp/boottime.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/uptime.txt /tmp/boottime.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
