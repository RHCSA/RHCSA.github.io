#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Here Document

# This is a LAB exercise
IS_LAB=true
LAB_ID="here_document"

QUESTION="Create a configuration file using a here document with variables"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create /tmp/app.conf with here document containing hostname"
TASK_1_HINT="Use cat << EOF > file to create a here document"
TASK_1_COMMAND_1="cat << EOF > /tmp/app.conf
hostname=\$(hostname)
user=\$(whoami)
EOF"

# Task 2
TASK_2_QUESTION="File must contain current username"
TASK_2_HINT="Variables are expanded (actual hostname/username in output)"
TASK_2_COMMAND_1="# Verified by check_tasks - username must be in file"


# Auto-generate HINT from commands
HINT=$(_build_hint)
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
