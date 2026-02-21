#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Directory Check Script

IS_LAB=true
LAB_ID="script_dir_check"

QUESTION="[LAB] Create a script that checks if directory exists, creates if not"
HINT="Task 1: Create /tmp/dircheck.sh that tests with if [ -d /tmp/mydir ]\nTask 2: Script creates /tmp/mydir if it doesn't exist"

LAB_TITLE="Directory Check Script"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/dircheck.sh that checks if directory exists" ;;
        1) echo "Running script creates /tmp/mydir directory" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous files...${RESET}"
    rm -f /tmp/dircheck.sh 2>/dev/null
    rm -rf /tmp/mydir 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script uses -d directory test
    if [[ -f /tmp/dircheck.sh ]] && [[ -x /tmp/dircheck.sh ]] && grep -q '\-d' /tmp/dircheck.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Run script and check if directory was created
    /tmp/dircheck.sh 2>/dev/null
    if [[ -d /tmp/mydir ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/dircheck.sh 2>/dev/null
    rm -rf /tmp/mydir 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
