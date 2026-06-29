#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Use positional parameters
IS_LAB=true
LAB_ID="script_positional_parameters"
QUESTION="Create a script that validates two positional parameters"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/touch-in-dir.sh that requires DIRECTORY and FILENAME arguments"
TASK_1_HINT="Use $1 and $2"
TASK_1_COMMAND_1="cat > /root/scripts/touch-in-dir.sh <<'EOF'
#!/usr/bin/bash
DIR=$1
FILE=$2
if [[ -z \"$DIR\" || -z \"$FILE\" ]]; then
  echo 'Usage: touch-in-dir.sh DIRECTORY FILENAME' >&2
  exit 2
fi
[[ -d \"$DIR\" ]] || exit 1
touch \"$DIR/$FILE\"
EOF"
TASK_2_QUESTION="Make the script executable"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/touch-in-dir.sh"
TASK_3_QUESTION="Run the script to create /tmp/exam/parameter-test.txt"
TASK_3_HINT="/root/scripts/touch-in-dir.sh /tmp/exam parameter-test.txt"
TASK_3_COMMAND_1="/root/scripts/touch-in-dir.sh /tmp/exam parameter-test.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /tmp/exam; rm -f /root/scripts/touch-in-dir.sh /tmp/exam/parameter-test.txt; }
check_tasks(){
 [[ -f /root/scripts/touch-in-dir.sh ]] && grep -q '\$1' /root/scripts/touch-in-dir.sh && grep -q '\$2' /root/scripts/touch-in-dir.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/touch-in-dir.sh ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 /root/scripts/touch-in-dir.sh /tmp/exam parameter-test.txt >/dev/null 2>&1; [[ -f /tmp/exam/parameter-test.txt ]] && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/touch-in-dir.sh /tmp/exam/parameter-test.txt; rmdir /tmp/exam 2>/dev/null || true; }
