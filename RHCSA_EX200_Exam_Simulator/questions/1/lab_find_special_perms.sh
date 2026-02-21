#!/bin/bash

# LAB: Find Files with Special Permissions (SUID, SGID, Sticky Bit)

IS_LAB=true
LAB_ID="find_special_perms"

QUESTION="[LAB] Use find command to locate files with SUID, SGID, and sticky bit permissions"

HINT="Task 1: find /tmp/exam -perm /4000 -type f > /tmp/exam/suid_files.txt
       (Find files with SUID set)

Task 2: find /tmp/exam -perm /2000 -type f > /tmp/exam/sgid_files.txt
       (Find files with SGID set)

Task 3: find /tmp/exam -perm /6000 -type f > /tmp/exam/suid_or_sgid.txt
       (Find files with SUID OR SGID set)

Task 4: find /tmp/exam -perm /1000 -type d > /tmp/exam/sticky_dirs.txt
       (Find directories with sticky bit)"

LAB_TITLE="Find Special Permissions (SUID/SGID/Sticky)"
LAB_TASK_COUNT=4

# Task descriptions
get_task_description() {
    local task_num=$1
    case $task_num in
        0) echo "Find files with SUID set in /tmp/exam, save to /tmp/exam/suid_files.txt (use -perm /4000)" ;;
        1) echo "Find files with SGID set in /tmp/exam, save to /tmp/exam/sgid_files.txt (use -perm /2000)" ;;
        2) echo "Find files with SUID or SGID set in /tmp/exam, save to /tmp/exam/suid_or_sgid.txt (use -perm /6000)" ;;
        3) echo "Find directories with sticky bit set in /tmp/exam, save to /tmp/exam/sticky_dirs.txt (use -perm /1000)" ;;
    esac
}

# Prepare lab environment
prepare_lab() {
    echo "  • Creating find special permissions lab environment..."
    
    # Clean up any existing lab files
    rm -rf /tmp/exam 2>/dev/null
    
    # Create exam directory structure
    mkdir -p /tmp/exam/bin
    mkdir -p /tmp/exam/shared
    mkdir -p /tmp/exam/public
    
    # Create files with SUID
    touch /tmp/exam/bin/suid_app1
    touch /tmp/exam/bin/suid_app2
    chmod 4755 /tmp/exam/bin/suid_app1
    chmod 4755 /tmp/exam/bin/suid_app2
    
    # Create files with SGID
    touch /tmp/exam/shared/sgid_script1
    touch /tmp/exam/shared/sgid_script2
    chmod 2755 /tmp/exam/shared/sgid_script1
    chmod 2755 /tmp/exam/shared/sgid_script2
    
    # Create file with both SUID and SGID
    touch /tmp/exam/bin/both_suid_sgid
    chmod 6755 /tmp/exam/bin/both_suid_sgid
    
    # Create directories with sticky bit
    chmod 1777 /tmp/exam/public
    mkdir -p /tmp/exam/dropzone
    chmod 1755 /tmp/exam/dropzone
    
    # Create some regular files (no special perms)
    touch /tmp/exam/regular_file.txt
    chmod 644 /tmp/exam/regular_file.txt
    
    echo "  • Lab environment ready"
}

# Check tasks
check_tasks() {
    # Task 1: suid_files.txt should contain the SUID files
    if [[ -f /tmp/exam/suid_files.txt ]]; then
        # Should find 3 SUID files (suid_app1, suid_app2, both_suid_sgid)
        local suid_count=$(grep -c "/tmp/exam" /tmp/exam/suid_files.txt 2>/dev/null)
        if [[ $suid_count -ge 3 ]]; then
            TASK_STATUS[0]=true
        else
            TASK_STATUS[0]=false
        fi
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 2: sgid_files.txt should contain the SGID files
    if [[ -f /tmp/exam/sgid_files.txt ]]; then
        # Should find 3 SGID files (sgid_script1, sgid_script2, both_suid_sgid)
        local sgid_count=$(grep -c "/tmp/exam" /tmp/exam/sgid_files.txt 2>/dev/null)
        if [[ $sgid_count -ge 3 ]]; then
            TASK_STATUS[1]=true
        else
            TASK_STATUS[1]=false
        fi
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 3: suid_or_sgid.txt should contain files with either SUID or SGID
    if [[ -f /tmp/exam/suid_or_sgid.txt ]]; then
        # Should find 5 files total (2 SUID + 2 SGID + 1 both)
        local both_count=$(grep -c "/tmp/exam" /tmp/exam/suid_or_sgid.txt 2>/dev/null)
        if [[ $both_count -ge 5 ]]; then
            TASK_STATUS[2]=true
        else
            TASK_STATUS[2]=false
        fi
    else
        TASK_STATUS[2]=false
    fi
    
    # Task 4: sticky_dirs.txt should contain directories with sticky bit
    if [[ -f /tmp/exam/sticky_dirs.txt ]]; then
        # Should find 2 directories (public, dropzone)
        local sticky_count=$(grep -c "/tmp/exam" /tmp/exam/sticky_dirs.txt 2>/dev/null)
        if [[ $sticky_count -ge 2 ]]; then
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
    echo "  • Cleanup complete"
}
