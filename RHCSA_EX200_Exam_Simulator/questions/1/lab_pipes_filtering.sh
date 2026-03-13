#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Pipes and Filtering

# This is a LAB exercise
IS_LAB=true
LAB_ID="pipes_filtering"

QUESTION="Use pipes to filter and process command output"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Count lines with 'nologin' in /etc/passwd, save to /tmp/nologin-count.txt"
TASK_1_HINT="Use grep to find lines and pipe to wc -l for counting"
TASK_1_COMMAND_1="grep 'nologin' /etc/passwd | wc -l > /tmp/nologin-count.txt"

# Task 2
TASK_2_QUESTION="List files containing 'conf' in /etc, sorted, save to /tmp/conf-files.txt"
TASK_2_HINT="Use ls piped to grep and then to sort"
TASK_2_COMMAND_1="ls /etc | grep 'conf' | sort > /tmp/conf-files.txt"

# Task 3
TASK_3_QUESTION="List 5 largest files in /var/log, save to /tmp/largest-logs.txt (use ls and head)"
TASK_3_HINT="Use ls -lS to sort by size and head to limit output"
TASK_3_COMMAND_1="ls -lS /var/log | head -6 > /tmp/largest-logs.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)
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
