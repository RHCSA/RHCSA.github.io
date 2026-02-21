#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Create sudoers Drop-in File

IS_LAB=true
LAB_ID="sudo_dropin"

QUESTION="[LAB] Create a sudoers drop-in file for a user"
HINT="Task 1: echo 'devops ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/devops\nTask 2: chmod 440 /etc/sudoers.d/devops"

LAB_TITLE="Create sudoers Drop-in"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /etc/sudoers.d/devops with NOPASSWD rule" ;;
        1) echo "Set correct permissions (440) on the file" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user...${RESET}"
    userdel -r devops 2>/dev/null
    useradd devops 2>/dev/null
    rm -f /etc/sudoers.d/devops 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if sudoers file exists with NOPASSWD
    if [[ -f /etc/sudoers.d/devops ]] && grep -q 'NOPASSWD' /etc/sudoers.d/devops 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check permissions (440 or 400)
    local perms=$(stat -c %a /etc/sudoers.d/devops 2>/dev/null)
    if [[ "$perms" == "440" ]] || [[ "$perms" == "400" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /etc/sudoers.d/devops 2>/dev/null
    userdel -r devops 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
