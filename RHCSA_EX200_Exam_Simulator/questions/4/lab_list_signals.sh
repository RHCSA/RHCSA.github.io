#!/bin/bash
# Objective 4: Operate running systems
# LAB: List Available Signals

IS_LAB=true
LAB_ID="list_signals"

QUESTION="[LAB] List available signals and understand common ones"
HINT="Task 1: kill -l > /tmp/signals.txt\nTask 2: Create /tmp/signal-notes.txt with SIGTERM, SIGKILL, SIGHUP descriptions"

LAB_TITLE="List Available Signals"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List all signals and save to /tmp/signals.txt" ;;
        1) echo "Create /tmp/signal-notes.txt describing SIGTERM, SIGKILL, SIGHUP" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/signals.txt /tmp/signal-notes.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if signals.txt exists with signal list
    if [[ -f /tmp/signals.txt ]] && grep -qE 'TERM|KILL|HUP' /tmp/signals.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if signal-notes.txt exists with signal descriptions
    if [[ -f /tmp/signal-notes.txt ]] && grep -qiE 'term|kill|hup' /tmp/signal-notes.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/signals.txt /tmp/signal-notes.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
