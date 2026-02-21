#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Grep Word Boundaries

# This is a LAB exercise
IS_LAB=true
LAB_ID="grep_word_match"

QUESTION="[LAB] Use grep -w to match whole words only"
HINT="Task 1: grep -w 'log' /tmp/services.txt > /tmp/log-only.txt (-w matches whole words)"

# Lab configuration
LAB_TITLE="Grep Word Boundaries"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Find lines containing the exact word 'log' (not 'login' or 'syslog') from /tmp/services.txt, save to /tmp/log-only.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing files...${RESET}"
    rm -f /tmp/log-only.txt /tmp/services.txt 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating services file...${RESET}"
    cat > /tmp/services.txt << 'EOF'
syslog daemon running on port 514
login service enabled
The log file is located at /var/log
syslog-ng configuration updated
blog application started
Enable log rotation daily
loginctl session active
Check the log for errors
analog signal processing
weblog analyzer installed
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check log-only.txt contains 'log' as whole word
    if [[ -f /tmp/log-only.txt ]]; then
        local line_count=$(wc -l < /tmp/log-only.txt 2>/dev/null)
        # Should have exactly 3 lines with "log" as whole word
        if [[ $line_count -ge 2 ]] && [[ $line_count -le 4 ]]; then
            # Should NOT contain syslog, login, blog, analog, weblog
            if ! grep -qE 'syslog|login|blog|analog|weblog' /tmp/log-only.txt 2>/dev/null; then
                # Should contain "the log" or "log file" or "log rotation"
                if grep -qw 'log' /tmp/log-only.txt 2>/dev/null; then
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
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/log-only.txt /tmp/services.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
