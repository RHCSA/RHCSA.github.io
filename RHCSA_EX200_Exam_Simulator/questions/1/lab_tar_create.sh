#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create tar Archive

# This is a LAB exercise
IS_LAB=true
LAB_ID="tar_create"

QUESTION="[LAB] Create an uncompressed tar archive"
HINT="Task 1: tar -cvf /tmp/backup.tar /etc/sysconfig/
(-c = create, -v = verbose, -f = file)"

# Lab configuration
LAB_TITLE="Create tar Archive"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create an uncompressed tar archive named /tmp/backup.tar containing all files in /etc/sysconfig/" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing any existing backup.tar...${RESET}"
    rm -f /tmp/backup.tar 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if archive exists and contains sysconfig files
    if [[ -f /tmp/backup.tar ]]; then
        if tar -tf /tmp/backup.tar 2>/dev/null | grep -q 'sysconfig'; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/backup.tar 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
