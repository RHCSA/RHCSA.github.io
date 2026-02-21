#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Set Account Expiration

IS_LAB=true
LAB_ID="account_expire"

QUESTION="[LAB] Set user account to expire on a specific date"
HINT="Task 1: chage -E 2025-12-31 expireuser\nTask 2: chage -l expireuser (verify expiration date)"

LAB_TITLE="Set Account Expiration"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set expireuser to expire on 2025-12-31" ;;
        1) echo "Verify account expiration date" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user...${RESET}"
    userdel -r expireuser 2>/dev/null
    useradd expireuser 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if expiration is set to 2025-12-31
    if chage -l expireuser 2>/dev/null | grep -i 'account expires' | grep -qE 'Dec 31, 2025|2025-12-31'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Same check
    if chage -l expireuser 2>/dev/null | grep -i 'account expires' | grep -qE 'Dec 31, 2025|2025-12-31'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r expireuser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
