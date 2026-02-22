#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Special Permissions (SUID, SGID, Sticky Bit)

# This is a LAB exercise
IS_LAB=true
LAB_ID="special_perms"

QUESTION="[LAB] Set special permissions: SUID, SGID, and Sticky Bit"
HINT="Task 1: chmod u+s /tmp/special/myapp (or chmod 4755)
Task 2: chmod g+s /tmp/special/shared/ (or chmod 2775)
Task 3: chmod o+t /tmp/special/dropbox/ (or chmod 1777)
Task 4: chmod 3775 /tmp/special/project/ (SGID+Sticky)"

# Lab configuration
LAB_TITLE="Special Permissions"
LAB_TASK_COUNT=4

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Make /tmp/special/myapp run as the file owner (SUID)" ;;
        1) echo "Make new files in /tmp/special/shared/ inherit the directory group (SGID)" ;;
        2) echo "Prevent users from deleting others' files in /tmp/special/dropbox/ (Sticky Bit)" ;;
        3) echo "Set /tmp/special/project/ to inherit group AND prevent deletion by others (SGID + Sticky)" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test files and directories...${RESET}"
    rm -rf /tmp/special 2>/dev/null
    
    mkdir -p /tmp/special/shared /tmp/special/dropbox /tmp/special/project
    touch /tmp/special/myapp
    chmod 755 /tmp/special/myapp
    chmod 775 /tmp/special/shared /tmp/special/dropbox /tmp/special/project
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check myapp has SUID set (4xxx)
    local perms=$(stat -c %a /tmp/special/myapp 2>/dev/null)
    if [[ "${perms:0:1}" == "4" ]] || [[ "$perms" =~ ^4 ]]; then
        TASK_STATUS[0]="true"
    else
        # Check using symbolic
        local sym_perms=$(stat -c %A /tmp/special/myapp 2>/dev/null)
        if [[ "$sym_perms" == *"s"* ]] && [[ "${sym_perms:3:1}" == "s" || "${sym_perms:3:1}" == "S" ]]; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    fi
    
    # Task 1: Check shared/ has SGID set (2xxx)
    perms=$(stat -c %a /tmp/special/shared 2>/dev/null)
    if [[ "$perms" == "2"* ]]; then
        TASK_STATUS[1]="true"
    else
        local sym_perms=$(stat -c %A /tmp/special/shared 2>/dev/null)
        if [[ "${sym_perms:6:1}" == "s" || "${sym_perms:6:1}" == "S" ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    fi
    
    # Task 2: Check dropbox/ has Sticky Bit set (1xxx)
    perms=$(stat -c %a /tmp/special/dropbox 2>/dev/null)
    if [[ "$perms" == "1"* ]]; then
        TASK_STATUS[2]="true"
    else
        local sym_perms=$(stat -c %A /tmp/special/dropbox 2>/dev/null)
        if [[ "${sym_perms:9:1}" == "t" || "${sym_perms:9:1}" == "T" ]]; then
            TASK_STATUS[2]="true"
        else
            TASK_STATUS[2]="false"
        fi
    fi
    
    # Task 3: Check project/ has both SGID and Sticky (3xxx)
    perms=$(stat -c %a /tmp/special/project 2>/dev/null)
    if [[ "$perms" == "3"* ]]; then
        TASK_STATUS[3]="true"
    else
        local sym_perms=$(stat -c %A /tmp/special/project 2>/dev/null)
        local has_sgid=false
        local has_sticky=false
        if [[ "${sym_perms:6:1}" == "s" || "${sym_perms:6:1}" == "S" ]]; then
            has_sgid=true
        fi
        if [[ "${sym_perms:9:1}" == "t" || "${sym_perms:9:1}" == "T" ]]; then
            has_sticky=true
        fi
        if [[ "$has_sgid" == "true" ]] && [[ "$has_sticky" == "true" ]]; then
            TASK_STATUS[3]="true"
        else
            TASK_STATUS[3]="false"
        fi
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/special 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
