#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Validate Argument Count

IS_LAB=true
LAB_ID="script_arg_validation"

QUESTION="[LAB] Create a script that validates the number of arguments passed"
HINT="Task 1: Create /tmp/validate.sh that checks if \$# equals required count\nTask 2: Exit with error code 1 if wrong number of arguments"

LAB_TITLE="Validate Argument Count"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/validate.sh that checks \$# for argument count" ;;
        1) echo "Script exits with code 1 if called without 2 arguments" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous script...${RESET}"
    rm -f /tmp/validate.sh 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script exists and checks $#
    if [[ -f /tmp/validate.sh ]] && [[ -x /tmp/validate.sh ]] && grep -q '\$#' /tmp/validate.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if script exits with error when wrong args
    /tmp/validate.sh 2>/dev/null
    local exit_code=$?
    if [[ $exit_code -eq 1 ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/validate.sh 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
