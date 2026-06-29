#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Check disk usage threshold
IS_LAB=true
LAB_ID="script_disk_threshold"
QUESTION="Create a script that checks root filesystem usage against a threshold"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/check-root-usage.sh THRESHOLD"
TASK_1_HINT="Use df -P / and awk"
TASK_1_COMMAND_1="cat > /root/scripts/check-root-usage.sh <<'EOF'
#!/usr/bin/bash
THRESHOLD=${1:-80}
USED=$(df -P / | awk 'NR==2 {gsub(/%/,\"\",$5); print $5}')
if [[ $USED -ge $THRESHOLD ]]; then
  echo HIGH
  exit 1
else
  echo OK
  exit 0
fi
EOF"
TASK_2_QUESTION="Make executable"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/check-root-usage.sh"
TASK_3_QUESTION="Run with threshold 100 and confirm OK"
TASK_3_HINT="/root/scripts/check-root-usage.sh 100"
TASK_3_COMMAND_1="/root/scripts/check-root-usage.sh 100"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts; rm -f /root/scripts/check-root-usage.sh; }
check_tasks(){
 [[ -f /root/scripts/check-root-usage.sh ]] && grep -q 'df -P /' /root/scripts/check-root-usage.sh && grep -q 'awk' /root/scripts/check-root-usage.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/check-root-usage.sh ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 out=$(/root/scripts/check-root-usage.sh 100 2>/dev/null); rc=$?; [[ "$out" == "OK" && $rc -eq 0 ]] && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/check-root-usage.sh; }
