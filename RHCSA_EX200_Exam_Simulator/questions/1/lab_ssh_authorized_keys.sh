#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create authorized_keys File

# This is a LAB exercise
IS_LAB=true
LAB_ID="ssh_authorized_keys"

QUESTION="[LAB] Set up authorized_keys for SSH key authentication"
HINT="Task 1: cat /tmp/remote_user.pub >> ~/.ssh/authorized_keys"

# Lab configuration
LAB_TITLE="Create authorized_keys File"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add the public key from /tmp/remote_user.pub to ~/.ssh/authorized_keys" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Ensuring .ssh directory exists...${RESET}"
    mkdir -p ~/.ssh 2>/dev/null
    chmod 700 ~/.ssh
    sleep 0.3
    
    echo -e "  ${DIM}• Backing up existing authorized_keys...${RESET}"
    if [[ -f ~/.ssh/authorized_keys ]]; then
        cp ~/.ssh/authorized_keys ~/.ssh/authorized_keys.lab_backup 2>/dev/null
    fi
    sleep 0.2
    
    echo -e "  ${DIM}• Creating simulated remote user public key...${RESET}"
    cat > /tmp/remote_user.pub << 'EOF'
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHxExampleRemoteUserPublicKeyForAuthTesting123 remote_user@client.example.com
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check authorized_keys contains the public key
    if [[ -f ~/.ssh/authorized_keys ]]; then
        # Should contain the remote_user key
        if grep -q 'remote_user@client.example.com' ~/.ssh/authorized_keys 2>/dev/null; then
            # Should contain the ssh-ed25519 key type
            if grep -q 'ssh-ed25519' ~/.ssh/authorized_keys 2>/dev/null; then
                TASK_STATUS[0]="true"
            else
                TASK_STATUS[0]="false"
            fi
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
    # Remove the lab key from authorized_keys
    if [[ -f ~/.ssh/authorized_keys ]]; then
        sed -i '/remote_user@client\.example\.com$/d' ~/.ssh/authorized_keys 2>/dev/null
    fi
    # Restore backup if it existed
    if [[ -f ~/.ssh/authorized_keys.lab_backup ]]; then
        mv ~/.ssh/authorized_keys.lab_backup ~/.ssh/authorized_keys 2>/dev/null
    fi
    rm -f /tmp/remote_user.pub 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
