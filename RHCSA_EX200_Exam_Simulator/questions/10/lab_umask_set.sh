#!/bin/bash
# Objective 10: Manage security
# LAB: Set Umask Temporarily

IS_LAB=true
LAB_ID="set_umask_temp"

QUESTION="[LAB] Set umask temporarily and verify with test files"
HINT="Task 1: umask 027 (set restrictive umask)\nTask 2: touch /tmp/umask-test.txt; ls -l /tmp/umask-test.txt (should be 640)"

LAB_TITLE="Set Umask Temporarily"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set umask to 027" ;;
        1) echo "Create /tmp/umask-test.txt with resulting permissions" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/umask-test.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check current umask is 027
    local current_umask=$(umask)
    if [[ "$current_umask" == "0027" ]] || [[ "$current_umask" == "027" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if file exists with 640 or rw-r----- permissions
    if [[ -f /tmp/umask-test.txt ]]; then
        local perms=$(stat -c %a /tmp/umask-test.txt 2>/dev/null)
        if [[ "$perms" == "640" ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/umask-test.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
