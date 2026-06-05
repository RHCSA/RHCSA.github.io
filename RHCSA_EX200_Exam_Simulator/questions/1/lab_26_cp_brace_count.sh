#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Copy Files with Brace Expansion and Count Files

# This is a LAB exercise
IS_LAB=true
LAB_ID="cp_brace_count"

QUESTION="Copy files using brace expansion and count files"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Copy files20 through files25 from /tmp/source/dir1/dir2/ to /tmp/destination/ preserving attributes and permissions"
TASK_1_HINT="Use brace expansion {20..25} to specify file range"
TASK_1_COMMAND_1="cp -arp /tmp/source/dir1/dir2/files{20..25} /tmp/destination/"

# Task 2
TASK_2_QUESTION="Count files in /tmp/destination/ and save the count to /tmp/file_count.txt"
TASK_2_HINT="Use wc -l to count lines from ls output"
TASK_2_COMMAND_1="ls /tmp/destination/ | wc -l > /tmp/file_count.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating source directory structure...${RESET}"
    rm -rf /tmp/source /tmp/destination /tmp/file_count.txt 2>/dev/null
    mkdir -p /tmp/source/dir1/dir2
    mkdir -p /tmp/destination
    
    # Create test files (files10 through files30)
    for i in {10..30}; do
        echo "Content of files$i" > /tmp/source/dir1/dir2/files$i
        chmod 644 /tmp/source/dir1/dir2/files$i
    done
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if files20 through files25 were copied to destination
    local all_copied=true
    for i in {20..25}; do
        if [[ ! -f /tmp/destination/files$i ]]; then
            all_copied=false
            break
        fi
        if ! grep -q "Content of files$i" /tmp/destination/files$i 2>/dev/null; then
            all_copied=false
            break
        fi
    done
    if [[ "$all_copied" == "true" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if file_count.txt exists and contains correct count
    if [[ -f /tmp/file_count.txt ]]; then
        local count=$(cat /tmp/file_count.txt | tr -d ' \n')
        # Should be 6 files (files20 through files25)
        if [[ "$count" == "6" ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/source /tmp/destination /tmp/file_count.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
