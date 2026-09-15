#!/bin/bash
# Objective 2: Manage software
# LAB: Remove httpd Inside a Container (container-only terminal, no host tab)
# NOTE: same pattern as lab_container_install_httpd.sh - prepare_lab attaches
# the single default terminal straight into the container via `tmux
# send-keys`, so no host shell is ever shown or reachable. Web UI only;
# harmless no-op on the CLI simulator - CLI users would need to run
# `docker exec -it rhcsa_lab_container_remove_httpd bash` themselves.

IS_LAB=true
LAB_ID="container_remove_httpd"

QUESTION="Remove the httpd package using dnf."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Remove the httpd package"
TASK_1_HINT="dnf remove -y httpd removes the package without pausing for a yes/no prompt"
TASK_1_COMMAND_1="dnf remove -y httpd"

# Auto-generate HINT from commands
HINT=$(_build_hint)

CONTAINER_NAME="rhcsa_lab_container_remove_httpd"
CONTAINER_IMAGE="rockylinux/rockylinux:10-ubi-init"

# Prepare the lab environment
# Docker and the container image are already installed/pulled by the simulator
# installer. This starts the container, pre-installs httpd inside it so the
# task is to remove it, then attaches the terminal to the container.
prepare_lab() {
    echo -e "  ${DIM}• Removing any previous container...${RESET}"
    docker rm -f "$CONTAINER_NAME" &>/dev/null

    echo -e "  ${DIM}• Starting container (${CONTAINER_IMAGE})...${RESET}"
    # --privileged + the cgroup mount are required for systemd to run as PID 1 inside the container
    docker run -d --name "$CONTAINER_NAME" --privileged --cgroupns=host \
        -v /sys/fs/cgroup:/sys/fs/cgroup:rw "$CONTAINER_IMAGE" /usr/sbin/init &>/dev/null
    sleep 2

    # Web UI only: attach the single visible terminal straight into the
    # container immediately, before the slower provisioning below - so a
    # slow dnf install can never leave the terminal stuck on the host shell
    tmux send-keys -t rhcsa-terminal:lab_main "clear; docker exec -it $CONTAINER_NAME bash" Enter 2>/dev/null

    echo -e "  ${DIM}• Pre-installing httpd inside the container...${RESET}"
    docker exec "$CONTAINER_NAME" dnf install -y httpd &>/dev/null
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: httpd removed from inside the container (the container must
    # still be running, otherwise this can't prove anything either way)
    if docker exec "$CONTAINER_NAME" true &>/dev/null && ! docker exec "$CONTAINER_NAME" rpm -q httpd &>/dev/null; then
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
