#!/bin/bash
# Objective 4: Operate running systems
# LAB: Start Process with Nice Value

IS_LAB=true
LAB_ID="nice_start_process"

QUESTION="[LAB] Start a process with a specific nice value"
HINT="Task 1: nice -n 10 sleep 120 & (start with nice 10)\nTask 2: ps -o pid,ni,comm -p PID to verify nice value"

LAB_TITLE="Start Process with Nice"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Start 'sleep 120' with nice value 10 in background" ;;
        1) echo "Verify the process has nice value 10" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Stopping any existing lab processes...${RESET}"
    pkill -f "sleep 120" 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if sleep 120 process is running
    if pgrep -f "sleep 120" &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if the process has nice value 10
    local pid=$(pgrep -f "sleep 120" | head -1)
    if [[ -n "$pid" ]]; then
        local nice_val=$(ps -o ni= -p $pid 2>/dev/null | tr -d ' ')
        if [[ "$nice_val" == "10" ]]; then
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
    pkill -f "sleep 120" 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
