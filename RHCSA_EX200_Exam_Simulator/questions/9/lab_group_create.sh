#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Create Group

IS_LAB=true
LAB_ID="create_group"

QUESTION="[LAB] Create a new group"
HINT="Task 1: groupadd devteam\nTask 2: getent group devteam > /tmp/group-info.txt"

LAB_TITLE="Create Group"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create group devteam" ;;
        1) echo "Save group info to /tmp/group-info.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous lab data...${RESET}"
    groupdel devteam 2>/dev/null
    rm -f /tmp/group-info.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if group exists
    if getent group devteam &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if group-info.txt exists
    if [[ -f /tmp/group-info.txt ]] && grep -q 'devteam' /tmp/group-info.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    groupdel devteam 2>/dev/null
    rm -f /tmp/group-info.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
