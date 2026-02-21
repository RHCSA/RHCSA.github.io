#!/bin/bash
# Objective 5: Configure local storage
# LAB: View Swap Information

IS_LAB=true
LAB_ID="swap_info"

QUESTION="[LAB] Display swap space information"
HINT="Task 1: free -h > /tmp/free-output.txt\nTask 2: swapon --show > /tmp/swap-devices.txt"

LAB_TITLE="View Swap Information"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save memory/swap info to /tmp/free-output.txt" ;;
        1) echo "Save swap devices to /tmp/swap-devices.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/free-output.txt /tmp/swap-devices.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if free-output.txt exists with swap info
    if [[ -f /tmp/free-output.txt ]] && grep -qiE 'mem|swap|total' /tmp/free-output.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if swap-devices.txt exists
    if [[ -f /tmp/swap-devices.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/free-output.txt /tmp/swap-devices.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
