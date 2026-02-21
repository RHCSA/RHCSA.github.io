#!/bin/bash
# Objective 10: Manage security
# LAB: View File SELinux Context

IS_LAB=true
LAB_ID="selinux_file_context"

QUESTION="[LAB] View SELinux context of files and directories"
HINT="Task 1: ls -Z /etc/passwd > /tmp/passwd-context.txt\nTask 2: ls -dZ /var/www/html > /tmp/www-context.txt 2>/dev/null || echo 'N/A' > /tmp/www-context.txt"

LAB_TITLE="View File Context"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save /etc/passwd context to /tmp/passwd-context.txt" ;;
        1) echo "Save /var/www/html context to /tmp/www-context.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/passwd-context.txt /tmp/www-context.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if passwd-context.txt exists with context
    if [[ -f /tmp/passwd-context.txt ]] && grep -qE 'system_u|unconfined_u|passwd' /tmp/passwd-context.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if www-context.txt exists
    if [[ -f /tmp/www-context.txt ]] && [[ -s /tmp/www-context.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/passwd-context.txt /tmp/www-context.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
