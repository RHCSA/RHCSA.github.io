#!/bin/bash
# Objective 4: Operate running systems
# LAB: Check Service Status

IS_LAB=true
LAB_ID="service_status"

QUESTION="[LAB] Check status of network services"
HINT="Task 1: systemctl status sshd > /tmp/sshd-status.txt\nTask 2: systemctl is-active sshd > /tmp/sshd-active.txt"

LAB_TITLE="Check Service Status"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save sshd service status to /tmp/sshd-status.txt" ;;
        1) echo "Save sshd active state to /tmp/sshd-active.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/sshd-status.txt /tmp/sshd-active.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if sshd-status.txt exists with status info
    if [[ -f /tmp/sshd-status.txt ]] && grep -qiE 'sshd|active|loaded' /tmp/sshd-status.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if sshd-active.txt exists with active/inactive
    if [[ -f /tmp/sshd-active.txt ]] && grep -qE 'active|inactive' /tmp/sshd-active.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/sshd-status.txt /tmp/sshd-active.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
