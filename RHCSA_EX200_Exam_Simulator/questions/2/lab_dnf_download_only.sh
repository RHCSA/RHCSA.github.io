#!/bin/bash
# Objective 2: Manage software
# LAB: Download a Package Without Installing It (runs on the host)

IS_LAB=true
LAB_ID="dnf_download_only"

QUESTION="Download a package with and without its dependencies, without installing it."

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Download the httpd package into /tmp/httpd-package-only/ without installing it"
TASK_1_HINT="dnf download saves the .rpm file itself without installing it; --destdir sets where the file is saved"
TASK_1_COMMAND_1="dnf download httpd --destdir=/tmp/httpd-package-only/"

# Task 2
TASK_2_QUESTION="Download httpd again, this time including every one of its dependencies, into /tmp/httpd-dependencies/"
TASK_2_HINT="adding --resolve tells dnf download to also fetch every dependency the package needs, not just the package itself"
TASK_2_COMMAND_1="dnf download httpd --resolve --destdir=/tmp/httpd-dependencies/"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -rf /tmp/httpd-package-only /tmp/httpd-dependencies
    rpm -e httpd 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: httpd's rpm was downloaded into the right folder, and httpd
    # itself was never actually installed (proves it was download-only)
    if ls /tmp/httpd-package-only/httpd-*.rpm &>/dev/null \
        && ! rpm -q httpd &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: httpd's rpm is in the dependencies folder, and more than just
    # that one file is there (proves --resolve actually pulled in dependencies)
    local dep_file_count
    dep_file_count=$(ls /tmp/httpd-dependencies/*.rpm 2>/dev/null | wc -l)
    if ls /tmp/httpd-dependencies/httpd-*.rpm &>/dev/null \
        && [[ "$dep_file_count" -gt 1 ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/httpd-package-only /tmp/httpd-dependencies
    rpm -e httpd 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}

