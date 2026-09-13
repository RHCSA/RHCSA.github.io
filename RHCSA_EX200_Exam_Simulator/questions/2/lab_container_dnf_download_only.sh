#!/bin/bash
# Objective 2: Manage software
# LAB: Download a Package Without Installing It (container-only terminal)
# NOTE: same pattern as lab_container_install_httpd.sh - prepare_lab attaches
# the single default terminal straight into the container via `tmux
# send-keys`, so no host shell is ever shown or reachable. Web UI only;
# harmless no-op on the CLI simulator - CLI users would need to run
# `docker exec -it rhcsa_lab_container_dnf_download bash` themselves.

IS_LAB=true
LAB_ID="container_dnf_download_only"

QUESTION="Download a package with and without its dependencies, without installing it."

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="This terminal is inside a Rocky Linux 10 container (a free RHEL 10 rebuild) running on this machine. Download the httpd package into /tmp/httpd-package-only/ without installing it"
TASK_1_HINT="dnf download saves the .rpm file itself without installing it; --destdir sets where the file is saved"
TASK_1_COMMAND_1="dnf download httpd --destdir=/tmp/httpd-package-only/"

# Task 2
TASK_2_QUESTION="Download httpd again, this time including every one of its dependencies, into /tmp/httpd-dependencies/"
TASK_2_HINT="adding --resolve tells dnf download to also fetch every dependency the package needs, not just the package itself"
TASK_2_COMMAND_1="dnf download httpd --resolve --destdir=/tmp/httpd-dependencies/"

# Auto-generate HINT from commands
HINT=$(_build_hint)

CONTAINER_NAME="rhcsa_lab_container_dnf_download"
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
    # Task 0: httpd's rpm was downloaded into the right folder, and httpd
    # itself was never actually installed (proves it was download-only)
    if docker exec "$CONTAINER_NAME" bash -c 'ls /tmp/httpd-package-only/httpd-*.rpm &>/dev/null' \
        && ! docker exec "$CONTAINER_NAME" rpm -q httpd &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: httpd's rpm is in the dependencies folder, and more than just
    # that one file is there (proves --resolve actually pulled in dependencies)
    local dep_file_count
    dep_file_count=$(docker exec "$CONTAINER_NAME" bash -c 'ls /tmp/httpd-dependencies/*.rpm 2>/dev/null | wc -l')
    if docker exec "$CONTAINER_NAME" bash -c 'ls /tmp/httpd-dependencies/httpd-*.rpm &>/dev/null' \
        && [[ "$dep_file_count" -gt 1 ]]; then
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
