#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Here Document

# This is a LAB exercise
IS_LAB=true
LAB_ID="here_document"

QUESTION="[LAB] Create a configuration file using a here document with variables"
HINT="Task 1: cat << EOF > /tmp/app.conf\nhostname=$(hostname)\nuser=$(whoami)\nEOF
Task 2: Variables are expanded (actual hostname/username in output)"

# Lab configuration
LAB_TITLE="Here Document (<<)"
LAB_TASK_COUNT=2

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/app.conf with here document containing hostname" ;;
        1) echo "File must contain current username" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM} Removing existing config file...${RESET}"
    rm -f /tmp/app.conf 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local current_hostname=$(hostname)
    local current_user=$(whoami)
    
    # Task 0: Check if file exists and contains hostname
    if [[ -f /tmp/app.conf ]] && grep -q "$current_hostname" /tmp/app.conf 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if file contains username
    if grep -q "$current_user" /tmp/app.conf 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM} Cleaning up lab environment...${RESET}"
    rm -f /tmp/app.conf 2>/dev/null
    echo -e "  ${GREEN} Lab environment cleaned up${RESET}"
    sleep 1
}
