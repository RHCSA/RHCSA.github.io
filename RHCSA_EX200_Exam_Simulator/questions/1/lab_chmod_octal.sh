#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Set Permissions Using Octal Mode

# This is a LAB exercise
IS_LAB=true
LAB_ID="chmod_octal"

QUESTION="[LAB] Set file permissions using octal (numeric) notation"
HINT="Task 1: chmod 755 /tmp/script.sh (rwxr-xr-x)
Task 2: chmod 644 /tmp/document.txt (rw-r--r--)
Task 3: chmod 600 /tmp/private.txt (rw-------)
Task 4: chmod 750 /tmp/shared/ (rwxr-x---)"

# Lab configuration
LAB_TITLE="chmod Octal Mode"
LAB_TASK_COUNT=4

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set /tmp/script.sh to 755 (rwxr-xr-x) - user: full access; group/others: read and execute only" ;;
        1) echo "Set /tmp/document.txt to 644 (rw-r--r--) - user: read/write; group/others: read only" ;;
        2) echo "Set /tmp/private.txt to 600 (rw-------) - user: read/write; group/others: no access" ;;
        3) echo "Set /tmp/shared/ to 750 (rwxr-x---) - user: full access; group: read/execute; others: no access" ;;
    esac
}

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
