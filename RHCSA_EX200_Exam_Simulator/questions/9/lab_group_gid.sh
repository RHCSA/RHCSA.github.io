#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Create Group with Specific GID

IS_LAB=true
LAB_ID="create_group_gid"

QUESTION="[LAB] Create a group with a specific GID"
HINT="Task 1: groupadd -g 5500 admins\nTask 2: getent group admins (verify GID=5500)"

LAB_TITLE="Create Group with GID"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create group admins with GID 5500" ;;
        1) echo "Verify GID is 5500" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous lab data...${RESET}"
    groupdel admins 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if group exists
    if getent group admins &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if GID is 5500
    local group_gid=$(getent group admins 2>/dev/null | cut -d: -f3)
    if [[ "$group_gid" == "5500" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    groupdel admins 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
