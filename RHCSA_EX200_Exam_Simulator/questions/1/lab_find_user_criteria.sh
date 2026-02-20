#!/bin/bash

# LAB: Find by User/UID and Combined Criteria

IS_LAB=true
LAB_ID="find_user_criteria"

QUESTION="[LAB] Use find to search by user/UID and combine criteria with AND, OR, NOT"

HINT="Task 1: find /tmp/exam -user examuser > /tmp/exam/user_files.txt
       (Find files owned by examuser)

Task 2: find /tmp/exam -uid <UID> -type f > /tmp/exam/uid_files.txt
       (Use the UID shown in lab setup, e.g., find /tmp/exam -uid 1002 -type f)

Task 3: find /tmp/exam -type f -name '*.txt' -user root > /tmp/exam/root_txt.txt
       (AND - all conditions must match)

Task 4: find /tmp/exam -type f -name '*.log' -o -name '*.tmp' > /tmp/exam/log_or_tmp.txt
       (OR - either condition matches)

Task 5: find /tmp/exam -type f ! -name '*.conf' > /tmp/exam/not_conf.txt
       (NOT - exclude .conf files)"

LAB_TITLE="Find by User and Combined Criteria"
LAB_TASK_COUNT=5

# Task descriptions
get_task_description() {
    local task_num=$1
    local examuser_uid=$(id -u examuser 2>/dev/null || echo "???")
    case $task_num in
        0) echo "Find files owned by examuser, save to /tmp/exam/user_files.txt" ;;
        1) echo "Find files owned by the user with UID $examuser_uid, save to /tmp/exam/uid_files.txt (use -uid)" ;;
        2) echo "Find .txt files owned by root, save to /tmp/exam/root_txt.txt" ;;
        3) echo "Find .log OR .tmp files, save to /tmp/exam/log_or_tmp.txt" ;;
        4) echo "Find files that are NOT .conf, save to /tmp/exam/not_conf.txt" ;;
    esac
}

# Prepare lab environment
prepare_lab() {
    echo "  • Creating find user/criteria lab environment..."
    
    # Clean up any existing lab files
    rm -rf /tmp/exam 2>/dev/null
    
    # Create test user if it doesn't exist (let system assign UID)
    if ! id examuser &>/dev/null; then
        useradd examuser 2>/dev/null || true
    fi
    
    # Get the actual UID assigned to examuser
    local examuser_uid=$(id -u examuser 2>/dev/null)
    
    # Create exam directory structure
    mkdir -p /tmp/exam/logs
    mkdir -p /tmp/exam/config
    mkdir -p /tmp/exam/data
    
    # Create files owned by root
    touch /tmp/exam/data/report.txt
    touch /tmp/exam/data/summary.txt
    touch /tmp/exam/config/app.conf
    touch /tmp/exam/config/db.conf
    
    # Create files owned by examuser
    touch /tmp/exam/data/user_data.txt
    touch /tmp/exam/logs/user.log
    touch /tmp/exam/logs/audit.log
    touch /tmp/exam/data/cache.tmp
    chown examuser:examuser /tmp/exam/data/user_data.txt
    chown examuser:examuser /tmp/exam/logs/user.log
    chown examuser:examuser /tmp/exam/logs/audit.log
    chown examuser:examuser /tmp/exam/data/cache.tmp
    
    # Create various file types for OR/NOT tests
    touch /tmp/exam/logs/system.log
    touch /tmp/exam/logs/error.log
    touch /tmp/exam/data/temp.tmp
    touch /tmp/exam/data/backup.tmp
    touch /tmp/exam/config/network.conf
    touch /tmp/exam/data/readme.md
    
    echo "  • Lab environment ready"
    echo "  • User 'examuser' UID: $examuser_uid"
}

# Check tasks
check_tasks() {
    # Get examuser UID for validation
    local examuser_uid=$(id -u examuser 2>/dev/null)
    
    # Task 1: user_files.txt should contain files owned by examuser
    if [[ -f /tmp/exam/user_files.txt ]]; then
        local user_count=$(grep -c "/tmp/exam" /tmp/exam/user_files.txt 2>/dev/null)
        if [[ $user_count -ge 2 ]]; then
            TASK_STATUS[0]=true
        else
            TASK_STATUS[0]=false
        fi
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 2: uid_files.txt should contain files owned by examuser's UID
    if [[ -f /tmp/exam/uid_files.txt ]]; then
        local uid_count=$(grep -c "/tmp/exam" /tmp/exam/uid_files.txt 2>/dev/null)
        if [[ $uid_count -ge 2 ]]; then
            TASK_STATUS[1]=true
        else
            TASK_STATUS[1]=false
        fi
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 3: root_txt.txt should contain .txt files owned by root
    if [[ -f /tmp/exam/root_txt.txt ]]; then
        local root_count=$(grep -c "\.txt" /tmp/exam/root_txt.txt 2>/dev/null)
        if [[ $root_count -ge 2 ]]; then
            TASK_STATUS[2]=true
        else
            TASK_STATUS[2]=false
        fi
    else
        TASK_STATUS[2]=false
    fi
    
    # Task 4: log_or_tmp.txt should contain .log OR .tmp files
    if [[ -f /tmp/exam/log_or_tmp.txt ]]; then
        local log_count=$(grep -c "\.log\|\.tmp" /tmp/exam/log_or_tmp.txt 2>/dev/null)
        if [[ $log_count -ge 4 ]]; then
            TASK_STATUS[3]=true
        else
            TASK_STATUS[3]=false
        fi
    else
        TASK_STATUS[3]=false
    fi
    
    # Task 5: not_conf.txt should NOT contain .conf files
    if [[ -f /tmp/exam/not_conf.txt ]]; then
        local has_files=$(grep -c "/tmp/exam" /tmp/exam/not_conf.txt 2>/dev/null)
        local has_conf=$(grep -c "\.conf" /tmp/exam/not_conf.txt 2>/dev/null)
        if [[ $has_files -ge 5 ]] && [[ $has_conf -eq 0 ]]; then
            TASK_STATUS[4]=true
        else
            TASK_STATUS[4]=false
        fi
    else
        TASK_STATUS[4]=false
    fi
}

# Cleanup lab environment
cleanup_lab() {
    echo "  • Cleaning up lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    # Remove examuser created for this lab
    userdel examuser 2>/dev/null
    echo "  • Cleanup complete"
}
