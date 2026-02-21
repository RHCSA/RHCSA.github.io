#!/bin/bash
# Objective 2: Manage software
# LAB: Install Local RPM Package

IS_LAB=true
LAB_ID="rpm_install_local"

QUESTION="[LAB] Download and install a local RPM package file"
HINT="Task 1: dnf download tree --downloaddir=/tmp\nTask 2: sudo rpm -ivh /tmp/tree*.rpm or sudo dnf install /tmp/tree*.rpm"

LAB_TITLE="Install Local RPM Package"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Download the 'tree' package RPM to /tmp directory" ;;
        1) echo "Install the downloaded RPM using rpm -ivh or dnf install" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Removing tree package if present...${RESET}"
    sudo dnf remove tree -y &>/dev/null
    rm -f /tmp/tree*.rpm 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if tree RPM file exists in /tmp
    if ls /tmp/tree*.rpm &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if tree is installed
    if rpm -q tree &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    sudo dnf remove tree -y &>/dev/null
    rm -f /tmp/tree*.rpm 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
