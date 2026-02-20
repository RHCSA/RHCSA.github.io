#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Comprehensive Permissions Lab

# This is a LAB exercise
IS_LAB=true
LAB_ID="permissions_comprehensive"

QUESTION="[LAB] Comprehensive permissions lab combining multiple skills"
HINT="This lab has 5 tasks:\n\n1. Create file and set permissions:\n   touch /tmp/exam/report.txt\n   chmod 640 /tmp/exam/report.txt\n   (640 = user:rw, group:r, others:none)\n\n2. Create directory with specific permissions:\n   mkdir /tmp/exam/data\n   chmod 750 /tmp/exam/data\n   (750 = user:rwx, group:rx, others:none)\n\n3. Change ownership:\n   chown nobody:nobody /tmp/exam/report.txt\n\n4. Make new files inherit directory group (SGID):\n   chmod g+s /tmp/exam/data\n   Or: chmod 2750 /tmp/exam/data\n\n5. Save permissions to file:\n   stat -c %a /tmp/exam/report.txt > /tmp/exam/perms.txt"

# Lab configuration
LAB_TITLE="Comprehensive Permissions"
LAB_TASK_COUNT=5

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/exam/report.txt with 640 (user:rw, group:r, others:none)" ;;
        1) echo "Create directory /tmp/exam/data with 750 (user:rwx, group:rx, others:none)" ;;
        2) echo "Change ownership of /tmp/exam/report.txt to nobody:nobody" ;;
        3) echo "Make new files in /tmp/exam/data inherit directory group (SGID)" ;;
        4) echo "Save octal permissions of /tmp/exam/report.txt to /tmp/exam/perms.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating exam directory...${RESET}"
    rm -rf /tmp/exam 2>/dev/null
    mkdir -p /tmp/exam
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check report.txt exists with 640 permissions
    if [[ -f /tmp/exam/report.txt ]]; then
        local perms=$(stat -c %a /tmp/exam/report.txt 2>/dev/null)
        if [[ "$perms" == "640" ]]; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check data/ exists with 750 permissions (ignoring special bits)
    if [[ -d /tmp/exam/data ]]; then
        local perms=$(stat -c %a /tmp/exam/data 2>/dev/null)
        # Accept 750 or 2750 (with SGID)
        if [[ "$perms" == "750" ]] || [[ "$perms" == "2750" ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check report.txt ownership is nobody:nobody
    if [[ -f /tmp/exam/report.txt ]]; then
        local owner=$(stat -c %U /tmp/exam/report.txt 2>/dev/null)
        local group=$(stat -c %G /tmp/exam/report.txt 2>/dev/null)
        if [[ "$owner" == "nobody" ]] && [[ "$group" == "nobody" ]]; then
            TASK_STATUS[2]="true"
        else
            TASK_STATUS[2]="false"
        fi
    else
        TASK_STATUS[2]="false"
    fi
    
    # Task 3: Check data/ has SGID set
    if [[ -d /tmp/exam/data ]]; then
        local perms=$(stat -c %a /tmp/exam/data 2>/dev/null)
        if [[ "$perms" == "2"* ]]; then
            TASK_STATUS[3]="true"
        else
            local sym_perms=$(stat -c %A /tmp/exam/data 2>/dev/null)
            if [[ "${sym_perms:6:1}" == "s" || "${sym_perms:6:1}" == "S" ]]; then
                TASK_STATUS[3]="true"
            else
                TASK_STATUS[3]="false"
            fi
        fi
    else
        TASK_STATUS[3]="false"
    fi
    
    # Task 4: Check perms.txt contains correct octal
    if [[ -f /tmp/exam/perms.txt ]] && [[ -f /tmp/exam/report.txt ]]; then
        local saved_perms=$(cat /tmp/exam/perms.txt | tr -d ' \n')
        local actual_perms=$(stat -c %a /tmp/exam/report.txt 2>/dev/null)
        if [[ "$saved_perms" == "$actual_perms" ]]; then
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
    rm -rf /tmp/exam 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
