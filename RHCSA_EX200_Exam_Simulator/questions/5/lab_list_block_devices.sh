#!/bin/bash
# Objective 5: Configure local storage
# LAB: List Block Devices

IS_LAB=true
LAB_ID="list_block_devices"

QUESTION="[LAB] List block devices and save output to files"
HINT="Task 1: lsblk > /tmp/block-devices.txt\nTask 2: lsblk -f > /tmp/block-fs.txt"

LAB_TITLE="List Block Devices"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List block devices and save to /tmp/block-devices.txt" ;;
        1) echo "List with filesystem info to /tmp/block-fs.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/block-devices.txt /tmp/block-fs.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if block-devices.txt exists with device info
    if [[ -f /tmp/block-devices.txt ]] && grep -qE 'NAME|disk|part|lvm' /tmp/block-devices.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if block-fs.txt exists with fs info
    if [[ -f /tmp/block-fs.txt ]] && grep -qE 'FSTYPE|NAME|UUID' /tmp/block-fs.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/block-devices.txt /tmp/block-fs.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
