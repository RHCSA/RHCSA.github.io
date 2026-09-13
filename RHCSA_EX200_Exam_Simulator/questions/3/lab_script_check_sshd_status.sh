#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Check a Service's Enabled and Active State (systemctl)
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal $enabled/
# $active, which the CLI's bash-based parser will expand while sourcing (a
# framework limitation - see repo memory). This does NOT affect grading
# (check_tasks is real bash, not a parsed string) or the web UI, which
# shows/sends it correctly. CLI users may see a slightly different hint
# text for this task.
# NOTE: sshd is what provides remote access to this machine, so its real
# enabled/active state is only ever read here, never changed. The "not ok"
# path is graded by running a copy of the script with "sshd" substituted
# for a unit name that is guaranteed not to exist; the real sshd is
# untouched.

IS_LAB=true
LAB_ID="script_check_sshd_status"

QUESTION="Write a script that prints ok only if sshd is both enabled and active, or not ok otherwise."

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/check_sshd_status.sh. Store the result of checking whether the sshd service is enabled, and separately the result of checking whether it is active. Print ok only when both checks confirm it is enabled and active; otherwise print not ok"
TASK_1_HINT="systemctl is-enabled sshd reports whether the service is enabled; systemctl is-active sshd reports whether it is currently running. Capture both with command substitution, then compare each result before deciding what to print"
TASK_1_COMMAND_1="cat > /root/check_sshd_status.sh << 'SCRIPT_END'
#!/bin/bash
enabled=$(systemctl is-enabled sshd)
active=$(systemctl is-active sshd)
if [ $enabled = enabled ] && [ $active = active ]
then
    echo ok
else
    echo not ok
fi
SCRIPT_END
chmod +x /root/check_sshd_status.sh"

# Task 2
TASK_2_QUESTION="Run the script: since sshd is enabled and active on this machine, it should print ok"
TASK_2_HINT="Run the script directly; with sshd already enabled and running, the output should be exactly ok"
TASK_2_COMMAND_1="/root/check_sshd_status.sh"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/check_sshd_status.sh
    rm -f /tmp/.rhcsa_check_sshd_copy.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/check_sshd_status.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    # Task 0: not-ok path, tested against a copy of the script pointed at a
    # unit that is guaranteed not to exist (never touches the real sshd)
    local tmp_script="/tmp/.rhcsa_check_sshd_copy.sh"
    sed 's/sshd/rhcsa_missing_unit_xyz/g' "$script" > "$tmp_script"
    chmod +x "$tmp_script"
    local out1
    out1=$("$tmp_script" 2>/dev/null)
    rm -f "$tmp_script"
    if echo "$out1" | grep -qx "not ok"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: sshd is really enabled and active on this machine, so the
    # script should report ok (this only reads sshd's status, never changes it)
    local out2
    out2=$("$script" 2>/dev/null)
    if echo "$out2" | grep -qx "ok"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/check_sshd_status.sh
    rm -f /tmp/.rhcsa_check_sshd_copy.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
