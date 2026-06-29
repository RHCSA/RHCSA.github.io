#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Fix a broken Bash script
IS_LAB=true
LAB_ID="script_fix_broken"
QUESTION="Fix a broken script so it runs successfully"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Inspect /root/scripts/broken.sh"
TASK_1_HINT="Use bash -n /root/scripts/broken.sh"
TASK_1_COMMAND_1="bash -n /root/scripts/broken.sh"
TASK_2_QUESTION="Fix the script so it writes OK to /tmp/exam/fixed.txt"
TASK_2_HINT="The if statement is missing then/fi"
TASK_2_COMMAND_1="cat > /root/scripts/broken.sh <<'EOF'
#!/usr/bin/bash
if [[ -d /tmp/exam ]]; then
  echo OK > /tmp/exam/fixed.txt
fi
EOF"
TASK_3_QUESTION="Make it executable and run it"
TASK_3_HINT="chmod +x and execute"
TASK_3_COMMAND_1="chmod +x /root/scripts/broken.sh && /root/scripts/broken.sh"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /tmp/exam; cat >/root/scripts/broken.sh <<'EOF'
#!/usr/bin/bash
if [[ -d /tmp/exam ]]
  echo OK > /tmp/exam/fixed.txt
EOF
chmod 644 /root/scripts/broken.sh; rm -f /tmp/exam/fixed.txt; }
check_tasks(){
 ! bash -n /root/scripts/broken.sh &>/dev/null && [[ ! -f /tmp/exam/fixed.txt ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 bash -n /root/scripts/broken.sh &>/dev/null && grep -q 'fi' /root/scripts/broken.sh && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 chmod +x /root/scripts/broken.sh 2>/dev/null; /root/scripts/broken.sh >/dev/null 2>&1; grep -qx OK /tmp/exam/fixed.txt 2>/dev/null && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/broken.sh /tmp/exam/fixed.txt; rmdir /tmp/exam 2>/dev/null || true; }
