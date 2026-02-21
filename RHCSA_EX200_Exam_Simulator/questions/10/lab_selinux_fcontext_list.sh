#!/bin/bash
# Objective 10: Manage security
# LAB: View SELinux File Context Rules

IS_LAB=true
LAB_ID="selinux_fcontext_list"

QUESTION="[LAB] List SELinux file context rules"
HINT="Task 1: semanage fcontext -l | grep '/var/www' > /tmp/fcontext-www.txt\nTask 2: semanage fcontext -l | head -50 > /tmp/fcontext-list.txt"

LAB_TITLE="View File Context Rules"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List /var/www context rules to /tmp/fcontext-www.txt" ;;
        1) echo "List first 50 rules to /tmp/fcontext-list.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/fcontext-www.txt /tmp/fcontext-list.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if fcontext-www.txt exists with www context
    if [[ -f /tmp/fcontext-www.txt ]] && [[ -s /tmp/fcontext-www.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if fcontext-list.txt exists with rules
    if [[ -f /tmp/fcontext-list.txt ]] && grep -qE '_t:' /tmp/fcontext-list.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/fcontext-www.txt /tmp/fcontext-list.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
