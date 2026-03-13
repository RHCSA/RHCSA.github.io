#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Remove Host from known_hosts

# This is a LAB exercise
IS_LAB=true
LAB_ID="ssh_known_hosts"

QUESTION="Remove a host from ~/.ssh/known_hosts"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Remove 'server5.example.com' entry from ~/.ssh/known_hosts"
TASK_1_HINT="-R option removes all keys for specified hostname"
TASK_1_COMMAND_1="ssh-keygen -R server5.example.com"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Ensuring .ssh directory exists...${RESET}"
    mkdir -p ~/.ssh 2>/dev/null
    chmod 700 ~/.ssh
    sleep 0.3
    
    echo -e "  ${DIM}• Backing up existing known_hosts...${RESET}"
    if [[ -f ~/.ssh/known_hosts ]]; then
        cp ~/.ssh/known_hosts ~/.ssh/known_hosts.lab_backup 2>/dev/null
    fi
    sleep 0.2
    
    echo -e "  ${DIM}• Adding test entries to known_hosts...${RESET}"
    # Add fake host entries for testing
    cat >> ~/.ssh/known_hosts << 'EOF'
server1.example.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample1Server1HostKeyForTesting12345
server5.example.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample5Server5HostKeyNeedsRemoval67890
server5.example.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5example5RSAKeyAlsoNeedsRemoval
server9.example.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample9Server9HostKeyForTesting99999
EOF
    chmod 644 ~/.ssh/known_hosts
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check that server5.example.com is NOT in known_hosts
    if [[ -f ~/.ssh/known_hosts ]]; then
        # server5.example.com should be removed
        if ! grep -q 'server5\.example\.com' ~/.ssh/known_hosts 2>/dev/null; then
            # server1 and server9 should still exist
            if grep -q 'server1\.example\.com' ~/.ssh/known_hosts 2>/dev/null; then
                if grep -q 'server9\.example\.com' ~/.ssh/known_hosts 2>/dev/null; then
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
    else
        # If file doesn't exist, that's wrong - should only remove one entry
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    # Remove test entries
    if [[ -f ~/.ssh/known_hosts ]]; then
        sed -i '/server1\.example\.com/d' ~/.ssh/known_hosts 2>/dev/null
        sed -i '/server5\.example\.com/d' ~/.ssh/known_hosts 2>/dev/null
        sed -i '/server9\.example\.com/d' ~/.ssh/known_hosts 2>/dev/null
    fi
    # Restore backup
    if [[ -f ~/.ssh/known_hosts.lab_backup ]]; then
        mv ~/.ssh/known_hosts.lab_backup ~/.ssh/known_hosts 2>/dev/null
    fi
    # Remove empty files
    if [[ -f ~/.ssh/known_hosts ]] && [[ ! -s ~/.ssh/known_hosts ]]; then
        rm -f ~/.ssh/known_hosts
    fi
    rm -f ~/.ssh/known_hosts.old 2>/dev/null  # ssh-keygen creates .old backup
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
