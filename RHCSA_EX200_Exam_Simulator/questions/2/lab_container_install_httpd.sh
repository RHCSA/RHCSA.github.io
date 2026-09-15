#!/bin/bash
# Objective 2: Manage software
# LAB: Install httpd Inside a Container, then List its Dependencies (container-only terminal, no host tab)
# NOTE: unlike questions/8/lab_docker_container_demo.sh (host tab + separate
# container tab), this lab redirects the single default terminal itself
# straight into the container via `tmux send-keys` in prepare_lab, so no host
# shell is ever shown or reachable for this lab. This only has an effect in
# the web UI (which uses this tmux session); it is a harmless no-op on the
# CLI simulator - CLI users would need to run
# `docker exec -it rhcsa_lab_container_httpd bash` themselves to reach it.

IS_LAB=true
LAB_ID="container_install_httpd"

QUESTION="Install httpd using dnf, then list its dependencies."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Install the httpd package"
TASK_1_HINT="dnf install -y httpd installs the package without pausing for a yes/no prompt"
TASK_1_COMMAND_1="dnf install -y httpd"

# Task 2
TASK_2_QUESTION="List httpd's dependencies, and redirect the output into /root/httpd_deps.txt instead of the screen"
TASK_2_HINT="rpm -qR httpd lists every dependency (requirement) that httpd needs to run"
TASK_2_COMMAND_1="rpm -qR httpd > /root/httpd_deps.txt"

# Auto-generate HINT from commands
HINT=$(_build_hint)

CONTAINER_NAME="rhcsa_lab_container_httpd"
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
    # Task 0: httpd installed inside the container
    if docker exec "$CONTAINER_NAME" rpm -q httpd &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: httpd's dependency list was redirected into a real file that
    # looks like actual rpm -qR httpd output. This checks for stable,
    # well-known dependency markers rather than an exact match against a
    # live re-run, since duplicate/ordering details in rpm's own dependency
    # list are not guaranteed to be identical between two separate queries.
    if docker exec "$CONTAINER_NAME" test -s /root/httpd_deps.txt &>/dev/null; then
        local content
        content=$(docker exec "$CONTAINER_NAME" cat /root/httpd_deps.txt 2>/dev/null)
        if echo "$content" | grep -q 'httpd-core' && echo "$content" | grep -qi 'libc\.so'; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
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
