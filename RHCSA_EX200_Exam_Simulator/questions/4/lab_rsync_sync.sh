#!/bin/bash
# Objective 4: Operate running systems
# LAB: Rsync File Synchronization

IS_LAB=true
LAB_ID="rsync_sync"

QUESTION="[LAB] Use rsync to synchronize directories locally"
HINT="Task 1: rsync -av /etc/hosts /tmp/hosts-backup\nTask 2: rsync -av /etc/passwd /tmp/passwd-backup"

LAB_TITLE="Rsync File Synchronization"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Sync /etc/hosts to /tmp/hosts-backup using rsync" ;;
        1) echo "Sync /etc/passwd to /tmp/passwd-backup using rsync" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous backups...${RESET}"
    rm -f /tmp/hosts-backup /tmp/passwd-backup 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if hosts-backup exists
    if [[ -f /tmp/hosts-backup ]] && diff -q /etc/hosts /tmp/hosts-backup &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if passwd-backup exists
    if [[ -f /tmp/passwd-backup ]] && diff -q /etc/passwd /tmp/passwd-backup &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/hosts-backup /tmp/passwd-backup 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
