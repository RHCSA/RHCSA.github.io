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
TASK_3_QUESTION="Add write permission for group on everything in /tmp/webroot/"
TASK_3_HINT="Use chmod -R g+w to recursively add write permission for group"
TASK_3_COMMAND_1="chmod -R g+w /tmp/webroot/"


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
    local task3_done=false
    local dirs_755=true
    local files_644=true
    local dirs_775=true
    local files_664=true

    # Collect current permission state.
    while IFS= read -r dir; do
        local perms
        perms=$(stat -c %a "$dir" 2>/dev/null)

        if [[ "$perms" != "755" ]]; then
            dirs_755=false
        fi

        if [[ "$perms" != "775" ]]; then
            dirs_775=false
        fi
    done < <(find /tmp/webroot -type d 2>/dev/null)

    while IFS= read -r file; do
        local perms
        perms=$(stat -c %a "$file" 2>/dev/null)

        if [[ "$perms" != "644" ]]; then
            files_644=false
        fi

        if [[ "$perms" != "664" ]]; then
            files_664=false
        fi
    done < <(find /tmp/webroot -type f 2>/dev/null)

    # Task 3 is only correct when the earlier permission model is preserved
    # and group write has been added to both directories and files:
    # directories: 755 -> 775
    # files:       644 -> 664
    if [[ "$dirs_775" == "true" && "$files_664" == "true" ]]; then
        task3_done=true
    fi

    # Task 1:
    # Before task 3, directories must be exactly 755.
    # After task 3, directories are allowed to be 775 because group write was added.
    if [[ "$dirs_755" == "true" || "$task3_done" == "true" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 2:
    # Before task 3, files must be exactly 644.
    # After task 3, files are allowed to be 664 because group write was added.
    if [[ "$files_644" == "true" || "$task3_done" == "true" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 3:
    # Final expected state after the sequential changes:
    # directories must be 775 and files must be 664.
    if [[ "$task3_done" == "true" ]]; then
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
