#!/bin/bash
# Objective 5: Configure local storage
# LAB: View Volume Groups

IS_LAB=true
LAB_ID="view_vgs"

QUESTION="[LAB] Display volume group information with vgs and vgdisplay"
HINT="Task 1: vgs > /tmp/vgs-output.txt\nTask 2: vgdisplay > /tmp/vgdisplay-output.txt"

LAB_TITLE="View Volume Groups"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save vgs output to /tmp/vgs-output.txt" ;;
        1) echo "Save vgdisplay output to /tmp/vgdisplay-output.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/vgs-output.txt /tmp/vgdisplay-output.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if vgs-output.txt exists
    if [[ -f /tmp/vgs-output.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if vgdisplay-output.txt exists
    if [[ -f /tmp/vgdisplay-output.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/vgs-output.txt /tmp/vgdisplay-output.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
