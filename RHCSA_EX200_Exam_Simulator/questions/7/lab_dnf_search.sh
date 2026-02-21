#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Search DNF Packages

IS_LAB=true
LAB_ID="dnf_search"

QUESTION="[LAB] Search for packages using dnf"
HINT="Task 1: dnf search httpd > /tmp/dnf-search.txt\nTask 2: dnf info httpd > /tmp/dnf-info.txt"

LAB_TITLE="Search DNF Packages"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Search for httpd packages, save to /tmp/dnf-search.txt" ;;
        1) echo "Get httpd info, save to /tmp/dnf-info.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/dnf-search.txt /tmp/dnf-info.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if dnf-search.txt exists with results
    if [[ -f /tmp/dnf-search.txt ]] && grep -qiE 'httpd|apache' /tmp/dnf-search.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if dnf-info.txt exists with package info
    if [[ -f /tmp/dnf-info.txt ]] && grep -qiE 'name|version|release' /tmp/dnf-info.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/dnf-search.txt /tmp/dnf-info.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
