#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Tee Command

# This is a LAB exercise
IS_LAB=true
LAB_ID="tee_command"

QUESTION="[LAB] Use tee to save command output to a file while displaying it"
HINT="Task 1: df -h | tee /tmp/disk-usage.txt
Task 2: free -m | tee -a /tmp/disk-usage.txt (-a = append)"

# Lab configuration
LAB_TITLE="Tee Command"
LAB_TASK_COUNT=2

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Run 'df -h' and use tee to both display the output and save it to /tmp/disk-usage.txt" ;;
        1) echo "Append 'free -m' output to /tmp/disk-usage.txt using tee -a" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM} Removing existing file...${RESET}"
    rm -f /tmp/disk-usage.txt 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if file exists and contains df output (Filesystem, Size, Used, etc)
    if [[ -f /tmp/disk-usage.txt ]] && grep -qE "(Filesystem|Size|Used|Avail)" /tmp/disk-usage.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if file also contains free output (Mem, total, free, etc)
    if grep -qE "(Mem|total|free|used|buff)" /tmp/disk-usage.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM} Cleaning up lab environment...${RESET}"
    rm -f /tmp/disk-usage.txt 2>/dev/null
    echo -e "  ${GREEN} Lab environment cleaned up${RESET}"
    sleep 1
}
