#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: View GRUB Configuration

IS_LAB=true
LAB_ID="grub_config"

QUESTION="[LAB] View GRUB2 bootloader configuration"
HINT="Task 1: cat /etc/default/grub > /tmp/grub-default.txt\nTask 2: grubby --info=DEFAULT > /tmp/grub-default-kernel.txt"

LAB_TITLE="View GRUB Configuration"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Copy /etc/default/grub to /tmp/grub-default.txt" ;;
        1) echo "Save default kernel info to /tmp/grub-default-kernel.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/grub-default.txt /tmp/grub-default-kernel.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if grub-default.txt exists with GRUB config
    if [[ -f /tmp/grub-default.txt ]] && grep -q 'GRUB' /tmp/grub-default.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if grub-default-kernel.txt exists
    if [[ -f /tmp/grub-default-kernel.txt ]] && [[ -s /tmp/grub-default-kernel.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/grub-default.txt /tmp/grub-default-kernel.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
