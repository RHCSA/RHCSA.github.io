#!/bin/bash
# Objective 10: Manage security
# LAB: Umask Calculation Verification

IS_LAB=true
LAB_ID="umask_calc"

QUESTION="[LAB] Verify umask effect by creating files with different umasks"
HINT="Task 1: umask 022; touch /tmp/umask022.txt; stat -c %a /tmp/umask022.txt > /tmp/perms022.txt\nTask 2: umask 077; touch /tmp/umask077.txt; stat -c %a /tmp/umask077.txt > /tmp/perms077.txt"

LAB_TITLE="Umask Calculation"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create file with umask 022, save perms to /tmp/perms022.txt" ;;
        1) echo "Create file with umask 077, save perms to /tmp/perms077.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous files...${RESET}"
    rm -f /tmp/umask022.txt /tmp/umask077.txt /tmp/perms022.txt /tmp/perms077.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if perms022.txt exists with 644 (666-022)
    if [[ -f /tmp/perms022.txt ]] && grep -q '644' /tmp/perms022.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if perms077.txt exists with 600 (666-077=600, considering intersection)
    if [[ -f /tmp/perms077.txt ]] && grep -q '600' /tmp/perms077.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/umask022.txt /tmp/umask077.txt /tmp/perms022.txt /tmp/perms077.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
