#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Find Symbolic Links and Hard Links

# This is a LAB exercise
IS_LAB=true
LAB_ID="find_links"

QUESTION="Use find command to locate symbolic and hard links"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Find all symlinks in /tmp/linktest and save to /tmp/symlinks.txt"
TASK_1_HINT="Use find with -type l to find symbolic links"
TASK_1_COMMAND_1="find /tmp/linktest -type l > /tmp/symlinks.txt"

# Task 2
TASK_2_QUESTION="Find broken symlinks in /tmp/linktest and save to /tmp/broken_links.txt"
TASK_2_HINT="Use find with -xtype l to find broken symbolic links"
TASK_2_COMMAND_1="find /tmp/linktest -xtype l > /tmp/broken_links.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test environment with various links...${RESET}"
    rm -rf /tmp/linktest /tmp/symlinks.txt /tmp/broken_links.txt 2>/dev/null
    
    mkdir -p /tmp/linktest/subdir
    
    # Create original file
    echo "original content" > /tmp/linktest/original.txt
    
    # Create working symlinks
    ln -s /tmp/linktest/original.txt /tmp/linktest/symlink1.txt
    ln -s /etc/passwd /tmp/linktest/symlink2.txt
    
    # Create broken symlinks
    ln -s /tmp/nonexistent_file.txt /tmp/linktest/broken1.txt
    ln -s /tmp/another_missing.txt /tmp/linktest/subdir/broken2.txt
    
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check symlinks.txt contains all symlinks (4 total: 2 working + 2 broken)
    if [[ -f /tmp/symlinks.txt ]]; then
        local count=$(wc -l < /tmp/symlinks.txt | tr -d ' ')
        # Should have 4 symlinks
        if [[ "$count" -ge 4 ]]; then
            if grep -q "symlink1.txt" /tmp/symlinks.txt && grep -q "broken1.txt" /tmp/symlinks.txt; then
                TASK_STATUS[0]="true"
            else
                TASK_STATUS[0]="false"
            fi
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check broken_links.txt contains only broken symlinks (2 total)
    if [[ -f /tmp/broken_links.txt ]]; then
        local count=$(wc -l < /tmp/broken_links.txt | tr -d ' ')
        # Should have 2 broken symlinks
        if [[ "$count" -eq 2 ]]; then
            if grep -q "broken1.txt" /tmp/broken_links.txt && grep -q "broken2.txt" /tmp/broken_links.txt; then
                TASK_STATUS[1]="true"
            else
                TASK_STATUS[1]="false"
            fi
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/linktest /tmp/symlinks.txt /tmp/broken_links.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
