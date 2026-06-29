#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Check service status with systemctl
IS_LAB=true
LAB_ID="script_if_service_status"
QUESTION="Create a script that checks whether a systemd service is active"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/check-service.sh"
TASK_1_HINT="Use systemctl is-active --quiet"
TASK_1_COMMAND_1="cat > /root/scripts/check-service.sh <<'EOF'
#!/usr/bin/bash
SERVICE=$1
if systemctl is-active --quiet \"$SERVICE\"; then
  echo ACTIVE
else
  echo INACTIVE
fi
EOF"
TASK_2_QUESTION="Make the script executable"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/check-service.sh"
TASK_3_QUESTION="Run it for sshd or crond and save output to /tmp/exam/service-status.txt"
TASK_3_HINT="/root/scripts/check-service.sh sshd > /tmp/exam/service-status.txt"
TASK_3_COMMAND_1="/root/scripts/check-service.sh sshd > /tmp/exam/service-status.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /tmp/exam; rm -f /root/scripts/check-service.sh /tmp/exam/service-status.txt; }
check_tasks(){
 [[ -f /root/scripts/check-service.sh ]] && grep -q 'systemctl is-active' /root/scripts/check-service.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/check-service.sh ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 /root/scripts/check-service.sh sshd >/tmp/exam/service-status.txt 2>/dev/null || true; grep -Eq '^(ACTIVE|INACTIVE)$' /tmp/exam/service-status.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/check-service.sh /tmp/exam/service-status.txt; rmdir /tmp/exam 2>/dev/null || true; }
