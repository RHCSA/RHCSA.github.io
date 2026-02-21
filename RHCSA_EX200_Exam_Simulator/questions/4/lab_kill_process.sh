#!/bin/bash
# Objective 4: Operate running systems
# LAB: Kill Background Process

IS_LAB=true
LAB_ID="kill_process"

QUESTION="[LAB] Start a background process and kill it"
HINT="Task 1: Start with sleep 300 & and note PID\nTask 2: kill PID to terminate the process"

LAB_TITLE="Kill Background Process"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Start 'sleep 300' in background (sleep 300 &)" ;;
        1) echo "Kill the sleep process using kill command" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating background process marker...${RESET}"
    pkill -f "sleep 300" 2>/dev/null
    touch /tmp/.kill_lab_started
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if sleep process was started (marker exists means lab started)
    # We check if the lab was started and the process either exists or was killed
    if [[ -f /tmp/.kill_lab_started ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if no sleep 300 process is running (it was killed)
    if ! pgrep -f "sleep 300" &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    pkill -f "sleep 300" 2>/dev/null
    rm -f /tmp/.kill_lab_started 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
