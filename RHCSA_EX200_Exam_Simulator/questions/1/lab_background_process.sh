#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Run Command in Background

# This is a LAB exercise
IS_LAB=true
LAB_ID="background_process"

QUESTION="[LAB] Start a long-running process in the background that continues running after logout"
HINT="Task 1: nohup sleep 300 & (or sleep 300 &)
Task 2: nohup ensures process survives logout (or use disown)"

# Lab configuration
LAB_TITLE="Run Command in Background"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Start 'sleep 300' as a background process" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM} Killing any existing sleep processes...${RESET}"
    pkill -f "sleep 300" 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if sleep 300 is running in background
    if pgrep -f "sleep 300" >/dev/null 2>&1; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM} Cleaning up lab environment...${RESET}"
    
    # Kill the sleep process
    pkill -f "sleep 300" 2>/dev/null
    
    echo -e "  ${GREEN} Lab environment cleaned up${RESET}"
    sleep 1
}
