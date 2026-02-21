#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Change File Ownership

IS_LAB=true
LAB_ID="change_ownership"

QUESTION="[LAB] Change file ownership to a specific user"
HINT="Task 1: chown nobody /tmp/labownfile.txt\nTask 2: ls -l /tmp/labownfile.txt > /tmp/owner-check.txt"

LAB_TITLE="Change File Ownership"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Change owner of /tmp/labownfile.txt to 'nobody'" ;;
        1) echo "Verify ownership and save to /tmp/owner-check.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating file with root ownership...${RESET}"
    echo "Ownership test" > /tmp/labownfile.txt
    chown root:root /tmp/labownfile.txt 2>/dev/null
    rm -f /tmp/owner-check.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if file is owned by nobody
    local owner=$(stat -c %U /tmp/labownfile.txt 2>/dev/null)
    if [[ "$owner" == "nobody" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if owner-check.txt exists
    if [[ -f /tmp/owner-check.txt ]] && grep -q 'labownfile' /tmp/owner-check.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/labownfile.txt /tmp/owner-check.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
