#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: DNF List Packages

IS_LAB=true
LAB_ID="dnf_list"

QUESTION="[LAB] List installed and available packages with dnf"
HINT="Task 1: dnf list installed | head -50 > /tmp/installed-pkgs.txt\nTask 2: dnf list available | head -50 > /tmp/available-pkgs.txt"

LAB_TITLE="DNF List Packages"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List first 50 installed packages to /tmp/installed-pkgs.txt" ;;
        1) echo "List first 50 available packages to /tmp/available-pkgs.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/installed-pkgs.txt /tmp/available-pkgs.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if installed-pkgs.txt exists with packages
    if [[ -f /tmp/installed-pkgs.txt ]] && grep -qE '\.[a-z0-9_]+\s+' /tmp/installed-pkgs.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if available-pkgs.txt exists with packages
    if [[ -f /tmp/available-pkgs.txt ]] && [[ -s /tmp/available-pkgs.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/installed-pkgs.txt /tmp/available-pkgs.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
