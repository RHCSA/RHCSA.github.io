#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Stream Editor (sed) Operations

# This is a LAB exercise
IS_LAB=true
LAB_ID="sed_operations"

QUESTION="[LAB] Use sed for text substitution and line deletion"
HINT="Task 1: sed -i 's/error/warning/' /tmp/logfile.txt
Task 2: sed -i 's/DEBUG/INFO/g' /tmp/logfile.txt (g = global)
Task 3: sed -i 's/fail/pass/gi' /tmp/logfile.txt (gi = global + ignore case)
Task 4: sed -i '/DEPRECATED/d' /tmp/logfile.txt (d = delete lines)"

# Lab configuration
LAB_TITLE="sed Text Operations"
LAB_TASK_COUNT=4

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Replace first 'error' with 'warning' on each line in /tmp/logfile.txt (in-place)" ;;
        1) echo "Replace ALL occurrences of 'DEBUG' with 'INFO' in /tmp/logfile.txt (global)" ;;
        2) echo "Replace all 'fail' with 'pass' case-insensitively in /tmp/logfile.txt" ;;
        3) echo "Delete all lines containing 'DEPRECATED' from /tmp/logfile.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test log file...${RESET}"
    rm -f /tmp/logfile.txt 2>/dev/null
    
    cat > /tmp/logfile.txt << 'EOF'
2024-01-01 error: Connection error occurred
2024-01-02 DEBUG: Starting DEBUG mode with DEBUG level
2024-01-03 FAIL: Authentication FAIL - retry fail
2024-01-04 DEPRECATED: Old function DEPRECATED - remove soon
2024-01-05 INFO: Normal operation
2024-01-06 DEBUG: Debug message DEBUG
2024-01-07 Fail: Another failure detected
2024-01-08 DEPRECATED: Legacy code DEPRECATED
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    if [[ ! -f /tmp/logfile.txt ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        TASK_STATUS[2]="false"
        TASK_STATUS[3]="false"
        return
    fi
    
    local content=$(cat /tmp/logfile.txt)
    
    # Task 0: Check 'error' replaced with 'warning' (first occurrence per line)
    # Line 1 should have "warning" instead of first "error"
    if echo "$content" | grep -q "warning:.*error\|warning.*occurred"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check ALL 'DEBUG' replaced with 'INFO' (global)
    if ! echo "$content" | grep -q "DEBUG"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check all 'fail' (case-insensitive) replaced with 'pass'
    if ! echo "$content" | grep -qi "fail"; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
    
    # Task 3: Check lines with 'DEPRECATED' are deleted
    if ! echo "$content" | grep -q "DEPRECATED"; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/logfile.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
