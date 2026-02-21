#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Calculator Script with Arguments

IS_LAB=true
LAB_ID="script_calculator"

QUESTION="[LAB] Create a calculator script that adds two numbers from arguments"
HINT="Task 1: Create /tmp/calc.sh accepting two arguments \$1 and \$2\nTask 2: Script calculates sum using RESULT=\$((\$1 + \$2)) and outputs it"

LAB_TITLE="Calculator Script"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/calc.sh accepting \$1 and \$2 as numbers" ;;
        1) echo "Running '/tmp/calc.sh 5 10' outputs 15" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous script...${RESET}"
    rm -f /tmp/calc.sh 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script uses $1 and $2
    if [[ -f /tmp/calc.sh ]] && [[ -x /tmp/calc.sh ]] && \
       grep -q '\$1' /tmp/calc.sh 2>/dev/null && grep -q '\$2' /tmp/calc.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Run script with test values and check output
    local output
    output=$(/tmp/calc.sh 5 10 2>/dev/null)
    if [[ "$output" == *"15"* ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/calc.sh 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
