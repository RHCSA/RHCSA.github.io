#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Docker Container Practice (demo of a container as a second terminal tab)

IS_LAB=true
LAB_ID="docker_container_demo"

QUESTION="Tab 2 is a live terminal inside a Rocky Linux 10 container (a free RHEL 10 rebuild) running on this same machine. Switch to that tab and install the httpd package inside the container."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, answer, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Inside the container tab, install the httpd package"
TASK_1_ANSWER="Use dnf to install httpd inside the container (tab 2)"
TASK_1_COMMAND_1="dnf install -y httpd"

# =============================================================================
# CONTAINER SETUP
# =============================================================================

CONTAINER_NAME="rhcsa_lab_docker_demo"
CONTAINER_IMAGE="rockylinux/rockylinux:10-ubi-init"

# Tab names
PREPARE_LAB_1_NAME="Host Machine"
PREPARE_LAB_2_NAME="Container (Rocky Linux 10)"
# Attach tab 2 straight into the running container instead of a host shell
PREPARE_LAB_2_COMMAND="docker exec -it rhcsa_lab_docker_demo bash"

# Prepare the lab environment (host / tab 1)
# Docker and the container image are already installed/pulled by the simulator
# installer - this just needs to run and prepare the container itself.
prepare_lab() {
    echo -e "  ${DIM}• Removing any previous container...${RESET}"
    docker rm -f "$CONTAINER_NAME" &>/dev/null

    echo -e "  ${DIM}• Starting container (${CONTAINER_IMAGE})...${RESET}"
    # --privileged + the cgroup mount are required for systemd to run as PID 1 inside the container
    docker run -d --name "$CONTAINER_NAME" --privileged --cgroupns=host \
        -v /sys/fs/cgroup:/sys/fs/cgroup:rw "$CONTAINER_IMAGE" /usr/sbin/init &>/dev/null
    sleep 2
}

# Prepare tab 2 - required so the web UI detects and creates
# the container tab; the container itself is already started by prepare_lab.
prepare_lab_2() {
    :
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: httpd installed inside the container
    if docker exec "$CONTAINER_NAME" rpm -q httpd &>/dev/null; then
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
