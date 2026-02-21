#!/bin/bash
# Objective 5: Configure local storage
# LAB: View Mount Points

IS_LAB=true
LAB_ID="mount_points"

QUESTION="[LAB] Display current mount points and options"
HINT="Task 1: mount > /tmp/mounts.txt\nTask 2: findmnt > /tmp/findmnt-output.txt"

LAB_TITLE="View Mount Points"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save mount output to /tmp/mounts.txt" ;;
        1) echo "Save findmnt output to /tmp/findmnt-output.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/mounts.txt /tmp/findmnt-output.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if mounts.txt exists with mount info
    if [[ -f /tmp/mounts.txt ]] && grep -qE 'on.*type' /tmp/mounts.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if findmnt-output.txt exists
    if [[ -f /tmp/findmnt-output.txt ]] && grep -qE 'TARGET|SOURCE|/' /tmp/findmnt-output.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/mounts.txt /tmp/findmnt-output.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
