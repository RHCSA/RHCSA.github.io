#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Create a service watchdog script
IS_LAB=true
LAB_ID="script_service_watchdog"
QUESTION="Create a watchdog script that starts a service if it is inactive"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/watch-sshd.sh"
TASK_1_HINT="Use systemctl is-active --quiet sshd || systemctl start sshd"
TASK_1_COMMAND_1="cat > /root/scripts/watch-sshd.sh <<'EOF'
#!/usr/bin/bash
LOG=/var/log/rhcsa-watchdog.log
if systemctl is-active --quiet sshd; then
  echo 'sshd OK' >> $LOG
else
  systemctl start sshd
  echo 'sshd restarted' >> $LOG
fi
EOF"
TASK_2_QUESTION="Make the script executable and run it"
TASK_2_HINT="chmod +x"
TASK_2_COMMAND_1="chmod +x /root/scripts/watch-sshd.sh && /root/scripts/watch-sshd.sh"
TASK_3_QUESTION="Verify the watchdog log exists"
TASK_3_HINT="Check /var/log/rhcsa-watchdog.log"
TASK_3_COMMAND_1="cat /var/log/rhcsa-watchdog.log"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts; rm -f /root/scripts/watch-sshd.sh /var/log/rhcsa-watchdog.log; }
check_tasks(){
 [[ -f /root/scripts/watch-sshd.sh ]] && grep -q 'systemctl is-active' /root/scripts/watch-sshd.sh && grep -q 'systemctl start' /root/scripts/watch-sshd.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/watch-sshd.sh ]] && /root/scripts/watch-sshd.sh >/dev/null 2>&1 && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /var/log/rhcsa-watchdog.log ]] && grep -Eq 'sshd (OK|restarted)' /var/log/rhcsa-watchdog.log && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/watch-sshd.sh /var/log/rhcsa-watchdog.log; }
