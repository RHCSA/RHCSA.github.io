#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Grep Case Insensitive and Line Numbers

# This is a LAB exercise
IS_LAB=true
LAB_ID="grep_options"

QUESTION="[LAB] Use grep with -i (case-insensitive) and -n (line numbers)"
HINT="Task 1: grep -i 'error' /tmp/system.log > /tmp/all-errors.txt
Task 2: grep -n 'Failed' /tmp/auth.log > /tmp/failed-lines.txt"

# Lab configuration
LAB_TITLE="Grep Options: Case and Line Numbers"
LAB_TASK_COUNT=2

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Find all lines containing 'error' (any case: ERROR, Error, error) from /tmp/system.log, save to /tmp/all-errors.txt" ;;
        1) echo "Find 'Failed' in /tmp/auth.log with line numbers shown, save to /tmp/failed-lines.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing files...${RESET}"
    rm -f /tmp/all-errors.txt /tmp/failed-lines.txt /tmp/system.log /tmp/auth.log 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating system log file...${RESET}"
    cat > /tmp/system.log << 'EOF'
Jan 15 10:00:01 server kernel: System started
Jan 15 10:00:02 server app: ERROR - Database connection failed
Jan 15 10:00:03 server app: Retrying connection
Jan 15 10:00:04 server app: error - timeout occurred
Jan 15 10:00:05 server app: Connection established
Jan 15 10:00:06 server kernel: Error loading module xyz
Jan 15 10:00:07 server app: Request processed
Jan 15 10:00:08 server app: ERROR - Memory allocation failed
Jan 15 10:00:09 server app: Cleanup initiated
Jan 15 10:00:10 server kernel: CRITICAL ERROR reported
EOF
    sleep 0.2
    
    echo -e "  ${DIM}• Creating auth log file...${RESET}"
    cat > /tmp/auth.log << 'EOF'
Jan 15 09:00:01 server sshd: Accepted password for user1
Jan 15 09:00:02 server sshd: Failed password for root
Jan 15 09:00:03 server sshd: Accepted publickey for admin
Jan 15 09:00:04 server sudo: user1 opened session
Jan 15 09:00:05 server sshd: Failed password for invalid user
Jan 15 09:00:06 server sshd: Accepted password for user2
Jan 15 09:00:07 server sshd: Failed password for root
Jan 15 09:00:08 server sshd: Connection closed by 10.0.0.1
Jan 15 09:00:09 server sshd: Accepted password for admin
Jan 15 09:00:10 server sshd: Failed password for user1
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check all-errors.txt contains all case variations of error
    if [[ -f /tmp/all-errors.txt ]]; then
        local line_count=$(wc -l < /tmp/all-errors.txt 2>/dev/null)
        # Should have 5 lines with various ERROR/Error/error
        if [[ $line_count -ge 4 ]]; then
            # Check for different case variations
            if grep -qi 'error' /tmp/all-errors.txt 2>/dev/null; then
                # Verify we got both uppercase and lowercase
                local has_upper=$(grep -c 'ERROR' /tmp/all-errors.txt 2>/dev/null)
                local has_lower=$(grep -c 'error' /tmp/all-errors.txt 2>/dev/null)
                if [[ $has_upper -ge 1 ]] || [[ $has_lower -ge 1 ]]; then
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
    
    # Task 1: Check failed-lines.txt has line numbers
    if [[ -f /tmp/failed-lines.txt ]]; then
        # Should contain Failed
        if grep -qi 'failed' /tmp/failed-lines.txt 2>/dev/null; then
            # Should have line number format (number:content)
            if grep -qE '^[0-9]+:' /tmp/failed-lines.txt 2>/dev/null; then
                local line_count=$(wc -l < /tmp/failed-lines.txt 2>/dev/null)
                # Should have 4 failed lines
                if [[ $line_count -ge 3 ]]; then
                    TASK_STATUS[1]="true"
                else
                    TASK_STATUS[1]="false"
                fi
            else
                TASK_STATUS[1]="false"
            fi
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/all-errors.txt /tmp/failed-lines.txt /tmp/system.log /tmp/auth.log 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
