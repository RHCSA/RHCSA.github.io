#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Force Password Change

IS_LAB=true
LAB_ID="force_passwd_change"

QUESTION="[LAB] Force user to change password at next login"
HINT="Task 1: chage -d 0 forceuser (or passwd -e forceuser)\nTask 2: chage -l forceuser > /tmp/chage-info.txt"

LAB_TITLE="Force Password Change"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Force forceuser to change password at next login" ;;
        1) echo "Save chage info to /tmp/chage-info.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user...${RESET}"
    userdel -r forceuser 2>/dev/null
    useradd forceuser 2>/dev/null
    echo 'testpass' | passwd --stdin forceuser 2>/dev/null
    rm -f /tmp/chage-info.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if password must be changed (last change = 0)
    local last_change=$(chage -l forceuser 2>/dev/null | grep 'Last password change' | grep -i 'must be changed\|password must\|Jan 01, 1970')
    if [[ -n "$last_change" ]] || chage -l forceuser 2>/dev/null | grep -qi 'password must be changed'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if chage-info.txt exists
    if [[ -f /tmp/chage-info.txt ]] && grep -qi 'password' /tmp/chage-info.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r forceuser 2>/dev/null
    rm -f /tmp/chage-info.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
