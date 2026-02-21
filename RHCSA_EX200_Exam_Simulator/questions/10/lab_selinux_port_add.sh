#!/bin/bash
# Objective 10: Manage security
# LAB: Add SELinux Port Label

IS_LAB=true
LAB_ID="selinux_port_add"

QUESTION="[LAB] Add a custom SELinux port label"
HINT="Task 1: semanage port -a -t http_port_t -p tcp 8888\nTask 2: semanage port -l | grep 8888 > /tmp/port-verify.txt"

LAB_TITLE="Add Port Label"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add http_port_t label to TCP port 8888" ;;
        1) echo "Verify port label in /tmp/port-verify.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Removing any existing port rule...${RESET}"
    semanage port -d -t http_port_t -p tcp 8888 2>/dev/null
    rm -f /tmp/port-verify.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if port 8888 is labeled http_port_t
    if semanage port -l 2>/dev/null | grep -E 'http_port_t.*8888|8888.*http_port_t' | grep -q tcp; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if port-verify.txt exists with 8888
    if [[ -f /tmp/port-verify.txt ]] && grep -q '8888' /tmp/port-verify.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Removing custom port label...${RESET}"
    semanage port -d -t http_port_t -p tcp 8888 2>/dev/null
    rm -f /tmp/port-verify.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
