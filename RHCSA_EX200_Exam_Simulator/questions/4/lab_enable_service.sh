#!/bin/bash
# Objective 4: Operate running systems
# LAB: Enable Service at Boot

IS_LAB=true
LAB_ID="enable_service"

QUESTION="[LAB] Check if a service is enabled and verify boot status"
HINT="Task 1: systemctl is-enabled chronyd > /tmp/chronyd-enabled.txt\nTask 2: systemctl is-enabled sshd > /tmp/sshd-enabled.txt"

LAB_TITLE="Check Service Enable Status"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Check chronyd enable status, save to /tmp/chronyd-enabled.txt" ;;
        1) echo "Check sshd enable status, save to /tmp/sshd-enabled.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/chronyd-enabled.txt /tmp/sshd-enabled.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if chronyd-enabled.txt exists
    if [[ -f /tmp/chronyd-enabled.txt ]] && grep -qE 'enabled|disabled|static' /tmp/chronyd-enabled.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if sshd-enabled.txt exists
    if [[ -f /tmp/sshd-enabled.txt ]] && grep -qE 'enabled|disabled|static' /tmp/sshd-enabled.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/chronyd-enabled.txt /tmp/sshd-enabled.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
