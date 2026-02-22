#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Extract tar Archive to Specific Directory

# This is a LAB exercise
IS_LAB=true
LAB_ID="tar_extract"

QUESTION="[LAB] Extract a tar archive to a specific directory"
HINT="Task 1: mkdir -p /tmp/restore
Task 2: tar -xvzf /tmp/test_archive.tar.gz -C /tmp/restore"

# Lab configuration
LAB_TITLE="Extract tar Archive"
LAB_TASK_COUNT=2

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create the directory /tmp/restore" ;;
        1) echo "Extract /tmp/test_archive.tar.gz to /tmp/restore" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test archive for extraction...${RESET}"
    rm -rf /tmp/restore 2>/dev/null
    rm -f /tmp/test_archive.tar.gz 2>/dev/null
    
    # Create test files to archive
    mkdir -p /tmp/lab_source
    echo "File 1 content" > /tmp/lab_source/file1.txt
    echo "File 2 content" > /tmp/lab_source/file2.txt
    echo "Config data" > /tmp/lab_source/config.conf
    
    # Create the test archive
    tar -czf /tmp/test_archive.tar.gz -C /tmp lab_source
    rm -rf /tmp/lab_source
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if /tmp/restore directory exists
    if [[ -d /tmp/restore ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if files were extracted to /tmp/restore
    if [[ -f /tmp/restore/lab_source/file1.txt ]] && \
       [[ -f /tmp/restore/lab_source/file2.txt ]] && \
       [[ -f /tmp/restore/lab_source/config.conf ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/restore 2>/dev/null
    rm -f /tmp/test_archive.tar.gz 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
