#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Conditional Backup with Date (test, cp, date)
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal
# $(date +%Y-%m-%d) command substitution, which the CLI's bash-based parser
# will execute immediately while sourcing (a framework limitation - see
# repo memory), embedding whatever date is current at load time into the
# displayed hint instead of the live command. This does NOT affect grading
# (check_tasks is real bash, not a parsed string) or the web UI, which
# shows/sends it correctly. CLI users may see a slightly different hint
# text for this task.
# NOTE: /etc/passwd always exists on a working system, so the "missing
# file" branch cannot safely be tested by removing the real file. Task 2 is
# graded by running a copy of the script with the source path substituted
# to a guaranteed-nonexistent path; the real /etc/passwd is never touched.

IS_LAB=true
LAB_ID="script_backup_passwd_date"

QUESTION="Write a script that backs up /etc/passwd to a dated file, or prints an error if it is missing."

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/backup_passwd.sh. Test whether /etc/passwd exists; if it does, copy it to /tmp/passwd followed by a dot and today's date in YYYY-MM-DD format, for example /tmp/passwd.2026-10-18. If /etc/passwd does not exist, print an error message instead of copying anything"
TASK_1_HINT="Use a file test such as -e or -f to check /etc/passwd first; build the destination name by joining /tmp/passwd. with the output of the date command; cp should only run in the branch where the test succeeds"
TASK_1_COMMAND_1="cat > /root/backup_passwd.sh << 'SCRIPT_END'
#!/bin/bash
if [ -e /etc/passwd ]
then
    cp /etc/passwd /tmp/passwd.$(date +%Y-%m-%d)
else
    echo Error: /etc/passwd does not exist
fi
SCRIPT_END
chmod +x /root/backup_passwd.sh"

# Task 2
TASK_2_QUESTION="Confirm the script reports an error instead of copying anything when the file it checks for is missing. Since /etc/passwd always exists on a working system, review the else branch (or equivalent) in your script to confirm it only prints a message and never calls cp"
TASK_2_HINT="The branch that runs when the test fails must not call cp at all; it should only print an error message"
TASK_2_COMMAND_1="cat /root/backup_passwd.sh"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/backup_passwd.sh
    rm -f /tmp/passwd.*
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/backup_passwd.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    local today
    today=$(date +%Y-%m-%d)
    local backup_file="/tmp/passwd.$today"

    # Task 0: /etc/passwd really exists, so a real, exact backup should appear
    rm -f "$backup_file"
    "$script" &>/dev/null
    if [[ -f "$backup_file" ]] && diff -q "$backup_file" /etc/passwd &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    rm -f "$backup_file"

    # Task 1: error handling, tested against a copy of the script pointed at
    # a path that is guaranteed not to exist (never touches the real /etc/passwd)
    local tmp_script="/tmp/.rhcsa_backup_passwd_copy.sh"
    sed 's#/etc/passwd#/tmp/rhcsa_missing_source_file#g' "$script" > "$tmp_script"
    chmod +x "$tmp_script"
    rm -f "$backup_file"
    local out
    out=$("$tmp_script" 2>&1)
    if [[ -n "$out" ]] && [[ ! -f "$backup_file" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
    rm -f "$tmp_script" "$backup_file"
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/backup_passwd.sh
    rm -f /tmp/passwd.*
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
