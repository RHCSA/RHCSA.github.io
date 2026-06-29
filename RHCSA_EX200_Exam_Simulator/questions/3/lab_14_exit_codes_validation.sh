#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Use exit codes for validation
IS_LAB=true
LAB_ID="script_exit_codes_validation"
QUESTION="Create a script that returns useful exit codes"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/require-file.sh that accepts a path"
TASK_1_HINT="Use [[ -f $1 ]] and exit 0/1/2"
TASK_1_COMMAND_1="cat > /root/scripts/require-file.sh <<'EOF'
#!/usr/bin/bash
if [[ -z \"$1\" ]]; then
  echo 'Missing path' >&2
  exit 2
fi
if [[ -f \"$1\" ]]; then
  echo FOUND
  exit 0
else
  echo MISSING
  exit 1
fi
EOF"
TASK_2_QUESTION="Make the script executable"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/require-file.sh"
TASK_3_QUESTION="Verify it exits 0 for existing files and non-zero for missing files"
TASK_3_HINT="Use echo $?"
TASK_3_COMMAND_1="/root/scripts/require-file.sh /etc/passwd; echo $?"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts; rm -f /root/scripts/require-file.sh; }
check_tasks(){
 [[ -f /root/scripts/require-file.sh ]] && grep -q 'exit 0' /root/scripts/require-file.sh && grep -q 'exit 1' /root/scripts/require-file.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/require-file.sh ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 /root/scripts/require-file.sh /etc/passwd >/dev/null 2>&1; a=$?; /root/scripts/require-file.sh /no/such/file >/dev/null 2>&1; b=$?; [[ $a -eq 0 && $b -ne 0 ]] && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/require-file.sh; }
