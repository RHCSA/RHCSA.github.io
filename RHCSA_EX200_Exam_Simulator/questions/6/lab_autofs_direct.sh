#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Autofs Direct Map

IS_LAB=true
LAB_ID="autofs_direct"

QUESTION="[LAB] Create an autofs direct map configuration"
HINT="Task 1: Create /etc/auto.master.d/direct.autofs with '/- /etc/auto.direct'\nTask 2: Create /etc/auto.direct with '/mnt/autodirect -fstype=tmpfs :/'"

LAB_TITLE="Autofs Direct Map"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create direct map entry /- in auto.master.d/" ;;
        1) echo "Create /etc/auto.direct with absolute path mount" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous autofs config...${RESET}"
    rm -f /etc/auto.master.d/direct.autofs /etc/auto.direct 2>/dev/null
    mkdir -p /etc/auto.master.d 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if direct master map file exists with /-
    if [[ -f /etc/auto.master.d/direct.autofs ]] && grep -q '/-' /etc/auto.master.d/direct.autofs 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if auto.direct map file exists with absolute path
    if [[ -f /etc/auto.direct ]] && grep -qE '^/mnt/|^/data/' /etc/auto.direct 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /etc/auto.master.d/direct.autofs /etc/auto.direct 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
