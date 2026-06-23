#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: SUID/SGID Display - Understanding lowercase s vs uppercase S and capital X

IS_LAB=true
LAB_ID="suid_sgid_display"

QUESTION="Practice SUID/SGID display and use capital X for directory search permissions"

LAB_TASK_COUNT=6

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Configure /tmp/exam/suid_exec so every user can execute it, and execution uses the file owner's privileges"
TASK_1_HINT="Use symbolic chmod: add execute permission for everyone and enable the special user-ID bit. Do not rely on numeric permissions."
TASK_1_COMMAND_1="chmod u+s,a+x /tmp/exam/suid_exec"

# Task 2
TASK_2_QUESTION="Enable the special user-ID bit on /tmp/exam/suid_noexec, but keep the file non-executable"
TASK_2_HINT="Only add the special user-ID bit. Without owner execute permission, ls shows uppercase S in the owner execute position."
TASK_2_COMMAND_1="chmod u+s /tmp/exam/suid_noexec"

# Task 3
TASK_3_QUESTION="Configure /tmp/exam/sgid_exec so every user can execute it, and execution uses the file group's privileges"
TASK_3_HINT="Use symbolic chmod: add execute permission for everyone and enable the special group-ID bit. Do not rely on numeric permissions."
TASK_3_COMMAND_1="chmod g+s,a+x /tmp/exam/sgid_exec"

# Task 4
TASK_4_QUESTION="Enable the special group-ID bit on /tmp/exam/sgid_noexec, but keep the file non-executable"
TASK_4_HINT="Only add the special group-ID bit. Without group execute permission, ls shows uppercase S in the group execute position."
TASK_4_COMMAND_1="chmod g+s /tmp/exam/sgid_noexec"

# Task 5
TASK_5_QUESTION="Configure /tmp/exam/shared as a group-shared directory: owner and group may write, others may enter/read, and new items inherit the directory group"
TASK_5_HINT="On a directory, the special group-ID bit makes new files and subdirectories inherit the directory group. Also add group write permission."
TASK_5_COMMAND_1="chmod g+rwx,g+s /tmp/exam/shared"

# Task 6
TASK_6_QUESTION="The /tmp/exam/webroot tree has lost directory search permission. Restore it recursively with one chmod command using capital X, so directories become searchable but ordinary files do not become executable"
TASK_6_HINT="Use symbolic permissions with capital X. Capital X applies execute/search permission to directories, while regular files that are not already executable stay non-executable."
TASK_6_COMMAND_1="chmod -R u=rwX,go=rX /tmp/exam/webroot"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

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

    # Set initial permissions for SUID/SGID files.
    # These start as normal, non-executable files so the difference between
    # lowercase s and uppercase S can be demonstrated by the tasks.
    chmod 644 /tmp/exam/suid_exec /tmp/exam/suid_noexec
    chmod 644 /tmp/exam/sgid_exec /tmp/exam/sgid_noexec
    chmod 755 /tmp/exam/shared

    # Create webroot structure for chmod capital-X test
    mkdir -p /tmp/exam/webroot/css
    mkdir -p /tmp/exam/webroot/js
    echo "html" > /tmp/exam/webroot/index.html
    echo "css" > /tmp/exam/webroot/css/style.css
    echo "js" > /tmp/exam/webroot/js/app.js

    # Deliberately broken webroot permissions:
    # - directories have read/write but no execute/search permission (666)
    # - regular files also have read/write but no execute permission (666)
    #
    # This makes the reason for capital X clear:
    # chmod -R u=rwX,go=rX /tmp/exam/webroot
    # should add execute/search to directories only and leave ordinary files
    # non-executable, resulting in directories 755 and files 644.
    chmod 666 /tmp/exam/webroot
    chmod 666 /tmp/exam/webroot/css
    chmod 666 /tmp/exam/webroot/js
    chmod 666 /tmp/exam/webroot/index.html
    chmod 666 /tmp/exam/webroot/css/style.css
    chmod 666 /tmp/exam/webroot/js/app.js

    echo "  • Lab environment ready"
}

# Check tasks
check_tasks() {
    # Task 1: suid_exec should be executable by all with SUID set (4755 / -rwsr-xr-x)
    local perms1
    perms1=$(stat -c "%a" /tmp/exam/suid_exec 2>/dev/null)
    if [[ "$perms1" == "4755" ]]; then
        TASK_STATUS[0]=true
    else
        TASK_STATUS[0]=false
    fi

    # Task 2: suid_noexec should have SUID set but no execute bits (4644 / -rwSr--r--)
    local perms2
    perms2=$(stat -c "%a" /tmp/exam/suid_noexec 2>/dev/null)
    if [[ "$perms2" == "4644" ]]; then
        TASK_STATUS[1]=true
    else
        TASK_STATUS[1]=false
    fi

    # Task 3: sgid_exec should be executable by all with SGID set (2755 / -rwxr-sr-x)
    local perms3
    perms3=$(stat -c "%a" /tmp/exam/sgid_exec 2>/dev/null)
    if [[ "$perms3" == "2755" ]]; then
        TASK_STATUS[2]=true
    else
        TASK_STATUS[2]=false
    fi

    # Task 4: sgid_noexec should have SGID set but no execute bits (2644 / -rw-r-Sr--)
    local perms4
    perms4=$(stat -c "%a" /tmp/exam/sgid_noexec 2>/dev/null)
    if [[ "$perms4" == "2644" ]]; then
        TASK_STATUS[3]=true
    else
        TASK_STATUS[3]=false
    fi

    # Task 5: shared directory should be group-writable with SGID set (2775 / drwxrwsr-x)
    local perms5
    perms5=$(stat -c "%a" /tmp/exam/shared 2>/dev/null)
    if [[ "$perms5" == "2775" ]]; then
        TASK_STATUS[4]=true
    else
        TASK_STATUS[4]=false
    fi

    # Task 6: webroot directories should be 755 and ordinary files should be 644.
    # This verifies the result of the intended capital-X exercise.
    local webroot_ok=true
    local item_perms

    while IFS= read -r -d '' dir; do
        item_perms=$(stat -c "%a" "$dir" 2>/dev/null)
        if [[ "$item_perms" != "755" ]]; then
            webroot_ok=false
            break
        fi
    done < <(find /tmp/exam/webroot -type d -print0 2>/dev/null)

    if $webroot_ok; then
        while IFS= read -r -d '' file; do
            item_perms=$(stat -c "%a" "$file" 2>/dev/null)
            if [[ "$item_perms" != "644" ]]; then
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
