#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Parse a security log file
IS_LAB=true
LAB_ID="script_security_log_report"
QUESTION="Create a script that counts failed login events in a log file"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Use /tmp/exam/secure.log"
TASK_1_HINT="prepare_lab creates a small log sample"
TASK_1_COMMAND_1="cat /tmp/exam/secure.log"
TASK_2_QUESTION="Create /root/scripts/failed-login-count.sh that writes FAILED_LOGINS=N"
TASK_2_HINT="Use grep -c or awk"
TASK_2_COMMAND_1="cat > /root/scripts/failed-login-count.sh <<'EOF'
#!/usr/bin/bash
mkdir -p /root/reports
COUNT=$(grep -c 'Failed password' /tmp/exam/secure.log)
echo FAILED_LOGINS=$COUNT > /root/reports/failed-logins.txt
EOF
chmod +x /root/scripts/failed-login-count.sh"
TASK_3_QUESTION="Run the script and verify FAILED_LOGINS=2"
TASK_3_HINT="cat /root/reports/failed-logins.txt"
TASK_3_COMMAND_1="/root/scripts/failed-login-count.sh && cat /root/reports/failed-logins.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /root/reports /tmp/exam; cat >/tmp/exam/secure.log <<'EOF'
Accepted publickey for root
Failed password for invalid user test
Failed password for root
session opened for user root
EOF
rm -f /root/scripts/failed-login-count.sh /root/reports/failed-logins.txt; }
check_tasks(){
 [[ -f /tmp/exam/secure.log ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/failed-login-count.sh ]] && grep -Eq 'grep|awk' /root/scripts/failed-login-count.sh && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 /root/scripts/failed-login-count.sh >/dev/null 2>&1; grep -qx 'FAILED_LOGINS=2' /root/reports/failed-logins.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/failed-login-count.sh /root/reports/failed-logins.txt /tmp/exam/secure.log; rmdir /tmp/exam 2>/dev/null || true; }
