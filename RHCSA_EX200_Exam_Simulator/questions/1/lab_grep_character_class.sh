#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Grep Character Classes

# This is a LAB exercise
IS_LAB=true
LAB_ID="grep_character_class"

QUESTION="Use grep with character classes and POSIX classes"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Extract lines containing any digit from /tmp/mixed.txt, save to /tmp/has-digits.txt"
TASK_1_HINT="Use [0-9] character class to match digits"
TASK_1_COMMAND_1="grep '[0-9]' /tmp/mixed.txt > /tmp/has-digits.txt"

# Task 2
TASK_2_QUESTION="Extract lines starting with an uppercase letter from /tmp/mixed.txt, save to /tmp/uppercase-start.txt"
TASK_2_HINT="Use ^[A-Z] to match lines starting with uppercase"
TASK_2_COMMAND_1="grep '^[A-Z]' /tmp/mixed.txt > /tmp/uppercase-start.txt"

# Task 3
TASK_3_QUESTION="Extract lines that contain ONLY digits (no letters or spaces) from /tmp/numbers.txt, save to /tmp/digits-only.txt"
TASK_3_HINT="Use -E with ^[0-9]+$ to match lines with only digits"
TASK_3_COMMAND_1="grep -E '^[0-9]+$' /tmp/numbers.txt > /tmp/digits-only.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)
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
