#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Configure SSH Client Config File

# This is a LAB exercise
IS_LAB=true
LAB_ID="ssh_client_config"

QUESTION="[LAB] Create SSH client configuration file"
HINT="Task 1: Create ~/.ssh/config with:
  Host labserver\n    HostName 192.168.1.100\n    User admin\n    Port 2222
Then: chmod 600 ~/.ssh/config"

# Lab configuration
LAB_TITLE="Configure SSH Client Config"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create SSH client config (~/.ssh/config) with Host 'labserver' (HostName 192.168.1.100, User admin, Port 2222) and set permissions to 600" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Ensuring .ssh directory exists...${RESET}"
    mkdir -p ~/.ssh 2>/dev/null
    chmod 700 ~/.ssh
    sleep 0.3
    
    echo -e "  ${DIM}• Backing up existing config if present...${RESET}"
    if [[ -f ~/.ssh/config ]]; then
        cp ~/.ssh/config ~/.ssh/config.lab_backup 2>/dev/null
    fi
    # Remove any existing labserver entry for clean testing
    if [[ -f ~/.ssh/config ]]; then
        sed -i '/^Host labserver$/,/^Host /{ /^Host labserver$/d; /^Host /!d; }' ~/.ssh/config 2>/dev/null
        # Clean up empty file
        if [[ ! -s ~/.ssh/config ]]; then
            rm -f ~/.ssh/config
        fi
    fi
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check ~/.ssh/config exists with correct labserver entry
    if [[ -f ~/.ssh/config ]]; then
        local perms=$(stat -c %a ~/.ssh/config 2>/dev/null)
        # Permissions should be 600 or 644
        if [[ "$perms" == "600" ]] || [[ "$perms" == "644" ]] || [[ "$perms" == "400" ]]; then
            # Check for Host labserver
            if grep -qi '^[[:space:]]*Host[[:space:]]\+labserver' ~/.ssh/config 2>/dev/null; then
                # Check for HostName
                if grep -qi 'HostName[[:space:]]\+192\.168\.1\.100' ~/.ssh/config 2>/dev/null; then
                    # Check for User admin
                    if grep -qi 'User[[:space:]]\+admin' ~/.ssh/config 2>/dev/null; then
                        # Check for Port 2222
                        if grep -qi 'Port[[:space:]]\+2222' ~/.ssh/config 2>/dev/null; then
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
    # Remove the labserver entry we added
    if [[ -f ~/.ssh/config ]]; then
        # Create temp file without labserver block
        awk '/^Host labserver$/{skip=1; next} /^Host /{skip=0} !skip' ~/.ssh/config > ~/.ssh/config.tmp 2>/dev/null
        mv ~/.ssh/config.tmp ~/.ssh/config 2>/dev/null
        # If file is empty, remove it
        if [[ ! -s ~/.ssh/config ]]; then
            rm -f ~/.ssh/config
        fi
    fi
    # Restore backup if it existed
    if [[ -f ~/.ssh/config.lab_backup ]]; then
        mv ~/.ssh/config.lab_backup ~/.ssh/config 2>/dev/null
    fi
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
