#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Script to Create a User and Group
# NOTE: this lab creates a real system user/group; prepare_lab/cleanup_lab
# remove them so the practice environment is left clean afterward.

IS_LAB=true
LAB_ID="script_create_user_group"

QUESTION="Write a script that creates a user, a group, and sets the user's password."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/create_user.sh that creates a group named examgroup, creates a user named examuser with home directory /home/examuser and examgroup as a secondary group, and sets examuser's password to P@ssw0rd123. Then run the script"
TASK_1_HINT="groupadd creates the group; useradd -m -d /home/examuser -G examgroup examuser creates the user"
TASK_1_COMMAND_1="cat > /root/create_user.sh << 'SCRIPT_END'
#!/bin/bash
groupadd examgroup
useradd -m -d /home/examuser -G examgroup examuser
echo P@ssw0rd123 | passwd --stdin examuser
echo User and group created.
SCRIPT_END
chmod +x /root/create_user.sh && /root/create_user.sh"

# Task 2
TASK_2_QUESTION="Confirm examuser exists with home directory /home/examuser and is a member of examgroup"
TASK_2_HINT="Check with id examuser"
TASK_2_COMMAND_1="id examuser"

# Task 3
TASK_3_QUESTION="Confirm examuser's password is set to P@ssw0rd123"
TASK_3_HINT="passwd --stdin reads the new password directly from standard input"
TASK_3_COMMAND_1="getent shadow examuser"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    userdel -r examuser 2>/dev/null
    groupdel examgroup 2>/dev/null
    rm -f /root/create_user.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: examgroup exists
    if getent group examgroup &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: examuser exists, with the right home directory and secondary group
    if id examuser &>/dev/null \
        && [[ "$(getent passwd examuser | cut -d: -f6)" == "/home/examuser" ]] \
        && id -nG examuser 2>/dev/null | grep -qw examgroup; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: password matches P@ssw0rd123 (recompute the hash using its own salt)
    local shadow_hash
    shadow_hash=$(getent shadow examuser 2>/dev/null | cut -d: -f2)
    local salt
    salt=$(echo "$shadow_hash" | cut -d'$' -f3)
    local computed_hash
    computed_hash=$(openssl passwd -6 -salt "$salt" 'P@ssw0rd123' 2>/dev/null)
    if [[ -n "$shadow_hash" ]] && [[ "$shadow_hash" == "$computed_hash" ]]; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r examuser 2>/dev/null
    groupdel examgroup 2>/dev/null
    rm -f /root/create_user.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
