#!/bin/bash
# Objective 2: Manage software
# LAB: Install RPM Files (local file and directly from a URL, container-only terminal)
# NOTE: same pattern as lab_container_install_httpd.sh - prepare_lab attaches
# the single default terminal straight into the container via `tmux
# send-keys`, so no host shell is ever shown or reachable. Web UI only;
# harmless no-op on the CLI simulator - CLI users would need to run
# `docker exec -it rhcsa_lab_container_rpm_install bash` themselves.
# NOTE: prepare_lab downloads the EPEL RPM on the host (curl is a guaranteed
# dependency of the simulator itself) and copies it in with `docker cp`,
# rather than requiring curl/wget to be present inside the container image.

IS_LAB=true
LAB_ID="container_install_rpm_file"

QUESTION="Install RPM packages from a local file and directly from a URL using dnf."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="The EPEL release package for RHEL 10 has already been downloaded to /root/epel-release-latest-10.noarch.rpm. Install that local file using dnf"
TASK_1_HINT="dnf install can install a local .rpm file directly by path, resolving any of its own dependencies from the enabled repositories"
TASK_1_COMMAND_1="dnf install -y /root/epel-release-latest-10.noarch.rpm"

# Task 2
TASK_2_QUESTION="Install this package directly from a URL, without downloading it separately first: https://packages.microsoft.com/config/rhel/10/packages-microsoft-prod.rpm"
TASK_2_HINT="dnf install can take a URL directly as its argument; dnf downloads the file itself before installing it"
TASK_2_COMMAND_1="dnf install -y https://packages.microsoft.com/config/rhel/10/packages-microsoft-prod.rpm"

# Auto-generate HINT from commands
HINT=$(_build_hint)

CONTAINER_NAME="rhcsa_lab_container_rpm_install"
CONTAINER_IMAGE="rockylinux/rockylinux:10-ubi-init"
EPEL_RPM_URL="https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm"

# Prepare the lab environment
# Docker and the container image are already installed/pulled by the simulator
# installer. This starts the container, downloads the EPEL RPM on the host
# and copies it in, then attaches the terminal to the container.
prepare_lab() {
    echo -e "  ${DIM}• Removing any previous container...${RESET}"
    docker rm -f "$CONTAINER_NAME" &>/dev/null

    echo -e "  ${DIM}• Starting container (${CONTAINER_IMAGE})...${RESET}"
    # --privileged + the cgroup mount are required for systemd to run as PID 1 inside the container
    docker run -d --name "$CONTAINER_NAME" --privileged --cgroupns=host \
        -v /sys/fs/cgroup:/sys/fs/cgroup:rw "$CONTAINER_IMAGE" /usr/sbin/init &>/dev/null
    sleep 2

    echo -e "  ${DIM}• Downloading the EPEL release RPM...${RESET}"
    curl -sL -o /tmp/epel-release-latest-10.noarch.rpm "$EPEL_RPM_URL"
    docker cp /tmp/epel-release-latest-10.noarch.rpm "$CONTAINER_NAME":/root/epel-release-latest-10.noarch.rpm &>/dev/null
    rm -f /tmp/epel-release-latest-10.noarch.rpm

    # Web UI only: attach the single visible terminal straight into the
    # container so no host shell is ever shown for this lab
    tmux send-keys -t rhcsa-terminal:lab_main "clear; docker exec -it $CONTAINER_NAME bash" Enter 2>/dev/null
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: epel-release installed from the local RPM file
    if docker exec "$CONTAINER_NAME" rpm -q epel-release &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: packages-microsoft-prod installed directly from the URL
    if docker exec "$CONTAINER_NAME" rpm -q packages-microsoft-prod &>/dev/null; then
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
