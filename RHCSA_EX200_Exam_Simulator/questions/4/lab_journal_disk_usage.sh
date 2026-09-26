#!/bin/bash
# Objective 4: Operate running systems
# LAB: Check Journal Disk Usage
# Host-machine terminal only (no container) - the single default terminal
# every lab starts with. Purely read-only reporting, no system state to
# reset or restore.

IS_LAB=true
LAB_ID="journal_disk_usage"

QUESTION="Check journal disk usage"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Check how much disk space the journal is currently using. Save the output to /tmp/journal_disk_usage.txt"
TASK_1_HINT="Use journalctl with --disk-usage"
TASK_1_COMMAND_1="journalctl --disk-usage > /tmp/journal_disk_usage.txt"

# Task 2
TASK_2_QUESTION="From that same report, extract just the size value (for example 173.4M) and save it to /tmp/journal_disk_size.txt"
TASK_2_HINT="Pipe journalctl --disk-usage through grep with a pattern that matches a number followed by a size letter"
TASK_2_COMMAND_1="journalctl --disk-usage | grep -oE '[0-9.]+[BKMGT]' > /tmp/journal_disk_size.txt"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing old output files...${RESET}"
    rm -f /tmp/journal_disk_usage.txt /tmp/journal_disk_size.txt
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: disk usage report captured
    if [[ -s /tmp/journal_disk_usage.txt ]] && grep -qi 'journal' /tmp/journal_disk_usage.txt; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: size value extracted, matching a number+unit pattern (not an
    # exact number, since actual disk usage naturally changes over time)
    if [[ -f /tmp/journal_disk_size.txt ]] && grep -qE '^[0-9]+(\.[0-9]+)?[BKMGT]$' /tmp/journal_disk_size.txt; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/journal_disk_usage.txt /tmp/journal_disk_size.txt
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
