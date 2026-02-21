#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Grep Extended Regex (ERE)

# This is a LAB exercise
IS_LAB=true
LAB_ID="grep_extended"

QUESTION="[LAB] Use grep -E (extended regex) for advanced pattern matching"
HINT="Task 1: grep -iE 'error|warning|critical' /tmp/app.log > /tmp/issues.txt
Task 2: grep -E 'o{2,}' /tmp/words.txt > /tmp/double-o.txt (or grep 'oo')
Task 3: grep -Ev '^#|^$' /tmp/server.conf > /tmp/clean-config.txt"

# Lab configuration
LAB_TITLE="Grep Extended Regex (ERE)"
LAB_TASK_COUNT=3

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Find lines containing 'error', 'warning', or 'critical' (case-insensitive) from /tmp/app.log, save to /tmp/issues.txt" ;;
        1) echo "Find lines with 2 or more consecutive 'o' characters from /tmp/words.txt and save to /tmp/double-o.txt" ;;
        2) echo "From /tmp/server.conf, extract lines that are NOT comments and NOT empty, save to /tmp/clean-config.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing files...${RESET}"
    rm -f /tmp/issues.txt /tmp/double-o.txt /tmp/clean-config.txt 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating test log file...${RESET}"
    cat > /tmp/app.log << 'EOF'
2024-01-15 10:00:01 INFO Application started
2024-01-15 10:00:05 error Failed to connect to database
2024-01-15 10:00:10 INFO Retrying connection
2024-01-15 10:00:15 warning Connection slow
2024-01-15 10:00:20 INFO Connected successfully
2024-01-15 10:00:25 critical Disk space low
2024-01-15 10:00:30 INFO Cleanup initiated
2024-01-15 10:00:35 ERROR Memory threshold exceeded
2024-01-15 10:00:40 INFO System stable
EOF
    sleep 0.2
    
    echo -e "  ${DIM}• Creating words file...${RESET}"
    cat > /tmp/words.txt << 'EOF'
hello
book
moon
food
cat
door
floor
good
bad
pool
school
tool
goooood
EOF
    sleep 0.2
    
    echo -e "  ${DIM}• Creating server config file...${RESET}"
    cat > /tmp/server.conf << 'EOF'
# Server Configuration File
# Last updated: 2024

ServerName webserver01

# Network settings
ListenPort 8080
BindAddress 0.0.0.0

# Timeout configuration
ConnectionTimeout 30
ReadTimeout 60

# Logging
LogLevel info
LogFile /var/log/server.log
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check issues.txt contains error/warning/critical lines
    if [[ -f /tmp/issues.txt ]]; then
        if grep -qiE 'error|warning|critical' /tmp/issues.txt 2>/dev/null; then
            local total=$(wc -l < /tmp/issues.txt 2>/dev/null)
            # Should have at least 4 lines (error, warning, critical, ERROR)
            if [[ $total -ge 4 ]]; then
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
    
    # Task 1: Check double-o.txt contains words with oo
    if [[ -f /tmp/double-o.txt ]]; then
        if grep -qE 'oo' /tmp/double-o.txt 2>/dev/null; then
            # Should contain book, moon, food, door, floor, good, pool, school, tool
            local count=$(wc -l < /tmp/double-o.txt 2>/dev/null)
            if [[ $count -ge 5 ]]; then
                # Verify it doesn't contain words without oo
                if ! grep -qE '^(hello|cat|bad)$' /tmp/double-o.txt 2>/dev/null; then
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
    
    # Task 2: Check clean-config.txt has no comments and no empty lines
    if [[ -f /tmp/clean-config.txt ]]; then
        local has_content=$(grep -c '.' /tmp/clean-config.txt 2>/dev/null)
        if [[ $has_content -ge 5 ]]; then
            # Should NOT have lines starting with #
            if ! grep -q '^#' /tmp/clean-config.txt 2>/dev/null; then
                # Should NOT have empty lines
                if ! grep -q '^$' /tmp/clean-config.txt 2>/dev/null; then
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
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/issues.txt /tmp/double-o.txt /tmp/clean-config.txt /tmp/app.log /tmp/words.txt /tmp/server.conf 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
