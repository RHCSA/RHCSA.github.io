#!/bin/bash
# Objective 10: Manage security
# LAB: Check Expected Context with matchpathcon

IS_LAB=true
LAB_ID="selinux_matchpathcon"

QUESTION="[LAB] Check expected SELinux context for paths"
HINT="Task 1: matchpathcon /var/www/html > /tmp/match-www.txt 2>&1\nTask 2: matchpathcon /etc/passwd > /tmp/match-passwd.txt 2>&1"

LAB_TITLE="Check Expected Context"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Check expected context for /var/www/html" ;;
        1) echo "Check expected context for /etc/passwd" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/match-www.txt /tmp/match-passwd.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if match-www.txt exists
    if [[ -f /tmp/match-www.txt ]] && [[ -s /tmp/match-www.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if match-passwd.txt exists with context
    if [[ -f /tmp/match-passwd.txt ]] && [[ -s /tmp/match-passwd.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/match-www.txt /tmp/match-passwd.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
