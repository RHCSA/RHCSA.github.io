#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Read File Line by Line

IS_LAB=true
LAB_ID="script_read_file"

QUESTION="[LAB] Create a script that reads a file line by line using while read"
HINT="Task 1: Create /tmp/readlines.sh using while read line; do ... done < /etc/hosts\nTask 2: Script saves line count to /tmp/linecount.txt"

LAB_TITLE="Read File Line by Line"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/readlines.sh with 'while read' loop" ;;
        1) echo "Script reads /etc/hosts and saves count to /tmp/linecount.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous files...${RESET}"
    rm -f /tmp/readlines.sh /tmp/linecount.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script exists and contains while read pattern
    if [[ -f /tmp/readlines.sh ]] && [[ -x /tmp/readlines.sh ]] && \
       grep -q 'while' /tmp/readlines.sh 2>/dev/null && grep -q 'read' /tmp/readlines.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if linecount.txt exists and contains a number
    if [[ -f /tmp/linecount.txt ]] && grep -qE '^[0-9]+$' /tmp/linecount.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/readlines.sh /tmp/linecount.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
