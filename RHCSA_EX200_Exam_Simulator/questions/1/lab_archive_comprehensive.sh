#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Comprehensive tar/gzip/bzip2 Operations

# This is a LAB exercise
IS_LAB=true
LAB_ID="archive_comprehensive"

QUESTION="Perform multiple archive and compression operations"

# Lab configuration
LAB_TASK_COUNT=5

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create uncompressed tar archive /tmp/backup1.tar with /etc/hosts and /etc/hostname"
TASK_1_HINT="Use -cvf for create, verbose, file"
TASK_1_COMMAND_1="tar -cvf /tmp/backup1.tar /etc/hosts /etc/hostname"

# Task 2
TASK_2_QUESTION="Create gzip compressed archive /tmp/backup2.tar.gz with /etc/passwd and /etc/group"
TASK_2_HINT="-z = gzip compression"
TASK_2_COMMAND_1="tar -cvzf /tmp/backup2.tar.gz /etc/passwd /etc/group"

# Task 3
TASK_3_QUESTION="Create bzip2 compressed archive /tmp/backup3.tar.bz2 with /etc/ssh"
TASK_3_HINT="-j = bzip2 compression"
TASK_3_COMMAND_1="tar -cvjf /tmp/backup3.tar.bz2 /etc/ssh"

# Task 4
TASK_4_QUESTION="Extract /tmp/backup2.tar.gz to /tmp/extracted directory"
TASK_4_HINT="-C specifies target directory for extraction"
TASK_4_COMMAND_1="mkdir -p /tmp/extracted && tar -xvzf /tmp/backup2.tar.gz -C /tmp/extracted"

# Task 5
TASK_5_QUESTION="Compress /etc/services to /tmp/services.gz (keep original)"
TASK_5_HINT="Use -c to write to stdout and redirect"
TASK_5_COMMAND_1="gzip -k /etc/services -c > /tmp/services.gz"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Cleaning up any existing files...${RESET}"
    rm -f /tmp/backup1.tar /tmp/backup2.tar.gz /tmp/backup3.tar.bz2 2>/dev/null
    rm -f /tmp/services.gz 2>/dev/null
    rm -rf /tmp/extracted 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check uncompressed tar exists with hosts and hostname
    if [[ -f /tmp/backup1.tar ]]; then
        local contents=$(tar -tf /tmp/backup1.tar 2>/dev/null)
        if echo "$contents" | grep -q 'hosts' && echo "$contents" | grep -q 'hostname'; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check gzip tar exists with passwd and group
    if [[ -f /tmp/backup2.tar.gz ]]; then
        local contents=$(tar -tzf /tmp/backup2.tar.gz 2>/dev/null)
        if echo "$contents" | grep -q 'passwd' && echo "$contents" | grep -q 'group'; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check bzip2 tar exists with ssh
    if [[ -f /tmp/backup3.tar.bz2 ]]; then
        if tar -tjf /tmp/backup3.tar.bz2 2>/dev/null | grep -q 'ssh'; then
            TASK_STATUS[2]="true"
        else
            TASK_STATUS[2]="false"
        fi
    else
        TASK_STATUS[2]="false"
    fi
    
    # Task 3: Check extraction to /tmp/extracted
    if [[ -d /tmp/extracted ]]; then
        if [[ -f /tmp/extracted/etc/passwd ]] || [[ -f /tmp/extracted/etc/group ]]; then
            TASK_STATUS[3]="true"
        else
            TASK_STATUS[3]="false"
        fi
    else
        TASK_STATUS[3]="false"
    fi
    
    # Task 4: Check services.gz exists and original /etc/services still exists
    if [[ -f /tmp/services.gz ]] && [[ -f /etc/services ]]; then
        if gzip -t /tmp/services.gz 2>/dev/null; then
            TASK_STATUS[4]="true"
        else
            TASK_STATUS[4]="false"
        fi
    else
        TASK_STATUS[4]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/backup1.tar /tmp/backup2.tar.gz /tmp/backup3.tar.bz2 2>/dev/null
    rm -f /tmp/services.gz 2>/dev/null
    rm -rf /tmp/extracted 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
