#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: System Cron Jobs

IS_LAB=true
LAB_ID="system_cron"

QUESTION="[LAB] View and create system cron jobs"
HINT="Task 1: ls /etc/cron.d/ > /tmp/cron-d-list.txt; cat /etc/crontab > /tmp/crontab-sys.txt\nTask 2: Create /etc/cron.d/labtest with '0 * * * * root echo test'"

LAB_TITLE="System Cron Jobs"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List /etc/cron.d/ and copy /etc/crontab to /tmp/" ;;
        1) echo "Create /etc/cron.d/labtest with hourly job" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/cron-d-list.txt /tmp/crontab-sys.txt /etc/cron.d/labtest 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if cron files were saved
    if [[ -f /tmp/cron-d-list.txt ]] && [[ -f /tmp/crontab-sys.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if /etc/cron.d/labtest exists with proper format
    if [[ -f /etc/cron.d/labtest ]] && grep -qE '^[0-9*].*root' /etc/cron.d/labtest 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/cron-d-list.txt /tmp/crontab-sys.txt /etc/cron.d/labtest 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
