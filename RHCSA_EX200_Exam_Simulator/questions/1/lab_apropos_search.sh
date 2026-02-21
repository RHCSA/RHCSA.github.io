#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Search Man Pages with apropos and man -k

IS_LAB=true
LAB_ID="apropos_search"

QUESTION="[LAB] Use apropos and man -k to search for commands by keyword"

HINT="Task 1: apropos password > /tmp/exam/password_cmds.txt
       (Search all man pages containing 'password')

Task 2: man -k partition > /tmp/exam/partition_cmds.txt
       (man -k is same as apropos)

Task 3: apropos -s 8 user > /tmp/exam/user_admin.txt
       (Search only section 8 - admin commands)"

LAB_TITLE="Search Man Pages (apropos)"
LAB_TASK_COUNT=3

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Find all commands related to 'password', save to /tmp/exam/password_cmds.txt" ;;
        1) echo "Find all commands related to 'partition', save to /tmp/exam/partition_cmds.txt" ;;
        2) echo "Find admin commands (section 8) related to 'user', save to /tmp/exam/user_admin.txt" ;;
    esac
}

prepare_lab() {
    echo "  • Creating apropos lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    mkdir -p /tmp/exam
    
    # Ensure man database is up to date
    mandb -q 2>/dev/null || true
    
    echo "  • Lab environment ready"
}

check_tasks() {
    # Task 0: password_cmds.txt should have search results
    if [[ -f /tmp/exam/password_cmds.txt ]]; then
        # Should find passwd, chpasswd, etc.
        local count=$(wc -l < /tmp/exam/password_cmds.txt 2>/dev/null)
        if [[ $count -ge 2 ]]; then
            TASK_STATUS[0]=true
        else
            TASK_STATUS[0]=false
        fi
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 1: partition_cmds.txt should have search results
    if [[ -f /tmp/exam/partition_cmds.txt ]]; then
        local count=$(wc -l < /tmp/exam/partition_cmds.txt 2>/dev/null)
        if [[ $count -ge 1 ]]; then
            TASK_STATUS[1]=true
        else
            TASK_STATUS[1]=false
        fi
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 2: user_admin.txt should have section 8 results
    if [[ -f /tmp/exam/user_admin.txt ]]; then
        # Should contain (8) entries
        if grep -q "(8)" /tmp/exam/user_admin.txt 2>/dev/null; then
            TASK_STATUS[2]=true
        else
            TASK_STATUS[2]=false
        fi
    else
        TASK_STATUS[2]=false
    fi
}

cleanup_lab() {
    echo "  • Cleaning up lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    echo "  • Cleanup complete"
}
