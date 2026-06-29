#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Create a permissions audit script
IS_LAB=true
LAB_ID="script_permissions_audit"
QUESTION="Create a script that reports world-writable files"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Use /tmp/exam/audit as scan directory"
TASK_1_HINT="prepare_lab creates one unsafe file"
TASK_1_COMMAND_1="find /tmp/exam/audit -type f -ls"
TASK_2_QUESTION="Create /root/scripts/world-writable-report.sh"
TASK_2_HINT="Use find -perm -0002"
TASK_2_COMMAND_1="cat > /root/scripts/world-writable-report.sh <<'EOF'
#!/usr/bin/bash
mkdir -p /root/reports
find /tmp/exam/audit -type f -perm -0002 -print | sort > /root/reports/world-writable.txt
EOF
chmod +x /root/scripts/world-writable-report.sh"
TASK_3_QUESTION="Run the script and verify only unsafe.txt appears"
TASK_3_HINT="safe.txt must not appear"
TASK_3_COMMAND_1="/root/scripts/world-writable-report.sh && cat /root/reports/world-writable.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /root/reports /tmp/exam/audit; touch /tmp/exam/audit/safe.txt /tmp/exam/audit/unsafe.txt; chmod 644 /tmp/exam/audit/safe.txt; chmod 666 /tmp/exam/audit/unsafe.txt; rm -f /root/scripts/world-writable-report.sh /root/reports/world-writable.txt; }
check_tasks(){
 [[ -f /tmp/exam/audit/unsafe.txt ]] && [[ $(stat -c %a /tmp/exam/audit/unsafe.txt) == 666 ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/world-writable-report.sh ]] && grep -q -- '-perm -0002' /root/scripts/world-writable-report.sh && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 /root/scripts/world-writable-report.sh >/dev/null 2>&1; grep -q 'unsafe.txt' /root/reports/world-writable.txt && ! grep -q 'safe.txt' /root/reports/world-writable.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/world-writable-report.sh /root/reports/world-writable.txt; rm -rf /tmp/exam/audit; rmdir /tmp/exam 2>/dev/null || true; }
