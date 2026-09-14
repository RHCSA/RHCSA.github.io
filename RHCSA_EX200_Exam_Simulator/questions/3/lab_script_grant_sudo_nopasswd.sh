#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Grant Passwordless Sudo Access (sudoers.d)
# NOTE: this lab creates a real system user (Sam); prepare_lab/cleanup_lab
# remove Sam and the sudoers.d rule so the practice environment stays clean.

IS_LAB=true
LAB_ID="script_grant_sudo_nopasswd"

QUESTION="Write a script that grants user Sam full, passwordless sudo access."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/grant_sudo_sam.sh. Have it append a rule granting user Sam full sudo privileges with no password prompt to a new file inside /etc/sudoers.d/, then run the script"
TASK_1_HINT="Append a line such as Sam ALL=(ALL) NOPASSWD:ALL to /etc/sudoers.d/Sam; quote the whole line with single or double quotes so the parentheses are not interpreted by the shell"
TASK_1_COMMAND_1="cat > /root/grant_sudo_sam.sh << 'SCRIPT_END'
#!/bin/bash
echo 'Sam ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/Sam
SCRIPT_END
chmod +x /root/grant_sudo_sam.sh && /root/grant_sudo_sam.sh"

# Task 2
TASK_2_QUESTION="Confirm Sam can run sudo commands without being prompted for a password"
TASK_2_HINT="Switch to Sam and attempt a non-interactive sudo command; it should succeed immediately with no password prompt"
TASK_2_COMMAND_1="sudo -u Sam sudo -n true"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/grant_sudo_sam.sh
    rm -f /etc/sudoers.d/Sam
    userdel -r Sam 2>/dev/null
    useradd Sam
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: /etc/sudoers.d/Sam contains the exact NOPASSWD rule for Sam
    if [[ -f /etc/sudoers.d/Sam ]] && grep -qx 'Sam ALL=(ALL) NOPASSWD:ALL' /etc/sudoers.d/Sam; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: Sam can actually run sudo commands with no password prompt
    if sudo -u Sam sudo -n true 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /etc/sudoers.d/Sam
    userdel -r Sam 2>/dev/null
    rm -f /root/grant_sudo_sam.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
