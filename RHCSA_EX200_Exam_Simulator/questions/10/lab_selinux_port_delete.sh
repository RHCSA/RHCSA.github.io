#!/bin/bash
# Objective 10: Manage security
# LAB: Delete SELinux Port Label

IS_LAB=true
LAB_ID="selinux_port_delete"

QUESTION="[LAB] Delete a custom SELinux port label"
HINT="Task 1: semanage port -d -t http_port_t -p tcp 9999\nTask 2: semanage port -l | grep -v 9999 | head -5 > /tmp/port-deleted.txt"

LAB_TITLE="Delete Port Label"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Delete http_port_t label from TCP port 9999" ;;
        1) echo "Verify deletion in /tmp/port-deleted.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Adding port label to delete...${RESET}"
    semanage port -a -t http_port_t -p tcp 9999 2>/dev/null || true
    rm -f /tmp/port-deleted.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if port 9999 is NOT labeled http_port_t
    if ! semanage port -l 2>/dev/null | grep -E 'http_port_t.*9999|9999.*http_port_t' | grep -q tcp; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if port-deleted.txt exists
    if [[ -f /tmp/port-deleted.txt ]] && [[ -s /tmp/port-deleted.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up...${RESET}"
    semanage port -d -t http_port_t -p tcp 9999 2>/dev/null
    rm -f /tmp/port-deleted.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
