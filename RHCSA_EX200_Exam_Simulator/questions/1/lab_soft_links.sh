#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create and Work with Symbolic Links

# This is a LAB exercise
IS_LAB=true
LAB_ID="soft_links"

QUESTION="[LAB] Create symbolic links to files and directories"
HINT="This lab has 3 tasks:\n\n1. Create symlink to file:\n   ln -s /etc/passwd /tmp/passwd_link\n   -s = symbolic (soft) link\n\n2. Create symlink to directory:\n   ln -s /var/log /tmp/logs\n   Symlinks can point to directories\n\n3. Verify symlink target:\n   readlink /tmp/passwd_link > /tmp/link_target.txt\n\nTip: ls -l shows symlinks with '->' arrow"

# Lab configuration
LAB_TITLE="Symbolic Links"
LAB_TASK_COUNT=3

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create symlink for /tmp/passwd_link file pointing to /etc/passwd" ;;
        1) echo "Create symlink for /tmp/logs directory pointing to /var/log directory" ;;
        2) echo "Save the target of /tmp/passwd_link to /tmp/link_target.txt using readlink command" ;;
    esac
}

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
