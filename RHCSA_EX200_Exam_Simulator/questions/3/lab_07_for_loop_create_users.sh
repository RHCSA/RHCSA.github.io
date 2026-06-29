#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Create users with a for loop
IS_LAB=true
LAB_ID="script_for_loop_users"
QUESTION="Create a script that uses a for loop to create multiple users"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/create-training-users.sh using a for loop"
TASK_1_HINT="for n in 1 2 3; do useradd ...; done"
TASK_1_COMMAND_1="cat > /root/scripts/create-training-users.sh <<'EOF'
#!/usr/bin/bash
for n in 1 2 3; do
  id rhcsa_train$n &>/dev/null || useradd -m rhcsa_train$n
  echo rhcsa_train$n
 done
EOF"
TASK_2_QUESTION="Make the script executable and run it"
TASK_2_HINT="chmod +x and execute"
TASK_2_COMMAND_1="chmod +x /root/scripts/create-training-users.sh && /root/scripts/create-training-users.sh"
TASK_3_QUESTION="Confirm users rhcsa_train1 through rhcsa_train3 exist"
TASK_3_HINT="Use id"
TASK_3_COMMAND_1="id rhcsa_train1 rhcsa_train2 rhcsa_train3"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts; for n in 1 2 3; do userdel -r rhcsa_train$n 2>/dev/null || true; done; rm -f /root/scripts/create-training-users.sh; }
check_tasks(){
 [[ -f /root/scripts/create-training-users.sh ]] && grep -q 'for ' /root/scripts/create-training-users.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/create-training-users.sh ]] && /root/scripts/create-training-users.sh >/dev/null 2>&1 && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 id rhcsa_train1 &>/dev/null && id rhcsa_train2 &>/dev/null && id rhcsa_train3 &>/dev/null && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ for n in 1 2 3; do userdel -r rhcsa_train$n 2>/dev/null || true; done; rm -f /root/scripts/create-training-users.sh; }
