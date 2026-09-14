#!/bin/bash
# Objective 2: Manage software
# LAB: Query an Installed Package with rpm (container-only terminal)
# NOTE: same pattern as lab_container_install_httpd.sh - prepare_lab attaches
# the single default terminal straight into the container via `tmux
# send-keys`, so no host shell is ever shown or reachable. Web UI only;
# harmless no-op on the CLI simulator - CLI users would need to run
# `docker exec -it rhcsa_lab_container_rpm_query bash` themselves.

IS_LAB=true
LAB_ID="container_rpm_query_bash"

QUESTION="Check which bash package is installed using rpm."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="This terminal is inside a Rocky Linux 10 container (a free RHEL 10 rebuild) running on this machine. Use rpm to list installed packages and filter for bash, redirecting the result into /root/bash_package.txt instead of the screen"
TASK_1_HINT="rpm -qa lists every installed package; piping that into grep bash filters the list down to just the ones with bash in their name"
TASK_1_COMMAND_1="rpm -qa | grep bash > /root/bash_package.txt"

# Auto-generate HINT from commands
HINT=$(_build_hint)

CONTAINER_NAME="rhcsa_lab_container_rpm_query"
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
    # Task 0: the file contains the real, exact bash package string (queried
    # fresh right now), proving a real rpm lookup was done, not a guess
    local real_bash_pkg
    real_bash_pkg=$(docker exec "$CONTAINER_NAME" rpm -q bash 2>/dev/null)
    if [[ -n "$real_bash_pkg" ]] \
        && docker exec "$CONTAINER_NAME" test -s /root/bash_package.txt &>/dev/null \
        && docker exec "$CONTAINER_NAME" grep -qF "$real_bash_pkg" /root/bash_package.txt &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Removing container...${RESET}"
    docker rm -f "$CONTAINER_NAME" &>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
