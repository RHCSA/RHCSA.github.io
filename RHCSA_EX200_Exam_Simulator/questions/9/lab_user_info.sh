#!/bin/bash
# Objective 9: Manage users and groups
# LAB: View User Information

IS_LAB=true
LAB_ID="view_user_info"

QUESTION="[LAB] View detailed user information"
HINT="Task 1: getent passwd root > /tmp/passwd-info.txt\nTask 2: id root >> /tmp/passwd-info.txt"

LAB_TITLE="View User Information"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Get passwd entry for root to /tmp/passwd-info.txt" ;;
        1) echo "Append id info to /tmp/passwd-info.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/passwd-info.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if passwd-info.txt has passwd entry
    if [[ -f /tmp/passwd-info.txt ]] && grep -q 'root:' /tmp/passwd-info.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if file also has uid/gid info
    if grep -qE 'uid=|gid=' /tmp/passwd-info.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/passwd-info.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
