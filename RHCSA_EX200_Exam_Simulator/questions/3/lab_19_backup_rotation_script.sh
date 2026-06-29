#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Create a backup script with simple rotation
IS_LAB=true
LAB_ID="script_backup_rotation"
QUESTION="Create a script that backs up a directory and keeps only the latest three archives"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/backup-examdir.sh"
TASK_1_HINT="Use tar and ls -1t | tail -n +4 | xargs -r rm"
TASK_1_COMMAND_1="cat > /root/scripts/backup-examdir.sh <<'EOF'
#!/usr/bin/bash
SRC=/tmp/exam/source
DEST=/root/backups/examdir
mkdir -p $DEST
tar -C /tmp/exam -czf $DEST/source-$(date +%Y%m%d%H%M%S).tar.gz source
ls -1t $DEST/source-*.tar.gz 2>/dev/null | tail -n +4 | xargs -r rm -f
EOF"
TASK_2_QUESTION="Make executable and run it"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/backup-examdir.sh && /root/scripts/backup-examdir.sh"
TASK_3_QUESTION="Verify a valid tar.gz archive exists"
TASK_3_HINT="tar -tzf"
TASK_3_COMMAND_1="tar -tzf /root/backups/examdir/source-*.tar.gz"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /root/backups/examdir /tmp/exam/source; echo data >/tmp/exam/source/file.txt; rm -f /root/scripts/backup-examdir.sh /root/backups/examdir/source-*.tar.gz; }
check_tasks(){
 [[ -f /root/scripts/backup-examdir.sh ]] && grep -q 'tar ' /root/scripts/backup-examdir.sh && grep -q 'tail -n +4' /root/scripts/backup-examdir.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/backup-examdir.sh ]] && /root/scripts/backup-examdir.sh >/dev/null 2>&1 && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 f=$(ls -1 /root/backups/examdir/source-*.tar.gz 2>/dev/null | head -1); [[ -n "$f" ]] && tar -tzf "$f" 2>/dev/null | grep -q 'source/file.txt' && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/backup-examdir.sh /root/backups/examdir/source-*.tar.gz; rm -rf /tmp/exam/source; rmdir /tmp/exam 2>/dev/null || true; }
