#!/bin/bash
# Objective 4: Operate running systems
# LAB: Schedule and Reschedule a Reboot
# NOTE: shutdown -r only *schedules* a reboot for later - cleanup_lab always
# cancels it with shutdown -c before exiting, so the host is never actually
# rebooted. This must run on the real host, not a container: shutdown needs
# systemd-logind reachable over D-Bus, which fails there ("Could not
# activate remote peer 'org.freedesktop.login1'") even in a --privileged
# systemd container - confirmed by testing.
# NOTE: check_tasks reads /run/systemd/shutdown/scheduled directly (the
# exact file systemd-logind itself writes/reads for a pending shutdown,
# USEC=<epoch usec>) rather than parsing `shutdown --show` text, which is
# less certain to match across systemd versions.
# NOTE: since shutdown only ever tracks ONE pending action at a time, Task
# 2's reschedule instantly overwrites Task 1's live state - if the student
# runs both commands before ever checking (the normal workflow), Task 1's
# evidence would be gone by the time check_tasks runs. prepare_lab starts a
# background watcher that polls the state file and latches a marker file
# the moment it ever sees a non-01:00 schedule, so Task 1 stays gradeable
# regardless of when check_tasks is actually invoked. The watcher is killed
# in cleanup_lab.

IS_LAB=true
LAB_ID="shutdown_schedule"

QUESTION="Schedule a system reboot, then reschedule it for a specific time."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Schedule a reboot for 10 minutes from now, with the wall message 'reboot in 10 minutes'"
TASK_1_HINT="shutdown -r +N 'message' schedules a reboot N minutes from now and broadcasts the message to logged-in users beforehand"
TASK_1_COMMAND_1="shutdown -r +10 'reboot in 10 minutes'"

# Task 2
TASK_2_QUESTION="Reschedule the reboot to happen at 01:00 instead, with the wall message 'apply update'"
TASK_2_HINT="Running shutdown again with a new time replaces the previously scheduled one; an hh:mm time schedules it for that clock time"
TASK_2_COMMAND_1="shutdown -r 01:00 'apply update'"

# Auto-generate HINT from commands
HINT=$(_build_hint)

WATCHER_STOP_FILE="/tmp/.rhcsa_lab_shutdown_watcher_stop"
MARKER_FILE="/root/.task1_seen"

# HH:MM of the currently pending shutdown, if any (empty if none scheduled)
_scheduled_hhmm() {
    local f="/run/systemd/shutdown/scheduled"
    [[ -f "$f" ]] || return
    local usec
    usec=$(sed -n 's/^USEC=//p' "$f" 2>/dev/null)
    [[ -n "$usec" ]] || return
    date -d "@$((usec / 1000000))" +%H:%M 2>/dev/null
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Cancelling any previously scheduled shutdown...${RESET}"
    shutdown -c &>/dev/null
    rm -f "$MARKER_FILE" "$WATCHER_STOP_FILE"
    sleep 0.3

    echo -e "  ${DIM}• Starting a background watcher for Task 1 grading...${RESET}"
    (
        while [[ ! -f "$WATCHER_STOP_FILE" ]]; do
            hhmm=$(_scheduled_hhmm)
            if [[ -n "$hhmm" ]] && [[ "$hhmm" != "01:00" ]]; then
                touch "$MARKER_FILE"
            fi
            sleep 0.5
        done
    ) &>/dev/null &
    disown
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: a non-01:00 reboot was scheduled at some point - latched by
    # the background watcher, since Task 2's later 01:00 reschedule
    # overwrites systemd's own live pending-shutdown state
    if [[ -f "$MARKER_FILE" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: a reboot is currently scheduled for exactly 01:00
    if [[ "$(_scheduled_hhmm)" == "01:00" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Stopping the background watcher...${RESET}"
    touch "$WATCHER_STOP_FILE"
    sleep 0.6
    rm -f "$WATCHER_STOP_FILE"

    echo -e "  ${DIM}• Cancelling any scheduled shutdown...${RESET}"
    shutdown -c &>/dev/null
    rm -f "$MARKER_FILE"
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
