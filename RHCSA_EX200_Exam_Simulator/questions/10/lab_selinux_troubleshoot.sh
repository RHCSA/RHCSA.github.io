#!/bin/bash
# Objective 10: Manage security
# LAB: SELinux Troubleshooting Commands

IS_LAB=true
LAB_ID="selinux_troubleshoot"

QUESTION="[LAB] Use SELinux troubleshooting commands"
HINT="Task 1: ausearch -m avc -ts recent > /tmp/avc-recent.txt 2>&1 || echo 'No AVCs' > /tmp/avc-recent.txt\nTask 2: sealert -a /var/log/audit/audit.log > /tmp/sealert.txt 2>&1 || echo 'N/A' > /tmp/sealert.txt"

LAB_TITLE="SELinux Troubleshooting"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Search recent AVC messages to /tmp/avc-recent.txt" ;;
        1) echo "Analyze audit log with sealert to /tmp/sealert.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/avc-recent.txt /tmp/sealert.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if avc-recent.txt exists
    if [[ -f /tmp/avc-recent.txt ]] && [[ -s /tmp/avc-recent.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if sealert.txt exists
    if [[ -f /tmp/sealert.txt ]] && [[ -s /tmp/sealert.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/avc-recent.txt /tmp/sealert.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
