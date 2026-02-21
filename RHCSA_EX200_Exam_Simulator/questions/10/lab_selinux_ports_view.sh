#!/bin/bash
# Objective 10: Manage security
# LAB: View SELinux Port Labels

IS_LAB=true
LAB_ID="selinux_ports_view"

QUESTION="[LAB] View SELinux port labels"
HINT="Task 1: semanage port -l | grep http > /tmp/http-ports.txt\nTask 2: semanage port -l | grep ssh > /tmp/ssh-ports.txt"

LAB_TITLE="View Port Labels"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List HTTP port labels to /tmp/http-ports.txt" ;;
        1) echo "List SSH port labels to /tmp/ssh-ports.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/http-ports.txt /tmp/ssh-ports.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if http-ports.txt exists with port info
    if [[ -f /tmp/http-ports.txt ]] && grep -qE 'http.*tcp|http.*80' /tmp/http-ports.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if ssh-ports.txt exists with port info
    if [[ -f /tmp/ssh-ports.txt ]] && grep -qE 'ssh.*tcp|ssh.*22' /tmp/ssh-ports.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/http-ports.txt /tmp/ssh-ports.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
