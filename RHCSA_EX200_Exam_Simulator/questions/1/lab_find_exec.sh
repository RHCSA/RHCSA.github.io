#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Find with -exec Actions

# This is a LAB exercise
IS_LAB=true
LAB_ID="find_exec"

QUESTION="Use find -exec to perform actions on found files (chmod, cp, delete)"

# Lab configuration
LAB_TASK_COUNT=5

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Set all FILES in /tmp/exam/web to 644"
TASK_1_HINT="Use find with -type f and -exec chmod 644 {} \\;"
TASK_1_COMMAND_1="find /tmp/exam/web -type f -exec chmod 644 {} \\;"

# Task 2
TASK_2_QUESTION="Set all DIRECTORIES in /tmp/exam/web to 755"
TASK_2_HINT="Use find with -type d and -exec chmod 755 {} \\;"
TASK_2_COMMAND_1="find /tmp/exam/web -type d -exec chmod 755 {} \\;"

# Task 3
TASK_3_QUESTION="Copy all .conf files from /tmp/exam/config to /tmp/exam/backup/"
TASK_3_HINT="Use find with -name '*.conf' and -exec cp {} destination \\;"
TASK_3_COMMAND_1="find /tmp/exam/config -name '*.conf' -exec cp {} /tmp/exam/backup/ \\;"

# Task 4
TASK_4_QUESTION="Delete all empty files in /tmp/exam/temp"
TASK_4_HINT="Use find with -type f -empty -delete"
TASK_4_COMMAND_1="find /tmp/exam/temp -type f -empty -delete"

# Task 5
TASK_5_QUESTION="Delete all empty directories in /tmp/exam/cleanup"
TASK_5_HINT="Use find with -type d -empty -delete"
TASK_5_COMMAND_1="find /tmp/exam/cleanup -type d -empty -delete"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# Prepare lab environment
prepare_lab() {
    echo "  • Creating find -exec lab environment..."
    
    # Clean up any existing lab files
    rm -rf /tmp/exam 2>/dev/null
    
    # Create exam directory structure
    mkdir -p /tmp/exam/web/css
    mkdir -p /tmp/exam/web/js
    mkdir -p /tmp/exam/web/images
    mkdir -p /tmp/exam/config
    mkdir -p /tmp/exam/backup
    mkdir -p /tmp/exam/temp
    mkdir -p /tmp/exam/cleanup
    
    # Create web files with wrong permissions (777)
    echo "html content" > /tmp/exam/web/index.html
    echo "css content" > /tmp/exam/web/css/style.css
    echo "js content" > /tmp/exam/web/js/app.js
    echo "image placeholder" > /tmp/exam/web/images/logo.png
    chmod 777 /tmp/exam/web/index.html
    chmod 777 /tmp/exam/web/css/style.css
    chmod 777 /tmp/exam/web/js/app.js
    chmod 777 /tmp/exam/web/images/logo.png
    
    # Set directories to wrong permissions too
    chmod 777 /tmp/exam/web
    chmod 777 /tmp/exam/web/css
    chmod 777 /tmp/exam/web/js
    chmod 777 /tmp/exam/web/images
    
    # Create config files
    echo "app config" > /tmp/exam/config/app.conf
    echo "db config" > /tmp/exam/config/database.conf
    echo "cache config" > /tmp/exam/config/cache.conf
    echo "readme" > /tmp/exam/config/README.md
    
    # Create temp files (some empty, some not)
    touch /tmp/exam/temp/empty1.tmp
    touch /tmp/exam/temp/empty2.tmp
    touch /tmp/exam/temp/empty3.tmp
    echo "has content" > /tmp/exam/temp/notempty.tmp
    echo "also content" > /tmp/exam/temp/data.txt
    
    # Create cleanup directory with empty and non-empty subdirectories
    mkdir -p /tmp/exam/cleanup/empty1
    mkdir -p /tmp/exam/cleanup/empty2
    mkdir -p /tmp/exam/cleanup/empty3
    mkdir -p /tmp/exam/cleanup/notempty
    echo "keep this dir" > /tmp/exam/cleanup/notempty/file.txt
    
    echo "  • Lab environment ready"
}

# Check tasks
check_tasks() {
    # Task 1: All FILES in /tmp/exam/web should be 644
    local file_perms_ok=true
    while IFS= read -r -d '' file; do
        local perms=$(stat -c "%a" "$file" 2>/dev/null)
        if [[ "$perms" != "644" ]]; then
            file_perms_ok=false
            break
        fi
    done < <(find /tmp/exam/web -type f -print0 2>/dev/null)
    
    if $file_perms_ok && [[ -f /tmp/exam/web/index.html ]]; then
        TASK_STATUS[0]=true
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 2: All DIRECTORIES in /tmp/exam/web should be 755
    local dir_perms_ok=true
    while IFS= read -r -d '' dir; do
        local perms=$(stat -c "%a" "$dir" 2>/dev/null)
        if [[ "$perms" != "755" ]]; then
            dir_perms_ok=false
            break
        fi
    done < <(find /tmp/exam/web -type d -print0 2>/dev/null)
    
    if $dir_perms_ok; then
        TASK_STATUS[1]=true
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 3: All .conf files should be copied to /tmp/exam/backup/
    if [[ -f /tmp/exam/backup/app.conf ]] && \
       [[ -f /tmp/exam/backup/database.conf ]] && \
       [[ -f /tmp/exam/backup/cache.conf ]]; then
        TASK_STATUS[2]=true
    else
        TASK_STATUS[2]=false
    fi
    
    # Task 4: Empty files in /tmp/exam/temp should be deleted
    local empty_count=$(find /tmp/exam/temp -type f -empty 2>/dev/null | wc -l)
    local notempty_exists=$([[ -f /tmp/exam/temp/notempty.tmp ]] && echo "yes" || echo "no")
    
    if [[ $empty_count -eq 0 ]] && [[ "$notempty_exists" == "yes" ]]; then
        TASK_STATUS[3]=true
    else
        TASK_STATUS[3]=false
    fi
    
    # Task 5: Empty directories in /tmp/exam/cleanup should be deleted
    local empty_dir_count=$(find /tmp/exam/cleanup -type d -empty 2>/dev/null | wc -l)
    local notempty_dir_exists=$([[ -d /tmp/exam/cleanup/notempty ]] && echo "yes" || echo "no")
    
    if [[ $empty_dir_count -eq 0 ]] && [[ "$notempty_dir_exists" == "yes" ]]; then
        TASK_STATUS[4]=true
    else
        TASK_STATUS[4]=false
    fi
}

# Cleanup lab environment
cleanup_lab() {
    echo "  • Cleaning up lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    echo "  • Cleanup complete"
}
