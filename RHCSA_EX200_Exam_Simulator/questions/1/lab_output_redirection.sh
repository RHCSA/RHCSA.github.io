#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Output Redirection

# This is a LAB exercise
IS_LAB=true
LAB_ID="output_redirection"

QUESTION="[LAB] Practice output redirection: create files using > and >> operators"
HINT="Task 1: echo 'Hello World' > /tmp/myfile.txt
Task 2: echo 'Second Line' >> /tmp/myfile.txt
Task 3: echo 'Third Line' >> /tmp/myfile.txt"

# Lab configuration
LAB_TITLE="Output Redirection (> and >>)"
LAB_TASK_COUNT=3

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/myfile.txt containing 'Hello World'" ;;
        1) echo "Append 'Second Line' to /tmp/myfile.txt" ;;
        2) echo "Append 'Third Line' to /tmp/myfile.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM} Removing existing file...${RESET}"
    rm -f /tmp/myfile.txt 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if file exists and contains 'Hello World'
    if [[ -f /tmp/myfile.txt ]] && grep -q "Hello World" /tmp/myfile.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if file contains 'Second Line'
    if grep -q "Second Line" /tmp/myfile.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check if file contains 'Third Line'
    if grep -q "Third Line" /tmp/myfile.txt 2>/dev/null; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM} Cleaning up lab environment...${RESET}"
    rm -f /tmp/myfile.txt 2>/dev/null
    echo -e "  ${GREEN} Lab environment cleaned up${RESET}"
    sleep 1
}
