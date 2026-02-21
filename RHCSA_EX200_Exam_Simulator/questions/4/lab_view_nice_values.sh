#!/bin/bash
# Objective 4: Operate running systems
# LAB: View Process Nice Values

IS_LAB=true
LAB_ID="view_nice_values"

QUESTION="[LAB] View nice values of processes and save output"
HINT="Task 1: ps -eo pid,ni,comm | head -20 > /tmp/nice-values.txt\nTask 2: ps -l > /tmp/process-list.txt"

LAB_TITLE="View Process Nice Values"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save process PIDs with nice values to /tmp/nice-values.txt" ;;
        1) echo "Save long process listing to /tmp/process-list.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/nice-values.txt /tmp/process-list.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if nice-values.txt exists with NI column
    if [[ -f /tmp/nice-values.txt ]] && grep -qiE 'NI|pid|comm' /tmp/nice-values.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if process-list.txt exists with process info
    if [[ -f /tmp/process-list.txt ]] && grep -qE 'PID|NI|UID' /tmp/process-list.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/nice-values.txt /tmp/process-list.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
