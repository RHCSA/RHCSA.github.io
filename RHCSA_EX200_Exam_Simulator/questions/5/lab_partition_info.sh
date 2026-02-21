#!/bin/bash
# Objective 5: Configure local storage
# LAB: View Partition Information

IS_LAB=true
LAB_ID="partition_info"

QUESTION="[LAB] View partition information using fdisk and parted"
HINT="Task 1: fdisk -l > /tmp/fdisk-output.txt\nTask 2: parted -l > /tmp/parted-output.txt (may need sudo)"

LAB_TITLE="View Partition Information"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save fdisk -l output to /tmp/fdisk-output.txt" ;;
        1) echo "Save parted -l output to /tmp/parted-output.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/fdisk-output.txt /tmp/parted-output.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if fdisk-output.txt exists with partition info
    if [[ -f /tmp/fdisk-output.txt ]] && grep -qiE 'disk|device|sector' /tmp/fdisk-output.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if parted-output.txt exists with partition info
    if [[ -f /tmp/parted-output.txt ]] && grep -qiE 'model|partition|disk' /tmp/parted-output.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/fdisk-output.txt /tmp/parted-output.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
