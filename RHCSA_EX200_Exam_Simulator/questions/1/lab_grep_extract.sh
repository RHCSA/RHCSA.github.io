#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Grep Extract Matched Part

# This is a LAB exercise
IS_LAB=true
LAB_ID="grep_extract"

QUESTION="[LAB] Use grep -o to extract only the matched portion of lines"
HINT="Task 1: grep -oE '[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+' /tmp/access.log > /tmp/ips.txt (-o shows only match)"

# Lab configuration
LAB_TITLE="Grep Extract Matched Part"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Extract only the IP addresses from /tmp/access.log (not full lines), save to /tmp/ips.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing files...${RESET}"
    rm -f /tmp/ips.txt /tmp/access.log 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating access log file...${RESET}"
    cat > /tmp/access.log << 'EOF'
192.168.1.100 - - [15/Jan/2024:10:00:01] "GET /index.html HTTP/1.1" 200
10.0.0.55 - - [15/Jan/2024:10:00:02] "GET /about.html HTTP/1.1" 200
172.16.0.25 - - [15/Jan/2024:10:00:03] "POST /login HTTP/1.1" 302
192.168.1.100 - - [15/Jan/2024:10:00:04] "GET /dashboard HTTP/1.1" 200
10.0.0.77 - - [15/Jan/2024:10:00:05] "GET /api/data HTTP/1.1" 200
172.16.0.25 - - [15/Jan/2024:10:00:06] "GET /logout HTTP/1.1" 302
192.168.1.200 - - [15/Jan/2024:10:00:07] "GET /index.html HTTP/1.1" 200
10.0.0.55 - - [15/Jan/2024:10:00:08] "GET /contact.html HTTP/1.1" 200
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check ips.txt contains only IP addresses (not full log lines)
    if [[ -f /tmp/ips.txt ]]; then
        local line_count=$(wc -l < /tmp/ips.txt 2>/dev/null)
        if [[ $line_count -ge 5 ]]; then
            # Should contain IP addresses
            if grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' /tmp/ips.txt 2>/dev/null; then
                # Should NOT contain log entry text like GET, HTTP, dates
                if ! grep -qE 'GET|POST|HTTP|\[' /tmp/ips.txt 2>/dev/null; then
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
    rm -f /tmp/ips.txt /tmp/access.log 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
