#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: While Loop Script

IS_LAB=true
LAB_ID="script_while_loop"

QUESTION="[LAB] Create a script with a while loop that counts to 5"
HINT="Task 1: Create /tmp/counter.sh with while [ \$count -le 5 ]\nTask 2: Script outputs count and saves to /tmp/count_output.txt"

LAB_TITLE="While Loop Script"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/counter.sh with a while loop" ;;
        1) echo "Script counts 1-5, saves output to /tmp/count_output.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous files...${RESET}"
    rm -f /tmp/counter.sh /tmp/count_output.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script exists and contains while loop
    if [[ -f /tmp/counter.sh ]] && [[ -x /tmp/counter.sh ]] && grep -q 'while' /tmp/counter.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if output file contains numbers
    if [[ -f /tmp/count_output.txt ]] && grep -q '5' /tmp/count_output.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/counter.sh /tmp/count_output.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
