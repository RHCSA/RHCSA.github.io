#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Filter logs with grep
IS_LAB=true
LAB_ID="script_grep_log_errors"
QUESTION="Create a script that extracts ERROR and FAILED lines from a log file"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Use /tmp/exam/app.log as input"
TASK_1_HINT="prepare_lab creates the file"
TASK_1_COMMAND_1="cat /tmp/exam/app.log"
TASK_2_QUESTION="Create /root/scripts/error-report.sh using grep -E"
TASK_2_HINT="grep -E 'ERROR|FAILED'"
TASK_2_COMMAND_1="cat > /root/scripts/error-report.sh <<'EOF'
#!/usr/bin/bash
mkdir -p /root/reports
grep -E 'ERROR|FAILED' /tmp/exam/app.log > /root/reports/error-report.txt
EOF
chmod +x /root/scripts/error-report.sh"
TASK_3_QUESTION="Run the script and verify the report"
TASK_3_HINT="There should be two matching lines"
TASK_3_COMMAND_1="/root/scripts/error-report.sh && wc -l /root/reports/error-report.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /root/reports /tmp/exam; cat >/tmp/exam/app.log <<'EOF'
INFO startup complete
ERROR failed to open config
WARN retrying
FAILED service check
INFO finished
EOF
rm -f /root/scripts/error-report.sh /root/reports/error-report.txt; }
check_tasks(){
 [[ -f /tmp/exam/app.log ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/error-report.sh ]] && grep -q 'grep' /root/scripts/error-report.sh && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 /root/scripts/error-report.sh >/dev/null 2>&1; [[ $(wc -l < /root/reports/error-report.txt 2>/dev/null) -eq 2 ]] && grep -q ERROR /root/reports/error-report.txt && grep -q FAILED /root/reports/error-report.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/error-report.sh /root/reports/error-report.txt /tmp/exam/app.log; rmdir /tmp/exam 2>/dev/null || true; }
