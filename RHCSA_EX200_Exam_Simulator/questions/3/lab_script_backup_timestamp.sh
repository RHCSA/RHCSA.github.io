#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Backup Script with Timestamp

IS_LAB=true
LAB_ID="script_backup_timestamp"

QUESTION="[LAB] Create a backup script that uses timestamp in filename"
HINT="Task 1: Create /tmp/backup.sh using TIMESTAMP=$(date +%Y%m%d_%H%M%S)\nTask 2: Script creates /tmp/backup_TIMESTAMP.tar.gz from /etc/hosts"

LAB_TITLE="Backup Script with Timestamp"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/backup.sh using date for timestamp variable" ;;
        1) echo "Running script creates /tmp/backup_*.tar.gz file" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous files...${RESET}"
    rm -f /tmp/backup.sh /tmp/backup_*.tar.gz 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script uses date command for timestamp
    if [[ -f /tmp/backup.sh ]] && [[ -x /tmp/backup.sh ]] && \
       grep -q 'date' /tmp/backup.sh 2>/dev/null && grep -qE '\$\(' /tmp/backup.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Run script and check if backup file was created
    /tmp/backup.sh 2>/dev/null
    if ls /tmp/backup_*.tar.gz &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/backup.sh /tmp/backup_*.tar.gz 2>/dev/null
    echo -e "  ${GREEN}? Lab environment cleaned up${RESET}"
    sleep 1
}
