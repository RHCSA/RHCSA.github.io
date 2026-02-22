#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Grep with Line Anchors

# This is a LAB exercise
IS_LAB=true
LAB_ID="grep_anchors"

QUESTION="[LAB] Use grep anchors (^ and $) to match line patterns"
HINT="Task 1: grep '^root' /etc/passwd > /tmp/root-lines.txt
Task 2: grep 'bash$' /etc/passwd > /tmp/bash-shell.txt
Task 3: grep -c '^$' /tmp/testfile.txt > /tmp/empty-count.txt"

# Lab configuration
LAB_TITLE="Grep with Line Anchors"
LAB_TASK_COUNT=3

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Extract lines starting with 'root' from /etc/passwd to /tmp/root-lines.txt" ;;
        1) echo "Extract lines ending with 'bash' from /etc/passwd to /tmp/bash-shell.txt" ;;
        2) echo "Count empty lines in /tmp/testfile.txt and save count to /tmp/empty-count.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing files...${RESET}"
    rm -f /tmp/root-lines.txt /tmp/bash-shell.txt /tmp/empty-count.txt 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating test file with empty lines...${RESET}"
    cat > /tmp/testfile.txt << 'EOF'
This is line one

Line three after empty line

Another line here


Two empty lines above
Last line
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if root-lines.txt contains lines starting with root
    if [[ -f /tmp/root-lines.txt ]]; then
        if grep -q '^root' /tmp/root-lines.txt 2>/dev/null; then
            # Make sure all lines start with root
            local total=$(wc -l < /tmp/root-lines.txt 2>/dev/null)
            local matching=$(grep -c '^root' /tmp/root-lines.txt 2>/dev/null)
            if [[ $total -eq $matching ]] && [[ $total -ge 1 ]]; then
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
    
    # Task 1: Check if bash-shell.txt contains lines ending with bash
    if [[ -f /tmp/bash-shell.txt ]]; then
        if grep -q 'bash$' /tmp/bash-shell.txt 2>/dev/null; then
            # Make sure all lines end with bash
            local total=$(wc -l < /tmp/bash-shell.txt 2>/dev/null)
            local matching=$(grep -c 'bash$' /tmp/bash-shell.txt 2>/dev/null)
            if [[ $total -eq $matching ]] && [[ $total -ge 1 ]]; then
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
    
    # Task 2: Check if empty-count.txt contains correct count (4 empty lines)
    if [[ -f /tmp/empty-count.txt ]]; then
        local count=$(cat /tmp/empty-count.txt 2>/dev/null | tr -d '[:space:]')
        if [[ "$count" == "4" ]]; then
            TASK_STATUS[2]="true"
        else
            TASK_STATUS[2]="false"
        fi
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/root-lines.txt /tmp/bash-shell.txt /tmp/empty-count.txt /tmp/testfile.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
