#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Grep Context Lines

# This is a LAB exercise
IS_LAB=true
LAB_ID="grep_context"

QUESTION="[LAB] Use grep -A, -B, -C to show context around matches"
HINT="Task 1: grep -A 2 'ERROR' /tmp/application.log > /tmp/error-context.txt
Task 2: grep -C 1 'WARNING' /tmp/application.log > /tmp/warning-context.txt"

# Lab configuration
LAB_TITLE="Grep Context Lines"
LAB_TASK_COUNT=2

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Find 'ERROR' in /tmp/application.log and show 2 lines AFTER each match, save to /tmp/error-context.txt" ;;
        1) echo "Find 'WARNING' in /tmp/application.log and show 1 line BEFORE and 1 line AFTER, save to /tmp/warning-context.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing files...${RESET}"
    rm -f /tmp/error-context.txt /tmp/warning-context.txt /tmp/application.log 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating application log file...${RESET}"
    cat > /tmp/application.log << 'EOF'
2024-01-15 08:00:01 INFO  Application starting up
2024-01-15 08:00:02 INFO  Loading configuration
2024-01-15 08:00:03 INFO  Configuration loaded successfully
2024-01-15 08:00:04 INFO  Connecting to database
2024-01-15 08:00:05 ERROR Database connection failed
2024-01-15 08:00:06 INFO  Retrying connection attempt 1
2024-01-15 08:00:07 INFO  Retrying connection attempt 2
2024-01-15 08:00:08 INFO  Connection established
2024-01-15 08:00:09 INFO  Starting web server
2024-01-15 08:00:10 WARNING High memory usage detected
2024-01-15 08:00:11 INFO  Memory cleanup initiated
2024-01-15 08:00:12 INFO  Web server listening on port 8080
2024-01-15 08:00:13 INFO  Processing request from client
2024-01-15 08:00:14 ERROR Request timeout exceeded
2024-01-15 08:00:15 INFO  Client disconnected
2024-01-15 08:00:16 INFO  Cleanup completed
2024-01-15 08:00:17 INFO  Application running normally
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check error-context.txt has ERROR lines with 2 lines after
    if [[ -f /tmp/error-context.txt ]]; then
        # Should contain ERROR lines
        if grep -q 'ERROR' /tmp/error-context.txt 2>/dev/null; then
            # Should also contain lines after ERROR (like "Retrying" after first ERROR)
            if grep -q 'Retrying connection attempt 1' /tmp/error-context.txt 2>/dev/null; then
                # Should have more lines than just ERROR lines (context was added)
                local total=$(wc -l < /tmp/error-context.txt 2>/dev/null)
                if [[ $total -ge 5 ]]; then
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
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check warning-context.txt has WARNING with before and after context
    if [[ -f /tmp/warning-context.txt ]]; then
        # Should contain WARNING line
        if grep -q 'WARNING' /tmp/warning-context.txt 2>/dev/null; then
            # Should contain line BEFORE warning (Starting web server)
            if grep -q 'Starting web server' /tmp/warning-context.txt 2>/dev/null; then
                # Should contain line AFTER warning (Memory cleanup)
                if grep -q 'Memory cleanup' /tmp/warning-context.txt 2>/dev/null; then
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
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/error-context.txt /tmp/warning-context.txt /tmp/application.log 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
