#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: View Filesystem Types

IS_LAB=true
LAB_ID="view_fs_types"

QUESTION="[LAB] Display filesystem types of mounted devices"
HINT="Task 1: lsblk -f > /tmp/fs-types.txt\nTask 2: df -Th > /tmp/df-types.txt"

LAB_TITLE="View Filesystem Types"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save lsblk filesystem info to /tmp/fs-types.txt" ;;
        1) echo "Save df with types to /tmp/df-types.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/fs-types.txt /tmp/df-types.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if fs-types.txt exists with filesystem info
    if [[ -f /tmp/fs-types.txt ]] && grep -qiE 'FSTYPE|xfs|ext' /tmp/fs-types.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if df-types.txt exists with type info
    if [[ -f /tmp/df-types.txt ]] && grep -qE 'Type|xfs|ext' /tmp/df-types.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/fs-types.txt /tmp/df-types.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
