#!/bin/bash
# Objective 4: Operate running systems
# LAB: Monitor Processes (ps, pgrep, sort by CPU/memory)
# Host-machine terminal only (no container) - the single default terminal
# every lab starts with.
# NOTE: Task 4 uses chrony (chronyd), since it ships and runs by default on
# RHEL/CentOS/Rocky - no package install or service start needed.

IS_LAB=true
LAB_ID="process_monitoring"

QUESTION="Monitor processes with ps and pgrep"
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

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
TASK_4_QUESTION="List all processes owned by the user chrony. Save the output to /tmp/chrony_procs.txt"
TASK_4_HINT="Use ps -u chrony, or pgrep -u chrony"
TASK_4_COMMAND_1="ps -u chrony > /tmp/chrony_procs.txt"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing old output files...${RESET}"
    rm -f /tmp/top_cpu.txt /tmp/top_mem.txt /tmp/sshd_pid.txt /tmp/chrony_procs.txt 2>/dev/null
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

    # Task 3: chrony processes - accepts either "ps -u chrony" or
    # "pgrep -u chrony" output, matched against currently live chrony PIDs
    local chrony_pids=$(pgrep -u chrony 2>/dev/null)
    if [[ -f /tmp/chrony_procs.txt ]] && [[ -n "$chrony_pids" ]]; then
        local matched="false"
        while IFS= read -r pid; do
            if [[ -n "$pid" ]] && grep -qw "$pid" /tmp/chrony_procs.txt 2>/dev/null; then
                matched="true"
                break
            fi
        done <<< "$chrony_pids"
        TASK_STATUS[3]="$matched"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/top_cpu.txt /tmp/top_mem.txt /tmp/sshd_pid.txt /tmp/chrony_procs.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
