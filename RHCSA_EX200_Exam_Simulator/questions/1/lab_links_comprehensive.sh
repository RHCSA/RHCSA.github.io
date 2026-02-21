#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Comprehensive Hard and Soft Links

# This is a LAB exercise
IS_LAB=true
LAB_ID="links_comprehensive"

QUESTION="[LAB] Comprehensive lab covering hard and soft links"
HINT="Task 1: echo 'data' > /tmp/datafile.txt && ln /tmp/datafile.txt /tmp/datafile_hard.txt
Task 2: ln -s /etc /tmp/etc_link
Task 3: stat -c %i /tmp/datafile.txt > /tmp/inode.txt
Task 4: ln -sfn /var /tmp/etc_link (-n = don't follow symlink)
Task 5: stat -c %h /tmp/datafile.txt > /tmp/linkcount.txt"

# Lab configuration
LAB_TITLE="Comprehensive Links Lab"
LAB_TASK_COUNT=5

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/datafile.txt with 'data' and hard link /tmp/datafile_hard.txt" ;;
        1) echo "Create symlink /tmp/etc_link pointing to /etc" ;;
        2) echo "Save the inode number of /tmp/datafile.txt to /tmp/inode.txt" ;;
        3) echo "Update /tmp/etc_link to point to /var instead (use ln -sfn)" ;;
        4) echo "Save the hard link count of /tmp/datafile.txt to /tmp/linkcount.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Cleaning test environment...${RESET}"
    rm -f /tmp/datafile.txt /tmp/datafile_hard.txt 2>/dev/null
    rm -f /tmp/etc_link /tmp/inode.txt /tmp/linkcount.txt 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check datafile.txt and hard link exist with same inode
    if [[ -f /tmp/datafile.txt ]] && [[ -f /tmp/datafile_hard.txt ]]; then
        local inode1=$(stat -c %i /tmp/datafile.txt 2>/dev/null)
        local inode2=$(stat -c %i /tmp/datafile_hard.txt 2>/dev/null)
        if [[ "$inode1" == "$inode2" ]] && grep -q "data" /tmp/datafile.txt 2>/dev/null; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check symlink exists (may have been updated to /var)
    if [[ -L /tmp/etc_link ]]; then
        local target=$(readlink /tmp/etc_link)
        if [[ "$target" == "/etc" ]] || [[ "$target" == "/var" ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check inode.txt contains correct inode number
    if [[ -f /tmp/inode.txt ]] && [[ -f /tmp/datafile.txt ]]; then
        local expected_inode=$(stat -c %i /tmp/datafile.txt 2>/dev/null)
        local saved_inode=$(cat /tmp/inode.txt | tr -d ' \n')
        if [[ "$expected_inode" == "$saved_inode" ]]; then
            TASK_STATUS[2]="true"
        else
            TASK_STATUS[2]="false"
        fi
    else
        TASK_STATUS[2]="false"
    fi
    
    # Task 3: Check symlink now points to /var
    if [[ -L /tmp/etc_link ]]; then
        local target=$(readlink /tmp/etc_link)
        if [[ "$target" == "/var" ]]; then
            TASK_STATUS[3]="true"
        else
            TASK_STATUS[3]="false"
        fi
    else
        TASK_STATUS[3]="false"
    fi
    
    # Task 4: Check linkcount.txt contains correct link count (should be 2)
    if [[ -f /tmp/linkcount.txt ]] && [[ -f /tmp/datafile.txt ]]; then
        local expected_count=$(stat -c %h /tmp/datafile.txt 2>/dev/null)
        local saved_count=$(cat /tmp/linkcount.txt | tr -d ' \n')
        if [[ "$expected_count" == "$saved_count" ]] && [[ "$saved_count" == "2" ]]; then
            TASK_STATUS[4]="true"
        else
            TASK_STATUS[4]="false"
        fi
    else
        TASK_STATUS[4]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/datafile.txt /tmp/datafile_hard.txt 2>/dev/null
    rm -f /tmp/etc_link /tmp/inode.txt /tmp/linkcount.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
