#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Sort Command Operations

# This is a LAB exercise
IS_LAB=true
LAB_ID="sort_operations"

QUESTION="Use sort with different options for various sorting needs"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Sort /tmp/numbers.txt numerically, save to /tmp/sorted_numeric.txt"
TASK_1_HINT="-n = numeric sort"
TASK_1_COMMAND_1="sort -n /tmp/numbers.txt > /tmp/sorted_numeric.txt"

# Task 2
TASK_2_QUESTION="Sort /tmp/words.txt alphabetically, case-insensitive, unique only save to /tmp/sorted_words.txt"
TASK_2_HINT="-d=dictionary order, -f=fold case, -u=unique"
TASK_2_COMMAND_1="sort -dfu /tmp/words.txt > /tmp/sorted_words.txt"

# Task 3
TASK_3_QUESTION="Sort /tmp/numbers.txt numerically in reverse (descending) save to /tmp/sorted_reverse.txt"
TASK_3_HINT="-r = reverse order"
TASK_3_COMMAND_1="sort -nr /tmp/numbers.txt > /tmp/sorted_reverse.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test files...${RESET}"
    rm -f /tmp/numbers.txt /tmp/words.txt 2>/dev/null
    rm -f /tmp/sorted_numeric.txt /tmp/sorted_words.txt /tmp/sorted_reverse.txt 2>/dev/null
    
    # Create numbers file (unsorted)
    cat > /tmp/numbers.txt << 'EOF'
42
8
100
3
25
1
99
15
EOF
    
    # Create words file with duplicates and mixed case
    cat > /tmp/words.txt << 'EOF'
Apple
banana
APPLE
Cherry
apple
BANANA
date
Date
cherry
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check numeric sort
    if [[ -f /tmp/sorted_numeric.txt ]]; then
        local expected_numeric="1
3
8
15
25
42
99
100"
        local actual_numeric=$(cat /tmp/sorted_numeric.txt)
        if [[ "$actual_numeric" == "$expected_numeric" ]]; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check alphabetic, case-insensitive, unique sort
    if [[ -f /tmp/sorted_words.txt ]]; then
        # Should have only unique words (case-insensitive): apple, banana, cherry, date
        local line_count=$(wc -l < /tmp/sorted_words.txt | tr -d ' ')
        # Check it has 4 unique entries and is sorted
        if [[ "$line_count" == "4" ]]; then
            # Verify first word starts with a/A and last with d/D
            local first_word=$(head -1 /tmp/sorted_words.txt | tr '[:upper:]' '[:lower:]')
            local last_word=$(tail -1 /tmp/sorted_words.txt | tr '[:upper:]' '[:lower:]')
            if [[ "$first_word" == "apple" ]] && [[ "$last_word" == "date" ]]; then
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
    
    # Task 2: Check reverse numeric sort
    if [[ -f /tmp/sorted_reverse.txt ]]; then
        local expected_reverse="100
99
42
25
15
8
3
1"
        local actual_reverse=$(cat /tmp/sorted_reverse.txt)
        if [[ "$actual_reverse" == "$expected_reverse" ]]; then
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
    rm -f /tmp/numbers.txt /tmp/words.txt 2>/dev/null
    rm -f /tmp/sorted_numeric.txt /tmp/sorted_words.txt /tmp/sorted_reverse.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
