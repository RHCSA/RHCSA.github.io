#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: DNF Provides Command

IS_LAB=true
LAB_ID="dnf_provides"

QUESTION="[LAB] Find which package provides a file"
HINT="Task 1: dnf provides /usr/bin/vim > /tmp/provides-vim.txt\nTask 2: dnf provides */httpd.conf > /tmp/provides-httpd.txt"

LAB_TITLE="DNF Provides Command"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Find package providing vim, save to /tmp/provides-vim.txt" ;;
        1) echo "Find package providing httpd.conf, save to /tmp/provides-httpd.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/provides-vim.txt /tmp/provides-httpd.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if provides-vim.txt exists
    if [[ -f /tmp/provides-vim.txt ]] && grep -qiE 'vim' /tmp/provides-vim.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if provides-httpd.txt exists
    if [[ -f /tmp/provides-httpd.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/provides-vim.txt /tmp/provides-httpd.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
