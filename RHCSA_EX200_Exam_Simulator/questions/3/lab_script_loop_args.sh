#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Loop Through Arguments

IS_LAB=true
LAB_ID="script_loop_args"

QUESTION="[LAB] Create a script that loops through all arguments using \$@ or \$*"
HINT="Task 1: Create /tmp/loopargs.sh using for arg in \"\$@\"; do ... done\nTask 2: Script processes each argument and saves to /tmp/args_output.txt"

LAB_TITLE="Loop Through Arguments"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/loopargs.sh with for loop over \$@" ;;
        1) echo "Running script with args saves each to /tmp/args_output.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous files...${RESET}"
    rm -f /tmp/loopargs.sh /tmp/args_output.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script exists and uses $@ or $*
    if [[ -f /tmp/loopargs.sh ]] && [[ -x /tmp/loopargs.sh ]] && \
       grep -qE '\$@|\$\*' /tmp/loopargs.sh 2>/dev/null && grep -q 'for' /tmp/loopargs.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Run the script and check output
    /tmp/loopargs.sh apple banana cherry 2>/dev/null
    if [[ -f /tmp/args_output.txt ]] && grep -q 'apple' /tmp/args_output.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/loopargs.sh /tmp/args_output.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
