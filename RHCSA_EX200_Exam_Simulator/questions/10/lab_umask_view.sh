#!/bin/bash
# Objective 10: Manage security
# LAB: View Current Umask

IS_LAB=true
LAB_ID="view_umask"

QUESTION="[LAB] View the current umask value"
HINT="Task 1: umask > /tmp/umask-octal.txt (octal format)\nTask 2: umask -S > /tmp/umask-symbolic.txt (symbolic format)"

LAB_TITLE="View Current Umask"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save umask octal value to /tmp/umask-octal.txt" ;;
        1) echo "Save umask symbolic value to /tmp/umask-symbolic.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/umask-octal.txt /tmp/umask-symbolic.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if umask-octal.txt exists with umask value
    if [[ -f /tmp/umask-octal.txt ]] && grep -qE '^[0-7]{3,4}$' /tmp/umask-octal.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if umask-symbolic.txt exists with symbolic format
    if [[ -f /tmp/umask-symbolic.txt ]] && grep -qE 'u=|g=|o=' /tmp/umask-symbolic.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/umask-octal.txt /tmp/umask-symbolic.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
