#!/bin/bash
# Objective 4: Operate running systems
# LAB: Schedule and Reschedule a Reboot
# NOTE: shutdown -r only *schedules* a reboot for later - cleanup_lab always
# cancels it with shutdown -c before exiting, so the host is never actually
# rebooted. This must run on the real host, not a container: shutdown needs
# systemd-logind reachable over D-Bus, which fails there ("Could not
# activate remote peer 'org.freedesktop.login1'") even in a --privileged
# systemd container - confirmed by testing.
# NOTE: `shutdown --show` (systemd >= 250, confirmed present on RHEL 10) is
# the official way to query a pending scheduled shutdown without waiting for
# it. Because shutdown only ever tracks ONE pending action at a time, Task 2
# rescheduling immediately overwrites Task 1's live state - Task 1 is
# recorded with a one-time marker file the first time it is seen, so
# completing Task 2 doesn't make Task 1 look incomplete again.
# NOTE (limitation): exact "10 minutes remaining" arithmetic is not verified
# for Task 1, since shutdown --show reports an absolute clock time that
# depends on exactly when the student ran the command (unknowable to
# check_tasks) - Task 1 only confirms some non-01:00 reboot was scheduled at
# some point, which Task 2's own absolute time can't satisfy by coincidence
# except in the sub-1-in-1440 case of running Task 1 at exactly 00:50.

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

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Cancelling any previously scheduled shutdown...${RESET}"
    shutdown -c &>/dev/null
    rm -f /root/.task1_seen
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: a reboot was scheduled (via +10) at some point - latched with
    # a marker file, since Task 2's later 01:00 reschedule overwrites this
    # live state. Requiring "not 01:00" means this can't be satisfied by
    # skipping straight to Task 2 instead of actually doing Task 1.
    if [[ -f /root/.task1_seen ]]; then
        TASK_STATUS[0]="true"
    elif shutdown --show 2>/dev/null | grep -qi "scheduled" \
        && ! shutdown --show 2>/dev/null | grep -q "01:00"; then
        touch /root/.task1_seen
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: a reboot is currently scheduled for 01:00 (checked live, since
    # this is the final state after rescheduling - a fixed, known clock time
    # so it can be matched directly, unlike Task 1's relative +10)
    if shutdown --show 2>/dev/null | grep -q '01:00'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cancelling any scheduled shutdown...${RESET}"
    shutdown -c &>/dev/null
    rm -f /root/.task1_seen
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
