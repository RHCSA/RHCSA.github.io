#!/bin/bash
# Objective 2: Manage software
# LAB: Configure a Local DNF Repository from a Mounted ISO
# NOTE: check_tasks is method-agnostic - it queries dnf's actual repo state
# (base_url + is_enabled via `dnf repo info --json` - note this is `repo
# info`, not `repo list`; only `info` includes base_url/gpg_key/pkg_gpgcheck)
# rather than looking for one specific repo ID or file, so a manual
# /etc/yum.repos.d/*.repo file OR `dnf config-manager addrepo` both pass
# equally.
# NOTE: subscription-manager repos --enable/--disable only manages repos
# that come from an attached Red Hat subscription (the CDN repos) - it does
# not apply to a custom local repo like the one this lab creates. It is
# mentioned in the hints as real-exam-relevant knowledge, not as a method
# that works for this specific repo.
# NOTE: dnf config-manager --add-repo=URL is old DNF4 flag syntax. DNF5
# (RHEL 10's default) does not document that flag on config-manager, and a
# currently open DNF5 issue (rpm-software-management/dnf5#2925) confirms its
# alias system cannot map an old flag to a subcommand plus rewritten value,
# so it is unreliable here. TASK_1 uses the native addrepo --set= syntax.
# ASSUMPTION: the bundled fixture at questions/2/rhel10-mini.iso contains a
# single package named "tree" (chosen because it has no dependencies beyond
# glibc, which every install already has). If a different package was
# packed into the ISO, update the "tree" references below to match.

IS_LAB=true
LAB_ID="dnf_local_repo_from_iso"

QUESTION="Configure a local DNF repository from a mounted ISO, install a package from it, then disable it."

# Lab configuration
LAB_TASK_COUNT=4

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Mount /root/rhel10-mini.iso on /mnt, then configure a new DNF repository whose base URL points at /mnt, enabled and without GPG checking, so packages on the ISO become installable"
TASK_1_HINT="dnf config-manager addrepo --id=rhel10-mini --set=baseurl=file:///mnt --set=gpgcheck=0 mounts a working repo in one command and enables it by default. You can instead write a file under /etc/yum.repos.d/ by hand with a section that sets baseurl=file:///mnt, enabled=1, and gpgcheck=0 - both produce the same result"
TASK_1_COMMAND_1="mount -o loop /root/rhel10-mini.iso /mnt && dnf config-manager addrepo --id=rhel10-mini --set=baseurl=file:///mnt --set=gpgcheck=0"

# Task 2
TASK_2_QUESTION="Install the tree package using the newly configured repository, proving that it actually works"
TASK_2_HINT="dnf install -y tree pulls the package from whichever enabled repository provides it - here, that is the repository pointing at /mnt"
TASK_2_COMMAND_1="dnf install -y tree"

# Task 3
TASK_3_QUESTION="Run dnf repolist and redirect its output into /root/repolist_output.txt instead of the screen"
TASK_3_HINT="The > operator redirects standard output to a file, overwriting any existing content"
TASK_3_COMMAND_1="dnf repolist > /root/repolist_output.txt"

# Task 4
TASK_4_QUESTION="Disable the repository you added, then run dnf repolist --enabled and confirm it no longer appears in that list"
TASK_4_HINT="Set enabled=0 in the repo file, or run dnf config-manager --disable rhel10-mini (dnf5's config-manager plugin also accepts --set=rhel10-mini.enabled=0); either way, --enabled only lists repositories that are still active"
TASK_4_COMMAND_1="dnf repolist --enabled"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    umount /mnt 2>/dev/null
    rm -f /etc/yum.repos.d/rhel10-mini.repo
    rm -f /etc/dnf/repos.override.d/99-config_manager.repo
    rpm -e tree 2>/dev/null
    rm -f /root/repolist_output.txt /root/rhel10-mini.iso
    cp /usr/local/share/rhcsa/questions/2/rhel10-mini.iso /root/rhel10-mini.iso 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: ISO mounted at /mnt with valid repo data, and dnf sees an
    # enabled repo whose base URL points there (works no matter which repo
    # ID or method - manual .repo file or dnf config-manager - was used)
    local mnt_enabled
    mnt_enabled=$(dnf repo info --all --json 2>/dev/null | python3 -c "
import json, sys
try:
    repos = json.load(sys.stdin)
except Exception:
    print('no')
    sys.exit()
for r in repos:
    urls = r.get('base_url') or []
    if any('/mnt' in u for u in urls) and r.get('is_enabled'):
        print('yes')
        sys.exit()
print('no')
" 2>/dev/null)
    if mountpoint -q /mnt && [[ -d /mnt/repodata ]] && [[ "$mnt_enabled" == "yes" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: the package was actually installed (the real proof the repo works)
    if rpm -q tree &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: repolist output was redirected into the file
    if [[ -s /root/repolist_output.txt ]] && [[ $(wc -l < /root/repolist_output.txt) -ge 2 ]]; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: the /mnt repo no longer shows up as enabled
    local mnt_still_enabled
    mnt_still_enabled=$(dnf repo info --enabled --json 2>/dev/null | python3 -c "
import json, sys
try:
    repos = json.load(sys.stdin)
except Exception:
    print('no')
    sys.exit()
for r in repos:
    urls = r.get('base_url') or []
    if any('/mnt' in u for u in urls):
        print('yes')
        sys.exit()
print('no')
" 2>/dev/null)
    if [[ "$mnt_still_enabled" == "no" ]]; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    umount /mnt 2>/dev/null
    rm -f /etc/yum.repos.d/rhel10-mini.repo
    rm -f /etc/dnf/repos.override.d/99-config_manager.repo
    rpm -e tree 2>/dev/null
    rm -f /root/repolist_output.txt /root/rhel10-mini.iso
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
