#!/bin/bash

# LAB: Directory Permissions - Understanding r, w, x on directories

IS_LAB=true
LAB_ID="directory_permissions"

QUESTION="[LAB] Set directory permissions to control access (r=list, w=create/delete, x=enter)"

HINT="Task 1: chmod 755 /tmp/exam/public
       (Owner: full access, Others: can list and enter, but not create files)

Task 2: chmod 700 /tmp/exam/private
       (Only owner can list, enter, or modify - others blocked completely)

Task 3: chmod 733 /tmp/exam/dropbox
       (Owner: full access, Others: can enter and create files, but cannot list contents)

Task 4: chmod 711 /tmp/exam/gateway
       (Owner: full access, Others: can enter only if they know exact filename)"

LAB_TITLE="Directory Permissions (r/w/x behavior)"
LAB_TASK_COUNT=4

# Task descriptions
get_task_description() {
    local task_num=$1
    case $task_num in
        0) echo "Set the permission of  /tmp/exam/public, so owner has full access, others can list and enter but not create files" ;;
        1) echo "Set the permission of /tmp/exam/private, so only owner can access - completely private from others" ;;
        2) echo "Set the permission of /tmp/exam/dropbox, so others can enter and create files but cannot list contents" ;;
        3) echo "Set the permission of /tmp/exam/gateway, so others can only enter - cannot list (must know exact filename)" ;;
    esac
}

# Prepare lab environment
prepare_lab() {
    echo "  • Creating directory permission test directories..."
    
    # Clean up any existing lab files
    rm -rf /tmp/exam 2>/dev/null
    
    # Create exam directory structure
    mkdir -p /tmp/exam/public
    mkdir -p /tmp/exam/private
    mkdir -p /tmp/exam/dropbox
    mkdir -p /tmp/exam/gateway
    
    # Create sample files in each directory to test access
    echo "public file" > /tmp/exam/public/readme.txt
    echo "private data" > /tmp/exam/private/secret.txt
    echo "drop here" > /tmp/exam/dropbox/info.txt
    echo "gateway file" > /tmp/exam/gateway/known.txt
    
    # Set initial permissions (all open)
    chmod 777 /tmp/exam/public /tmp/exam/private /tmp/exam/dropbox /tmp/exam/gateway
}

# Check tasks
check_tasks() {
    # Task 1: /tmp/exam/public should be 755
    local perms1=$(stat -c "%a" /tmp/exam/public 2>/dev/null)
    if [[ "$perms1" == "755" ]]; then
        TASK_STATUS[0]=true
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 2: /tmp/exam/private should be 700
    local perms2=$(stat -c "%a" /tmp/exam/private 2>/dev/null)
    if [[ "$perms2" == "700" ]]; then
        TASK_STATUS[1]=true
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 3: /tmp/exam/dropbox should be 733
    local perms3=$(stat -c "%a" /tmp/exam/dropbox 2>/dev/null)
    if [[ "$perms3" == "733" ]]; then
        TASK_STATUS[2]=true
    else
        TASK_STATUS[2]=false
    fi
    
    # Task 4: /tmp/exam/gateway should be 711
    local perms4=$(stat -c "%a" /tmp/exam/gateway 2>/dev/null)
    if [[ "$perms4" == "711" ]]; then
        TASK_STATUS[3]=true
    else
        TASK_STATUS[3]=false
    fi
}

# Cleanup lab environment
cleanup_lab() {
    echo "  • Cleaning up lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    echo "  • Cleanup complete"
}
