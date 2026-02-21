#!/bin/bash
# Objective 2: Manage software
# LAB: Search for Packages with DNF

IS_LAB=true
LAB_ID="dnf_search"

QUESTION="[LAB] Search for packages and get package information"
HINT="Task 1: dnf search 'web server' > /tmp/search-results.txt\nTask 2: dnf info httpd > /tmp/httpd-info.txt"

LAB_TITLE="Search and Info with DNF"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Search for 'web server' packages, save to /tmp/search-results.txt" ;;
        1) echo "Get httpd package info and save to /tmp/httpd-info.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/search-results.txt /tmp/httpd-info.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if search-results.txt exists and contains results
    if [[ -f /tmp/search-results.txt ]] && [[ -s /tmp/search-results.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if httpd-info.txt exists and contains httpd info
    if [[ -f /tmp/httpd-info.txt ]] && grep -qi 'httpd\|apache\|name\|version' /tmp/httpd-info.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/search-results.txt /tmp/httpd-info.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
