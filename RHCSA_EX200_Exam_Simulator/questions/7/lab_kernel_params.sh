#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: View Running Kernel Parameters

IS_LAB=true
LAB_ID="kernel_params"

QUESTION="[LAB] View current kernel command line parameters"
HINT="Task 1: cat /proc/cmdline > /tmp/cmdline.txt\nTask 2: grubby --default-kernel > /tmp/default-kernel.txt"

LAB_TITLE="View Kernel Parameters"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save running kernel cmdline to /tmp/cmdline.txt" ;;
        1) echo "Save default kernel path to /tmp/default-kernel.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/cmdline.txt /tmp/default-kernel.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if cmdline.txt exists with kernel params
    if [[ -f /tmp/cmdline.txt ]] && grep -qE 'root=|rd\.' /tmp/cmdline.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if default-kernel.txt exists
    if [[ -f /tmp/default-kernel.txt ]] && grep -qiE 'vmlinuz|boot' /tmp/default-kernel.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/cmdline.txt /tmp/default-kernel.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
