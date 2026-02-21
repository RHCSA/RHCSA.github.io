#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Loop Through Config Files

IS_LAB=true
LAB_ID="script_loop_files"

QUESTION="[LAB] Create a script that loops through .conf files in /etc"
HINT="Task 1: Create /tmp/conflist.sh using for file in /etc/*.conf; do\nTask 2: Script saves list of .conf files to /tmp/configs.txt"

LAB_TITLE="Loop Through Config Files"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/conflist.sh with for loop over /etc/*.conf" ;;
        1) echo "Script saves config file paths to /tmp/configs.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous files...${RESET}"
    rm -f /tmp/conflist.sh /tmp/configs.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script uses for loop with glob pattern
    if [[ -f /tmp/conflist.sh ]] && [[ -x /tmp/conflist.sh ]] && \
       grep -q 'for' /tmp/conflist.sh 2>/dev/null && grep -q '\*.conf' /tmp/conflist.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Run script and check output
    /tmp/conflist.sh 2>/dev/null
    if [[ -f /tmp/configs.txt ]] && grep -q '\.conf' /tmp/configs.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/conflist.sh /tmp/configs.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
