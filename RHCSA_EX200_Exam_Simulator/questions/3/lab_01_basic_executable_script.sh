#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Create an executable Bash script with fixed output
IS_LAB=true
LAB_ID="script_basic_executable"
QUESTION="Create an executable Bash script that writes a fixed status line"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create directory /root/scripts"
TASK_1_HINT="Use mkdir -p /root/scripts"
TASK_1_COMMAND_1="mkdir -p /root/scripts"
TASK_2_QUESTION="Create /root/scripts/rhcsa-status.sh with a Bash shebang and output exactly: RHCSA scripting ready"
TASK_2_HINT="Use #!/usr/bin/bash and echo"
TASK_2_COMMAND_1="cat > /root/scripts/rhcsa-status.sh <<'EOF'
#!/usr/bin/bash
echo 'RHCSA scripting ready'
EOF"
TASK_3_QUESTION="Make /root/scripts/rhcsa-status.sh executable"
TASK_3_HINT="Use chmod +x"
TASK_3_COMMAND_1="chmod +x /root/scripts/rhcsa-status.sh"
HINT=$(_build_hint)
prepare_lab(){ rm -f /root/scripts/rhcsa-status.sh /tmp/rhcsa-status.out; mkdir -p /root/scripts; }
check_tasks(){
 [[ -d /root/scripts ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -f /root/scripts/rhcsa-status.sh ]] && head -n1 /root/scripts/rhcsa-status.sh | grep -Eq '^#!.*bash' && /root/scripts/rhcsa-status.sh 2>/dev/null | grep -qx 'RHCSA scripting ready' && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -x /root/scripts/rhcsa-status.sh ]] && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/rhcsa-status.sh /tmp/rhcsa-status.out; }
