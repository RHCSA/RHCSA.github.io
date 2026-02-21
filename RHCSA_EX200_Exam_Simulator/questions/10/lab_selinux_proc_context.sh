#!/bin/bash
# Objective 10: Manage security
# LAB: View Process SELinux Context

IS_LAB=true
LAB_ID="selinux_proc_context"

QUESTION="[LAB] View SELinux context of running processes"
HINT="Task 1: ps -eZ > /tmp/process-contexts.txt\nTask 2: id -Z > /tmp/user-context.txt"

LAB_TITLE="View Process Context"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save all process contexts to /tmp/process-contexts.txt" ;;
        1) echo "Save current user context to /tmp/user-context.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/process-contexts.txt /tmp/user-context.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if process-contexts.txt exists with context info
    if [[ -f /tmp/process-contexts.txt ]] && grep -qE 'system_u|unconfined_u|_t:' /tmp/process-contexts.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if user-context.txt exists with user context
    if [[ -f /tmp/user-context.txt ]] && grep -qE '_u:.*_r:.*_t:' /tmp/user-context.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/process-contexts.txt /tmp/user-context.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
