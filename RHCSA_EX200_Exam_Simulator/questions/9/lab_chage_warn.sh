#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Set Password Warning Days

IS_LAB=true
LAB_ID="passwd_warn_days"

QUESTION="[LAB] Set password warning to 14 days before expiration"
HINT="Task 1: chage -W 14 warnuser\nTask 2: chage -l warnuser (verify warning = 14)"

LAB_TITLE="Set Password Warning"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set warning days to 14 for warnuser" ;;
        1) echo "Verify warning days is 14" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user...${RESET}"
    userdel -r warnuser 2>/dev/null
    useradd warnuser 2>/dev/null
    echo 'testpass' | passwd --stdin warnuser 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if warning is 14
    local warn_days=$(chage -l warnuser 2>/dev/null | grep 'warning before password expires' | grep -oE '[0-9]+$')
    if [[ "$warn_days" == "14" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Same check
    if [[ "$warn_days" == "14" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r warnuser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
