#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Man Page Sections - Finding the Right Documentation

IS_LAB=true
LAB_ID="man_sections"

QUESTION="[LAB] Use man page sections to find command docs vs config file docs"

HINT="Task 1: man 5 passwd > /tmp/exam/passwd_file.txt
       (Section 5 = file formats, not the command)

Task 2: man 5 crontab > /tmp/exam/crontab_format.txt
       (Section 5 = crontab file format, not the command)

Task 3: man 8 useradd > /tmp/exam/useradd_admin.txt
       (Section 8 = system administration commands)"

LAB_TITLE="Man Page Sections (1, 5, 8)"
LAB_TASK_COUNT=3

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Get man page for passwd FILE FORMAT (section 5), save to /tmp/exam/passwd_file.txt" ;;
        1) echo "Get man page for crontab FILE FORMAT (section 5), save to /tmp/exam/crontab_format.txt" ;;
        2) echo "Get man page for useradd ADMIN command (section 8), save to /tmp/exam/useradd_admin.txt" ;;
    esac
}

prepare_lab() {
    echo "  • Creating man sections lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    mkdir -p /tmp/exam
    echo "  • Lab environment ready"
}

check_tasks() {
    # Task 0: passwd_file.txt should contain section 5 content (password file format)
    if [[ -f /tmp/exam/passwd_file.txt ]]; then
        # Section 5 passwd contains "password file" or field descriptions
        if grep -qi "password file\|account information\|/etc/passwd" /tmp/exam/passwd_file.txt 2>/dev/null; then
            TASK_STATUS[0]=true
        else
            TASK_STATUS[0]=false
        fi
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 1: crontab_format.txt should contain section 5 content
    if [[ -f /tmp/exam/crontab_format.txt ]]; then
        if grep -qi "tables for driving cron\|crontab file\|minute hour" /tmp/exam/crontab_format.txt 2>/dev/null; then
            TASK_STATUS[1]=true
        else
            TASK_STATUS[1]=false
        fi
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 2: useradd_admin.txt should contain section 8 content
    if [[ -f /tmp/exam/useradd_admin.txt ]]; then
        if grep -qi "create a new user\|useradd\|USERADD" /tmp/exam/useradd_admin.txt 2>/dev/null; then
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
