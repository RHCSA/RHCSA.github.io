#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Directory Structure and Backup File

# This is a LAB exercise
IS_LAB=true
LAB_ID="directory_backup"

QUESTION="[LAB] Create a nested directory structure, a dated backup file with system info, and multiple files"
ANSWER="Use: mkdir -p, touch with date, hostnamectl redirection, and brace expansion"
HINT="This lab has 4 tasks:\n\n1. Create nested directories: Use 'mkdir -p /tmp/dir1/dir2/dir3/dir4/dir5' to create all directories at once.\n\n2. Create dated file in dir5: Use command substitution with spaces in filename:\n   touch \"/tmp/dir1/dir2/dir3/dir4/dir5/my backup $(date +%Y-%m-%d).log\"\n\n3. Add hostnamectl output: Redirect the command output to the file:\n   hostnamectl > \"/tmp/dir1/dir2/dir3/dir4/dir5/my backup $(date +%Y-%m-%d).log\"\n\n4. Create files in dir4: Use brace expansion:\n   touch /tmp/dir1/dir2/dir3/dir4/file{1,2,3,4,5}\n\nTip: Remember to quote filenames with spaces!"

# Lab configuration
LAB_TITLE="Directory Structure and Backup File"
LAB_TASK_COUNT=4

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    local today=$(date +%Y-%m-%d)
    case "$task_idx" in
        0) echo "Create directories /tmp/dir1/dir2/dir3/dir4/dir5" ;;
        1) echo "Create file 'my backup ${today}.log' in dir5 using date command" ;;
        2) echo "Redirect hostnamectl command output in 'my backup ${today}.log'" ;;
        3) echo "Create file1, file2, file3, file4, file5 in dir4" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM} Removing existing directory structure...${RESET}"
    rm -rf /tmp/dir1 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local today=$(date +%Y-%m-%d)
    local backup_file="/tmp/dir1/dir2/dir3/dir4/dir5/my backup ${today}.log"
    
    # Task 0: Check nested directories exist
    if [[ -d /tmp/dir1/dir2/dir3/dir4/dir5 ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check backup file with today's date exists in dir5
    if [[ -f "$backup_file" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check file contains hostnamectl output
    if [[ -f "$backup_file" ]] && grep -qE "(Static hostname|Operating System|Kernel|Architecture)" "$backup_file" 2>/dev/null; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
    
    # Task 3: Check file1-5 exist in dir4
    local all_files_exist=true
    for i in 1 2 3 4 5; do
        if [[ ! -f "/tmp/dir1/dir2/dir3/dir4/file${i}" ]]; then
            all_files_exist=false
            break
        fi
        done
    if $all_files_exist; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM} Cleaning up lab environment...${RESET}"
    
    rm -rf /tmp/dir1 2>/dev/null
    
    echo -e "  ${GREEN} Lab environment cleaned up${RESET}"
    sleep 1
}
