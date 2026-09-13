#!/bin/bash
# Objective 4: Operate running systems
# LAB: Monitor Processes (ps, pgrep, sort by CPU/memory)
# Host-machine terminal only (no container) - the single default terminal
# every lab starts with.
# NOTE: Task 4 assumes postfix is installed, since it ships by default on
# RHEL/CentOS/Rocky. prepare_lab only starts it if already installed - it
# does not install the package, to avoid a slow/network-dependent lab start.

IS_LAB=true
LAB_ID="process_monitoring"

QUESTION="Monitor processes with ps and pgrep"

# Lab configuration
LAB_TASK_COUNT=4

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Display the top 10 processes sorted by CPU usage. Save the output to /tmp/top_cpu.txt"
TASK_1_HINT="Use ps aux with --sort=-%cpu, then head"
TASK_1_COMMAND_1="ps aux --sort=-%cpu | head -11 > /tmp/top_cpu.txt"

# Task 2
TASK_2_QUESTION="Display the top 10 processes sorted by memory usage. Save the output to /tmp/top_mem.txt"
TASK_2_HINT="Use ps aux with --sort=-%mem, then head"
TASK_2_COMMAND_1="ps aux --sort=-%mem | head -11 > /tmp/top_mem.txt"

# Task 3
TASK_3_QUESTION="Find the PID of the sshd process. Save the output to /tmp/sshd_pid.txt"
TASK_3_HINT="Use pgrep"
TASK_3_COMMAND_1="pgrep sshd > /tmp/sshd_pid.txt"

# Task 4
TASK_4_QUESTION="List all processes owned by the user postfix. Save the output to /tmp/postfix_procs.txt"
TASK_4_HINT="Use ps -u postfix, or pgrep -u postfix"
TASK_4_COMMAND_1="ps -u postfix > /tmp/postfix_procs.txt"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing old output files...${RESET}"
    rm -f /tmp/top_cpu.txt /tmp/top_mem.txt /tmp/sshd_pid.txt /tmp/postfix_procs.txt 2>/dev/null
    sleep 0.3

    echo -e "  ${DIM}• Making sure postfix is running (needed for Task 4)...${RESET}"
    systemctl start postfix 2>/dev/null || true
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: top 10 by CPU - 11 lines (header + 10), %CPU header present,
    # and the %CPU column (3rd) is actually sorted descending
    if [[ -f /tmp/top_cpu.txt ]] && [[ $(wc -l < /tmp/top_cpu.txt) -eq 11 ]] && \
       head -1 /tmp/top_cpu.txt | grep -q '%CPU' && \
       tail -n +2 /tmp/top_cpu.txt | awk '{v=$3+0; if (NR>1 && v>prev) bad=1; prev=v} END{exit bad?1:0}'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: top 10 by memory - same shape, %MEM column (4th) sorted descending
    if [[ -f /tmp/top_mem.txt ]] && [[ $(wc -l < /tmp/top_mem.txt) -eq 11 ]] && \
       head -1 /tmp/top_mem.txt | grep -q '%MEM' && \
       tail -n +2 /tmp/top_mem.txt | awk '{v=$4+0; if (NR>1 && v>prev) bad=1; prev=v} END{exit bad?1:0}'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: sshd PID - saved PID must be one of the currently live sshd PIDs
    if [[ -f /tmp/sshd_pid.txt ]]; then
        local saved_pid=$(grep -oE '[0-9]+' /tmp/sshd_pid.txt | head -1)
        local live_pids=$(pgrep sshd 2>/dev/null)
        if [[ -n "$saved_pid" ]] && echo "$live_pids" | grep -qx "$saved_pid"; then
            TASK_STATUS[2]="true"
        else
            TASK_STATUS[2]="false"
        fi
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: postfix processes - accepts either "ps -u postfix" or
    # "pgrep -u postfix" output, matched against currently live postfix PIDs
    local postfix_pids=$(pgrep -u postfix 2>/dev/null)
    if [[ -f /tmp/postfix_procs.txt ]] && [[ -n "$postfix_pids" ]]; then
        local matched="false"
        while IFS= read -r pid; do
            if [[ -n "$pid" ]] && grep -qw "$pid" /tmp/postfix_procs.txt 2>/dev/null; then
                matched="true"
                break
            fi
        done <<< "$postfix_pids"
        TASK_STATUS[3]="$matched"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/top_cpu.txt /tmp/top_mem.txt /tmp/sshd_pid.txt /tmp/postfix_procs.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
