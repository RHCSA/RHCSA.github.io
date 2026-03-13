#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: File Transfer Using SCP

# This is a LAB exercise
IS_LAB=true
LAB_ID="ssh_scp_transfer"

QUESTION="File transfer to/from a server using SCP"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Use scp to upload /tmp/upload_test.txt to root@127.0.0.1:/tmp/uploaded.txt"
TASK_1_HINT="scp syntax: scp source user@host:destination"
TASK_1_COMMAND_1="scp /tmp/upload_test.txt root@127.0.0.1:/tmp/uploaded.txt"

# Task 2
TASK_2_QUESTION="Use scp to download root@127.0.0.1:/tmp/remote_file.txt to /tmp/downloaded.txt"
TASK_2_HINT="To download, put remote path first and local path second"
TASK_2_COMMAND_1="scp root@127.0.0.1:/tmp/remote_file.txt /tmp/downloaded.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing files...${RESET}"
    rm -f /tmp/upload_test.txt /tmp/uploaded.txt /tmp/remote_file.txt /tmp/downloaded.txt 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating file to upload...${RESET}"
    echo "This file will be uploaded via SCP" > /tmp/upload_test.txt
    sleep 0.2
    
    echo -e "  ${DIM}• Creating remote file to download...${RESET}"
    echo "This file will be downloaded via SCP" > /tmp/remote_file.txt
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check uploaded.txt exists with correct content
    if [[ -f /tmp/uploaded.txt ]]; then
        if grep -q "uploaded via SCP" /tmp/uploaded.txt 2>/dev/null; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check downloaded.txt exists with correct content
    if [[ -f /tmp/downloaded.txt ]]; then
        if grep -q "downloaded via SCP" /tmp/downloaded.txt 2>/dev/null; then
            TASK_STATUS[1]="true"
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
    rm -f /tmp/upload_test.txt /tmp/uploaded.txt /tmp/remote_file.txt /tmp/downloaded.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
