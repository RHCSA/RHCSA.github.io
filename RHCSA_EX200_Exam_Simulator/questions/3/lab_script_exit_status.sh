#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Exit Status Script

IS_LAB=true
LAB_ID="script_exit_status"

QUESTION="[LAB] Create a script that checks exit status of commands using \$?"
HINT="Task 1: Create /tmp/exitcheck.sh that runs a command and checks \$?\nTask 2: Script exits 0 on success, 1 on failure"

LAB_TITLE="Exit Status Script"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/exitcheck.sh that uses \$? to check exit status" ;;
        1) echo "Script returns appropriate exit code based on check" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous script...${RESET}"
    rm -f /tmp/exitcheck.sh 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script uses $? exit status
    if [[ -f /tmp/exitcheck.sh ]] && [[ -x /tmp/exitcheck.sh ]] && grep -q '\$?' /tmp/exitcheck.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if script uses exit command
    if grep -q 'exit' /tmp/exitcheck.sh 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/exitcheck.sh 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
