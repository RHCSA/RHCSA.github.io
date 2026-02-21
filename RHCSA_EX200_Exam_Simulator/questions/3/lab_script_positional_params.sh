#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Script with Positional Parameters

IS_LAB=true
LAB_ID="script_positional_params"

QUESTION="[LAB] Create a script that uses positional parameters \$1, \$2"
HINT="Task 1: Create /tmp/greet.sh that accepts a name as \$1\nTask 2: Script echoes 'Hello, \$1!' when run with argument"

LAB_TITLE="Positional Parameters"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create executable /tmp/greet.sh that uses \$1" ;;
        1) echo "Running '/tmp/greet.sh World' outputs 'Hello, World!'" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous script...${RESET}"
    rm -f /tmp/greet.sh 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script exists and uses $1
    if [[ -f /tmp/greet.sh ]] && [[ -x /tmp/greet.sh ]] && grep -q '\$1' /tmp/greet.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if script outputs correctly when run
    local output
    output=$(/tmp/greet.sh World 2>/dev/null)
    if [[ "$output" == *"Hello"* ]] && [[ "$output" == *"World"* ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/greet.sh 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
