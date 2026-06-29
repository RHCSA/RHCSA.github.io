#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Exam-style onboarding scenario
IS_LAB=true
LAB_ID="script_exam_onboarding"
QUESTION="Exam scenario: automate user onboarding and reporting from CSV input"
LAB_TASK_COUNT=5
TASK_1_QUESTION="Review /tmp/exam/newhires.csv with fields username,primary_group,shell"
TASK_1_HINT="Do not edit the input file"
TASK_1_COMMAND_1="cat /tmp/exam/newhires.csv"
TASK_2_QUESTION="Create /root/scripts/onboard-newhires.sh that creates missing groups and users"
TASK_2_HINT="Use while IFS=, read user group shell"
TASK_2_COMMAND_1="cat > /root/scripts/onboard-newhires.sh <<'EOF'
#!/usr/bin/bash
INPUT=/tmp/exam/newhires.csv
REPORT=/root/reports/newhires-report.txt
mkdir -p /root/reports
: > $REPORT
while IFS=, read user group shell; do
  [[ \"$user\" == username || -z \"$user\" ]] && continue
  getent group \"$group\" >/dev/null || groupadd \"$group\"
  id \"$user\" &>/dev/null || useradd -m -g \"$group\" -s \"$shell\" \"$user\"
  echo \"$user:$group:$shell\" >> $REPORT
done < $INPUT
EOF"
TASK_3_QUESTION="Make the script executable and run it"
TASK_3_HINT="chmod +x"
TASK_3_COMMAND_1="chmod +x /root/scripts/onboard-newhires.sh && /root/scripts/onboard-newhires.sh"
TASK_4_QUESTION="Verify users, groups and shells are correct"
TASK_4_HINT="Use id and getent passwd"
TASK_4_COMMAND_1="id rhcsa_eva; getent passwd rhcsa_eva"
TASK_5_QUESTION="Verify /root/reports/newhires-report.txt contains all onboarded users"
TASK_5_HINT="Report should contain three lines"
TASK_5_COMMAND_1="wc -l /root/reports/newhires-report.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /root/reports /tmp/exam; cat >/tmp/exam/newhires.csv <<'EOF'
username,primary_group,shell
rhcsa_eva,rhcsa_sales,/bin/bash
rhcsa_noah,rhcsa_ops,/sbin/nologin
rhcsa_lina,rhcsa_sales,/bin/bash
EOF
for u in rhcsa_eva rhcsa_noah rhcsa_lina; do userdel -r $u 2>/dev/null || true; done; groupdel rhcsa_sales 2>/dev/null || true; groupdel rhcsa_ops 2>/dev/null || true; rm -f /root/scripts/onboard-newhires.sh /root/reports/newhires-report.txt; }
check_tasks(){
 [[ -f /tmp/exam/newhires.csv ]] && grep -q 'username,primary_group,shell' /tmp/exam/newhires.csv && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -f /root/scripts/onboard-newhires.sh ]] && grep -q 'IFS=,' /root/scripts/onboard-newhires.sh && grep -q 'groupadd' /root/scripts/onboard-newhires.sh && grep -q 'useradd' /root/scripts/onboard-newhires.sh && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -x /root/scripts/onboard-newhires.sh ]] && /root/scripts/onboard-newhires.sh >/dev/null 2>&1 && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
 id rhcsa_eva 2>/dev/null | grep -q rhcsa_sales && getent passwd rhcsa_noah | grep -q '/sbin/nologin$' && id rhcsa_lina 2>/dev/null | grep -q rhcsa_sales && TASK_STATUS[3]="true" || TASK_STATUS[3]="false"
 [[ $(wc -l < /root/reports/newhires-report.txt 2>/dev/null) -eq 3 ]] && grep -q rhcsa_eva /root/reports/newhires-report.txt && grep -q rhcsa_noah /root/reports/newhires-report.txt && TASK_STATUS[4]="true" || TASK_STATUS[4]="false"
}
cleanup_lab(){ for u in rhcsa_eva rhcsa_noah rhcsa_lina; do userdel -r $u 2>/dev/null || true; done; groupdel rhcsa_sales 2>/dev/null || true; groupdel rhcsa_ops 2>/dev/null || true; rm -f /root/scripts/onboard-newhires.sh /root/reports/newhires-report.txt /tmp/exam/newhires.csv; rmdir /tmp/exam 2>/dev/null || true; }
