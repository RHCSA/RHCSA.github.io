#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Create User with No Login Shell

IS_LAB=true
LAB_ID="create_user_nologin"

QUESTION="[LAB] Create a service user that cannot log in"
HINT="Task 1: useradd -s /sbin/nologin svcuser\nTask 2: getent passwd svcuser | grep nologin"

LAB_TITLE="Create No-Login User"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create user svcuser with /sbin/nologin shell" ;;
        1) echo "Verify shell is /sbin/nologin" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous lab data...${RESET}"
    userdel -r svcuser 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if user exists
    if id svcuser &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if shell is nologin
    local user_shell=$(getent passwd svcuser 2>/dev/null | cut -d: -f7)
    if [[ "$user_shell" == "/sbin/nologin" ]] || [[ "$user_shell" == "/usr/sbin/nologin" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r svcuser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
