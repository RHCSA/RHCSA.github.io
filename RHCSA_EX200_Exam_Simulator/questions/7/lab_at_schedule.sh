#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Schedule at Job

IS_LAB=true
LAB_ID="schedule_at_job"

QUESTION="[LAB] Schedule a one-time job using at command"
HINT="Task 1: echo 'date > /tmp/at-ran.txt' | at now + 1 minute\nTask 2: atq > /tmp/at-queue.txt (list pending jobs)"

LAB_TITLE="Schedule at Job"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Schedule a job with at to create /tmp/at-ran.txt" ;;
        1) echo "List pending at jobs to /tmp/at-queue.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/at-ran.txt /tmp/at-queue.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if an at job is scheduled or already ran
    if atq 2>/dev/null | grep -qE '[0-9]' || [[ -f /tmp/at-ran.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if at-queue.txt exists
    if [[ -f /tmp/at-queue.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    # Remove pending at jobs for this lab
    for job in $(atq 2>/dev/null | awk '{print $1}'); do
        atrm "$job" 2>/dev/null
    done
    rm -f /tmp/at-ran.txt /tmp/at-queue.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
