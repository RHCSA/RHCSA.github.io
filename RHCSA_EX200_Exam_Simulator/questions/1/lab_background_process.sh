#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Run Command in Background

# This is a LAB exercise
IS_LAB=true
LAB_ID="background_process"

QUESTION="[LAB] Start a long-running process in the background that continues running after logout"
HINT="This lab has 2 tasks:\n\n1. Start a background process: Run 'sleep 300' in the background using:\n   sleep 300 &\n   Or better: nohup sleep 300 &\n\n2. Ensure it survives logout: The 'nohup' command prevents the process from being killed when you log out.\n   Alternative: Run 'sleep 300 &' then 'disown'\n\nTip: Use 'jobs' to see background jobs in current shell.\nUse 'ps aux | grep sleep' to verify the process is running."

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
