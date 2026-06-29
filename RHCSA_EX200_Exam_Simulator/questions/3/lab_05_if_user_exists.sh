#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Use if statements to test user existence
IS_LAB=true
LAB_ID="script_if_user_exists"
QUESTION="Create a script that reports whether a user exists"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create user rhcsa_present for testing"
TASK_1_HINT="prepare_lab already creates the user"
TASK_1_COMMAND_1="id rhcsa_present"
TASK_2_QUESTION="Create /root/scripts/check-user.sh that accepts a username and prints USER_EXISTS or USER_MISSING"
TASK_2_HINT="Use id USERNAME in an if statement"
TASK_2_COMMAND_1="cat > /root/scripts/check-user.sh <<'EOF'
#!/usr/bin/bash
if id \"$1\" &>/dev/null; then
  echo USER_EXISTS
else
  echo USER_MISSING
fi
EOF
chmod +x /root/scripts/check-user.sh"
TASK_3_QUESTION="Verify both existing and missing user paths"
TASK_3_HINT="Run the script with rhcsa_present and rhcsa_absent"
TASK_3_COMMAND_1="/root/scripts/check-user.sh rhcsa_present; /root/scripts/check-user.sh rhcsa_absent"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts; userdel -r rhcsa_present 2>/dev/null || true; useradd -m rhcsa_present; rm -f /root/scripts/check-user.sh; }
check_tasks(){
 id rhcsa_present &>/dev/null && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/check-user.sh ]] && grep -q 'if' /root/scripts/check-user.sh && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 out1=$(/root/scripts/check-user.sh rhcsa_present 2>/dev/null); out2=$(/root/scripts/check-user.sh rhcsa_absent 2>/dev/null); [[ "$out1" == "USER_EXISTS" && "$out2" == "USER_MISSING" ]] && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ userdel -r rhcsa_present 2>/dev/null || true; rm -f /root/scripts/check-user.sh; }
