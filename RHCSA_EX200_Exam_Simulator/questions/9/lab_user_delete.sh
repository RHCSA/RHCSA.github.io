#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Delete User Account

IS_LAB=true
LAB_ID="delete_user"

QUESTION="[LAB] Delete a user account and home directory"
HINT="Task 1: userdel -r deleteuser\nTask 2: id deleteuser (should fail - user gone)"

LAB_TITLE="Delete User Account"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Delete user deleteuser with home directory" ;;
        1) echo "Verify user no longer exists" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user to delete...${RESET}"
    userdel -r deleteuser 2>/dev/null
    useradd -m deleteuser 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if user does NOT exist
    if ! id deleteuser &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if home directory is gone
    if [[ ! -d /home/deleteuser ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r deleteuser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
