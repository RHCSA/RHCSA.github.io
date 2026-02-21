#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Set Password Maximum Age

IS_LAB=true
LAB_ID="passwd_max_age"

QUESTION="[LAB] Set password maximum age to 90 days"
HINT="Task 1: chage -M 90 ageuser\nTask 2: chage -l ageuser (verify Maximum = 90)"

LAB_TITLE="Set Password Max Age"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set max password age to 90 days for ageuser" ;;
        1) echo "Verify maximum age is 90 days" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user...${RESET}"
    userdel -r ageuser 2>/dev/null
    useradd ageuser 2>/dev/null
    echo 'testpass' | passwd --stdin ageuser 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if max age is 90
    local max_days=$(chage -l ageuser 2>/dev/null | grep 'Maximum number of days' | grep -oE '[0-9]+$')
    if [[ "$max_days" == "90" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Same check
    if [[ "$max_days" == "90" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r ageuser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
