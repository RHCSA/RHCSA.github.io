#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: View Kernel Boot Entries

IS_LAB=true
LAB_ID="grub_entries"

QUESTION="[LAB] List kernel boot entries"
HINT="Task 1: grubby --info=ALL > /tmp/all-kernels.txt\nTask 2: ls /boot/loader/entries/ > /tmp/bls-entries.txt"

LAB_TITLE="View Kernel Entries"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List all kernel entries to /tmp/all-kernels.txt" ;;
        1) echo "List BLS entries to /tmp/bls-entries.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/all-kernels.txt /tmp/bls-entries.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if all-kernels.txt exists with kernel info
    if [[ -f /tmp/all-kernels.txt ]] && grep -qiE 'kernel|vmlinuz|title' /tmp/all-kernels.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if bls-entries.txt exists
    if [[ -f /tmp/bls-entries.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/all-kernels.txt /tmp/bls-entries.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
