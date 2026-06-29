#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Process CSV input for users and groups
IS_LAB=true
LAB_ID="script_csv_users_groups"
QUESTION="Create users and groups from a CSV file"
LAB_TASK_COUNT=4
TASK_1_QUESTION="Inspect /tmp/exam/employees.csv with format user,group"
TASK_1_HINT="Use cat or awk -F,"
TASK_1_COMMAND_1="cat /tmp/exam/employees.csv"
TASK_2_QUESTION="Create /root/scripts/onboard-employees.sh that reads the CSV file"
TASK_2_HINT="Use IFS=, read user group"
TASK_2_COMMAND_1="cat > /root/scripts/onboard-employees.sh <<'EOF'
#!/usr/bin/bash
while IFS=, read user group; do
  [[ \"$user\" == user || -z \"$user\" ]] && continue
  getent group \"$group\" >/dev/null || groupadd \"$group\"
  id \"$user\" &>/dev/null || useradd -m -g \"$group\" \"$user\"
done < /tmp/exam/employees.csv
EOF"
TASK_3_QUESTION="Make the script executable and run it"
TASK_3_HINT="chmod +x"
TASK_3_COMMAND_1="chmod +x /root/scripts/onboard-employees.sh && /root/scripts/onboard-employees.sh"
TASK_4_QUESTION="Verify users are created with the requested primary groups"
TASK_4_HINT="Use id"
TASK_4_COMMAND_1="id rhcsa_alice; id rhcsa_bob"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /tmp/exam; cat >/tmp/exam/employees.csv <<'EOF'
user,group
rhcsa_alice,rhcsa_dev
rhcsa_bob,rhcsa_ops
EOF
for u in rhcsa_alice rhcsa_bob; do userdel -r $u 2>/dev/null || true; done; groupdel rhcsa_dev 2>/dev/null || true; groupdel rhcsa_ops 2>/dev/null || true; rm -f /root/scripts/onboard-employees.sh; }
check_tasks(){
 [[ -f /tmp/exam/employees.csv ]] && grep -q 'user,group' /tmp/exam/employees.csv && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -f /root/scripts/onboard-employees.sh ]] && grep -q 'IFS=,' /root/scripts/onboard-employees.sh && grep -q 'groupadd' /root/scripts/onboard-employees.sh && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -x /root/scripts/onboard-employees.sh ]] && /root/scripts/onboard-employees.sh >/dev/null 2>&1 && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
 id rhcsa_alice 2>/dev/null | grep -q 'rhcsa_dev' && id rhcsa_bob 2>/dev/null | grep -q 'rhcsa_ops' && TASK_STATUS[3]="true" || TASK_STATUS[3]="false"
}
cleanup_lab(){ for u in rhcsa_alice rhcsa_bob; do userdel -r $u 2>/dev/null || true; done; groupdel rhcsa_dev 2>/dev/null || true; groupdel rhcsa_ops 2>/dev/null || true; rm -f /root/scripts/onboard-employees.sh /tmp/exam/employees.csv; rmdir /tmp/exam 2>/dev/null || true; }
