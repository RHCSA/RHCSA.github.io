#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Set Permissions Using Symbolic Mode

# This is a LAB exercise
IS_LAB=true
LAB_ID="chmod_symbolic"

QUESTION="Set file permissions using symbolic notation (ugo+rwx)"

# Lab configuration
LAB_TASK_COUNT=4

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Add execute for user on /tmp/app.sh (rw-rw-r-- --> rwxrw-r--) - user gains execute"
TASK_1_HINT="Use chmod u+x to add execute permission for the user"
TASK_1_COMMAND_1="chmod u+x /tmp/app.sh"

# Task 2
TASK_2_QUESTION="Remove write for group/others on /tmp/config.txt (rw-rw-rw- --> rw-r--r--) - only user can write"
TASK_2_HINT="Use chmod go-w to remove write permission from group and others"
TASK_2_COMMAND_1="chmod go-w /tmp/config.txt"

# Task 3
TASK_3_QUESTION="Set /tmp/data.txt to 640 (rw-r-----) - user: read/write; group: read only; others: no access"
TASK_3_HINT="Use chmod with symbolic notation u=rw,g=r,o= to set exact permissions"
TASK_3_COMMAND_1="chmod u=rw,g=r,o= /tmp/data.txt"

# Task 4
TASK_4_QUESTION="Add read for all on /tmp/readme.txt (--------- --> r--r--r--) - everyone can read"
TASK_4_HINT="Use chmod a+r to add read permission for all users"
TASK_4_COMMAND_1="chmod a+r /tmp/readme.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

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
