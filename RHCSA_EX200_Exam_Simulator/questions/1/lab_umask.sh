#!/bin/bash

# LAB: umask - Control default permissions for new files and directories

IS_LAB=true
LAB_ID="umask"

QUESTION="[LAB] Use umask to control default permissions for newly created files and directories"

HINT="Task 1: umask 022; touch /tmp/exam/file1.txt
       (Creates file with 644: rw-r--r-- standard default)

Task 2: umask 077; touch /tmp/exam/file2.txt
       (Creates file with 600: rw------- private file)

Task 3: umask 027; mkdir /tmp/exam/dir1
       (Creates directory with 750: rwxr-x--- restrictive)

Task 4: umask 002; mkdir /tmp/exam/dir2
       (Creates directory with 775: rwxrwxr-x group-friendly)"

LAB_TITLE="umask - Default Permission Control"
LAB_TASK_COUNT=4

# Task descriptions
get_task_description() {
    local task_num=$1
    case $task_num in
        0) echo "Set umask so new files get user:rw, group:r, others:r then create /tmp/exam/file1.txt" ;;
        1) echo "Set umask so new files get user:rw, group:none, others:none then create /tmp/exam/file2.txt" ;;
        2) echo "Set umask so new dirs get user:rwx, group:rx, others:none then create /tmp/exam/dir1" ;;
        3) echo "Set umask so new dirs get user:rwx, group:rwx, others:rx then create /tmp/exam/dir2" ;;
    esac
}

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
