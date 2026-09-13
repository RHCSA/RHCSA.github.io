#!/bin/bash
# Objective 4: Operate running systems
# LAB: Kill Processes (kill -9, pkill by user, pkill by name) - container-only terminal
# NOTE: same pattern as questions/2/lab_container_install_httpd.sh - prepare_lab
# redirects the single default terminal straight into the container via
# `tmux send-keys`, so no host shell is ever shown or reachable. Web UI only;
# harmless no-op on the CLI simulator - CLI users would need to run
# `docker exec -it rhcsa_lab_container_kill_process bash` themselves.
# NOTE: Task 1's PID is chosen fresh each time prepare_lab runs, so
# TASK_1_QUESTION/TASK_1_COMMAND_1 embed ${TEST_PID} - this needs its own
# copy of get_task_description()/get_task_commands()/_build_hint() (same
# approach as questions/5/lab_lvm_pv_vg_lv.sh) so the web UI's post-prepare
# re-resolve step can pick up the real PID instead of the literal
# placeholder text.

IS_LAB=true
LAB_ID="container_kill_process"

QUESTION="Kill processes inside a container: by PID, by owning user, and by name"

# Lab configuration
LAB_TASK_COUNT=3

STATE_FILE="/tmp/.rhcsa_lab_kill_process_pid"

# Reuse the PID already chosen for this run (state file) if prepare_lab has
# already run, otherwise show a placeholder until it has.
_load_test_pid() {
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        echo "<pid>"
    fi
}
TEST_PID=$(_load_test_pid)

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="This terminal is inside a Rocky Linux 10 container (a free RHEL 10 rebuild) running on this machine. A test process is already running inside it with PID ${TEST_PID}. Kill it using signal 9"
TASK_1_HINT="Use kill -9 with the PID"
TASK_1_COMMAND_1="kill -9 ${TEST_PID}"

# Task 2
TASK_2_QUESTION="Kill all processes owned by the user testuser"
TASK_2_HINT="Use pkill with -u to match by owning user"
TASK_2_COMMAND_1="pkill -u testuser"

# Task 3
TASK_3_QUESTION="Kill all processes named httpd"
TASK_3_HINT="Use pkill with the process name"
TASK_3_COMMAND_1="pkill httpd"

# =============================================================================
# TASK HELPER FUNCTIONS (local copies so the web UI's dynamic re-resolve step
# can read the real ${TEST_PID} after prepare_lab has run - see NOTE above)
# =============================================================================

get_task_description() {
    local task_idx=$1
    local task_num=$((task_idx + 1))
    local var_name="TASK_${task_num}_QUESTION"
    echo "${!var_name}"
}

get_task_commands() {
    local task_idx=$1
    local task_num=$((task_idx + 1))
    local result=""

    for i in 1 2 3 4 5; do
        local var_name="TASK_${task_num}_COMMAND_${i}"
        local cmd="${!var_name}"
        if [[ -n "$cmd" ]]; then
            if [[ -n "$result" ]]; then
                result+=$'\n'
            fi
            result+="$cmd"
        fi
    done
    echo "$result"
}

_build_hint() {
    local result=""
    for ((i=0; i<LAB_TASK_COUNT; i++)); do
        local task_num=$((i+1))
        local cmds=$(get_task_commands $i)
        if [[ -n "$cmds" ]]; then
            while IFS= read -r cmd; do
                if [[ -n "$cmd" ]]; then
                    if [[ -n "$result" ]]; then
                        result+=$'\n'
                    fi
                    result+="Task ${task_num}: ${cmd}"
                fi
            done <<< "$cmds"
        fi
    done
    echo "$result"
}

# Auto-generate HINT from commands
HINT=$(_build_hint)

CONTAINER_NAME="rhcsa_lab_container_kill_process"
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

    echo -e "  ${DIM}• Starting a test process for Task 1...${RESET}"
    local test_pid
    test_pid=$(docker exec "$CONTAINER_NAME" bash -c 'sleep 99999 & echo $!' 2>/dev/null)
    echo "$test_pid" > "$STATE_FILE"
    TEST_PID="$test_pid"

    echo -e "  ${DIM}• Creating testuser and a background process for it...${RESET}"
    docker exec "$CONTAINER_NAME" useradd testuser &>/dev/null
    docker exec -u testuser "$CONTAINER_NAME" bash -c 'sleep 99999 &>/dev/null &' &>/dev/null

    echo -e "  ${DIM}• Installing and starting httpd...${RESET}"
    docker exec "$CONTAINER_NAME" dnf install -y httpd &>/dev/null
    docker exec "$CONTAINER_NAME" httpd &>/dev/null

    # Web UI only: attach the single visible terminal straight into the
    # container so no host shell is ever shown for this lab
    tmux send-keys -t rhcsa-terminal:lab_main "clear; docker exec -it $CONTAINER_NAME bash" Enter 2>/dev/null
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    TEST_PID=$(_load_test_pid)

    # Task 0: the test process is gone
    if [[ -n "$TEST_PID" ]] && [[ "$TEST_PID" != "<pid>" ]] && \
       ! docker exec "$CONTAINER_NAME" kill -0 "$TEST_PID" &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: no processes left owned by testuser
    if ! docker exec "$CONTAINER_NAME" pgrep -u testuser &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: no httpd processes left (exact name match)
    if ! docker exec "$CONTAINER_NAME" pgrep -x httpd &>/dev/null; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Removing container...${RESET}"
    docker rm -f "$CONTAINER_NAME" &>/dev/null
    rm -f "$STATE_FILE" 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
