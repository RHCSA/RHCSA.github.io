#!/bin/bash
# Objective 2: Manage software
# LAB: Find Package That Provides a File

IS_LAB=true
LAB_ID="rpm_provides"

QUESTION="[LAB] Find which package provides a specific file and save results"
HINT="Task 1: rpm -qf /etc/passwd > /tmp/passwd-pkg.txt\nTask 2: dnf provides /usr/bin/wget > /tmp/wget-pkg.txt"

LAB_TITLE="Find Package That Provides File"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Find package owning /etc/passwd and save to /tmp/passwd-pkg.txt" ;;
        1) echo "Find package providing /usr/bin/wget and save to /tmp/wget-pkg.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/passwd-pkg.txt /tmp/wget-pkg.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if passwd-pkg.txt exists and contains setup or filesystem package
    if [[ -f /tmp/passwd-pkg.txt ]] && grep -qi 'setup\|filesystem' /tmp/passwd-pkg.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if wget-pkg.txt exists and contains wget
    if [[ -f /tmp/wget-pkg.txt ]] && grep -qi 'wget' /tmp/wget-pkg.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/passwd-pkg.txt /tmp/wget-pkg.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
