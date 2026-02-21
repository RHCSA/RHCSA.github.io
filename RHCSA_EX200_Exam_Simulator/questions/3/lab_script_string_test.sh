#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Script with String Test

IS_LAB=true
LAB_ID="script_string_test"

QUESTION="[LAB] Create a script that checks if a variable is empty using -z operator"
HINT="Task 1: Create /tmp/strtest.sh with a variable VAR\nTask 2: Use if [ -z \"\$VAR\" ] to test if empty and echo appropriate message"

LAB_TITLE="Script with String Test"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create executable /tmp/strtest.sh with variable VAR" ;;
        1) echo "Script uses -z or -n to test string and outputs result" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous script...${RESET}"
    rm -f /tmp/strtest.sh 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script exists and is executable
    if [[ -f /tmp/strtest.sh ]] && [[ -x /tmp/strtest.sh ]] && grep -q 'VAR' /tmp/strtest.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if script uses -z or -n string test
    if grep -qE '\-z|\-n' /tmp/strtest.sh 2>/dev/null && grep -q 'if' /tmp/strtest.sh 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/strtest.sh 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
