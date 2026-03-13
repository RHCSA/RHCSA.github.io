#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Directory Structure and Backup File

# This is a LAB exercise
IS_LAB=true
LAB_ID="directory_backup"

QUESTION="Create a nested directory structure, a dated backup file with system info, and multiple files"

# Lab configuration
LAB_TASK_COUNT=4

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create directories /tmp/dir1/dir2/dir3/dir4/dir5"
TASK_1_HINT="Use mkdir -p to create nested directories in one command"
TASK_1_COMMAND_1="mkdir -p /tmp/dir1/dir2/dir3/dir4/dir5"

# Task 2
TASK_2_QUESTION="Create file 'my backup \$(date +%Y-%m-%d).log' in dir5 using date command"
TASK_2_HINT="Use touch with command substitution for the date"
TASK_2_COMMAND_1='touch "/tmp/dir1/dir2/dir3/dir4/dir5/my backup $(date +%Y-%m-%d).log"'

# Task 3
TASK_3_QUESTION="Redirect hostnamectl command output in 'my backup \$(date +%Y-%m-%d).log'"
TASK_3_HINT="Use output redirection to write hostnamectl output to file"
TASK_3_COMMAND_1='hostnamectl > "/tmp/dir1/dir2/dir3/dir4/dir5/my backup $(date +%Y-%m-%d).log"'

# Task 4
TASK_4_QUESTION="Create file1, file2, file3, file4, file5 in dir4"
TASK_4_HINT="Use brace expansion to create multiple files in one command"
TASK_4_COMMAND_1="touch /tmp/dir1/dir2/dir3/dir4/file{1,2,3,4,5}"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

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
