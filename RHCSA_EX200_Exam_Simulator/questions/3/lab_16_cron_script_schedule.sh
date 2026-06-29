#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Schedule a script with cron
IS_LAB=true
LAB_ID="script_cron_schedule"
QUESTION="Create a script and schedule it with cron"
LAB_TASK_COUNT=4
TASK_1_QUESTION="Create /root/scripts/daily-heartbeat.sh that appends a timestamp to /var/log/rhcsa-heartbeat.log"
TASK_1_HINT="Use date >> log"
TASK_1_COMMAND_1="cat > /root/scripts/daily-heartbeat.sh <<'EOF'
#!/usr/bin/bash
echo \"$(date '+%F %T') heartbeat\" >> /var/log/rhcsa-heartbeat.log
EOF"
TASK_2_QUESTION="Make the script executable"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/daily-heartbeat.sh"
TASK_3_QUESTION="Create /etc/cron.d/rhcsa-heartbeat to run the script daily at 02:15 as root"
TASK_3_HINT="15 2 * * * root /root/scripts/daily-heartbeat.sh"
TASK_3_COMMAND_1="echo '15 2 * * * root /root/scripts/daily-heartbeat.sh' > /etc/cron.d/rhcsa-heartbeat"
TASK_4_QUESTION="Run the script once to verify it writes the log"
TASK_4_HINT="Execute the script manually"
TASK_4_COMMAND_1="/root/scripts/daily-heartbeat.sh"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts; rm -f /root/scripts/daily-heartbeat.sh /etc/cron.d/rhcsa-heartbeat /var/log/rhcsa-heartbeat.log; }
check_tasks(){
 [[ -f /root/scripts/daily-heartbeat.sh ]] && grep -q 'rhcsa-heartbeat.log' /root/scripts/daily-heartbeat.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/daily-heartbeat.sh ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -f /etc/cron.d/rhcsa-heartbeat ]] && grep -Eq '^15[[:space:]]+2[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+root[[:space:]]+/root/scripts/daily-heartbeat.sh' /etc/cron.d/rhcsa-heartbeat && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
 /root/scripts/daily-heartbeat.sh >/dev/null 2>&1; [[ -s /var/log/rhcsa-heartbeat.log ]] && TASK_STATUS[3]="true" || TASK_STATUS[3]="false"
}
cleanup_lab(){ rm -f /root/scripts/daily-heartbeat.sh /etc/cron.d/rhcsa-heartbeat /var/log/rhcsa-heartbeat.log; }
