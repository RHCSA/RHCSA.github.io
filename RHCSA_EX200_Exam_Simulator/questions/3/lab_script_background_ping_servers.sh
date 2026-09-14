#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Background Jobs (for, ping, &)
# NOTE: this lab launches real ping processes in the background to verify
# concurrency; check_tasks always terminates them afterward, regardless of
# outcome, so no ping processes are left running.
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal $ip, which
# the CLI's bash-based parser will expand while sourcing (a framework
# limitation - see repo memory). This does NOT affect grading (check_tasks
# is real bash, not a parsed string) or the web UI, which shows/sends it
# correctly. CLI users may see a slightly different hint text for this task.

IS_LAB=true
LAB_ID="script_background_ping_servers"

QUESTION="Write a script that uses a for loop to ping three different servers at the same time in the background."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/ping_servers.sh. Use a for loop over the three addresses 8.8.8.8, 8.8.4.4, and 1.1.1.1, and inside the loop send a ping of 5 packets to each address to the background with the ampersand operator, so all three run at the same time instead of one after another"
TASK_1_HINT="Use a for loop that steps through the three addresses one at a time; inside the loop body, ping each one 5 times and follow the command with an ampersand to send it to the background. Adding wait after the loop pauses the script until all three finish"
TASK_1_COMMAND_1="cat > /root/ping_servers.sh << 'SCRIPT_END'
#!/bin/bash
for ip in 8.8.8.8 8.8.4.4 1.1.1.1
do
    ping -c 5 $ip &
done
wait
SCRIPT_END
chmod +x /root/ping_servers.sh"

# Task 2
TASK_2_QUESTION="Run the script: all three pings should start together and run at the same time, instead of one finishing before the next begins"
TASK_2_HINT="While the script is running, check the process list in another terminal; all three ping processes should be visible running together, not one at a time"
TASK_2_COMMAND_1="/root/ping_servers.sh"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/ping_servers.sh
    pkill -f 'ping.*8\.8\.8\.8' 2>/dev/null
    pkill -f 'ping.*8\.8\.4\.4' 2>/dev/null
    pkill -f 'ping.*1\.1\.1\.1' 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/ping_servers.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    # Task 0: the script references all three required addresses
    if grep -q '8\.8\.8\.8' "$script" \
        && grep -q '8\.8\.4\.4' "$script" \
        && grep -q '1\.1\.1\.1' "$script"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: running it launches all three pings at the same time, in the background
    "$script" &>/dev/null &
    local script_pid=$!
    sleep 1
    local n1 n2 n3
    n1=$(pgrep -c -f 'ping.*8\.8\.8\.8')
    n2=$(pgrep -c -f 'ping.*8\.8\.4\.4')
    n3=$(pgrep -c -f 'ping.*1\.1\.1\.1')
    if [[ "$n1" -ge 1 && "$n2" -ge 1 && "$n3" -ge 1 ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    kill "$script_pid" 2>/dev/null
    pkill -f 'ping.*8\.8\.8\.8' 2>/dev/null
    pkill -f 'ping.*8\.8\.4\.4' 2>/dev/null
    pkill -f 'ping.*1\.1\.1\.1' 2>/dev/null
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    pkill -f 'ping.*8\.8\.8\.8' 2>/dev/null
    pkill -f 'ping.*8\.8\.4\.4' 2>/dev/null
    pkill -f 'ping.*1\.1\.1\.1' 2>/dev/null
    rm -f /root/ping_servers.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
