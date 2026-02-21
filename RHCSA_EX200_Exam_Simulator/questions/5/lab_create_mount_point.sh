#!/bin/bash
# Objective 5: Configure local storage
# LAB: Create Mount Point Directory

IS_LAB=true
LAB_ID="create_mount_point"

QUESTION="[LAB] Create mount point directories with proper permissions"
HINT="Task 1: mkdir -p /mnt/labdata\nTask 2: mkdir -p /mnt/labbackup && chmod 755 /mnt/labbackup"

LAB_TITLE="Create Mount Point Directory"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create directory /mnt/labdata" ;;
        1) echo "Create /mnt/labbackup with 755 permissions" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous mount points...${RESET}"
    rm -rf /mnt/labdata /mnt/labbackup 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if /mnt/labdata exists
    if [[ -d /mnt/labdata ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if /mnt/labbackup exists with correct permissions
    if [[ -d /mnt/labbackup ]]; then
        local perms=$(stat -c %a /mnt/labbackup 2>/dev/null)
        if [[ "$perms" == "755" ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /mnt/labdata /mnt/labbackup 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
