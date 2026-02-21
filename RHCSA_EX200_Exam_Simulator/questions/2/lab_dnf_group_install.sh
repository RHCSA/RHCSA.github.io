#!/bin/bash
# Objective 2: Manage software
# LAB: Install Package Group

IS_LAB=true
LAB_ID="dnf_group_install"

QUESTION="[LAB] List available package groups and view group information"
HINT="Task 1: dnf group list > /tmp/groups.txt\nTask 2: dnf group info 'System Tools' > /tmp/group-info.txt"

LAB_TITLE="Package Group Operations"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List all package groups and save to /tmp/groups.txt" ;;
        1) echo "Show info for 'System Tools' group, save to /tmp/group-info.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/groups.txt /tmp/group-info.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if groups.txt exists and contains group listings
    if [[ -f /tmp/groups.txt ]] && grep -qi 'group\|environment' /tmp/groups.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if group-info.txt exists and contains package info
    if [[ -f /tmp/group-info.txt ]] && grep -qi 'system\|package\|group' /tmp/group-info.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/groups.txt /tmp/group-info.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
