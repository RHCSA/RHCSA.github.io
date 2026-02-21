#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Create User with Custom Home Directory

IS_LAB=true
LAB_ID="create_user_home"

QUESTION="[LAB] Create a user with a custom home directory"
HINT="Task 1: useradd -m -d /opt/appuser appuser\nTask 2: ls -la /opt/appuser (verify directory exists)"

LAB_TITLE="Create User Custom Home"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create user appuser with home /opt/appuser" ;;
        1) echo "Verify home directory exists" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous lab data...${RESET}"
    userdel -r appuser 2>/dev/null
    rm -rf /opt/appuser 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if user exists
    if id appuser &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if home directory exists at /opt/appuser
    if [[ -d /opt/appuser ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r appuser 2>/dev/null
    rm -rf /opt/appuser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
