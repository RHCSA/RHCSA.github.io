#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: View Boot Targets

IS_LAB=true
LAB_ID="boot_targets"

QUESTION="[LAB] View and save boot target information"
HINT="Task 1: systemctl get-default > /tmp/default-target.txt\nTask 2: systemctl list-units --type=target > /tmp/all-targets.txt"

LAB_TITLE="View Boot Targets"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save default boot target to /tmp/default-target.txt" ;;
        1) echo "List all targets to /tmp/all-targets.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/default-target.txt /tmp/all-targets.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if default-target.txt exists with target info
    if [[ -f /tmp/default-target.txt ]] && grep -q '\.target' /tmp/default-target.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if all-targets.txt exists with target list
    if [[ -f /tmp/all-targets.txt ]] && grep -q 'target' /tmp/all-targets.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/default-target.txt /tmp/all-targets.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
