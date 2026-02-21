#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Copy SSH Public Key to Remote Server

# This is a LAB exercise
IS_LAB=true
LAB_ID="ssh_copy_id"

QUESTION="[LAB] Enable passwordless SSH authentication to a server"
HINT="Task 1: ssh-copy-id root@127.0.0.1
(Enter password when prompted, adds key to authorized_keys)"

# Lab configuration
LAB_TITLE="Copy SSH Key with ssh-copy-id"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Use ssh-copy-id to copy your SSH public key to root@127.0.0.1 (this server)" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Ensuring user has SSH key pair...${RESET}"
    if [[ ! -f ~/.ssh/id_rsa.pub ]] && [[ ! -f ~/.ssh/id_ed25519.pub ]]; then
        echo -e "  ${DIM}• Generating SSH key pair for user...${RESET}"
        ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N '' -q 2>/dev/null
    fi
    sleep 0.3
    
    echo -e "  ${DIM}• Backing up existing authorized_keys...${RESET}"
    if [[ -f /root/.ssh/authorized_keys ]]; then
        cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys.lab_backup 2>/dev/null
    fi
    sleep 0.2
    
    echo -e "  ${DIM}• Saving current user's public key fingerprint...${RESET}"
    # Store the user's public key for verification
    if [[ -f ~/.ssh/id_ed25519.pub ]]; then
        cat ~/.ssh/id_ed25519.pub > /tmp/.lab_user_pubkey 2>/dev/null
    elif [[ -f ~/.ssh/id_rsa.pub ]]; then
        cat ~/.ssh/id_rsa.pub > /tmp/.lab_user_pubkey 2>/dev/null
    fi
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check that the user's public key is in root's authorized_keys
    if [[ -f /root/.ssh/authorized_keys ]] && [[ -f /tmp/.lab_user_pubkey ]]; then
        # Get the key content (second field of public key)
        local pubkey_content=$(cat /tmp/.lab_user_pubkey 2>/dev/null | awk '{print $2}')
        if [[ -n "$pubkey_content" ]] && grep -q "$pubkey_content" /root/.ssh/authorized_keys 2>/dev/null; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    # Restore backup if it existed
    if [[ -f /root/.ssh/authorized_keys.lab_backup ]]; then
        mv /root/.ssh/authorized_keys.lab_backup /root/.ssh/authorized_keys 2>/dev/null
    fi
    # Remove temp file
    rm -f /tmp/.lab_user_pubkey 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
