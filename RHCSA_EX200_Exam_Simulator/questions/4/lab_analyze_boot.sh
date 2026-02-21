#!/bin/bash
# Objective 4: Operate running systems
# LAB: Analyze Boot Time

IS_LAB=true
LAB_ID="analyze_boot"

QUESTION="[LAB] Analyze system boot time using systemd-analyze"
HINT="Task 1: systemd-analyze > /tmp/boot-time.txt\nTask 2: systemd-analyze blame | head -20 > /tmp/boot-blame.txt"

LAB_TITLE="Analyze Boot Time"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save boot time analysis to /tmp/boot-time.txt" ;;
        1) echo "Save top 20 slowest services to /tmp/boot-blame.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/boot-time.txt /tmp/boot-blame.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if boot-time.txt exists with timing info
    if [[ -f /tmp/boot-time.txt ]] && grep -qE 'startup|kernel|userspace' /tmp/boot-time.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if boot-blame.txt exists with service list
    if [[ -f /tmp/boot-blame.txt ]] && grep -qE 'ms|s ' /tmp/boot-blame.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/boot-time.txt /tmp/boot-blame.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
