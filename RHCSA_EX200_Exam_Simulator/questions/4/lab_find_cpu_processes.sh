#!/bin/bash
# Objective 4: Operate running systems
# LAB: Find CPU Intensive Processes

IS_LAB=true
LAB_ID="find_cpu_processes"

QUESTION="[LAB] Find and list CPU-intensive processes sorted by usage"
HINT="Task 1: ps aux --sort=-%cpu | head -11 > /tmp/top-cpu.txt\nTask 2: ps aux --sort=-%mem | head -11 > /tmp/top-mem.txt"

LAB_TITLE="Find CPU Intensive Processes"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save top 10 CPU-consuming processes to /tmp/top-cpu.txt" ;;
        1) echo "Save top 10 memory-consuming processes to /tmp/top-mem.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/top-cpu.txt /tmp/top-mem.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if top-cpu.txt exists with process info
    if [[ -f /tmp/top-cpu.txt ]] && grep -qE 'PID|USER|%CPU' /tmp/top-cpu.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if top-mem.txt exists with process info
    if [[ -f /tmp/top-mem.txt ]] && grep -qE 'PID|USER|%MEM' /tmp/top-mem.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/top-cpu.txt /tmp/top-mem.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
