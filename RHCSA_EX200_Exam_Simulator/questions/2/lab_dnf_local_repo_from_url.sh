#!/bin/bash
# Objective 2: Manage software
# LAB: Add the Kubernetes DNF Repository and Secure it with its GPG Key
# NOTE: check_tasks is method-agnostic - it greps whichever .repo file under
# /etc/yum.repos.d or /etc/dnf/repos.override.d has a baseurl containing
# pkgs.k8s.io, rather than looking for one specific repo ID or filename, so
# a manual .repo file OR `dnf config-manager` both pass equally. This reads
# the file directly instead of `dnf repo info --json`, which has to sync
# live metadata for every configured repo just to build its output - slow,
# network-dependent, and unrelated to whether the file itself is correct.
# NOTE: TASK_1 uses `dnf config-manager --add-repo <url>` (a single
# positional URL, no --set=/--id= flags) - live-verified working on this
# system. It auto-creates /etc/yum.repos.d/pkgs.k8s.io_core_stable_v1.37_rpm_.repo
# with an auto-generated repo ID/name, baseurl, and enabled=1, but no
# gpgcheck line, so gpgcheck=0 is appended separately. The earlier
# `addrepo --id=... --set=...` and `setopt` syntax both failed on this
# system ("Command line error: ambiguous option").
# NOTE: this lab needs real internet access to pkgs.k8s.io - unlike the
# ISO-based local repo lab, it is not self-contained offline.
# NOTE: repo ID/URLs verified live against kubernetes.io on 2026-09-10. If a
# newer Kubernetes minor version has since become current, the v1.37 paths
# below may need bumping to match (see kubernetes.io/docs/setup/production-
# environment/tools/kubeadm/install-kubeadm/ for the current version).

IS_LAB=true
LAB_ID="dnf_kubernetes_repo"

QUESTION="Configure a DNF repository from a URL, secure it with its GPG key, install a package from it, then disable it."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=4

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Add a new DNF repository for Kubernetes using this base URL: https://pkgs.k8s.io/core:/stable:/v1.37/rpm/ - enable the repository, but leave GPG checking off for now"
TASK_1_HINT="dnf config-manager --add-repo followed by just the URL creates and enables the repository in one command; it does not turn off gpgcheck by itself, so append gpgcheck=0 to the resulting repo file"
TASK_1_COMMAND_1="dnf config-manager --add-repo https://pkgs.k8s.io/core:/stable:/v1.37/rpm/"
TASK_1_COMMAND_2="echo 'gpgcheck=0' >> /etc/yum.repos.d/pkgs.k8s.io_core_stable_v1.37_rpm_.repo"

# Task 2
TASK_2_QUESTION="Using this GPG key URL: https://pkgs.k8s.io/core:/stable:/v1.37/rpm/repodata/repomd.xml.key - turn gpgcheck on for the Kubernetes repository and point it at that key"
TASK_2_HINT="Edit the repo file: change gpgcheck to 1, and add a gpgkey= line pointing at the key URL"
TASK_2_COMMAND_1="sed -i 's/^gpgcheck=0/gpgcheck=1/' /etc/yum.repos.d/pkgs.k8s.io_core_stable_v1.37_rpm_.repo"
TASK_2_COMMAND_2="echo 'gpgkey=https://pkgs.k8s.io/core:/stable:/v1.37/rpm/repodata/repomd.xml.key' >> /etc/yum.repos.d/pkgs.k8s.io_core_stable_v1.37_rpm_.repo"

# Task 3
TASK_3_QUESTION="Install kubectl using the Kubernetes repository, proving that the repository and its GPG key are both configured correctly"
TASK_3_HINT="dnf install -y kubectl pulls the package from whichever enabled repository provides it, and verifies its signature against the configured GPG key before installing"
TASK_3_COMMAND_1="dnf install -y kubectl"

# Task 4
TASK_4_QUESTION="Disable the Kubernetes repository, then confirm it is gone from dnf repolist --enabled"
TASK_4_HINT="Set enabled=0 in the repo file; --enabled only lists repositories that are still active"
TASK_4_COMMAND_1="sed -i 's/^enabled=1/enabled=0/' /etc/yum.repos.d/pkgs.k8s.io_core_stable_v1.37_rpm_.repo"
TASK_4_COMMAND_2="dnf repolist --enabled"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Find whichever .repo file (any name) configures the pkgs.k8s.io repo
_k8s_repo_file() {
    local f
    for f in /etc/yum.repos.d/*.repo /etc/dnf/repos.override.d/*.repo; do
        [[ -f "$f" ]] || continue
        grep -qE '^baseurl\s*=.*pkgs\.k8s\.io' "$f" 2>/dev/null && { echo "$f"; return 0; }
    done
    return 1
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /etc/yum.repos.d/kubernetes.repo
    rm -f /etc/yum.repos.d/pkgs.k8s.io_core_stable_v1.37_rpm_.repo
    rm -f /etc/dnf/repos.override.d/99-config_manager.repo
    rpm -e kubectl 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local repo_file
    repo_file=$(_k8s_repo_file)

    # Task 0: an enabled repo pointing at pkgs.k8s.io exists, with GPG
    # package checking off (accepts either an explicit gpgcheck=0 or no
    # gpgcheck line at all, matching the hint's suggested command)
    if [[ -n "$repo_file" ]] && grep -qE '^enabled\s*=\s*1' "$repo_file" \
        && ! grep -qE '^gpgcheck\s*=\s*1' "$repo_file"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: that repo now has gpgcheck on, with the matching key URL set
    if [[ -n "$repo_file" ]] && grep -qE '^gpgcheck\s*=\s*1' "$repo_file" \
        && grep -q 'repomd\.xml\.key' "$repo_file"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: kubectl was actually installed (real proof the repo + key work)
    if rpm -q kubectl &>/dev/null; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: the pkgs.k8s.io repo is disabled, or removed entirely - either
    # way it won't show up in dnf repolist --enabled
    if [[ -z "$repo_file" ]] || grep -qE '^enabled\s*=\s*0' "$repo_file"; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /etc/yum.repos.d/kubernetes.repo
    rm -f /etc/yum.repos.d/pkgs.k8s.io_core_stable_v1.37_rpm_.repo
    rm -f /etc/dnf/repos.override.d/99-config_manager.repo
    rpm -e kubectl 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
