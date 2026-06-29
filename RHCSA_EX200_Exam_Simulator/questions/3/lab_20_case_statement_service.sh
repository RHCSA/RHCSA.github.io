#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Use a case statement
IS_LAB=true
LAB_ID="script_case_statement"
QUESTION="Create a script that uses a case statement for service actions"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/service-action.sh SERVICE ACTION"
TASK_1_HINT="Use case $2 in status|restart|enable)"
TASK_1_COMMAND_1="cat > /root/scripts/service-action.sh <<'EOF'
#!/usr/bin/bash
SERVICE=$1
ACTION=$2
case $ACTION in
  status) systemctl is-active $SERVICE ;;
  restart) systemctl restart $SERVICE ;;
  enable) systemctl enable $SERVICE ;;
  *) echo 'Usage: service-action.sh SERVICE status|restart|enable' >&2; exit 2 ;;
esac
EOF"
TASK_2_QUESTION="Make the script executable"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/service-action.sh"
TASK_3_QUESTION="Run status action for sshd"
TASK_3_HINT="/root/scripts/service-action.sh sshd status"
TASK_3_COMMAND_1="/root/scripts/service-action.sh sshd status"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts; rm -f /root/scripts/service-action.sh; }
check_tasks(){
 [[ -f /root/scripts/service-action.sh ]] && grep -q 'case ' /root/scripts/service-action.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/service-action.sh ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 /root/scripts/service-action.sh sshd status >/tmp/service-action.out 2>/dev/null || true; grep -Eq '^(active|inactive|failed|unknown)$' /tmp/service-action.out && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/service-action.sh /tmp/service-action.out; }
