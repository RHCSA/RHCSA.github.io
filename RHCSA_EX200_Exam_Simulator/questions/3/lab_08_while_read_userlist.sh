#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Process a user list with while read
IS_LAB=true
LAB_ID="script_while_read_userlist"
QUESTION="Create users from a text file with a while read loop"
LAB_TASK_COUNT=4
TASK_1_QUESTION="Use /tmp/exam/users.txt as input"
TASK_1_HINT="prepare_lab creates /tmp/exam/users.txt"
TASK_1_COMMAND_1="cat /tmp/exam/users.txt"
TASK_2_QUESTION="Create /root/scripts/create-users-from-list.sh using while read"
TASK_2_HINT="while read user; do ...; done < file"
TASK_2_COMMAND_1="cat > /root/scripts/create-users-from-list.sh <<'EOF'
#!/usr/bin/bash
while read user; do
  [[ -z \"$user\" ]] && continue
  id \"$user\" &>/dev/null || useradd -m \"$user\"
done < /tmp/exam/users.txt
EOF"
TASK_3_QUESTION="Make the script executable and run it"
TASK_3_HINT="chmod +x"
TASK_3_COMMAND_1="chmod +x /root/scripts/create-users-from-list.sh && /root/scripts/create-users-from-list.sh"
TASK_4_QUESTION="Verify all listed users exist"
TASK_4_HINT="Use id"
TASK_4_COMMAND_1="id rhcsa_list1 rhcsa_list2 rhcsa_list3"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /tmp/exam; printf 'rhcsa_list1\nrhcsa_list2\nrhcsa_list3\n' >/tmp/exam/users.txt; for u in rhcsa_list1 rhcsa_list2 rhcsa_list3; do userdel -r $u 2>/dev/null || true; done; rm -f /root/scripts/create-users-from-list.sh; }
check_tasks(){
 [[ -f /tmp/exam/users.txt ]] && grep -q rhcsa_list1 /tmp/exam/users.txt && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -f /root/scripts/create-users-from-list.sh ]] && grep -q 'while read' /root/scripts/create-users-from-list.sh && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -x /root/scripts/create-users-from-list.sh ]] && /root/scripts/create-users-from-list.sh >/dev/null 2>&1 && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
 id rhcsa_list1 &>/dev/null && id rhcsa_list2 &>/dev/null && id rhcsa_list3 &>/dev/null && TASK_STATUS[3]="true" || TASK_STATUS[3]="false"
}
cleanup_lab(){ for u in rhcsa_list1 rhcsa_list2 rhcsa_list3; do userdel -r $u 2>/dev/null || true; done; rm -f /root/scripts/create-users-from-list.sh /tmp/exam/users.txt; rmdir /tmp/exam 2>/dev/null || true; }
