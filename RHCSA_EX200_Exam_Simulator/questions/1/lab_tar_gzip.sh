#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create gzip Compressed Archive

# This is a LAB exercise
IS_LAB=true
LAB_ID="tar_gzip"

QUESTION="[LAB] Create a gzip compressed tar archive"
HINT="Task 1: tar -cvzf /tmp/logs.tar.gz '/var/log/*.log'
(-z = gzip compression)"

# Lab configuration
LAB_TITLE="Create gzip Compressed Archive"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create a gzip compressed tar archive named /tmp/logs.tar.gz containing all .log files in /var/log/" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing any existing logs.tar.gz...${RESET}"
    rm -f /tmp/logs.tar.gz 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if gzip archive exists and contains .log files
    if [[ -f /tmp/logs.tar.gz ]]; then
        # Verify it's a valid gzip compressed tar archive AND contains .log files
        if tar -tzf /tmp/logs.tar.gz 2>/dev/null | grep -qE '\.log$'; then
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
    rm -f /tmp/logs.tar.gz 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
