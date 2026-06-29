#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Write normal messages to a log and errors to stderr
IS_LAB=true
LAB_ID="script_logging_stderr"
QUESTION="Create a script with simple logging and stderr error messages"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/log-check.sh"
TASK_1_HINT="Use echo >> /var/log/rhcsa-script.log and >&2"
TASK_1_COMMAND_1="cat > /root/scripts/log-check.sh <<'EOF'
#!/usr/bin/bash
LOG=/var/log/rhcsa-script.log
echo \"$(date +%F) check started\" >> $LOG
if [[ ! -f /tmp/exam/required.txt ]]; then
  echo 'ERROR: required file missing' >&2
  exit 1
fi
echo 'OK'
EOF"
TASK_2_QUESTION="Make the script executable"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/log-check.sh"
TASK_3_QUESTION="Run it and verify logging occurs"
TASK_3_HINT="Create /tmp/exam/required.txt first"
TASK_3_COMMAND_1="touch /tmp/exam/required.txt && /root/scripts/log-check.sh"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /tmp/exam; rm -f /root/scripts/log-check.sh /var/log/rhcsa-script.log /tmp/exam/required.txt; }
check_tasks(){
 [[ -f /root/scripts/log-check.sh ]] && grep -q '/var/log/rhcsa-script.log' /root/scripts/log-check.sh && grep -q '>&2' /root/scripts/log-check.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/log-check.sh ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 touch /tmp/exam/required.txt; /root/scripts/log-check.sh >/dev/null 2>/tmp/exam/err.txt; [[ -s /var/log/rhcsa-script.log ]] && [[ ! -s /tmp/exam/err.txt ]] && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/log-check.sh /var/log/rhcsa-script.log /tmp/exam/required.txt /tmp/exam/err.txt; rmdir /tmp/exam 2>/dev/null || true; }
