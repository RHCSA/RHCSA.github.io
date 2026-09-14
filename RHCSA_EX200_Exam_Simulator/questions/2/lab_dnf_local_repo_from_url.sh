#!/bin/bash
# Objective 2: Manage software
# LAB: Add the Kubernetes DNF Repository and Secure it with its GPG Key
# NOTE: check_tasks is method-agnostic - it queries dnf's actual repo state
# via `dnf repo info --json` (base_url, is_enabled, pkg_gpgcheck, gpg_key -
# note this is `repo info`, not `repo list`; only `info` includes those
# fields) rather than looking for one specific repo ID or file, so a manual
# /etc/yum.repos.d/*.repo file OR `dnf config-manager` both pass equally.
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
    # Task 0: an enabled repo pointing at pkgs.k8s.io exists
    local repo_added
    repo_added=$(dnf repo info --all --json 2>/dev/null | python3 -c "
import json, sys
try:
    repos = json.load(sys.stdin)
except Exception:
    print('no')
    sys.exit()
for r in repos:
    urls = r.get('base_url') or []
    if any('pkgs.k8s.io' in u for u in urls) and r.get('is_enabled'):
        print('yes')
        sys.exit()
print('no')
" 2>/dev/null)
    if [[ "$repo_added" == "yes" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: that repo now has gpgcheck on, with the matching key URL set
    local gpg_ready
    gpg_ready=$(dnf repo info --all --json 2>/dev/null | python3 -c "
import json, sys
try:
    repos = json.load(sys.stdin)
except Exception:
    print('no')
    sys.exit()
for r in repos:
    urls = r.get('base_url') or []
    if any('pkgs.k8s.io' in u for u in urls):
        keys = r.get('gpg_key') or []
        if r.get('pkg_gpgcheck') and any('repomd.xml.key' in k for k in keys):
            print('yes')
        else:
            print('no')
        sys.exit()
print('no')
" 2>/dev/null)
    if [[ "$gpg_ready" == "yes" ]]; then
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

    # Task 3: the pkgs.k8s.io repo no longer shows up as enabled
    local still_enabled
    still_enabled=$(dnf repo info --enabled --json 2>/dev/null | python3 -c "
import json, sys
try:
    repos = json.load(sys.stdin)
except Exception:
    print('no')
    sys.exit()
for r in repos:
    urls = r.get('base_url') or []
    if any('pkgs.k8s.io' in u for u in urls):
        print('yes')
        sys.exit()
print('no')
" 2>/dev/null)
    if [[ "$still_enabled" == "no" ]]; then
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
