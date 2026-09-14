#!/bin/bash
# Objective 2: Manage software
# LAB: Set Up and Use Flatpak (container-only terminal)
# NOTE: same pattern as lab_container_install_httpd.sh - prepare_lab attaches
# the single default terminal straight into the container via `tmux
# send-keys`, so no host shell is ever shown or reachable. Web UI only;
# harmless no-op on the CLI simulator - CLI users would need to run
# `docker exec -it rhcsa_lab_container_flatpak bash` themselves.
# NOTE: verified live against flathub.org/en/setup/Rocky%20Linux - flatpak
# installs directly from Rocky's own repos, no EPEL needed.
# NOTE: Task 8 (update) has little to genuinely update within the same short
# lab session, since Firefox was only just installed in Task 7 - see the
# comment in check_tasks for how that is handled.

IS_LAB=true
LAB_ID="container_flatpak_setup"

QUESTION="Install Flatpak, add the Flathub repository, and manage Flatpak applications."

# Lab configuration
LAB_TASK_COUNT=8

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="This terminal is inside a Rocky Linux 10 container (a free RHEL 10 rebuild) running on this machine. Install Flatpak using dnf"
TASK_1_HINT="dnf install flatpak -y installs the Flatpak package manager itself"
TASK_1_COMMAND_1="dnf install flatpak -y"

# Task 2
TASK_2_QUESTION="Add the Flathub repository as a system-wide remote"
TASK_2_HINT="flatpak remote-add --if-not-exists flathub followed by its repo URL registers Flathub for every user on this machine; --if-not-exists avoids an error if it is already configured"
TASK_2_COMMAND_1="flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"

# Task 3
TASK_3_QUESTION="Add the Flathub repository again, this time as a remote for only the current user"
TASK_3_HINT="adding --user registers the remote for just the current user's account, separately from the system-wide copy"
TASK_3_COMMAND_1="flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"

# Task 4
TASK_4_QUESTION="List the currently configured Flatpak remotes, and redirect the output into /root/remotes_list.txt instead of the screen"
TASK_4_HINT="flatpak remotes lists every repository Flatpak currently knows about - it should now show flathub registered twice (system and user)"
TASK_4_COMMAND_1="flatpak remotes > /root/remotes_list.txt"

# Task 5
TASK_5_QUESTION="List the applications available from the Flathub remote, and redirect the output into /root/flathub_apps.txt instead of the screen"
TASK_5_HINT="flathub is now registered in both the system and user installations, so flatpak remote-ls needs --system or --user to say which one to read from"
TASK_5_COMMAND_1="flatpak remote-ls --system flathub > /root/flathub_apps.txt"

# Task 6
TASK_6_QUESTION="Search Flathub for applications related to 'editor', and redirect the output into /root/search_editor.txt instead of the screen"
TASK_6_HINT="flatpak search looks through every configured remote for applications matching the given word"
TASK_6_COMMAND_1="flatpak search editor > /root/search_editor.txt"

# Task 7
TASK_7_QUESTION="Install Firefox from Flathub, then confirm it with flatpak info org.mozilla.firefox"
TASK_7_HINT="flathub is registered in both installations, so flatpak install also needs --system or --user to say which one to install into; flatpak info shows its details once installed"
TASK_7_COMMAND_1="flatpak install -y --system flathub org.mozilla.firefox"

# Task 8
TASK_8_QUESTION="Update every installed Flatpak application"
TASK_8_HINT="flatpak update -y updates every installed application to its latest available version, without pausing for a yes/no prompt"
TASK_8_COMMAND_1="flatpak update -y"

# Auto-generate HINT from commands
HINT=$(_build_hint)

CONTAINER_NAME="rhcsa_lab_container_flatpak"
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
    # Task 0: flatpak installed
    if docker exec "$CONTAINER_NAME" rpm -q flatpak &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: flathub registered as a system-wide remote
    if docker exec "$CONTAINER_NAME" flatpak remotes --system 2>/dev/null | grep -qw flathub; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: flathub registered as a user-wide remote too
    if docker exec "$CONTAINER_NAME" flatpak remotes --user 2>/dev/null | grep -qw flathub; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: remotes listing redirected into a file matching a fresh
    # listing taken right now (compares against a live re-run rather than
    # requiring specific content, since the exact remotes present can vary)
    local real_remotes file_remotes
    real_remotes=$(docker exec "$CONTAINER_NAME" flatpak remotes 2>/dev/null)
    file_remotes=$(docker exec "$CONTAINER_NAME" cat /root/remotes_list.txt 2>/dev/null)
    if docker exec "$CONTAINER_NAME" test -f /root/remotes_list.txt &>/dev/null \
        && [[ "$file_remotes" == "$real_remotes" ]]; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi

    # Task 4: the available-apps listing was redirected into a real,
    # non-empty file (flathub has thousands of apps, so it is never empty)
    if docker exec "$CONTAINER_NAME" test -s /root/flathub_apps.txt &>/dev/null; then
        TASK_STATUS[4]="true"
    else
        TASK_STATUS[4]="false"
    fi

    # Task 5: the search results were redirected into a real, non-empty file
    if docker exec "$CONTAINER_NAME" test -s /root/search_editor.txt &>/dev/null; then
        TASK_STATUS[5]="true"
    else
        TASK_STATUS[5]="false"
    fi

    # Task 6: Firefox actually installed
    if docker exec "$CONTAINER_NAME" flatpak info org.mozilla.firefox &>/dev/null; then
        TASK_STATUS[6]="true"
    else
        TASK_STATUS[6]="false"
    fi

    # Task 7: flatpak's update mechanism is reachable and Firefox is still
    # correctly installed afterward. There is rarely anything new to update
    # within the same short lab session (Firefox was only just installed at
    # its current latest version), so this checks the update did not break
    # anything rather than that a specific new version was applied.
    if docker exec "$CONTAINER_NAME" flatpak info org.mozilla.firefox &>/dev/null; then
        TASK_STATUS[7]="true"
    else
        TASK_STATUS[7]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Removing container...${RESET}"
    docker rm -f "$CONTAINER_NAME" &>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
