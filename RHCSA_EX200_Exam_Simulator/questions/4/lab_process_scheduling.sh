#!/bin/bash
# Objective 4: Operate running systems
# LAB: Adjust Process Scheduling (nice, renice)
# Host-machine terminal only (no container) - the single default terminal
# every lab starts with.
# NOTE: Task 2's PID/NI/COMM check only verifies structure (right PID, right
# command name, right ps -o columns) - not the live NI value, since Task 4
# renices that same process afterwards, so a live-value check would fail if
# done in the intended order. Task 4 checks the NI value live instead, since
# that's the final state and nothing changes it back afterwards.
# NOTE: Task 5 uses the chrony user (chronyd) since it is guaranteed
# installed and running by default on RHEL/CentOS/Rocky - same reasoning as
# lab_process_monitoring.sh's Task 4.
# NOTE: task background processes use distinct sleep durations (600, 1234,
# and 99999 for the Task 2/4 target) purely as unique signatures so
# check_tasks can tell them apart with pgrep -f - the durations themselves
# don't matter.

IS_LAB=true
LAB_ID="process_scheduling"

QUESTION="Adjust process scheduling priority with nice and renice"

# Lab configuration
LAB_TASK_COUNT=6

STATE_FILE="/tmp/.rhcsa_lab_nice_target_pid"

# Reuse the PID already chosen for this run (state file) if prepare_lab has
# already run, otherwise show a placeholder until it has.
_load_target_pid() {
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        echo "<pid>"
    fi
}
TARGET_PID=$(_load_target_pid)

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Start a long-running command in the background with a lower priority (nice value 10). This is often used for backups or other heavy tasks so they do not slow down the rest of the system"
TASK_1_HINT="Use nice -n with the value, then the command, then & to run it in the background"
TASK_1_COMMAND_1="nice -n 10 sleep 600 &"

# Task 2
TASK_2_QUESTION="Show the PID, niceness, and command name of the process with PID ${TARGET_PID}. Save the output to /tmp/nice_ps_output.txt"
TASK_2_HINT="Use ps -o pid,ni,comm with -p and the PID"
TASK_2_COMMAND_1="ps -o pid,ni,comm -p ${TARGET_PID} > /tmp/nice_ps_output.txt"

# Task 3
TASK_3_QUESTION="Show the default nice value. Save the output to /tmp/nice_default.txt"
TASK_3_HINT="Run nice with no other arguments"
TASK_3_COMMAND_1="nice > /tmp/nice_default.txt"

# Task 4
TASK_4_QUESTION="Change the niceness of the process with PID ${TARGET_PID} to 15"
TASK_4_HINT="Use renice -n with the new value and -p with the PID"
TASK_4_COMMAND_1="renice -n 15 -p ${TARGET_PID}"

# Task 5
TASK_5_QUESTION="Change the niceness of every process owned by the user chrony to 10"
TASK_5_HINT="Use renice with the new value and -u with the username"
TASK_5_COMMAND_1="renice 10 -u chrony"

# Task 6
TASK_6_QUESTION="Start a background process with a very low priority (nice value 19)"
TASK_6_HINT="Use nice -n with a high value for low priority, then the command, then & to run it in the background"
TASK_6_COMMAND_1="nice -n 19 sleep 1234 &"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Making sure chrony is running (needed for Task 5)...${RESET}"
    systemctl start chronyd 2>/dev/null || true

    echo -e "  ${DIM}• Removing old output files and test processes...${RESET}"
    rm -f /tmp/nice_ps_output.txt /tmp/nice_default.txt
    pkill -f 'sleep 600' 2>/dev/null
    pkill -f 'sleep 1234' 2>/dev/null
    if [[ -f "$STATE_FILE" ]]; then
        kill "$(cat "$STATE_FILE")" 2>/dev/null
    fi
    sleep 0.3

    echo -e "  ${DIM}• Starting a target process for Task 2 and Task 4...${RESET}"
    sleep 99999 &
    local target_pid=$!
    echo "$target_pid" > "$STATE_FILE"
    TARGET_PID="$target_pid"
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    TARGET_PID=$(_load_target_pid)

    # Task 0: a background process with nice value 10 is running
    local pid600
    pid600=$(pgrep -f 'sleep 600' | head -1)
    if [[ -n "$pid600" ]] && [[ "$(ps -o ni= -p "$pid600" 2>/dev/null | tr -d ' ')" == "10" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: ps -o pid,ni,comm captured for the right PID - structure only,
    # not the live NI value (Task 3 changes it afterwards - see header NOTE)
    if [[ -f /tmp/nice_ps_output.txt ]] && grep -q "$TARGET_PID" /tmp/nice_ps_output.txt \
        && grep -q 'sleep' /tmp/nice_ps_output.txt \
        && head -1 /tmp/nice_ps_output.txt | grep -q 'NI'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: default nice value recorded (always 0 for a fresh shell)
    if [[ -f /tmp/nice_default.txt ]] && [[ "$(tr -d '[:space:]' < /tmp/nice_default.txt)" == "0" ]]; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: the target process was reniced to 15 (checked live - final state)
    if [[ -n "$TARGET_PID" ]] && [[ "$TARGET_PID" != "<pid>" ]] \
        && [[ "$(ps -o ni= -p "$TARGET_PID" 2>/dev/null | tr -d ' ')" == "15" ]]; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi

    # Task 4: every currently running chrony process has nice value 10
    local chrony_pids
    chrony_pids=$(pgrep -u chrony 2>/dev/null)
    if [[ -n "$chrony_pids" ]]; then
        local all_ok="true"
        while IFS= read -r pid; do
            [[ -z "$pid" ]] && continue
            local ni
            ni=$(ps -o ni= -p "$pid" 2>/dev/null | tr -d ' ')
            if [[ "$ni" != "10" ]]; then
                all_ok="false"
                break
            fi
        done <<< "$chrony_pids"
        TASK_STATUS[4]="$all_ok"
    else
        TASK_STATUS[4]="false"
    fi

    # Task 5: a background process with nice value 19 is running
    local pid1234
    pid1234=$(pgrep -f 'sleep 1234' | head -1)
    if [[ -n "$pid1234" ]] && [[ "$(ps -o ni= -p "$pid1234" 2>/dev/null | tr -d ' ')" == "19" ]]; then
        TASK_STATUS[5]="true"
    else
        TASK_STATUS[5]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    if [[ -f "$STATE_FILE" ]]; then
        kill "$(cat "$STATE_FILE")" 2>/dev/null
        rm -f "$STATE_FILE"
    fi
    pkill -f 'sleep 600' 2>/dev/null
    pkill -f 'sleep 1234' 2>/dev/null
    rm -f /tmp/nice_ps_output.txt /tmp/nice_default.txt
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
