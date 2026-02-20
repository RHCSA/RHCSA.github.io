#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Basic grep Searching

# This is a LAB exercise
IS_LAB=true
LAB_ID="grep_basic"

QUESTION="[LAB] Use grep to search and filter text in files"
HINT="This lab has 3 tasks:\n\n1. Find bash users:\n   grep '/bin/bash' /etc/passwd > /tmp/bash-users.txt\n\n2. Count nologin users:\n   grep -c 'nologin' /etc/passwd > /tmp/nologin-count.txt\n\n3. Exclude comments from config:\n   grep -v '^#' /tmp/testconfig.conf > /tmp/active-config.txt\n\nTip: -c counts, -v inverts match."

# Lab configuration
LAB_TITLE="Basic grep Searching"
LAB_TASK_COUNT=3

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Find all users with /bin/bash shell from /etc/passwd and save to /tmp/bash-users.txt" ;;
        1) echo "Count how many users have 'nologin' shell and save the count to /tmp/nologin-count.txt" ;;
        2) echo "From /tmp/testconfig.conf, extract only non-comment lines (lines not starting with #) to /tmp/active-config.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing files...${RESET}"
    rm -f /tmp/bash-users.txt /tmp/nologin-count.txt /tmp/active-config.txt 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating test configuration file...${RESET}"
    cat > /tmp/testconfig.conf << 'EOF'
# This is a comment
# Another comment line
ServerName localhost
# Port configuration
Port 8080
MaxClients 100
# Timeout settings
Timeout 300
KeepAlive On
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if bash-users.txt contains users with /bin/bash
    if [[ -f /tmp/bash-users.txt ]] && grep -q '/bin/bash' /tmp/bash-users.txt 2>/dev/null; then
        local line_count=$(wc -l < /tmp/bash-users.txt 2>/dev/null)
        if [[ $line_count -ge 1 ]]; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if nologin-count.txt contains a number
    if [[ -f /tmp/nologin-count.txt ]]; then
        local count=$(cat /tmp/nologin-count.txt 2>/dev/null | tr -d '[:space:]')
        if [[ "$count" =~ ^[0-9]+$ ]] && [[ $count -ge 1 ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check if active-config.txt has non-comment lines only
    if [[ -f /tmp/active-config.txt ]]; then
        # Should contain config lines but no comment lines
        if grep -q 'ServerName\|Port\|MaxClients\|Timeout\|KeepAlive' /tmp/active-config.txt 2>/dev/null; then
            # Should NOT contain lines starting with #
            if ! grep -q '^#' /tmp/active-config.txt 2>/dev/null; then
                TASK_STATUS[2]="true"
            else
                TASK_STATUS[2]="false"
            fi
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
    rm -f /tmp/bash-users.txt /tmp/nologin-count.txt /tmp/active-config.txt /tmp/testconfig.conf 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
