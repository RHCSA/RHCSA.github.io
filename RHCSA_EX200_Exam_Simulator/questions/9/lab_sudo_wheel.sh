#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Grant sudo via wheel Group

IS_LAB=true
LAB_ID="sudo_wheel"

QUESTION="[LAB] Grant sudo access by adding user to wheel group"
HINT="Task 1: usermod -aG wheel sudouser\nTask 2: groups sudouser (verify wheel membership)"

LAB_TITLE="Grant sudo via wheel"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add sudouser to wheel group" ;;
        1) echo "Verify sudouser is in wheel group" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user...${RESET}"
    userdel -r sudouser 2>/dev/null
    useradd sudouser 2>/dev/null
    echo 'testpass' | passwd --stdin sudouser 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if user is in wheel group
    if groups sudouser 2>/dev/null | grep -q 'wheel'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Same check
    if id -Gn sudouser 2>/dev/null | grep -q 'wheel'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r sudouser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
