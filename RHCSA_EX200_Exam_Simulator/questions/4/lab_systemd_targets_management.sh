#!/bin/bash
# Objective 4: Operate running systems
# LAB: List, Inspect, and Change systemd Targets
# Host-machine terminal only (no container) - the single default terminal
# every lab starts with.
# NOTE: systemctl set-default only changes what boots NEXT time. It does not
# change the target that is active right now, so Task 4 will not show
# rescue.target as active unless the machine is actually rebooted.

IS_LAB=true
LAB_ID="systemd_targets_management"

QUESTION="List, inspect, and change systemd targets on this host"
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=4

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="List all available targets on this host. Save the output to /tmp/all-targets.txt"
TASK_1_HINT="Use systemctl list-units with the --type=target option"
TASK_1_COMMAND_1="systemctl list-units --type=target > /tmp/all-targets.txt"

# Task 2
TASK_2_QUESTION="Get the current default target. Save the output to /tmp/default-target.txt. Do this before you change the default target in the next task"
TASK_2_HINT="Use systemctl get-default"
TASK_2_COMMAND_1="systemctl get-default > /tmp/default-target.txt"

# Task 3
TASK_3_QUESTION="Set the default target to rescue.target"
TASK_3_HINT="Use systemctl set-default"
TASK_3_COMMAND_1="systemctl set-default rescue.target"

# Task 4
TASK_4_QUESTION="List the targets that are active right now. Save the output to /tmp/active-targets.txt"
TASK_4_HINT="Use systemctl list-units with --type=target and --state=active"
TASK_4_COMMAND_1="systemctl list-units --type=target --state=active > /tmp/active-targets.txt"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Saving current default target...${RESET}"
    systemctl get-default > /tmp/.lab_systemd_targets_mgmt_original 2>/dev/null
    sleep 0.3

    echo -e "  ${DIM}• Setting a known default target (graphical.target)...${RESET}"
    systemctl set-default graphical.target 2>/dev/null
    sleep 0.3

    echo -e "  ${DIM}• Removing old output files...${RESET}"
    rm -f /tmp/all-targets.txt /tmp/default-target.txt /tmp/active-targets.txt 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: all available targets listed to a file
    if [[ -f /tmp/all-targets.txt ]] && grep -qE '\.target' /tmp/all-targets.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: default target recorded - checked against the known value
    # prepare_lab set (not a live re-run, since Task 3 changes the live
    # default afterwards)
    if [[ -f /tmp/default-target.txt ]] && grep -qx "graphical.target" /tmp/default-target.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: default target actually changed to rescue.target
    local current_target=$(systemctl get-default 2>/dev/null)
    if [[ "$current_target" == "rescue.target" ]]; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: active targets listed to a file
    if [[ -f /tmp/active-targets.txt ]] && grep -qE '\.target' /tmp/active-targets.txt 2>/dev/null; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Restoring original default target...${RESET}"
    if [[ -f /tmp/.lab_systemd_targets_mgmt_original ]]; then
        local original=$(cat /tmp/.lab_systemd_targets_mgmt_original)
        systemctl set-default "$original" 2>/dev/null
        rm -f /tmp/.lab_systemd_targets_mgmt_original
    fi

    echo -e "  ${DIM}• Removing lab output files...${RESET}"
    rm -f /tmp/all-targets.txt /tmp/default-target.txt /tmp/active-targets.txt 2>/dev/null

    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
