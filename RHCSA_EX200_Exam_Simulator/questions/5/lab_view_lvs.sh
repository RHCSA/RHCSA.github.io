#!/bin/bash
# Objective 5: Configure local storage
# LAB: View Logical Volumes

IS_LAB=true
LAB_ID="view_lvs"

QUESTION="[LAB] Display logical volume information with lvs and lvdisplay"
HINT="Task 1: lvs > /tmp/lvs-output.txt\nTask 2: lvdisplay > /tmp/lvdisplay-output.txt"

LAB_TITLE="View Logical Volumes"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save lvs output to /tmp/lvs-output.txt" ;;
        1) echo "Save lvdisplay output to /tmp/lvdisplay-output.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/lvs-output.txt /tmp/lvdisplay-output.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if lvs-output.txt exists
    if [[ -f /tmp/lvs-output.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if lvdisplay-output.txt exists
    if [[ -f /tmp/lvdisplay-output.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/lvs-output.txt /tmp/lvdisplay-output.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
