#!/bin/bash
# Objective 5: Configure local storage
# LAB: View Physical Volumes

IS_LAB=true
LAB_ID="view_pvs"

QUESTION="[LAB] Display physical volume information with pvs and pvdisplay"
HINT="Task 1: pvs > /tmp/pvs-output.txt\nTask 2: pvdisplay > /tmp/pvdisplay-output.txt"

LAB_TITLE="View Physical Volumes"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save pvs output to /tmp/pvs-output.txt" ;;
        1) echo "Save pvdisplay output to /tmp/pvdisplay-output.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/pvs-output.txt /tmp/pvdisplay-output.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if pvs-output.txt exists
    if [[ -f /tmp/pvs-output.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if pvdisplay-output.txt exists
    if [[ -f /tmp/pvdisplay-output.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/pvs-output.txt /tmp/pvdisplay-output.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
