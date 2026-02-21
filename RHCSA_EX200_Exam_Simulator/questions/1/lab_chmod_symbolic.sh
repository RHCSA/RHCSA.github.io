#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Set Permissions Using Symbolic Mode

# This is a LAB exercise
IS_LAB=true
LAB_ID="chmod_symbolic"

QUESTION="[LAB] Set file permissions using symbolic notation (ugo+rwx)"
HINT="Task 1: chmod u+x /tmp/app.sh
Task 2: chmod go-w /tmp/config.txt
Task 3: chmod u=rw,g=r,o= /tmp/data.txt
Task 4: chmod a+r /tmp/readme.txt"

# Lab configuration
LAB_TITLE="chmod Symbolic Mode"
LAB_TASK_COUNT=4

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add execute for user on /tmp/app.sh (rw-rw-r-- --> rwxrw-r--) - user gains execute" ;;
        1) echo "Remove write for group/others on /tmp/config.txt (rw-rw-rw- --> rw-r--r--) - only user can write" ;;
        2) echo "Set /tmp/data.txt to 640 (rw-r-----) - user: read/write; group: read only; others: no access" ;;
        3) echo "Add read for all on /tmp/readme.txt (--------- --> r--r--r--) - everyone can read" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test files with initial permissions...${RESET}"
    rm -f /tmp/app.sh /tmp/config.txt /tmp/data.txt /tmp/readme.txt 2>/dev/null
    
    touch /tmp/app.sh /tmp/config.txt /tmp/data.txt /tmp/readme.txt
    chmod 664 /tmp/app.sh      # rw-rw-r-- (need to add u+x)
    chmod 666 /tmp/config.txt  # rw-rw-rw- (need to remove go-w)
    chmod 777 /tmp/data.txt    # rwxrwxrwx (need to set to 640)
    chmod 000 /tmp/readme.txt  # --------- (need to add a+r)
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check app.sh has user execute (should be 764 or 774)
    local perms=$(stat -c %a /tmp/app.sh 2>/dev/null)
    # User must have execute (7xx)
    if [[ "${perms:0:1}" == "7" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check config.txt has no write for group/others (should be 644 or 640 or 600)
    perms=$(stat -c %a /tmp/config.txt 2>/dev/null)
    # Group and others must not have write (x4x or x0x for group, xx4 or xx0 for others)
    local group_perm="${perms:1:1}"
    local other_perm="${perms:2:1}"
    if [[ "$group_perm" =~ ^[0145]$ ]] && [[ "$other_perm" =~ ^[0145]$ ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check data.txt is exactly 640
    perms=$(stat -c %a /tmp/data.txt 2>/dev/null)
    if [[ "$perms" == "640" ]]; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
    
    # Task 3: Check readme.txt has read for all (at least 444)
    perms=$(stat -c %a /tmp/readme.txt 2>/dev/null)
    # All positions must have at least read (4)
    local user_perm="${perms:0:1}"
    group_perm="${perms:1:1}"
    other_perm="${perms:2:1}"
    if [[ "$user_perm" -ge 4 ]] && [[ "$group_perm" -ge 4 ]] && [[ "$other_perm" -ge 4 ]]; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/app.sh /tmp/config.txt /tmp/data.txt /tmp/readme.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
