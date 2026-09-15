#!/bin/bash
# Objective 2: Manage software
# LAB: List, Inspect, and Install a Package Group (container-only terminal)
# NOTE: same pattern as lab_container_install_httpd.sh - prepare_lab attaches
# the single default terminal straight into the container via `tmux
# send-keys`, so no host shell is ever shown or reachable. Web UI only;
# harmless no-op on the CLI simulator - CLI users would need to run
# `docker exec -it rhcsa_lab_container_dnf_group bash` themselves.

IS_LAB=true
LAB_ID="container_dnf_group_install"

QUESTION="List, inspect, and install a package group using dnf."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="List the available package groups, and redirect the output into /root/group_list.txt instead of the screen"
TASK_1_HINT="dnf group list shows every package group available from the enabled repositories"
TASK_1_COMMAND_1="dnf group list > /root/group_list.txt"

# Task 2
TASK_2_QUESTION="Show the contents of the 'Development Tools' group, and redirect the output into /root/group_info.txt instead of the screen"
TASK_2_HINT="dnf group info 'Development Tools' lists every package that belongs to that group, split into mandatory, default, and optional"
TASK_2_COMMAND_1="dnf group info 'Development Tools' > /root/group_info.txt"

# Task 3
TASK_3_QUESTION="Install the 'Development Tools' group"
TASK_3_HINT="dnf group install installs every mandatory and default package in the named group, without pausing for a yes/no prompt when combined with -y"
TASK_3_COMMAND_1="dnf group install 'Development Tools' -y"

# Auto-generate HINT from commands
HINT=$(_build_hint)

CONTAINER_NAME="rhcsa_lab_container_dnf_group"
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
    # Task 0: the group list was redirected into a file that actually
    # includes Development Tools (not just any output)
    if docker exec "$CONTAINER_NAME" test -s /root/group_list.txt &>/dev/null \
        && docker exec "$CONTAINER_NAME" grep -qi "Development Tools" /root/group_list.txt &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: the group's contents were redirected into a file that actually
    # names one of its member packages (gcc, always part of this group)
    if docker exec "$CONTAINER_NAME" test -s /root/group_info.txt &>/dev/null \
        && docker exec "$CONTAINER_NAME" grep -qi gcc /root/group_info.txt &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: the group was actually installed (checked via gcc, one of its
    # mandatory/default packages, rather than parsing dnf's group-list
    # installed/available filter output)
    if docker exec "$CONTAINER_NAME" rpm -q gcc &>/dev/null; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Removing container...${RESET}"
    docker rm -f "$CONTAINER_NAME" &>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
