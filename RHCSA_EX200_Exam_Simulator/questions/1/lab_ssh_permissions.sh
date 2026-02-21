#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Fix SSH Directory Permissions

# This is a LAB exercise
IS_LAB=true
LAB_ID="ssh_permissions"

QUESTION="[LAB] Fix SSH directory and file permissions"
HINT="Task 1: chmod 700 /tmp/sshtest/.ssh
Task 2: chmod 600 /tmp/sshtest/.ssh/id_rsa
Task 3: chmod 600 /tmp/sshtest/.ssh/authorized_keys"

# Lab configuration
LAB_TITLE="Fix SSH Directory Permissions"
LAB_TASK_COUNT=3

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Fix /tmp/sshtest/.ssh directory permissions (should be 700)" ;;
        1) echo "Fix /tmp/sshtest/.ssh/id_rsa private key permissions (should be 600)" ;;
        2) echo "Fix /tmp/sshtest/.ssh/authorized_keys permissions (should be 600)" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing test directory...${RESET}"
    rm -rf /tmp/sshtest 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating SSH directory with wrong permissions...${RESET}"
    mkdir -p /tmp/sshtest/.ssh
    chmod 777 /tmp/sshtest/.ssh  # Wrong - should be 700
    sleep 0.2
    
    echo -e "  ${DIM}• Creating private key with wrong permissions...${RESET}"
    cat > /tmp/sshtest/.ssh/id_rsa << 'EOF'
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBexamplekeyfortestingonlynotreal123456789ABCDEFG==
-----END OPENSSH PRIVATE KEY-----
EOF
    chmod 644 /tmp/sshtest/.ssh/id_rsa  # Wrong - should be 600
    sleep 0.2
    
    echo -e "  ${DIM}• Creating public key...${RESET}"
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExamplePublicKeyForTesting test@example" > /tmp/sshtest/.ssh/id_rsa.pub
    chmod 644 /tmp/sshtest/.ssh/id_rsa.pub  # This is correct
    sleep 0.2
    
    echo -e "  ${DIM}• Creating authorized_keys with wrong permissions...${RESET}"
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuthorizedKeyExample admin@remote" > /tmp/sshtest/.ssh/authorized_keys
    chmod 644 /tmp/sshtest/.ssh/authorized_keys  # Wrong - should be 600
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check .ssh directory has 700 permissions
    if [[ -d /tmp/sshtest/.ssh ]]; then
        local perms=$(stat -c %a /tmp/sshtest/.ssh 2>/dev/null)
        if [[ "$perms" == "700" ]]; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check id_rsa has 600 permissions
    if [[ -f /tmp/sshtest/.ssh/id_rsa ]]; then
        local perms=$(stat -c %a /tmp/sshtest/.ssh/id_rsa 2>/dev/null)
        if [[ "$perms" == "600" ]] || [[ "$perms" == "400" ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check authorized_keys has 600 permissions
    if [[ -f /tmp/sshtest/.ssh/authorized_keys ]]; then
        local perms=$(stat -c %a /tmp/sshtest/.ssh/authorized_keys 2>/dev/null)
        if [[ "$perms" == "600" ]] || [[ "$perms" == "400" ]]; then
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
    rm -rf /tmp/sshtest 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
