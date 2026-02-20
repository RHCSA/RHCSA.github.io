#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Comprehensive tar/gzip/bzip2 Operations

# This is a LAB exercise
IS_LAB=true
LAB_ID="archive_comprehensive"

QUESTION="[LAB] Perform multiple archive and compression operations"
HINT="This lab has 5 tasks:\n\n1. Create uncompressed tar:\n   tar -cvf /tmp/backup1.tar /etc/hosts /etc/hostname\n\n2. Create gzip compressed tar:\n   tar -cvzf /tmp/backup2.tar.gz /etc/passwd /etc/group\n\n3. Create bzip2 compressed tar:\n   tar -cvjf /tmp/backup3.tar.bz2 /etc/ssh\n\n4. Extract to specific directory:\n   mkdir -p /tmp/extracted\n   tar -xvzf /tmp/backup2.tar.gz -C /tmp/extracted\n\n5. Compress single file:\n   gzip -k /etc/services -c > /tmp/services.gz"

# Lab configuration
LAB_TITLE="Comprehensive Archive Operations"
LAB_TASK_COUNT=5

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create uncompressed tar archive /tmp/backup1.tar with /etc/hosts and /etc/hostname" ;;
        1) echo "Create gzip compressed archive /tmp/backup2.tar.gz with /etc/passwd and /etc/group" ;;
        2) echo "Create bzip2 compressed archive /tmp/backup3.tar.bz2 with /etc/ssh" ;;
        3) echo "Extract /tmp/backup2.tar.gz to /tmp/extracted directory" ;;
        4) echo "Compress /etc/services to /tmp/services.gz (keep original)" ;;
    esac
}

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
