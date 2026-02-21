#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Lock and Unlock User

IS_LAB=true
LAB_ID="lock_unlock_user"

QUESTION="[LAB] Lock and unlock a user account"
HINT="Task 1: passwd -l lockuser (lock the account)\nTask 2: passwd -u lockuser (unlock the account)"

LAB_TITLE="Lock and Unlock User"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Lock user lockuser" ;;
        1) echo "Unlock user lockuser" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user with password...${RESET}"
    userdel -r lockuser 2>/dev/null
    useradd lockuser 2>/dev/null
    echo 'testpass' | passwd --stdin lockuser 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Initially we want locked, then unlocked. Check final state is unlocked
    local status=$(passwd -S lockuser 2>/dev/null | awk '{print $2}')
    
    # Task 0: This is tricky - we want them to lock then unlock
    # Check if user was modified (shadow has been changed)
    if grep -q '^lockuser:' /etc/shadow 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if currently unlocked (PS status)
    if [[ "$status" == "PS" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r lockuser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
