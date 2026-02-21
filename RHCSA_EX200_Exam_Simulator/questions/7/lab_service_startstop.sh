#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Start and Stop Services

IS_LAB=true
LAB_ID="service_startstop"

QUESTION="[LAB] Start and stop a service using systemctl"
HINT="Task 1: systemctl start crond && systemctl status crond > /tmp/crond-status.txt\nTask 2: systemctl is-active crond > /tmp/crond-active.txt"

LAB_TITLE="Start and Stop Services"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Start crond service and save status to /tmp/crond-status.txt" ;;
        1) echo "Check if crond is active, save to /tmp/crond-active.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/crond-status.txt /tmp/crond-active.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if crond-status.txt exists with status info
    if [[ -f /tmp/crond-status.txt ]] && grep -qiE 'crond|active|loaded' /tmp/crond-status.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if crond-active.txt exists with active state
    if [[ -f /tmp/crond-active.txt ]] && grep -qE 'active|inactive' /tmp/crond-active.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/crond-status.txt /tmp/crond-active.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
