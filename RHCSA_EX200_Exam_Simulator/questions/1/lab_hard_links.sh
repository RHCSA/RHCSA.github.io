#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create and Verify Hard Links

# This is a LAB exercise
IS_LAB=true
LAB_ID="hard_links"

QUESTION="[LAB] Create hard links and verify they share the same inode"
HINT="This lab has 3 tasks:\n\n1. Create a hard link:\n   ln /tmp/original.txt /tmp/hardlink.txt\n   Hard links point to same inode (data blocks)\n\n2. Verify same inode:\n   ls -i /tmp/original.txt /tmp/hardlink.txt\n   Both files show same inode number\n\n3. Create hard link in different directory:\n   ln /tmp/original.txt /tmp/linkdir/file_link\n   Hard links can exist in different directories\n\nTip: Use 'stat' to see link count"

# Lab configuration
LAB_TITLE="Hard Links"
LAB_TASK_COUNT=3

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create a hard link /tmp/hardlink.txt pointing to /tmp/original.txt" ;;
        1) echo "Verify both files have the same inode number (use ls -i)" ;;
        2) echo "Create another hard link /tmp/linkdir/file_link to /tmp/original.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test files and directories...${RESET}"
    rm -rf /tmp/original.txt /tmp/hardlink.txt /tmp/linkdir 2>/dev/null
    
    echo "This is the original file content" > /tmp/original.txt
    mkdir -p /tmp/linkdir
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if hardlink.txt exists and is a hard link to original.txt
    if [[ -f /tmp/hardlink.txt ]]; then
        local inode_orig=$(stat -c %i /tmp/original.txt 2>/dev/null)
        local inode_hard=$(stat -c %i /tmp/hardlink.txt 2>/dev/null)
        if [[ "$inode_orig" == "$inode_hard" ]] && [[ -n "$inode_orig" ]]; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Already verified in task 0, but check link count >= 2
    if [[ "${TASK_STATUS[0]}" == "true" ]]; then
        local link_count=$(stat -c %h /tmp/original.txt 2>/dev/null)
        if [[ "$link_count" -ge 2 ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check if /tmp/linkdir/file_link exists and shares same inode
    if [[ -f /tmp/linkdir/file_link ]]; then
        local inode_orig=$(stat -c %i /tmp/original.txt 2>/dev/null)
        local inode_dir=$(stat -c %i /tmp/linkdir/file_link 2>/dev/null)
        if [[ "$inode_orig" == "$inode_dir" ]]; then
            TASK_STATUS[2]="true"
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
    rm -rf /tmp/original.txt /tmp/hardlink.txt /tmp/linkdir 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
