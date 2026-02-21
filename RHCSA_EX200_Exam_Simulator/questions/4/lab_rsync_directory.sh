#!/bin/bash
# Objective 4: Operate running systems
# LAB: Rsync Directory Sync

IS_LAB=true
LAB_ID="rsync_directory"

QUESTION="[LAB] Use rsync to recursively sync a directory"
HINT="Task 1: rsync -av /etc/ssh/ /tmp/ssh-backup/\nTask 2: Verify with ls /tmp/ssh-backup/"

LAB_TITLE="Rsync Directory Sync"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Sync /etc/ssh/ directory to /tmp/ssh-backup/" ;;
        1) echo "Verify backup contains ssh config files" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous backup...${RESET}"
    rm -rf /tmp/ssh-backup 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if ssh-backup directory exists
    if [[ -d /tmp/ssh-backup ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if backup contains expected files
    if [[ -f /tmp/ssh-backup/sshd_config ]] || [[ -f /tmp/ssh-backup/ssh_config ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/ssh-backup 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
