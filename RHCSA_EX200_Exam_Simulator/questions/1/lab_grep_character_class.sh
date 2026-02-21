#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Grep Character Classes

# This is a LAB exercise
IS_LAB=true
LAB_ID="grep_character_class"

QUESTION="[LAB] Use grep with character classes and POSIX classes"
HINT="Task 1: grep '[0-9]' /tmp/mixed.txt > /tmp/has-digits.txt
Task 2: grep '^[A-Z]' /tmp/mixed.txt > /tmp/uppercase-start.txt
Task 3: grep -E '^[0-9]+$' /tmp/numbers.txt > /tmp/digits-only.txt"

# Lab configuration
LAB_TITLE="Grep Character Classes"
LAB_TASK_COUNT=3

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Extract lines containing any digit from /tmp/mixed.txt, save to /tmp/has-digits.txt" ;;
        1) echo "Extract lines starting with an uppercase letter from /tmp/mixed.txt, save to /tmp/uppercase-start.txt" ;;
        2) echo "Extract lines that contain ONLY digits (no letters or spaces) from /tmp/numbers.txt, save to /tmp/digits-only.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing files...${RESET}"
    rm -f /tmp/has-digits.txt /tmp/uppercase-start.txt /tmp/digits-only.txt /tmp/mixed.txt /tmp/numbers.txt 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating mixed content file...${RESET}"
    cat > /tmp/mixed.txt << 'EOF'
Hello World
The year is 2024
welcome to linux
Server01 is online
no numbers here
Port 8080 is open
UPPERCASE LINE
1234567890
another lowercase line
Mixed Case Text
123 starting with digits
EOF
    sleep 0.2
    
    echo -e "  ${DIM}• Creating numbers file...${RESET}"
    cat > /tmp/numbers.txt << 'EOF'
12345
hello
67890
abc123
99999
test
00000
12 34
11111
number5
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check has-digits.txt contains lines with digits
    if [[ -f /tmp/has-digits.txt ]]; then
        local total=$(wc -l < /tmp/has-digits.txt 2>/dev/null)
        local with_digits=$(grep -c '[0-9]' /tmp/has-digits.txt 2>/dev/null)
        # Should have lines and all should contain digits
        if [[ $total -ge 4 ]] && [[ $total -eq $with_digits ]]; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check uppercase-start.txt contains lines starting with uppercase
    if [[ -f /tmp/uppercase-start.txt ]]; then
        local total=$(wc -l < /tmp/uppercase-start.txt 2>/dev/null)
        local uppercase=$(grep -c '^[A-Z]' /tmp/uppercase-start.txt 2>/dev/null)
        # Should have lines and all should start with uppercase
        if [[ $total -ge 4 ]] && [[ $total -eq $uppercase ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check digits-only.txt contains only lines with pure digits
    if [[ -f /tmp/digits-only.txt ]]; then
        local total=$(wc -l < /tmp/digits-only.txt 2>/dev/null)
        # Should have exactly 4 lines: 12345, 67890, 99999, 00000, 11111 (5 total)
        if [[ $total -ge 4 ]] && [[ $total -le 6 ]]; then
            # All lines should match only digits pattern
            local digits_only=$(grep -cE '^[0-9]+$' /tmp/digits-only.txt 2>/dev/null)
            if [[ $total -eq $digits_only ]]; then
                TASK_STATUS[2]="true"
            else
                TASK_STATUS[2]="false"
            fi
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
    rm -f /tmp/has-digits.txt /tmp/uppercase-start.txt /tmp/digits-only.txt /tmp/mixed.txt /tmp/numbers.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
