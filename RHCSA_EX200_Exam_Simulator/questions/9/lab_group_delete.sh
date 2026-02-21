#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Delete Group

IS_LAB=true
LAB_ID="delete_group"

QUESTION="[LAB] Delete a group"
HINT="Task 1: groupdel oldgroup\nTask 2: getent group oldgroup (should return nothing)"

LAB_TITLE="Delete Group"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Delete group oldgroup" ;;
        1) echo "Verify group no longer exists" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test group...${RESET}"
    groupdel oldgroup 2>/dev/null
    groupadd oldgroup 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if group does NOT exist
    if ! getent group oldgroup &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Same check
    if ! grep -q '^oldgroup:' /etc/group 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    groupdel oldgroup 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
