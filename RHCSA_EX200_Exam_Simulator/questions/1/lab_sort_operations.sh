#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Sort Command Operations

# This is a LAB exercise
IS_LAB=true
LAB_ID="sort_operations"

QUESTION="[LAB] Use sort with different options for various sorting needs"
HINT="This lab has 3 tasks:\n\n1. Numeric sort:\n   sort -n /tmp/numbers.txt > /tmp/sorted_numeric.txt\n   -n = numeric sort\n\n2. Alphabetic, case-insensitive, unique:\n   sort -dfu /tmp/words.txt > /tmp/sorted_words.txt\n   -d = dictionary order\n   -f = case-insensitive (fold)\n   -u = unique only\n\n3. Reverse numeric sort:\n   sort -nr /tmp/numbers.txt > /tmp/sorted_reverse.txt\n   -r = reverse order"

# Lab configuration
LAB_TITLE="sort Command Operations"
LAB_TASK_COUNT=3

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Sort /tmp/numbers.txt numerically, save to /tmp/sorted_numeric.txt" ;;
        1) echo "Sort /tmp/words.txt alphabetically, case-insensitive, unique only save to /tmp/sorted_words.txt" ;;
        2) echo "Sort /tmp/numbers.txt numerically in reverse (descending) save to /tmp/sorted_reverse.txt" ;;
    esac
}

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
