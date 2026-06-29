#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Generate a passwd report with awk
IS_LAB=true
LAB_ID="script_awk_passwd_report"
QUESTION="Create a script that uses awk to report normal users"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/passwd-report.sh"
TASK_1_HINT="Use awk -F: and select UID >= 1000"
TASK_1_COMMAND_1="cat > /root/scripts/passwd-report.sh <<'EOF'
#!/usr/bin/bash
mkdir -p /root/reports
awk -F: '$3 >= 1000 {print $1, $3, $7}' /etc/passwd | sort > /root/reports/passwd-report.txt
EOF"
TASK_2_QUESTION="Make executable and run it"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/passwd-report.sh && /root/scripts/passwd-report.sh"
TASK_3_QUESTION="Verify /root/reports/passwd-report.txt exists and contains the test user"
TASK_3_HINT="Use grep rhcsa_report"
TASK_3_COMMAND_1="grep rhcsa_report /root/reports/passwd-report.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /root/reports; userdel -r rhcsa_report 2>/dev/null || true; useradd -m -s /bin/bash rhcsa_report; rm -f /root/scripts/passwd-report.sh /root/reports/passwd-report.txt; }
check_tasks(){
 [[ -f /root/scripts/passwd-report.sh ]] && grep -q 'awk' /root/scripts/passwd-report.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/passwd-report.sh ]] && /root/scripts/passwd-report.sh >/dev/null 2>&1 && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -f /root/reports/passwd-report.txt ]] && grep -q 'rhcsa_report' /root/reports/passwd-report.txt && grep -q '/bin/bash' /root/reports/passwd-report.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ userdel -r rhcsa_report 2>/dev/null || true; rm -f /root/scripts/passwd-report.sh /root/reports/passwd-report.txt; }
