#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Grant Specific Command Access

IS_LAB=true
LAB_ID="sudo_specific_cmd"

QUESTION="[LAB] Grant sudo access for specific commands only"
HINT="Task 1: echo 'backup ALL=(ALL) /usr/bin/rsync' > /etc/sudoers.d/backup\nTask 2: chmod 440 /etc/sudoers.d/backup"

LAB_TITLE="Sudo Specific Command"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Allow backup user to run only rsync" ;;
        1) echo "Set correct permissions on sudoers file" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user...${RESET}"
    userdel -r backup 2>/dev/null
    useradd backup 2>/dev/null
    rm -f /etc/sudoers.d/backup 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if sudoers file exists with rsync
    if [[ -f /etc/sudoers.d/backup ]] && grep -qE '/usr/bin/rsync|rsync' /etc/sudoers.d/backup 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check permissions
    local perms=$(stat -c %a /etc/sudoers.d/backup 2>/dev/null)
    if [[ "$perms" == "440" ]] || [[ "$perms" == "400" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /etc/sudoers.d/backup 2>/dev/null
    userdel -r backup 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
