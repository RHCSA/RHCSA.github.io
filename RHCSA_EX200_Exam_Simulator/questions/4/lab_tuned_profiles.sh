#!/bin/bash
# Objective 4: Operate running systems
# LAB: Manage Tuning Profiles (tuned, tuned-adm)
# Host-machine terminal only (no container) - the single default terminal
# every lab starts with.
# NOTE: prepare_lab saves whatever tuned's real enabled/active/profile state
# already was, and cleanup_lab restores exactly that - same reasoning as
# lab_systemd_targets_management.sh, so this lab never leaves the machine's
# tuning state changed after it's finished.
# NOTE: Task 2 (tuned-adm list) and Task 4 (tuned-adm active) are checked
# structurally (right output format / a known profile name present) rather
# than with an exact live-value match, because both commands' output
# includes the CURRENTLY active profile - which Task 3 changes. Tasks 5 and
# 6 (recommend, profile config file) ARE checked with an exact live/on-disk
# match, since neither depends on which profile happens to be active.

IS_LAB=true
LAB_ID="tuned_profiles"

QUESTION="Manage tuning profiles with tuned-adm"

# Lab configuration
LAB_TASK_COUNT=7

STATE_FILE="/tmp/.rhcsa_lab_tuned_original_state"

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Enable and start the tuned service"
TASK_1_HINT="Use systemctl enable with --now to enable and start in one command"
TASK_1_COMMAND_1="systemctl enable --now tuned"

# Task 2
TASK_2_QUESTION="Display all available tuning profiles. Save the output to /tmp/tuned_list.txt"
TASK_2_HINT="Use tuned-adm list"
TASK_2_COMMAND_1="tuned-adm list > /tmp/tuned_list.txt"

# Task 3
TASK_3_QUESTION="Set the system tuning profile to optimize for throughput performance"
TASK_3_HINT="Use tuned-adm profile with the profile name"
TASK_3_COMMAND_1="tuned-adm profile throughput-performance"

# Task 4
TASK_4_QUESTION="Display the currently active tuning profile. Save the output to /tmp/tuned_active.txt"
TASK_4_HINT="Use tuned-adm active"
TASK_4_COMMAND_1="tuned-adm active > /tmp/tuned_active.txt"

# Task 5
TASK_5_QUESTION="Confirm that the current system settings match the active tuning profile"
TASK_5_HINT="Use tuned-adm verify"
TASK_5_COMMAND_1="tuned-adm verify"

# Task 6
TASK_6_QUESTION="Get tuned's recommended profile for this system. Save the output to /tmp/tuned_recommend.txt"
TASK_6_HINT="Use tuned-adm recommend"
TASK_6_COMMAND_1="tuned-adm recommend > /tmp/tuned_recommend.txt"

# Task 7
TASK_7_QUESTION="Display the configuration of the throughput-performance profile. Save the output to /tmp/tuned_profile_conf.txt"
TASK_7_HINT="The profile's configuration file is at /usr/lib/tuned/throughput-performance/tuned.conf"
TASK_7_COMMAND_1="cat /usr/lib/tuned/throughput-performance/tuned.conf > /tmp/tuned_profile_conf.txt"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Making sure tuned is installed...${RESET}"
    dnf install -y tuned &>/dev/null || true

    echo -e "  ${DIM}• Saving current tuned state...${RESET}"
    local was_enabled="disabled"
    local was_active="inactive"
    local was_profile=""
    systemctl is-enabled tuned 2>/dev/null | grep -q '^enabled$' && was_enabled="enabled"
    systemctl is-active tuned 2>/dev/null | grep -q '^active$' && was_active="active"
    was_profile=$(tuned-adm active 2>/dev/null | sed -n 's/.*: *//p')
    printf '%s\n%s\n%s\n' "$was_enabled" "$was_active" "$was_profile" > "$STATE_FILE"

    echo -e "  ${DIM}• Resetting tuned to a disabled, stopped state...${RESET}"
    systemctl disable --now tuned 2>/dev/null || true

    echo -e "  ${DIM}• Removing old output files...${RESET}"
    rm -f /tmp/tuned_list.txt /tmp/tuned_active.txt /tmp/tuned_recommend.txt /tmp/tuned_profile_conf.txt
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: tuned enabled and running
    if systemctl is-enabled tuned 2>/dev/null | grep -q '^enabled$' \
        && systemctl is-active tuned 2>/dev/null | grep -q '^active$'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: list of profiles captured - checks for known profile names
    # rather than an exact match (the list's own trailing "current active
    # profile" line changes once Task 3 runs)
    if [[ -f /tmp/tuned_list.txt ]] && grep -q 'throughput-performance' /tmp/tuned_list.txt \
        && grep -qi 'available profiles' /tmp/tuned_list.txt; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: active profile is throughput-performance (checked live)
    if tuned-adm active 2>/dev/null | grep -q 'throughput-performance'; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: active profile captured to a file - structure only (the right
    # "active profile" line present), not a specific profile name, since
    # Task 3 changes the live active profile and could run in either order
    if [[ -f /tmp/tuned_active.txt ]] && grep -qi 'active profile' /tmp/tuned_active.txt; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi

    # Task 4: tuned-adm verify currently succeeds (checked live)
    if tuned-adm verify &>/dev/null; then
        TASK_STATUS[4]="true"
    else
        TASK_STATUS[4]="false"
    fi

    # Task 5: recommendation captured, matches a fresh live re-run (based on
    # hardware/virtualization detection, unaffected by the active profile)
    if [[ -f /tmp/tuned_recommend.txt ]]; then
        local live_rec
        live_rec=$(tuned-adm recommend 2>/dev/null)
        if [[ -n "$live_rec" ]] && [[ "$(cat /tmp/tuned_recommend.txt)" == "$live_rec" ]]; then
            TASK_STATUS[5]="true"
        else
            TASK_STATUS[5]="false"
        fi
    else
        TASK_STATUS[5]="false"
    fi

    # Task 6: throughput-performance profile config captured, matches the
    # real file on disk (static content, unaffected by the active profile)
    if [[ -f /tmp/tuned_profile_conf.txt ]] && [[ -f /usr/lib/tuned/throughput-performance/tuned.conf ]] \
        && diff -q /tmp/tuned_profile_conf.txt /usr/lib/tuned/throughput-performance/tuned.conf &>/dev/null; then
        TASK_STATUS[6]="true"
    else
        TASK_STATUS[6]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Restoring original tuned state...${RESET}"
    if [[ -f "$STATE_FILE" ]]; then
        local was_enabled was_active was_profile
        was_enabled=$(sed -n '1p' "$STATE_FILE")
        was_active=$(sed -n '2p' "$STATE_FILE")
        was_profile=$(sed -n '3p' "$STATE_FILE")

        if [[ "$was_active" == "active" ]]; then
            systemctl start tuned 2>/dev/null
            [[ -n "$was_profile" ]] && tuned-adm profile "$was_profile" 2>/dev/null
        else
            systemctl stop tuned 2>/dev/null
        fi

        if [[ "$was_enabled" == "enabled" ]]; then
            systemctl enable tuned 2>/dev/null
        else
            systemctl disable tuned 2>/dev/null
        fi

        rm -f "$STATE_FILE"
    fi

    echo -e "  ${DIM}• Removing lab output files...${RESET}"
    rm -f /tmp/tuned_list.txt /tmp/tuned_active.txt /tmp/tuned_recommend.txt /tmp/tuned_profile_conf.txt
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
