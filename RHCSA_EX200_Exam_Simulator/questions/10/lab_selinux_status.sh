#!/bin/bash
# Objective 10: Manage security
# LAB: View SELinux Status

IS_LAB=true
LAB_ID="selinux_status"

QUESTION="[LAB] View SELinux mode and status"
HINT="Task 1: getenforce > /tmp/selinux-mode.txt\nTask 2: sestatus > /tmp/selinux-status.txt"

LAB_TITLE="View SELinux Status"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save current SELinux mode to /tmp/selinux-mode.txt" ;;
        1) echo "Save detailed status to /tmp/selinux-status.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/selinux-mode.txt /tmp/selinux-status.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if selinux-mode.txt exists with mode
    if [[ -f /tmp/selinux-mode.txt ]] && grep -qiE 'enforcing|permissive|disabled' /tmp/selinux-mode.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if selinux-status.txt exists with status info
    if [[ -f /tmp/selinux-status.txt ]] && grep -qi 'selinux' /tmp/selinux-status.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/selinux-mode.txt /tmp/selinux-status.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
