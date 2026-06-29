#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Update a configuration file with sed
IS_LAB=true
LAB_ID="script_sed_config_replace"
QUESTION="Create a script that changes a configuration value using sed"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Use /tmp/exam/app.conf with enabled=no"
TASK_1_HINT="prepare_lab creates it"
TASK_1_COMMAND_1="grep enabled /tmp/exam/app.conf"
TASK_2_QUESTION="Create /root/scripts/enable-app.sh that changes enabled=no to enabled=yes"
TASK_2_HINT="Use sed -i"
TASK_2_COMMAND_1="cat > /root/scripts/enable-app.sh <<'EOF'
#!/usr/bin/bash
sed -i 's/^enabled=no/enabled=yes/' /tmp/exam/app.conf
EOF
chmod +x /root/scripts/enable-app.sh"
TASK_3_QUESTION="Run the script and verify enabled=yes"
TASK_3_HINT="grep '^enabled=yes'"
TASK_3_COMMAND_1="/root/scripts/enable-app.sh && grep '^enabled=yes' /tmp/exam/app.conf"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /tmp/exam; cat >/tmp/exam/app.conf <<'EOF'
name=rhcsa-demo
enabled=no
mode=training
EOF
rm -f /root/scripts/enable-app.sh; }
check_tasks(){
 grep -q '^enabled=no' /tmp/exam/app.conf 2>/dev/null && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/enable-app.sh ]] && grep -q 'sed' /root/scripts/enable-app.sh && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 /root/scripts/enable-app.sh >/dev/null 2>&1; grep -q '^enabled=yes' /tmp/exam/app.conf && ! grep -q '^enabled=no' /tmp/exam/app.conf && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/enable-app.sh /tmp/exam/app.conf; rmdir /tmp/exam 2>/dev/null || true; }
