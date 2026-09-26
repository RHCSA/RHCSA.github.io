#!/bin/bash
# Objective 4: Operate running systems
# LAB: Query Logs and Journals with journalctl
# Host-machine terminal only (no container) - the single default terminal
# every lab starts with.
# NOTE: Task 3's time window is computed fresh in prepare_lab (5 minutes
# before "now" to 5 minutes after), not hardcoded, using full
# "YYYY-MM-DD HH:MM:SS" timestamps (not just HH:MM:SS) so the window is
# never ambiguous even if the lab starts within a few minutes of midnight.
# NOTE: Task 6's PID is a real, disposable `logger` process - its PID is
# captured with $! right after backgrounding it, and that PID is
# permanently recorded in the journal entry's own metadata (_PID=), so
# querying it later works even though that process has long since exited.
# NOTE: unlike lab_locate_interpret_logs.sh, cleanup_lab does NOT try to
# remove the injected journal entries - the systemd journal is an
# append-only structured store with no supported way to delete a single
# entry (only whole time/size ranges via --vacuum-*), and a few harmless
# extra log lines are exactly what logs are for. Only the /tmp output files
# and the state file are cleaned up.

IS_LAB=true
LAB_ID="journalctl_logs"

QUESTION="Query logs and journals with journalctl"

# Lab configuration
LAB_TASK_COUNT=6

STATE_FILE="/tmp/.rhcsa_lab_journalctl_state"

# Reuse the window/PID already chosen for this run (state file) if
# prepare_lab has already run, otherwise show placeholders until it has.
_load_state_line() {
    local line_num="$1" default="$2"
    if [[ -f "$STATE_FILE" ]]; then
        local val
        val=$(sed -n "${line_num}p" "$STATE_FILE")
        [[ -n "$val" ]] && echo "$val" || echo "$default"
    else
        echo "$default"
    fi
}
SINCE_TIME=$(_load_state_line 1 "<since>")
UNTIL_TIME=$(_load_state_line 2 "<until>")
TEST_PID=$(_load_state_line 3 "<pid>")

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Show the journal entries for the sshd service. Save the output to /tmp/journal_sshd.txt"
TASK_1_HINT="Use journalctl with -u and the unit name"
TASK_1_COMMAND_1="journalctl -u sshd > /tmp/journal_sshd.txt"

# Task 2
TASK_2_QUESTION="Show journal entries at error priority or higher. Save the output to /tmp/journal_err.txt"
TASK_2_HINT="Use journalctl with -p and the priority name"
TASK_2_COMMAND_1="journalctl -p err > /tmp/journal_err.txt"

# Task 3
TASK_3_QUESTION="Show journal entries between ${SINCE_TIME} and ${UNTIL_TIME}. Save the output to /tmp/journal_window.txt"
TASK_3_HINT="Use journalctl with --since and --until"
TASK_3_COMMAND_1="journalctl --since '${SINCE_TIME}' --until '${UNTIL_TIME}' > /tmp/journal_window.txt"

# Task 4
TASK_4_QUESTION="Show journal entries from the current boot. Save the output to /tmp/journal_boot.txt"
TASK_4_HINT="Use journalctl with -b"
TASK_4_COMMAND_1="journalctl -b > /tmp/journal_boot.txt"

# Task 5
TASK_5_QUESTION="Show kernel messages from the journal. Save the output to /tmp/journal_kernel.txt"
TASK_5_HINT="Use journalctl with -k"
TASK_5_COMMAND_1="journalctl -k > /tmp/journal_kernel.txt"

# Task 6
TASK_6_QUESTION="A test process with PID ${TEST_PID} just logged a message. Show the journal entries for that PID. Save the output to /tmp/journal_pid.txt"
TASK_6_HINT="Use journalctl with a field match: _PID= followed by the PID"
TASK_6_COMMAND_1="journalctl _PID=${TEST_PID} > /tmp/journal_pid.txt"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing old output files...${RESET}"
    rm -f /tmp/journal_sshd.txt /tmp/journal_err.txt /tmp/journal_window.txt \
        /tmp/journal_boot.txt /tmp/journal_kernel.txt /tmp/journal_pid.txt "$STATE_FILE"
    sleep 0.3

    echo -e "  ${DIM}• Computing a time window and logging test messages...${RESET}"
    local since_time until_time test_pid
    since_time=$(date -d '5 minutes ago' '+%Y-%m-%d %H:%M:%S')
    until_time=$(date -d '5 minutes' '+%Y-%m-%d %H:%M:%S')

    logger "rhcsa journal window test marker"
    logger -p user.err "rhcsa journal error test marker"

    logger "rhcsa journal pid test message" &
    test_pid=$!
    wait "$test_pid"

    printf '%s\n%s\n%s\n' "$since_time" "$until_time" "$test_pid" > "$STATE_FILE"
    SINCE_TIME="$since_time"
    UNTIL_TIME="$until_time"
    TEST_PID="$test_pid"
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    TEST_PID=$(_load_state_line 3 "<pid>")

    # Task 0: sshd journal entries captured
    if [[ -s /tmp/journal_sshd.txt ]] && grep -qi 'sshd' /tmp/journal_sshd.txt; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: error-priority entries captured, including the injected marker
    if [[ -f /tmp/journal_err.txt ]] && grep -q 'rhcsa journal error test marker' /tmp/journal_err.txt; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: time-window entries captured, including the injected marker
    if [[ -f /tmp/journal_window.txt ]] && grep -q 'rhcsa journal window test marker' /tmp/journal_window.txt; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: current-boot entries captured
    if [[ -s /tmp/journal_boot.txt ]]; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi

    # Task 4: kernel entries captured
    if [[ -s /tmp/journal_kernel.txt ]]; then
        TASK_STATUS[4]="true"
    else
        TASK_STATUS[4]="false"
    fi

    # Task 5: PID-specific entries captured, including the injected marker
    if [[ -f /tmp/journal_pid.txt ]] && [[ "$TEST_PID" != "<pid>" ]] \
        && grep -q 'rhcsa journal pid test message' /tmp/journal_pid.txt; then
        TASK_STATUS[5]="true"
    else
        TASK_STATUS[5]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/journal_sshd.txt /tmp/journal_err.txt /tmp/journal_window.txt \
        /tmp/journal_boot.txt /tmp/journal_kernel.txt /tmp/journal_pid.txt "$STATE_FILE"
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
