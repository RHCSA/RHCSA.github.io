#!/bin/bash

# LAB: Find Permission Search Modes (exact, minimum, any)

IS_LAB=true
LAB_ID="find_perm_modes"

QUESTION="[LAB] Practice find -perm with exact, minimum (-), and any (/) permission modes"

HINT="Task 1: find /tmp/exam -perm 644 > /tmp/exam/exact_644.txt
       (Files with EXACTLY 644 permissions)

Task 2: find /tmp/exam -perm -644 > /tmp/exam/minimum_644.txt
       (Files with AT LEAST 644 - same or more permissive)

Task 3: find /tmp/exam -perm /222 -type f > /tmp/exam/any_write.txt
       (Files where ANY write bit is set - user OR group OR other)

Task 4: find /tmp/exam -perm -111 -type f > /tmp/exam/all_exec.txt
       (Files where ALL execute bits are set - user AND group AND other)"

LAB_TITLE="Find Permission Modes (exact/-/+)"
LAB_TASK_COUNT=4

# Task descriptions
get_task_description() {
    local task_num=$1
    case $task_num in
        0) echo "Find files with EXACTLY 644, save to /tmp/exam/exact_644.txt (use -perm 644)" ;;
        1) echo "Find files with AT LEAST 644, save to /tmp/exam/minimum_644.txt (use -perm -644)" ;;
        2) echo "Find files where ANY write bit is set, save to /tmp/exam/any_write.txt (use -perm /222)" ;;
        3) echo "Find files where ALL have execute, save to /tmp/exam/all_exec.txt (use -perm -111)" ;;
    esac
}

# Prepare lab environment
prepare_lab() {
    echo "  • Creating find permission modes lab environment..."
    
    # Clean up any existing lab files
    rm -rf /tmp/exam 2>/dev/null
    
    # Create exam directory structure
    mkdir -p /tmp/exam/files
    
    # Create files with various permissions
    # Exact 644 files
    touch /tmp/exam/files/doc1.txt
    touch /tmp/exam/files/doc2.txt
    chmod 644 /tmp/exam/files/doc1.txt
    chmod 644 /tmp/exam/files/doc2.txt
    
    # More permissive than 644 (will match -644)
    touch /tmp/exam/files/shared.txt
    touch /tmp/exam/files/public.txt
    chmod 664 /tmp/exam/files/shared.txt   # group write added
    chmod 666 /tmp/exam/files/public.txt   # all write
    
    # Less permissive than 644 (won't match -644)
    touch /tmp/exam/files/private.txt
    chmod 600 /tmp/exam/files/private.txt
    
    # Files with various write bits (for /222 test)
    touch /tmp/exam/files/owner_write.txt
    touch /tmp/exam/files/group_write.txt
    touch /tmp/exam/files/other_write.txt
    chmod 644 /tmp/exam/files/owner_write.txt   # owner has write
    chmod 464 /tmp/exam/files/group_write.txt   # group has write
    chmod 446 /tmp/exam/files/other_write.txt   # other has write
    
    # Files with NO write bits (won't match /222)
    touch /tmp/exam/files/readonly.txt
    chmod 444 /tmp/exam/files/readonly.txt
    
    # Executable files (for -111 test - ALL must have x)
    touch /tmp/exam/files/script1.sh
    touch /tmp/exam/files/script2.sh
    chmod 755 /tmp/exam/files/script1.sh   # all have execute
    chmod 777 /tmp/exam/files/script2.sh   # all have execute
    
    # Partial execute (won't match -111)
    touch /tmp/exam/files/owner_exec.sh
    chmod 744 /tmp/exam/files/owner_exec.sh   # only owner has x
    
    echo "  • Lab environment ready"
    echo ""
    echo "  Permission search modes:"
    echo "    -perm 644   --> EXACTLY 644 (no more, no less)"
    echo "    -perm -644  --> AT LEAST 644 (all these bits must be set)"
    echo "    -perm /644  --> ANY of these bits set (OR logic)"
    echo ""
    echo "  Examples:"
    echo "    -perm -644  matches 644, 664, 666, 755 (has rw-r--r-- or more)"
    echo "    -perm /222  matches if user OR group OR other has write"
    echo "    -perm -111  matches only if ALL (user AND group AND other) have x"
    echo ""
    echo "  Test files created in /tmp/exam/files/"
}

# Check tasks
check_tasks() {
    # Task 1: exact_644.txt should contain only files with exactly 644
    if [[ -f /tmp/exam/exact_644.txt ]]; then
        # Should find doc1.txt, doc2.txt, owner_write.txt (exactly 644)
        local exact_count=$(grep -c "\.txt" /tmp/exam/exact_644.txt 2>/dev/null)
        if [[ $exact_count -ge 3 ]]; then
            TASK_STATUS[0]=true
        else
            TASK_STATUS[0]=false
        fi
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 2: minimum_644.txt should contain files with at least 644
    if [[ -f /tmp/exam/minimum_644.txt ]]; then
        # Should find files that have at least rw-r--r--
        # doc1, doc2, shared, public, owner_write, script1, script2
        local min_count=$(grep -c "/tmp/exam" /tmp/exam/minimum_644.txt 2>/dev/null)
        if [[ $min_count -ge 5 ]]; then
            TASK_STATUS[1]=true
        else
            TASK_STATUS[1]=false
        fi
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 3: any_write.txt should contain files where ANY write bit is set
    if [[ -f /tmp/exam/any_write.txt ]]; then
        # Should find most files except readonly.txt (444)
        local write_count=$(grep -c "/tmp/exam" /tmp/exam/any_write.txt 2>/dev/null)
        # Should NOT contain readonly.txt
        if [[ $write_count -ge 8 ]] && ! grep -q "readonly.txt" /tmp/exam/any_write.txt 2>/dev/null; then
            TASK_STATUS[2]=true
        elif [[ $write_count -ge 8 ]]; then
            TASK_STATUS[2]=true
        else
            TASK_STATUS[2]=false
        fi
    else
        TASK_STATUS[2]=false
    fi
    
    # Task 4: all_exec.txt should contain files where ALL have execute
    if [[ -f /tmp/exam/all_exec.txt ]]; then
        # Should find script1.sh (755) and script2.sh (777)
        local exec_count=$(grep -c "\.sh" /tmp/exam/all_exec.txt 2>/dev/null)
        if [[ $exec_count -ge 2 ]]; then
            # Should NOT contain owner_exec.sh (only owner has x)
            if ! grep -q "owner_exec.sh" /tmp/exam/all_exec.txt 2>/dev/null; then
                TASK_STATUS[3]=true
            else
                TASK_STATUS[3]=false
            fi
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
