#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Redirect script output to a report file
IS_LAB=true
LAB_ID="script_output_redirection"
QUESTION="Create a script that writes system identity data to a report"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/identity-report.sh"
TASK_1_HINT="Use hostnamectl or hostname and whoami"
TASK_1_COMMAND_1="cat > /root/scripts/identity-report.sh <<'EOF'
#!/usr/bin/bash
mkdir -p /root/reports
{ hostname; whoami; id -u; } > /root/reports/identity.txt
EOF"
TASK_2_QUESTION="Make the script executable and run it"
TASK_2_HINT="chmod +x and execute the script"
TASK_2_COMMAND_1="chmod +x /root/scripts/identity-report.sh && /root/scripts/identity-report.sh"
TASK_3_QUESTION="Ensure /root/reports/identity.txt contains hostname, username and UID"
TASK_3_HINT="Use output redirection inside the script"
TASK_3_COMMAND_1="cat /root/reports/identity.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /root/reports; rm -f /root/scripts/identity-report.sh /root/reports/identity.txt; }
check_tasks(){
 [[ -f /root/scripts/identity-report.sh ]] && grep -q '/root/reports/identity.txt' /root/scripts/identity-report.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/identity-report.sh ]] && /root/scripts/identity-report.sh >/dev/null 2>&1 && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /root/reports/identity.txt ]] && grep -q "$(hostname)" /root/reports/identity.txt && grep -q "$(id -u)" /root/reports/identity.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/identity-report.sh /root/reports/identity.txt; }
