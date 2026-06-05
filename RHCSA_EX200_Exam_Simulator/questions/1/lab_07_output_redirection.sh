#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Output Redirection

# This is a LAB exercise
IS_LAB=true
LAB_ID="output_redirection"

QUESTION="Practice output redirection: create files using > and >> operators"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create /tmp/myfile.txt containing 'Hello World'"
TASK_1_HINT="Use echo with > to create/overwrite file"
TASK_1_COMMAND_1="echo 'Hello World' > /tmp/myfile.txt"

# Task 2
TASK_2_QUESTION="Append 'Second Line' to /tmp/myfile.txt"
TASK_2_HINT="Use echo with >> to append to file"
TASK_2_COMMAND_1="echo 'Second Line' >> /tmp/myfile.txt"

# Task 3
TASK_3_QUESTION="Append 'Third Line' to /tmp/myfile.txt"
TASK_3_HINT="Use echo with >> to append to file"
TASK_3_COMMAND_1="echo 'Third Line' >> /tmp/myfile.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

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
