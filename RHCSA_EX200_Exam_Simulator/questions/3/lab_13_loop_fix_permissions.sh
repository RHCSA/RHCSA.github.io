#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Fix permissions in bulk
IS_LAB=true
LAB_ID="script_loop_fix_permissions"
QUESTION="Create a script that fixes permissions on multiple files"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Use /tmp/exam/secure/*.conf as input files"
TASK_1_HINT="prepare_lab creates insecure files"
TASK_1_COMMAND_1="ls -l /tmp/exam/secure/*.conf"
TASK_2_QUESTION="Create /root/scripts/fix-conf-perms.sh that sets all .conf files to 640"
TASK_2_HINT="Use for file in /tmp/exam/secure/*.conf"
TASK_2_COMMAND_1="cat > /root/scripts/fix-conf-perms.sh <<'EOF'
#!/usr/bin/bash
for file in /tmp/exam/secure/*.conf; do
  chmod 640 \"$file\"
done
EOF
chmod +x /root/scripts/fix-conf-perms.sh"
TASK_3_QUESTION="Run the script and verify permissions"
TASK_3_HINT="Use stat -c %a"
TASK_3_COMMAND_1="/root/scripts/fix-conf-perms.sh && stat -c %a /tmp/exam/secure/*.conf"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /tmp/exam/secure; touch /tmp/exam/secure/a.conf /tmp/exam/secure/b.conf /tmp/exam/secure/c.conf; chmod 666 /tmp/exam/secure/*.conf; rm -f /root/scripts/fix-conf-perms.sh; }
check_tasks(){
 [[ -f /tmp/exam/secure/a.conf ]] && [[ $(stat -c %a /tmp/exam/secure/a.conf) == 666 ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/fix-conf-perms.sh ]] && grep -q 'for ' /root/scripts/fix-conf-perms.sh && grep -q 'chmod 640' /root/scripts/fix-conf-perms.sh && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 /root/scripts/fix-conf-perms.sh >/dev/null 2>&1; ok=true; for f in /tmp/exam/secure/*.conf; do [[ $(stat -c %a "$f") == 640 ]] || ok=false; done; $ok && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/fix-conf-perms.sh; rm -rf /tmp/exam/secure; rmdir /tmp/exam 2>/dev/null || true; }
