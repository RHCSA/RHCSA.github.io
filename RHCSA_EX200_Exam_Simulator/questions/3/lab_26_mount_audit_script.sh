#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Create a mount audit report
IS_LAB=true
LAB_ID="script_mount_audit"
QUESTION="Create a script that reports current mounts and fstab entries"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/mount-audit.sh"
TASK_1_HINT="Use findmnt and /etc/fstab"
TASK_1_COMMAND_1="cat > /root/scripts/mount-audit.sh <<'EOF'
#!/usr/bin/bash
mkdir -p /root/reports
{
  echo 'ACTIVE_MOUNTS'
  findmnt -rn -o TARGET,SOURCE,FSTYPE
  echo 'FSTAB_ENTRIES'
  grep -Ev '^[[:space:]]*(#|$)' /etc/fstab
} > /root/reports/mount-audit.txt
EOF"
TASK_2_QUESTION="Make executable and run it"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/mount-audit.sh && /root/scripts/mount-audit.sh"
TASK_3_QUESTION="Verify the report contains ACTIVE_MOUNTS and FSTAB_ENTRIES"
TASK_3_HINT="Use grep"
TASK_3_COMMAND_1="grep ACTIVE_MOUNTS /root/reports/mount-audit.txt; grep FSTAB_ENTRIES /root/reports/mount-audit.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /root/reports; rm -f /root/scripts/mount-audit.sh /root/reports/mount-audit.txt; }
check_tasks(){
 [[ -f /root/scripts/mount-audit.sh ]] && grep -q 'findmnt' /root/scripts/mount-audit.sh && grep -q '/etc/fstab' /root/scripts/mount-audit.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/mount-audit.sh ]] && /root/scripts/mount-audit.sh >/dev/null 2>&1 && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 grep -q ACTIVE_MOUNTS /root/reports/mount-audit.txt && grep -q FSTAB_ENTRIES /root/reports/mount-audit.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/mount-audit.sh /root/reports/mount-audit.txt; }
