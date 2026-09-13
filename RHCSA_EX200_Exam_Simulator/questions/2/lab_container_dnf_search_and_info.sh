#!/bin/bash
# Objective 2: Manage software
# LAB: Search, Inspect, Count, and Update Packages (container-only terminal)
# NOTE: same pattern as lab_container_install_httpd.sh - prepare_lab attaches
# the single default terminal straight into the container via `tmux
# send-keys`, so no host shell is ever shown or reachable. Web UI only;
# harmless no-op on the CLI simulator - CLI users would need to run
# `docker exec -it rhcsa_lab_container_dnf_search bash` themselves.

IS_LAB=true
LAB_ID="container_dnf_search_and_info"

QUESTION="Search for, inspect, count, and update packages using dnf."

# Lab configuration
LAB_TASK_COUNT=4

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="This terminal is inside a Rocky Linux 10 container (a free RHEL 10 rebuild) running on this machine. Search for 'web server' using dnf, and redirect the output into /root/search_output.txt instead of the screen"
TASK_1_HINT="dnf search 'web server' looks for that phrase in package names and summaries; the > operator redirects standard output to a file"
TASK_1_COMMAND_1="dnf search 'web server' > /root/search_output.txt"

# Task 2
TASK_2_QUESTION="Get information about the httpd package, and redirect the output into /root/httpd_info.txt instead of the screen"
TASK_2_HINT="dnf info httpd shows detailed information about that package, including its version, size, and summary"
TASK_2_COMMAND_1="dnf info httpd > /root/httpd_info.txt"

# Task 3
TASK_3_QUESTION="Count how many packages are installed, and redirect the number into /root/installed_count.txt instead of the screen"
TASK_3_HINT="dnf list installed lists every installed package, one per line; piping that into wc -l counts the lines, giving the total"
TASK_3_COMMAND_1="dnf list installed | wc -l > /root/installed_count.txt"

# Task 4
TASK_4_QUESTION="Update all installed packages using dnf"
TASK_4_HINT="dnf update -y updates every package that has a newer version available, without pausing for a yes/no prompt"
TASK_4_COMMAND_1="dnf update -y"

# Auto-generate HINT from commands
HINT=$(_build_hint)

CONTAINER_NAME="rhcsa_lab_container_dnf_search"
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
    # Task 0: the search results were redirected into a real, non-empty file
    # inside the container (dnf always prints something, even "no matches",
    # so a non-empty file is a reliable sign a real search ran)
    if docker exec "$CONTAINER_NAME" test -s /root/search_output.txt &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: httpd's info was redirected into a real file that actually
    # mentions httpd (not just any output)
    if docker exec "$CONTAINER_NAME" test -s /root/httpd_info.txt &>/dev/null \
        && docker exec "$CONTAINER_NAME" grep -qi httpd /root/httpd_info.txt &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: the installed-package count in the file matches a fresh count
    # taken right now (proves it is a real, current count, not a guessed number)
    local real_count file_count
    real_count=$(docker exec "$CONTAINER_NAME" bash -c 'dnf list installed | wc -l' 2>/dev/null | tr -d '[:space:]')
    file_count=$(docker exec "$CONTAINER_NAME" cat /root/installed_count.txt 2>/dev/null | tr -d '[:space:]')
    if [[ -n "$file_count" ]] && [[ "$file_count" == "$real_count" ]]; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: no updates remain available (proves a real update was applied,
    # not just claimed - exit 0 from dnf check-update means fully up to date)
    if docker exec "$CONTAINER_NAME" dnf check-update &>/dev/null; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Removing container...${RESET}"
    docker rm -f "$CONTAINER_NAME" &>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
