#!/bin/bash
# Objective 4: Operate running systems
# LAB: Schedule and Reschedule a Reboot (container-only terminal)
# NOTE: same pattern as questions/2/lab_container_install_httpd.sh -
# prepare_lab attaches the single default terminal straight into the
# container via `tmux send-keys`, so no host shell is ever shown or
# reachable. Web UI only; harmless no-op on the CLI simulator - CLI users
# would need to run `docker exec -it rhcsa_lab_container_shutdown bash`
# themselves.
# NOTE: verified against systemd's own shutdown.c source - inside a
# container, if the scheduled reboot ever actually fired, the kernel's
# reboot() syscall from a non-init PID namespace only tears down that PID
# namespace (i.e. it kills/exits the container), regardless of --privileged.
# It cannot affect the host machine. If it ever did fire, cleanup_lab would
# simply be starting from a torn-down container regardless. Note the +10
# schedule in Task 1 is a much tighter window than a long "+100" would be -
# a slow student could plausibly still be on Task 2 when it lands, at which
# point the container just exits and the lab needs restarting.
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
LAB_ID="container_shutdown_schedule"

QUESTION="Schedule a system reboot, then reschedule it for a specific time."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="This terminal is inside a Rocky Linux 10 container (a free RHEL 10 rebuild) running on this machine. Schedule a reboot for 10 minutes from now, with the wall message 'reboot in 10 minutes'"
TASK_1_HINT="shutdown -r +N 'message' schedules a reboot N minutes from now and broadcasts the message to logged-in users beforehand"
TASK_1_COMMAND_1="shutdown -r +10 'reboot in 10 minutes'"

# Task 2
TASK_2_QUESTION="Reschedule the reboot to happen at 01:00 instead, with the wall message 'apply update'"
TASK_2_HINT="Running shutdown again with a new time replaces the previously scheduled one; an hh:mm time schedules it for that clock time"
TASK_2_COMMAND_1="shutdown -r 01:00 'apply update'"

# Auto-generate HINT from commands
HINT=$(_build_hint)

CONTAINER_NAME="rhcsa_lab_container_shutdown"
CONTAINER_IMAGE="rockylinux/rockylinux:10-ubi-init"

# Prepare the lab environment
# Docker and the container image are already installed/pulled by the simulator
# installer - this just starts the container and attaches the terminal to it.
prepare_lab() {
    echo -e "  ${DIM}• Removing any previous container...${RESET}"
    docker rm -f "$CONTAINER_NAME" &>/dev/null

    echo -e "  ${DIM}• Starting container (${CONTAINER_IMAGE})...${RESET}"
    # --privileged + the cgroup mount are required for systemd to run as PID 1 inside the container
    docker run -d --name "$CONTAINER_NAME" --privileged --cgroupns=host \
        -v /sys/fs/cgroup:/sys/fs/cgroup:rw "$CONTAINER_IMAGE" /usr/sbin/init &>/dev/null
    sleep 2

    # Web UI only: attach the single visible terminal straight into the
    # container so no host shell is ever shown for this lab
    tmux send-keys -t rhcsa-terminal:lab_main "clear; docker exec -it $CONTAINER_NAME bash" Enter 2>/dev/null
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: a reboot was scheduled (via +10) at some point - latched with
    # a marker file, since Task 2's later 01:00 reschedule overwrites this
    # live state. Requiring "not 01:00" means this can't be satisfied by
    # skipping straight to Task 2 instead of actually doing Task 1.
    if docker exec "$CONTAINER_NAME" test -f /root/.task1_seen &>/dev/null; then
        TASK_STATUS[0]="true"
    elif docker exec "$CONTAINER_NAME" bash -c "shutdown --show 2>/dev/null" | grep -qi "scheduled" \
        && ! docker exec "$CONTAINER_NAME" bash -c "shutdown --show 2>/dev/null" | grep -q "01:00"; then
        docker exec "$CONTAINER_NAME" touch /root/.task1_seen &>/dev/null
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: a reboot is currently scheduled for 01:00 (checked live, since
    # this is the final state after rescheduling - a fixed, known clock time
    # so it can be matched directly, unlike Task 1's relative +10)
    if docker exec "$CONTAINER_NAME" bash -c "shutdown --show 2>/dev/null | grep -q '01:00'"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Removing container...${RESET}"
    docker exec "$CONTAINER_NAME" shutdown -c &>/dev/null
    docker rm -f "$CONTAINER_NAME" &>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
