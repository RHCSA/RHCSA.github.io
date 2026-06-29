#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Use variables in a backup script
IS_LAB=true
LAB_ID="script_variables_backup"
QUESTION="Create a backup script that uses variables and a date stamp"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/backup-motd.sh using variables SRC, DEST and STAMP"
TASK_1_HINT="Use STAMP=$(date +%Y%m%d) and tar"
TASK_1_COMMAND_1="cat > /root/scripts/backup-motd.sh <<'EOF'
#!/usr/bin/bash
SRC=/etc/motd
DEST=/root/backups
STAMP=$(date +%Y%m%d)
mkdir -p $DEST
tar -czf $DEST/motd-$STAMP.tar.gz $SRC
EOF"
TASK_2_QUESTION="Make the script executable and run it"
TASK_2_HINT="chmod +x /root/scripts/backup-motd.sh"
TASK_2_COMMAND_1="chmod +x /root/scripts/backup-motd.sh && /root/scripts/backup-motd.sh"
TASK_3_QUESTION="Verify a dated tar.gz file exists in /root/backups"
TASK_3_HINT="Use ls /root/backups/motd-*.tar.gz"
TASK_3_COMMAND_1="ls /root/backups/motd-*.tar.gz"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /root/backups; rm -f /root/scripts/backup-motd.sh /root/backups/motd-*.tar.gz; echo 'RHCSA practice' >/etc/motd; }
check_tasks(){
 [[ -f /root/scripts/backup-motd.sh ]] && grep -q 'SRC=' /root/scripts/backup-motd.sh && grep -q 'DEST=' /root/scripts/backup-motd.sh && grep -q 'STAMP=' /root/scripts/backup-motd.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/backup-motd.sh ]] && /root/scripts/backup-motd.sh >/dev/null 2>&1 && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 archive="/root/backups/motd-$(date +%Y%m%d).tar.gz"; [[ -f "$archive" ]] && tar -tzf "$archive" 2>/dev/null | grep -q 'etc/motd' && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/backup-motd.sh /root/backups/motd-*.tar.gz; }
