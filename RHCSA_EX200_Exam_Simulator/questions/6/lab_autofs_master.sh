#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Autofs Master Map

IS_LAB=true
LAB_ID="autofs_master"

QUESTION="[LAB] Create an autofs indirect map configuration"
HINT="Task 1: echo '/labmnt /etc/auto.labtest' >> /etc/auto.master.d/lab.autofs\nTask 2: Create /etc/auto.labtest with 'testdir -fstype=tmpfs :/'"

LAB_TITLE="Autofs Master Map"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /etc/auto.master.d/lab.autofs with /labmnt entry" ;;
        1) echo "Create /etc/auto.labtest map file" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous autofs config...${RESET}"
    rm -f /etc/auto.master.d/lab.autofs /etc/auto.labtest 2>/dev/null
    mkdir -p /etc/auto.master.d 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if master map file exists with /labmnt
    if [[ -f /etc/auto.master.d/lab.autofs ]] && grep -q '/labmnt' /etc/auto.master.d/lab.autofs 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if auto.labtest map file exists with testdir
    if [[ -f /etc/auto.labtest ]] && grep -qE 'testdir|labdir' /etc/auto.labtest 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /etc/auto.master.d/lab.autofs /etc/auto.labtest 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
