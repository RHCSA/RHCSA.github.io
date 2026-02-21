#!/bin/bash
# Objective 5: Configure local storage
# LAB: Scan for LVM Components

IS_LAB=true
LAB_ID="lvm_scan"

QUESTION="[LAB] Scan system for LVM physical volumes, volume groups, and logical volumes"
HINT="Task 1: pvscan > /tmp/pvscan.txt; vgscan > /tmp/vgscan.txt\nTask 2: lvscan > /tmp/lvscan.txt"

LAB_TITLE="Scan for LVM Components"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Run pvscan and vgscan, save to /tmp/pvscan.txt and /tmp/vgscan.txt" ;;
        1) echo "Run lvscan and save to /tmp/lvscan.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/pvscan.txt /tmp/vgscan.txt /tmp/lvscan.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if pvscan.txt and vgscan.txt exist
    if [[ -f /tmp/pvscan.txt ]] && [[ -f /tmp/vgscan.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if lvscan.txt exists
    if [[ -f /tmp/lvscan.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/pvscan.txt /tmp/vgscan.txt /tmp/lvscan.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
