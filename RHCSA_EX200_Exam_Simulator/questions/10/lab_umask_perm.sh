#!/bin/bash
# Objective 10: Manage security
# LAB: Set Permanent Umask

IS_LAB=true
LAB_ID="umask_permanent"

QUESTION="[LAB] Configure permanent umask in user profile"
HINT="Task 1: echo 'umask 077' >> ~/.bashrc\nTask 2: grep umask ~/.bashrc > /tmp/bashrc-umask.txt"

LAB_TITLE="Set Permanent Umask"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add umask 077 to ~/.bashrc" ;;
        1) echo "Verify umask in /tmp/bashrc-umask.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Backing up .bashrc...${RESET}"
    cp ~/.bashrc ~/.bashrc.lab_backup 2>/dev/null
    sed -i '/^umask 077$/d' ~/.bashrc 2>/dev/null
    rm -f /tmp/bashrc-umask.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if umask 077 is in .bashrc
    if grep -q '^umask 077$' ~/.bashrc 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if bashrc-umask.txt exists with umask line
    if [[ -f /tmp/bashrc-umask.txt ]] && grep -q 'umask' /tmp/bashrc-umask.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Restoring .bashrc...${RESET}"
    if [[ -f ~/.bashrc.lab_backup ]]; then
        mv ~/.bashrc.lab_backup ~/.bashrc 2>/dev/null
    else
        sed -i '/^umask 077$/d' ~/.bashrc 2>/dev/null
    fi
    rm -f /tmp/bashrc-umask.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
