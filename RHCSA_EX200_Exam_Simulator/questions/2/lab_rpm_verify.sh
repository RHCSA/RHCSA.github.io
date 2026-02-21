#!/bin/bash
# Objective 2: Manage software
# LAB: Verify Package Integrity with RPM

IS_LAB=true
LAB_ID="rpm_verify"

QUESTION="[LAB] Verify package integrity and save verification output"
HINT="Task 1: rpm -V bash > /tmp/bash-verify.txt 2>&1 (empty=OK)\nTask 2: rpm -Va > /tmp/all-verify.txt 2>&1 (verify all packages)"

LAB_TITLE="Verify Package Integrity"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Verify bash package integrity and save to /tmp/bash-verify.txt" ;;
        1) echo "Verify all packages and save output to /tmp/all-verify.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/bash-verify.txt /tmp/all-verify.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if bash-verify.txt file was created
    if [[ -f /tmp/bash-verify.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if all-verify.txt exists and has content (or is empty which is valid)
    if [[ -f /tmp/all-verify.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/bash-verify.txt /tmp/all-verify.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
