#!/bin/bash

# LAB: SUID/SGID Display - Understanding lowercase s vs uppercase S

IS_LAB=true
LAB_ID="suid_sgid_display"

QUESTION="[LAB] Practice SUID/SGID with correct s/S display (lowercase s needs execute permission)"

HINT="Task 1: chmod 4755 /tmp/exam/suid_exec
       (Has execute, shows lowercase s: -rwsr-xr-x)

Task 2: chmod 4644 /tmp/exam/suid_noexec
       (No execute, shows uppercase S: -rwSr--r--)

Task 3: chmod 2755 /tmp/exam/sgid_exec
       (Has execute, shows lowercase s: -rwxr-sr-x)

Task 4: chmod 2644 /tmp/exam/sgid_noexec
       (No execute, shows uppercase S: -rw-r-Sr--)

Task 5: chmod 2775 /tmp/exam/shared
       (SGID directory: new files inherit group)

Task 6: chmod -R u=rwX,go=rX /tmp/exam/webroot
       (Capital X adds execute only to directories, not files)"

LAB_TITLE="SUID/SGID Display (s vs S) + chmod X"
LAB_TASK_COUNT=6

# Task descriptions
get_task_description() {
    local task_num=$1
    case $task_num in
        0) echo "Make /tmp/exam/suid_exec run as file owner (SUID with execute = lowercase s)" ;;
        1) echo "Set SUID on /tmp/exam/suid_noexec without execute (shows uppercase S warning)" ;;
        2) echo "Make /tmp/exam/sgid_exec run as file group (SGID with execute = lowercase s)" ;;
        3) echo "Set SGID on /tmp/exam/sgid_noexec without execute (shows uppercase S warning)" ;;
        4) echo "Make /tmp/exam/shared inherit group for new files (SGID on directory)" ;;
        5) echo "Set /tmp/exam/webroot: dirs=755, files=644 using chmod -R with capital X" ;;
    esac
}

# Prepare lab environment
prepare_lab() {
    echo "  • Creating SUID/SGID display lab environment..."
    
    # Clean up any existing lab files
    rm -rf /tmp/exam 2>/dev/null
    
    # Create exam directory
    mkdir -p /tmp/exam
    
    # Create test files
    touch /tmp/exam/suid_exec
    touch /tmp/exam/suid_noexec
    touch /tmp/exam/sgid_exec
    touch /tmp/exam/sgid_noexec
    mkdir -p /tmp/exam/shared
    
    # Create webroot structure for chmod X test
    mkdir -p /tmp/exam/webroot/css
    mkdir -p /tmp/exam/webroot/js
    echo "html" > /tmp/exam/webroot/index.html
    echo "css" > /tmp/exam/webroot/css/style.css
    echo "js" > /tmp/exam/webroot/js/app.js
    # Set wrong permissions (777 on everything)
    chmod -R 777 /tmp/exam/webroot
    
    # Set initial permissions (standard)
    chmod 644 /tmp/exam/suid_exec /tmp/exam/suid_noexec
    chmod 644 /tmp/exam/sgid_exec /tmp/exam/sgid_noexec
    chmod 755 /tmp/exam/shared
    
    echo "  • Lab environment ready"
}

# Check tasks
check_tasks() {
    # Task 1: suid_exec should be 4755 (shows -rwsr-xr-x)
    local perms1=$(stat -c "%a" /tmp/exam/suid_exec 2>/dev/null)
    if [[ "$perms1" == "4755" ]]; then
        TASK_STATUS[0]=true
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 2: suid_noexec should be 4644 (shows -rwSr--r--)
    local perms2=$(stat -c "%a" /tmp/exam/suid_noexec 2>/dev/null)
    if [[ "$perms2" == "4644" ]]; then
        TASK_STATUS[1]=true
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 3: sgid_exec should be 2755 (shows -rwxr-sr-x)
    local perms3=$(stat -c "%a" /tmp/exam/sgid_exec 2>/dev/null)
    if [[ "$perms3" == "2755" ]]; then
        TASK_STATUS[2]=true
    else
        TASK_STATUS[2]=false
    fi
    
    # Task 4: sgid_noexec should be 2644 (shows -rw-r-Sr--)
    local perms4=$(stat -c "%a" /tmp/exam/sgid_noexec 2>/dev/null)
    if [[ "$perms4" == "2644" ]]; then
        TASK_STATUS[3]=true
    else
        TASK_STATUS[3]=false
    fi
    
    # Task 5: shared directory should be 2775 (shows drwxrwsr-x)
    local perms5=$(stat -c "%a" /tmp/exam/shared 2>/dev/null)
    if [[ "$perms5" == "2775" ]]; then
        TASK_STATUS[4]=true
    else
        TASK_STATUS[4]=false
    fi
    
    # Task 6: webroot dirs should be 755, files should be 644
    local webroot_ok=true
    # Check directories are 755
    while IFS= read -r -d '' dir; do
        local perms=$(stat -c "%a" "$dir" 2>/dev/null)
        if [[ "$perms" != "755" ]]; then
            webroot_ok=false
            break
        fi
    done < <(find /tmp/exam/webroot -type d -print0 2>/dev/null)
    # Check files are 644
    if $webroot_ok; then
        while IFS= read -r -d '' file; do
            local perms=$(stat -c "%a" "$file" 2>/dev/null)
            if [[ "$perms" != "644" ]]; then
                webroot_ok=false
                break
            fi
        done < <(find /tmp/exam/webroot -type f -print0 2>/dev/null)
    fi
    
    if $webroot_ok; then
        TASK_STATUS[5]=true
    else
        TASK_STATUS[5]=false
    fi
}

# Cleanup lab environment
cleanup_lab() {
    echo "  • Cleaning up lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    echo "  • Cleanup complete"
}
