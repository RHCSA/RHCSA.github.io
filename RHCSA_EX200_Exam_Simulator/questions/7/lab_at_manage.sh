#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: List and Remove at Jobs

IS_LAB=true
LAB_ID="at_manage_jobs"

QUESTION="[LAB] List pending at jobs and remove a specific job"
HINT="Task 1: atq > /tmp/at-list.txt (list all pending jobs)\nTask 2: atrm JOB_NUMBER to remove the job, then verify"

LAB_TITLE="Manage at Jobs"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List pending at jobs to /tmp/at-list.txt" ;;
        1) echo "Remove all pending at jobs (no jobs in atq)" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating sample at jobs...${RESET}"
    rm -f /tmp/at-list.txt 2>/dev/null
    # Schedule some test jobs
    echo "echo test1" | at now + 2 hours 2>/dev/null
    echo "echo test2" | at now + 3 hours 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if at-list.txt exists with job info
    if [[ -f /tmp/at-list.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if no pending at jobs exist
    if ! atq 2>/dev/null | grep -qE '[0-9]'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    for job in $(atq 2>/dev/null | awk '{print $1}'); do
        atrm "$job" 2>/dev/null
    done
    rm -f /tmp/at-list.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
