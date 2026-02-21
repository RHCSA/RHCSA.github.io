#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Grant Limited sudo Access

# This is a LAB exercise
IS_LAB=true
LAB_ID="sudo_limited"

QUESTION="[LAB] Grant limited sudo access to a user"
HINT="Task 1: Add to /etc/sudoers.d/webdev:
webdev ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart httpd, PASSWD: /bin/kill"

# Lab configuration
LAB_TITLE="Grant Limited sudo Access"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Allow 'webdev' to run 'systemctl restart httpd' without password and 'kill' with password via sudo" ;;
    esac
}

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
