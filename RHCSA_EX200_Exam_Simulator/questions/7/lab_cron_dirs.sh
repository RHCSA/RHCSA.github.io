#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Cron Special Directories

IS_LAB=true
LAB_ID="cron_dirs"

QUESTION="[LAB] View and use cron special directories"
HINT="Task 1: ls /etc/cron.daily/ > /tmp/cron-daily.txt; ls /etc/cron.hourly/ >> /tmp/cron-daily.txt\nTask 2: Create executable script in /etc/cron.hourly/labtest"

LAB_TITLE="Cron Special Directories"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List cron.daily and cron.hourly to /tmp/cron-daily.txt" ;;
        1) echo "Create executable /etc/cron.hourly/labtest script" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/cron-daily.txt /etc/cron.hourly/labtest 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if cron-daily.txt exists
    if [[ -f /tmp/cron-daily.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if /etc/cron.hourly/labtest exists and is executable
    if [[ -x /etc/cron.hourly/labtest ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/cron-daily.txt /etc/cron.hourly/labtest 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
