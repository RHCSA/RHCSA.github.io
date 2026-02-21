#!/bin/bash
# Objective 5: Configure local storage
# LAB: Create Swap File

IS_LAB=true
LAB_ID="swap_file"

QUESTION="[LAB] Create and activate a swap file"
HINT="Task 1: dd if=/dev/zero of=/tmp/swapfile bs=1M count=128 && chmod 600 /tmp/swapfile\nTask 2: mkswap /tmp/swapfile && swapon /tmp/swapfile"

LAB_TITLE="Create Swap File"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create 128MB swap file at /tmp/swapfile with 600 permissions" ;;
        1) echo "Format and activate the swap file" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous swap file...${RESET}"
    swapoff /tmp/swapfile 2>/dev/null
    rm -f /tmp/swapfile 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if swapfile exists with correct permissions
    if [[ -f /tmp/swapfile ]]; then
        local perms=$(stat -c %a /tmp/swapfile 2>/dev/null)
        if [[ "$perms" == "600" ]]; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if swap is active
    if swapon --show | grep -q '/tmp/swapfile'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    swapoff /tmp/swapfile 2>/dev/null
    rm -f /tmp/swapfile 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
