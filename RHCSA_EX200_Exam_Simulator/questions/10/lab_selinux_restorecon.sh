#!/bin/bash
# Objective 10: Manage security
# LAB: Restore File Context

IS_LAB=true
LAB_ID="selinux_restorecon"

QUESTION="[LAB] Restore SELinux context on files"
HINT="Task 1: restorecon -Rv /tmp/selab/ > /tmp/restore-output.txt 2>&1\nTask 2: ls -Z /tmp/selab/ > /tmp/restored-context.txt"

LAB_TITLE="Restore File Context"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Run restorecon on /tmp/selab/ and save output" ;;
        1) echo "Save restored context to /tmp/restored-context.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test files with wrong context...${RESET}"
    rm -rf /tmp/selab 2>/dev/null
    mkdir -p /tmp/selab 2>/dev/null
    touch /tmp/selab/testfile.txt 2>/dev/null
    rm -f /tmp/restore-output.txt /tmp/restored-context.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if restore-output.txt exists
    if [[ -f /tmp/restore-output.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if restored-context.txt exists with context
    if [[ -f /tmp/restored-context.txt ]] && [[ -s /tmp/restored-context.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/selab 2>/dev/null
    rm -f /tmp/restore-output.txt /tmp/restored-context.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
