#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Fix Directory Access

IS_LAB=true
LAB_ID="fix_dir_access"

QUESTION="[LAB] Fix directory permissions so others can enter and list"
HINT="Task 1: chmod o+rx /tmp/labrestricteddir\nTask 2: ls /tmp/labrestricteddir > /tmp/dir-listing.txt"

LAB_TITLE="Fix Directory Access"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add read and execute for others on /tmp/labrestricteddir" ;;
        1) echo "List directory contents to /tmp/dir-listing.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating restricted directory...${RESET}"
    mkdir -p /tmp/labrestricteddir
    touch /tmp/labrestricteddir/file1.txt /tmp/labrestricteddir/file2.txt
    chmod 700 /tmp/labrestricteddir
    rm -f /tmp/dir-listing.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if directory has rx for others
    local perms=$(stat -c %a /tmp/labrestricteddir 2>/dev/null)
    local other_perm=$((perms % 10))
    if [[ $((other_perm & 5)) -eq 5 ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if dir-listing.txt exists with files
    if [[ -f /tmp/dir-listing.txt ]] && grep -qE 'file1|file2' /tmp/dir-listing.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/labrestricteddir /tmp/dir-listing.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
