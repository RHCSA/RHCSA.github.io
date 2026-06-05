#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Grant Limited sudo Access

# This is a LAB exercise
IS_LAB=true
LAB_ID="sudo_limited"

QUESTION="Grant limited sudo access to a user"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Allow 'webdev' to run 'systemctl restart httpd' without password and 'kill' with password via sudo"
TASK_1_HINT="Use NOPASSWD: for specific commands and PASSWD: for others"
TASK_1_COMMAND_1="echo 'webdev ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart httpd, PASSWD: /bin/kill' > /etc/sudoers.d/webdev"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing configuration...${RESET}"
    rm -f /etc/sudoers.d/webdev 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating test user webdev...${RESET}"
    userdel -r webdev 2>/dev/null
    useradd webdev 2>/dev/null
    echo "webdev:password123" | chpasswd 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if webdev has limited sudo access with both NOPASSWD and PASSWD
    local found_nopasswd="false"
    local found_passwd="false"
    
    # Check drop-in file first
    if [[ -f /etc/sudoers.d/webdev ]]; then
        if grep -qE '^webdev[[:space:]]+.*NOPASSWD:.*systemctl.*restart.*httpd' /etc/sudoers.d/webdev 2>/dev/null; then
            found_nopasswd="true"
        fi
        if grep -qE '^webdev[[:space:]]+.*PASSWD:.*kill' /etc/sudoers.d/webdev 2>/dev/null; then
            found_passwd="true"
        fi
    fi
    
    # Also check main sudoers file
    if grep -qE '^webdev[[:space:]]+.*NOPASSWD:.*systemctl.*restart.*httpd' /etc/sudoers 2>/dev/null; then
        found_nopasswd="true"
    fi
    if grep -qE '^webdev[[:space:]]+.*PASSWD:.*kill' /etc/sudoers 2>/dev/null; then
        found_passwd="true"
    fi
    
    # Verify both conditions and syntax is correct
    if [[ "$found_nopasswd" == "true" ]] && [[ "$found_passwd" == "true" ]]; then
        if visudo -c 2>/dev/null | grep -q 'parsed OK'; then
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
    rm -f /etc/sudoers.d/webdev 2>/dev/null
    # Remove entry from /etc/sudoers if added there
    sed -i '/^webdev[[:space:]].*NOPASSWD/d' /etc/sudoers 2>/dev/null
    userdel -r webdev 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
