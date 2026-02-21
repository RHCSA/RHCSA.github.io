#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Change Group Ownership

IS_LAB=true
LAB_ID="change_group"

QUESTION="[LAB] Change group ownership of a file"
HINT="Task 1: chgrp nobody /tmp/labgroupown.txt (or chown :nobody)\nTask 2: ls -l /tmp/labgroupown.txt > /tmp/group-check.txt"

LAB_TITLE="Change Group Ownership"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Change group of /tmp/labgroupown.txt to 'nobody'" ;;
        1) echo "Verify group and save to /tmp/group-check.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating file with root group...${RESET}"
    echo "Group test" > /tmp/labgroupown.txt
    chown root:root /tmp/labgroupown.txt 2>/dev/null
    rm -f /tmp/group-check.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if file group is nobody
    local group=$(stat -c %G /tmp/labgroupown.txt 2>/dev/null)
    if [[ "$group" == "nobody" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if group-check.txt exists
    if [[ -f /tmp/group-check.txt ]] && grep -q 'labgroupown' /tmp/group-check.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/labgroupown.txt /tmp/group-check.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
