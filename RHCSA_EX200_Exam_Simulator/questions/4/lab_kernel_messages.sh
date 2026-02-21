#!/bin/bash
# Objective 4: Operate running systems
# LAB: Kernel Messages

IS_LAB=true
LAB_ID="kernel_messages"

QUESTION="[LAB] View kernel messages using dmesg and journalctl"
HINT="Task 1: dmesg > /tmp/dmesg-output.txt\nTask 2: journalctl -k > /tmp/kernel-journal.txt"

LAB_TITLE="Kernel Messages"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save dmesg output to /tmp/dmesg-output.txt" ;;
        1) echo "Save kernel journal to /tmp/kernel-journal.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/dmesg-output.txt /tmp/kernel-journal.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if dmesg-output.txt exists with kernel messages
    if [[ -f /tmp/dmesg-output.txt ]] && [[ -s /tmp/dmesg-output.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if kernel-journal.txt exists
    if [[ -f /tmp/kernel-journal.txt ]] && [[ -s /tmp/kernel-journal.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/dmesg-output.txt /tmp/kernel-journal.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
