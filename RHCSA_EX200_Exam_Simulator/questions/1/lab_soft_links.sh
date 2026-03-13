#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create and Work with Symbolic Links

# This is a LAB exercise
IS_LAB=true
LAB_ID="soft_links"

QUESTION="Create symbolic links to files and directories"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create symlink for /tmp/passwd_link file pointing to /etc/passwd"
TASK_1_HINT="Use ln -s to create a symbolic link to a file"
TASK_1_COMMAND_1="ln -s /etc/passwd /tmp/passwd_link"

# Task 2
TASK_2_QUESTION="Create symlink for /tmp/logs directory pointing to /var/log directory"
TASK_2_HINT="Use ln -s to create a symbolic link to a directory"
TASK_2_COMMAND_1="ln -s /var/log /tmp/logs"

# Task 3
TASK_3_QUESTION="Save the target of /tmp/passwd_link to /tmp/link_target.txt using readlink command"
TASK_3_HINT="Use readlink to get the target path and redirect to file"
TASK_3_COMMAND_1="readlink /tmp/passwd_link > /tmp/link_target.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test environment...${RESET}"
    rm -rf /tmp/passwd_link /tmp/logs /tmp/link_target.txt 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check symlink to /etc/passwd
    if [[ -L /tmp/passwd_link ]]; then
        local target=$(readlink /tmp/passwd_link)
        if [[ "$target" == "/etc/passwd" ]]; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check symlink to /var/log
    if [[ -L /tmp/logs ]]; then
        local target=$(readlink /tmp/logs)
        if [[ "$target" == "/var/log" ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check if link_target.txt contains correct target
    if [[ -f /tmp/link_target.txt ]]; then
        local content=$(cat /tmp/link_target.txt | tr -d ' \n')
        if [[ "$content" == "/etc/passwd" ]]; then
            TASK_STATUS[2]="true"
        else
            TASK_STATUS[2]="false"
        fi
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/passwd_link /tmp/logs /tmp/link_target.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
