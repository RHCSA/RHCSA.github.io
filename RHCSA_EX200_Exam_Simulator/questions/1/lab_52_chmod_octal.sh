#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Set Permissions Using Octal Mode

# This is a LAB exercise
IS_LAB=true
LAB_ID="chmod_octal"

QUESTION="Set file permissions using octal (numeric) notation"

# Lab configuration
LAB_TASK_COUNT=4

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Set /tmp/script.sh to 755 (rwxr-xr-x) - user: full access; group/others: read and execute only"
TASK_1_HINT="Use chmod with octal mode 755 to set rwxr-xr-x permissions"
TASK_1_COMMAND_1="chmod 755 /tmp/script.sh"

# Task 2
TASK_2_QUESTION="Set /tmp/document.txt to 644 (rw-r--r--) - user: read/write; group/others: read only"
TASK_2_HINT="Use chmod with octal mode 644 to set rw-r--r-- permissions"
TASK_2_COMMAND_1="chmod 644 /tmp/document.txt"

# Task 3
TASK_3_QUESTION="Set /tmp/private.txt to 600 (rw-------) - user: read/write; group/others: no access"
TASK_3_HINT="Use chmod with octal mode 600 to restrict access to owner only"
TASK_3_COMMAND_1="chmod 600 /tmp/private.txt"

# Task 4
TASK_4_QUESTION="Set /tmp/shared/ to 750 (rwxr-x---) - user: full access; group: read/execute; others: no access"
TASK_4_HINT="Use chmod with octal mode 750 to allow group read/execute but deny others"
TASK_4_COMMAND_1="chmod 750 /tmp/shared/"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test files...${RESET}"
    rm -rf /tmp/script.sh /tmp/document.txt /tmp/private.txt /tmp/shared 2>/dev/null
    
    touch /tmp/script.sh /tmp/document.txt /tmp/private.txt
    mkdir -p /tmp/shared
    chmod 000 /tmp/script.sh /tmp/document.txt /tmp/private.txt /tmp/shared
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check script.sh has 755
    local perms=$(stat -c %a /tmp/script.sh 2>/dev/null)
    if [[ "$perms" == "755" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check document.txt has 644
    perms=$(stat -c %a /tmp/document.txt 2>/dev/null)
    if [[ "$perms" == "644" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check private.txt has 600
    perms=$(stat -c %a /tmp/private.txt 2>/dev/null)
    if [[ "$perms" == "600" ]]; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
    
    # Task 3: Check shared/ has 750
    perms=$(stat -c %a /tmp/shared 2>/dev/null)
    if [[ "$perms" == "750" ]]; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/script.sh /tmp/document.txt /tmp/private.txt /tmp/shared 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
