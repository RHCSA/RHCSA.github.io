#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Default Value for Parameter

IS_LAB=true
LAB_ID="script_default_value"

QUESTION="[LAB] Create a script that uses default value if no argument provided"
HINT="Task 1: Create /tmp/default.sh using NAME=\${1:-Guest}\nTask 2: Script outputs 'Hello, Guest!' when run without args"

LAB_TITLE="Default Value Parameter"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/default.sh using \${1:-defaultvalue} syntax" ;;
        1) echo "Running without args outputs greeting with default name" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous script...${RESET}"
    rm -f /tmp/default.sh 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script uses ${:-} default value syntax
    if [[ -f /tmp/default.sh ]] && [[ -x /tmp/default.sh ]] && grep -qE '\$\{[^}]+:-' /tmp/default.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Run script without params and check output
    local output
    output=$(/tmp/default.sh 2>/dev/null)
    if [[ -n "$output" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/default.sh 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
