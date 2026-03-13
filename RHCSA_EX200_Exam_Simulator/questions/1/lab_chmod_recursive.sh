#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Recursive Permission Changes

# This is a LAB exercise
IS_LAB=true
LAB_ID="chmod_recursive"

QUESTION="Set different permissions for files and directories recursively"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Set ALL directories in /tmp/webroot/ to 755"
TASK_1_HINT="Use find with -type d to target directories and -exec chmod to change permissions"
TASK_1_COMMAND_1="find /tmp/webroot -type d -exec chmod 755 {} \\;"

# Task 2
TASK_2_QUESTION="Set ALL files in /tmp/webroot/ to 644"
TASK_2_HINT="Use find with -type f to target files and -exec chmod to change permissions"
TASK_2_COMMAND_1="find /tmp/webroot -type f -exec chmod 644 {} \\;"

# Task 3
TASK_3_QUESTION="Remove write permission for others on everything in /tmp/webroot/"
TASK_3_HINT="Use chmod -R with o-w to recursively remove write for others"
TASK_3_COMMAND_1="chmod -R o-w /tmp/webroot/"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating web directory structure...${RESET}"
    rm -rf /tmp/webroot 2>/dev/null
    
    mkdir -p /tmp/webroot/css /tmp/webroot/js /tmp/webroot/images
    touch /tmp/webroot/index.html
    touch /tmp/webroot/css/style.css
    touch /tmp/webroot/js/app.js
    touch /tmp/webroot/images/logo.png
    
    # Set wrong permissions initially
    chmod 777 /tmp/webroot /tmp/webroot/css /tmp/webroot/js /tmp/webroot/images
    chmod 777 /tmp/webroot/index.html /tmp/webroot/css/style.css
    chmod 777 /tmp/webroot/js/app.js /tmp/webroot/images/logo.png
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check all directories are 755
    local all_dirs_correct=true
    while IFS= read -r dir; do
        local perms=$(stat -c %a "$dir" 2>/dev/null)
        if [[ "$perms" != "755" ]]; then
            all_dirs_correct=false
            break
        fi
    done < <(find /tmp/webroot -type d 2>/dev/null)
    
    if [[ "$all_dirs_correct" == "true" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check all files are 644
    local all_files_correct=true
    while IFS= read -r file; do
        local perms=$(stat -c %a "$file" 2>/dev/null)
        if [[ "$perms" != "644" ]]; then
            all_files_correct=false
            break
        fi
    done < <(find /tmp/webroot -type f 2>/dev/null)
    
    if [[ "$all_files_correct" == "true" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check no write for others on anything
    local no_other_write=true
    while IFS= read -r item; do
        local perms=$(stat -c %a "$item" 2>/dev/null)
        local other_perm="${perms:2:1}"
        # Others should not have write (must be 0,1,4,5)
        if [[ "$other_perm" =~ ^[2367]$ ]]; then
            no_other_write=false
            break
        fi
    done < <(find /tmp/webroot 2>/dev/null)
    
    if [[ "$no_other_write" == "true" ]]; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/webroot 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
