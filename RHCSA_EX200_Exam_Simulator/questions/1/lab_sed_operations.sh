#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Stream Editor (sed) Operations

# This is a LAB exercise
IS_LAB=true
LAB_ID="sed_operations"

QUESTION="Use sed for text substitution and line deletion"

# Lab configuration
LAB_TASK_COUNT=4

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Replace first 'error' with 'warning' on each line in /tmp/logfile.txt (in-place)"
TASK_1_HINT="Without 'g' flag, sed replaces only the first occurrence"
TASK_1_COMMAND_1="sed -i 's/error/warning/' /tmp/logfile.txt"

# Task 2
TASK_2_QUESTION="Replace ALL occurrences of 'DEBUG' with 'INFO' in /tmp/logfile.txt (global)"
TASK_2_HINT="g = global, replaces all occurrences on each line"
TASK_2_COMMAND_1="sed -i 's/DEBUG/INFO/g' /tmp/logfile.txt"

# Task 3
TASK_3_QUESTION="Replace all 'fail' with 'pass' case-insensitively in /tmp/logfile.txt"
TASK_3_HINT="gi = global + ignore case"
TASK_3_COMMAND_1="sed -i 's/fail/pass/gi' /tmp/logfile.txt"

# Task 4
TASK_4_QUESTION="Delete all lines containing 'DEPRECATED' from /tmp/logfile.txt"
TASK_4_HINT="d = delete lines matching the pattern"
TASK_4_COMMAND_1="sed -i '/DEPRECATED/d' /tmp/logfile.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)
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
