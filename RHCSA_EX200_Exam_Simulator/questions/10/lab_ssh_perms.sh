#!/bin/bash
# Objective 10: Manage security
# LAB: SSH Key Permissions

IS_LAB=true
LAB_ID="ssh_key_perms"

QUESTION="[LAB] Set correct permissions on SSH directory and keys"
HINT="Task 1: chmod 700 ~/.ssh; chmod 600 ~/.ssh/id_* 2>/dev/null\nTask 2: ls -la ~/.ssh/ > /tmp/ssh-perms.txt"

LAB_TITLE="SSH Key Permissions"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Ensure ~/.ssh directory has 700 permissions" ;;
        1) echo "Save .ssh directory listing to /tmp/ssh-perms.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring .ssh directory exists...${RESET}"
    mkdir -p ~/.ssh 2>/dev/null
    chmod 755 ~/.ssh 2>/dev/null  # Set wrong perms initially
    rm -f /tmp/ssh-perms.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if .ssh has 700 permissions
    local ssh_perms=$(stat -c %a ~/.ssh 2>/dev/null)
    if [[ "$ssh_perms" == "700" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if ssh-perms.txt exists
    if [[ -f /tmp/ssh-perms.txt ]] && grep -q '\.ssh' /tmp/ssh-perms.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/ssh-perms.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
