#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Extract Single File from Archive

# This is a LAB exercise
IS_LAB=true
LAB_ID="tar_extract_single"

QUESTION="Extract a single file from a tar archive"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Save the list of archive contents of /tmp/system.tar.gz to /tmp/archive_list.txt"
TASK_1_HINT="Use tar -tvzf to list contents with verbose output and redirect to file"
TASK_1_COMMAND_1="tar -tvzf /tmp/system.tar.gz > /tmp/archive_list.txt"

# Task 2
TASK_2_QUESTION="Extract only 'etc/hostname' from /tmp/system.tar.gz to current directory"
TASK_2_HINT="Specify the exact path of the file to extract after the archive name"
TASK_2_COMMAND_1="tar -xvzf /tmp/system.tar.gz etc/hostname"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM} Creating test archive with system files...${RESET}"
    rm -f /tmp/system.tar.gz /tmp/archive_list.txt 2>/dev/null
    rm -rf /tmp/lab_extract_test 2>/dev/null

    # Create test directory structure mimicking system files
    mkdir -p /tmp/lab_source/etc
    echo "lab-hostname" > /tmp/lab_source/etc/hostname
    echo "root:x:0:0:root:/root:/bin/bash" > /tmp/lab_source/etc/passwd
    echo "nameserver 8.8.8.8" > /tmp/lab_source/etc/resolv.conf

    # Create archive (without leading /tmp/lab_source)
    tar -czf /tmp/system.tar.gz -C /tmp/lab_source etc
    rm -rf /tmp/lab_source

    # Create working directory
    mkdir -p /tmp/lab_extract_test
    sleep 0.3

    echo -e "  ${DIM} Work in /tmp/lab_extract_test directory${RESET}"
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if archive listing was saved
    if [[ -f /tmp/archive_list.txt ]]; then
        if grep -qE 'etc/hostname|etc/passwd' /tmp/archive_list.txt 2>/dev/null; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: Check if only hostname was extracted
    # Could be in current dir or /tmp/lab_extract_test
    local hostname_found="false"

    if [[ -f ./etc/hostname ]] || [[ -f /tmp/lab_extract_test/etc/hostname ]]; then
        hostname_found="true"
    fi

    if [[ "$hostname_found" == "true" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM} Cleaning up lab environment...${RESET}"
    rm -f /tmp/system.tar.gz /tmp/archive_list.txt 2>/dev/null
    rm -rf /tmp/lab_extract_test 2>/dev/null
    rm -rf ./etc 2>/dev/null
    echo -e "  ${GREEN} Lab environment cleaned up${RESET}"
    sleep 1
}
