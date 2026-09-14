#!/bin/bash
# Objective 2: Manage software
# LAB: Find and Install a Package with dnf provides (container-only terminal)
# NOTE: same pattern as lab_container_install_httpd.sh - prepare_lab attaches
# the single default terminal straight into the container via `tmux
# send-keys`, so no host shell is ever shown or reachable. Web UI only;
# harmless no-op on the CLI simulator - CLI users would need to run
# `docker exec -it rhcsa_lab_container_dnf_provides bash` themselves.

IS_LAB=true
LAB_ID="container_dnf_provides_dig"

QUESTION="Find and install the package that provides the dig command using dnf."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="This terminal is inside a Rocky Linux 10 container (a free RHEL 10 rebuild) running on this machine. Find which package provides the dig command, and redirect the result into /root/provides_output.txt instead of the screen"
TASK_1_HINT="dnf provides '*/dig' searches every enabled repository for a package that contains a file named dig; the leading */ matches it regardless of which directory it ends up in"
TASK_1_COMMAND_1="dnf provides '*/dig' > /root/provides_output.txt"

# Task 2
TASK_2_QUESTION="Install the package you found, then confirm the dig command now works by looking up localhost"
TASK_2_HINT="dnf install -y bind-utils installs the package; dig localhost then queries DNS for that name to prove the command works"
TASK_2_COMMAND_1="dnf install -y bind-utils && dig localhost"

# Auto-generate HINT from commands
HINT=$(_build_hint)

CONTAINER_NAME="rhcsa_lab_container_dnf_provides"
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
    # Task 0: the provides lookup was redirected into a file that actually
    # names bind-utils (not just any output)
    if docker exec "$CONTAINER_NAME" test -s /root/provides_output.txt &>/dev/null \
        && docker exec "$CONTAINER_NAME" grep -qi bind-utils /root/provides_output.txt &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: bind-utils installed and dig genuinely present/executable.
    # (dig's own exit code doesn't reliably reflect DNS success/failure, so
    # this checks the package + binary are really there rather than trusting
    # a live query, which depends on network/DNS conditions outside the task)
    if docker exec "$CONTAINER_NAME" rpm -q bind-utils &>/dev/null \
        && docker exec "$CONTAINER_NAME" bash -c 'command -v dig' &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Removing container...${RESET}"
    docker rm -f "$CONTAINER_NAME" &>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
