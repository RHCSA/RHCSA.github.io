#!/bin/bash
# Objective 4: Operate running systems
# LAB: Find Process by Name

IS_LAB=true
LAB_ID="find_process_name"

QUESTION="[LAB] Find process PIDs by name using pgrep and ps"
HINT="Task 1: pgrep -a sshd > /tmp/sshd-pids.txt\nTask 2: ps aux | grep sshd > /tmp/sshd-details.txt"

LAB_TITLE="Find Process by Name"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Find sshd PIDs using pgrep and save to /tmp/sshd-pids.txt" ;;
        1) echo "Find sshd process details and save to /tmp/sshd-details.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/sshd-pids.txt /tmp/sshd-details.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if sshd-pids.txt exists with PID info
    if [[ -f /tmp/sshd-pids.txt ]] && grep -qE '[0-9]+.*sshd|sshd' /tmp/sshd-pids.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if sshd-details.txt exists with process details
    if [[ -f /tmp/sshd-details.txt ]] && grep -q 'sshd' /tmp/sshd-details.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/sshd-pids.txt /tmp/sshd-details.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
