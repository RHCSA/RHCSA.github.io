#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Comprehensive system audit script
IS_LAB=true
LAB_ID="script_comprehensive_audit"
QUESTION="Create a single audit script that reports users, services, mounts and disk usage"
LAB_TASK_COUNT=4
TASK_1_QUESTION="Create /root/scripts/rhcsa-audit.sh"
TASK_1_HINT="Use sections in a report file"
TASK_1_COMMAND_1="cat > /root/scripts/rhcsa-audit.sh <<'EOF'
#!/usr/bin/bash
OUT=/root/reports/rhcsa-audit.txt
mkdir -p /root/reports
{
 echo USERS
 awk -F: '$3>=1000 {print $1}' /etc/passwd
 echo SERVICES
 systemctl list-units --type=service --state=running --no-pager --no-legend | awk '{print $1}'
 echo MOUNTS
 findmnt -rn -o TARGET,SOURCE,FSTYPE
 echo DISK
 df -h /
} > $OUT
EOF"
TASK_2_QUESTION="Make the script executable"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/rhcsa-audit.sh"
TASK_3_QUESTION="Run the audit script"
TASK_3_HINT="Execute /root/scripts/rhcsa-audit.sh"
TASK_3_COMMAND_1="/root/scripts/rhcsa-audit.sh"
TASK_4_QUESTION="Verify /root/reports/rhcsa-audit.txt contains all required sections"
TASK_4_HINT="grep USERS SERVICES MOUNTS DISK"
TASK_4_COMMAND_1="grep USERS /root/reports/rhcsa-audit.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /root/reports; rm -f /root/scripts/rhcsa-audit.sh /root/reports/rhcsa-audit.txt; }
check_tasks(){
 [[ -f /root/scripts/rhcsa-audit.sh ]] && grep -q 'USERS' /root/scripts/rhcsa-audit.sh && grep -q 'SERVICES' /root/scripts/rhcsa-audit.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/rhcsa-audit.sh ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 /root/scripts/rhcsa-audit.sh >/dev/null 2>&1 && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
 for s in USERS SERVICES MOUNTS DISK; do grep -q "^$s$" /root/reports/rhcsa-audit.txt || exit 9; done >/dev/null 2>&1 && TASK_STATUS[3]="true" || TASK_STATUS[3]="false"
}
cleanup_lab(){ rm -f /root/scripts/rhcsa-audit.sh /root/reports/rhcsa-audit.txt; }
