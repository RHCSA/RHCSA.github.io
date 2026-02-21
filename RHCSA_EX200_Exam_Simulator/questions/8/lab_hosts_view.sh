#!/bin/bash
# Objective 8: Manage basic networking
# LAB: View Host Resolution

IS_LAB=true
LAB_ID="hosts_view"

QUESTION="[LAB] View /etc/hosts and test name resolution"
HINT="Task 1: cat /etc/hosts > /tmp/hosts-content.txt\nTask 2: getent hosts localhost > /tmp/hosts-resolve.txt"

LAB_TITLE="View Host Resolution"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Copy /etc/hosts to /tmp/hosts-content.txt" ;;
        1) echo "Resolve localhost using getent, save to /tmp/hosts-resolve.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/hosts-content.txt /tmp/hosts-resolve.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if hosts-content.txt exists with hosts file content
    if [[ -f /tmp/hosts-content.txt ]] && grep -qE 'localhost|127\.0\.0\.1' /tmp/hosts-content.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if hosts-resolve.txt exists with localhost resolution
    if [[ -f /tmp/hosts-resolve.txt ]] && grep -qE '127\.0\.0\.1|localhost' /tmp/hosts-resolve.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/hosts-content.txt /tmp/hosts-resolve.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
