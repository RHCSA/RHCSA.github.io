#!/bin/bash
# Objective 10: Manage security
# LAB: Create Authorized Keys File

IS_LAB=true
LAB_ID="ssh_authorized_keys"

QUESTION="[LAB] Create and configure authorized_keys file"
HINT="Task 1: mkdir -p ~/.ssh; touch ~/.ssh/authorized_keys\nTask 2: chmod 600 ~/.ssh/authorized_keys; ls -la ~/.ssh/ > /tmp/auth-keys.txt"

LAB_TITLE="Create Authorized Keys"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create ~/.ssh/authorized_keys file" ;;
        1) echo "Set 600 permissions and save listing" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Backing up existing authorized_keys...${RESET}"
    if [[ -f ~/.ssh/authorized_keys ]]; then
        cp ~/.ssh/authorized_keys ~/.ssh/authorized_keys.lab_backup 2>/dev/null
    fi
    rm -f ~/.ssh/authorized_keys /tmp/auth-keys.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if authorized_keys exists
    if [[ -f ~/.ssh/authorized_keys ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check permissions and output file
    local perms=$(stat -c %a ~/.ssh/authorized_keys 2>/dev/null)
    if [[ "$perms" == "600" ]] && [[ -f /tmp/auth-keys.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Restoring authorized_keys...${RESET}"
    if [[ -f ~/.ssh/authorized_keys.lab_backup ]]; then
        mv ~/.ssh/authorized_keys.lab_backup ~/.ssh/authorized_keys 2>/dev/null
    fi
    rm -f /tmp/auth-keys.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
