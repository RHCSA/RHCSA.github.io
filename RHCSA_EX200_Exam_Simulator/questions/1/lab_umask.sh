#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: umask - Control default permissions for new files and directories

# This is a LAB exercise
IS_LAB=true
LAB_ID="umask"

QUESTION="Use umask to control default permissions for newly created files and directories"

# Lab configuration
LAB_TASK_COUNT=4

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Set umask so new files get user:rw, group:r, others:r then create /tmp/exam/file1.txt"
TASK_1_HINT="Set umask 022 before creating the file to get 644 permissions"
TASK_1_COMMAND_1="umask 022"
TASK_1_COMMAND_2="touch /tmp/exam/file1.txt"

# Task 2
TASK_2_QUESTION="Set umask so new files get user:rw, group:none, others:none then create /tmp/exam/file2.txt"
TASK_2_HINT="Set umask 077 before creating the file to get 600 permissions"
TASK_2_COMMAND_1="umask 077"
TASK_2_COMMAND_2="touch /tmp/exam/file2.txt"

# Task 3
TASK_3_QUESTION="Set umask so new dirs get user:rwx, group:rx, others:none then create /tmp/exam/dir1"
TASK_3_HINT="Set umask 027 before creating the directory to get 750 permissions"
TASK_3_COMMAND_1="umask 027"
TASK_3_COMMAND_2="mkdir /tmp/exam/dir1"

# Task 4
TASK_4_QUESTION="Set umask so new dirs get user:rwx, group:rwx, others:rx then create /tmp/exam/dir2"
TASK_4_HINT="Set umask 002 before creating the directory to get 775 permissions"
TASK_4_COMMAND_1="umask 002"
TASK_4_COMMAND_2="mkdir /tmp/exam/dir2"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# Prepare lab environment
prepare_lab() {
    echo "  • Creating umask lab environment..."
    
    # Clean up any existing lab files
    rm -rf /tmp/exam 2>/dev/null
    
    # Create exam directory
    mkdir -p /tmp/exam

}

# Check tasks
check_tasks() {
    # Task 1: /tmp/exam/file1.txt should exist with 644
    if [[ -f /tmp/exam/file1.txt ]]; then
        local perms1=$(stat -c "%a" /tmp/exam/file1.txt 2>/dev/null)
        if [[ "$perms1" == "644" ]]; then
            TASK_STATUS[0]=true
        else
            TASK_STATUS[0]=false
        fi
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 2: /tmp/exam/file2.txt should exist with 600
    if [[ -f /tmp/exam/file2.txt ]]; then
        local perms2=$(stat -c "%a" /tmp/exam/file2.txt 2>/dev/null)
        if [[ "$perms2" == "600" ]]; then
            TASK_STATUS[1]=true
        else
            TASK_STATUS[1]=false
        fi
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 3: /tmp/exam/dir1 should exist with 750
    if [[ -d /tmp/exam/dir1 ]]; then
        local perms3=$(stat -c "%a" /tmp/exam/dir1 2>/dev/null)
        if [[ "$perms3" == "750" ]]; then
            TASK_STATUS[2]=true
        else
            TASK_STATUS[2]=false
        fi
    else
        TASK_STATUS[2]=false
    fi
    
    # Task 4: /tmp/exam/dir2 should exist with 775
    if [[ -d /tmp/exam/dir2 ]]; then
        local perms4=$(stat -c "%a" /tmp/exam/dir2 2>/dev/null)
        if [[ "$perms4" == "775" ]]; then
            TASK_STATUS[3]=true
        else
            TASK_STATUS[3]=false
        fi
    else
        TASK_STATUS[3]=false
    fi
}

# Cleanup lab environment
cleanup_lab() {
    echo "  • Cleaning up lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    # Reset umask to standard default
    umask 022
    echo "  • Cleanup complete (umask reset to 022)"
}
