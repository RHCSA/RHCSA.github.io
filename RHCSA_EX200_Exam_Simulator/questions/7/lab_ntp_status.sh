#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Check NTP Status

IS_LAB=true
LAB_ID="ntp_status"

QUESTION="[LAB] Check NTP synchronization status"
HINT="Task 1: timedatectl | grep -i ntp > /tmp/ntp-status.txt\nTask 2: systemctl status chronyd > /tmp/chronyd-status.txt"

LAB_TITLE="Check NTP Status"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save NTP status from timedatectl to /tmp/ntp-status.txt" ;;
        1) echo "Save chronyd status to /tmp/chronyd-status.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/ntp-status.txt /tmp/chronyd-status.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if ntp-status.txt exists with NTP info
    if [[ -f /tmp/ntp-status.txt ]] && grep -qiE 'ntp|synchronized' /tmp/ntp-status.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if chronyd-status.txt exists
    if [[ -f /tmp/chronyd-status.txt ]] && grep -qi 'chronyd' /tmp/chronyd-status.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/ntp-status.txt /tmp/chronyd-status.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
