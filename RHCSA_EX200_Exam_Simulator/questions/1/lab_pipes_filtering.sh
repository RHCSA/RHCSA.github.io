#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Pipes and Filtering

# This is a LAB exercise
IS_LAB=true
LAB_ID="pipes_filtering"

QUESTION="[LAB] Use pipes to filter and process command output"
HINT="This lab has 3 tasks:\n\n1. Count nologin users:\n   grep 'nologin' /etc/passwd | wc -l > /tmp/nologin-count.txt\n\n2. List files containing 'conf' in /etc, sorted:\n   ls /etc | grep 'conf' | sort > /tmp/conf-files.txt\n\n3. List 5 largest files in /var/log:\n   ls -lS /var/log | head -6 > /tmp/largest-logs.txt\n\nTip: | pipes output to next command."

# Lab configuration
LAB_TITLE="Pipes and Filtering"
LAB_TASK_COUNT=3

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Count lines with 'nologin' in /etc/passwd, save to /tmp/nologin-count.txt" ;;
        1) echo "List files containing 'conf' in /etc, sorted, save to /tmp/conf-files.txt" ;;
        2) echo "List 5 largest files in /var/log, save to /tmp/largest-logs.txt (use ls and tail)" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM} Removing existing files...${RESET}"
    rm -f /tmp/nologin-count.txt /tmp/conf-files.txt /tmp/largest-logs.txt 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check nologin count file exists and contains a number
    if [[ -f /tmp/nologin-count.txt ]] && grep -qE "^[0-9]+$" /tmp/nologin-count.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check conf-files.txt exists and contains conf entries
    if [[ -f /tmp/conf-files.txt ]] && grep -q "conf" /tmp/conf-files.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check largest-logs.txt exists and has content
    if [[ -f /tmp/largest-logs.txt ]] && [[ -s /tmp/largest-logs.txt ]]; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM} Cleaning up lab environment...${RESET}"
    rm -f /tmp/nologin-count.txt /tmp/conf-files.txt /tmp/largest-logs.txt 2>/dev/null
    echo -e "  ${GREEN} Lab environment cleaned up${RESET}"
    sleep 1
}
