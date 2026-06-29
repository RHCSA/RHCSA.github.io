#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Validate script input
IS_LAB=true
LAB_ID="script_input_validation"
QUESTION="Create a script that validates usernames before creating accounts"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/safe-useradd.sh"
TASK_1_HINT="Reject empty input and names with characters outside a-z, 0-9, underscore"
TASK_1_COMMAND_1="cat > /root/scripts/safe-useradd.sh <<'EOF'
#!/usr/bin/bash
USER=$1
if [[ -z \"$USER\" || ! \"$USER\" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo INVALID >&2
  exit 2
fi
id \"$USER\" &>/dev/null || useradd -m \"$USER\"
EOF"
TASK_2_QUESTION="Make the script executable"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/safe-useradd.sh"
TASK_3_QUESTION="Create user rhcsa_safe1 and reject Bad-Name"
TASK_3_HINT="Check exit codes"
TASK_3_COMMAND_1="/root/scripts/safe-useradd.sh rhcsa_safe1; /root/scripts/safe-useradd.sh Bad-Name"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts; userdel -r rhcsa_safe1 2>/dev/null || true; rm -f /root/scripts/safe-useradd.sh; }
check_tasks(){
 [[ -f /root/scripts/safe-useradd.sh ]] && grep -q '\[\[' /root/scripts/safe-useradd.sh && grep -q 'exit 2' /root/scripts/safe-useradd.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/safe-useradd.sh ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 /root/scripts/safe-useradd.sh rhcsa_safe1 >/dev/null 2>&1; a=$?; /root/scripts/safe-useradd.sh Bad-Name >/dev/null 2>&1; b=$?; id rhcsa_safe1 &>/dev/null && [[ $a -eq 0 && $b -ne 0 ]] && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ userdel -r rhcsa_safe1 2>/dev/null || true; rm -f /root/scripts/safe-useradd.sh; }
