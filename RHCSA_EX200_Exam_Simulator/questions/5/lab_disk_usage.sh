#!/bin/bash
# Objective 5: Configure local storage
# LAB: View Disk Usage

IS_LAB=true
LAB_ID="disk_usage"

QUESTION="[LAB] Display disk usage and filesystem information"
HINT="Task 1: df -h > /tmp/df-output.txt\nTask 2: df -Th > /tmp/df-types.txt"

LAB_TITLE="View Disk Usage"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save disk usage to /tmp/df-output.txt" ;;
        1) echo "Save disk usage with types to /tmp/df-types.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/df-output.txt /tmp/df-types.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if df-output.txt exists with filesystem info
    if [[ -f /tmp/df-output.txt ]] && grep -qE 'Filesystem|Size|Used' /tmp/df-output.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if df-types.txt exists with type info
    if [[ -f /tmp/df-types.txt ]] && grep -qE 'Type|xfs|ext|tmpfs' /tmp/df-types.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/df-output.txt /tmp/df-types.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
