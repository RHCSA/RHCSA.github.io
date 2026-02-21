#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Script with Numeric Comparison

IS_LAB=true
LAB_ID="script_numeric_compare"

QUESTION="[LAB] Create a script that compares two numbers and outputs the larger one"
HINT="Task 1: Create /tmp/compare.sh with two variables NUM1=10 and NUM2=20\nTask 2: Use if [ \$NUM1 -gt \$NUM2 ] to compare and echo the result"

LAB_TITLE="Script with Numeric Comparison"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create executable /tmp/compare.sh with variables NUM1 and NUM2" ;;
        1) echo "Script uses -gt, -lt, or -eq to compare and prints result" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous script...${RESET}"
    rm -f /tmp/compare.sh 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script exists with NUM1 and NUM2 variables
    if [[ -f /tmp/compare.sh ]] && [[ -x /tmp/compare.sh ]] && \
       grep -q 'NUM1' /tmp/compare.sh 2>/dev/null && grep -q 'NUM2' /tmp/compare.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if script uses numeric comparison
    if grep -qE '\-gt|\-lt|\-eq|\-ge|\-le|\-ne' /tmp/compare.sh 2>/dev/null && grep -q 'if' /tmp/compare.sh 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/compare.sh 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
