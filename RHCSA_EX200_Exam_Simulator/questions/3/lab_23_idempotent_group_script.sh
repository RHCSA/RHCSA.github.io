#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Write an idempotent group creation script
IS_LAB=true
LAB_ID="script_idempotent_group"
QUESTION="Create a script that can be safely run multiple times"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /root/scripts/ensure-groups.sh for groups rhcsa_devops and rhcsa_audit"
TASK_1_HINT="Use getent group before groupadd"
TASK_1_COMMAND_1="cat > /root/scripts/ensure-groups.sh <<'EOF'
#!/usr/bin/bash
for grp in rhcsa_devops rhcsa_audit; do
  getent group $grp >/dev/null || groupadd $grp
done
EOF"
TASK_2_QUESTION="Make executable and run it twice without error"
TASK_2_HINT="Idempotent means repeated runs succeed"
TASK_2_COMMAND_1="chmod +x /root/scripts/ensure-groups.sh && /root/scripts/ensure-groups.sh && /root/scripts/ensure-groups.sh"
TASK_3_QUESTION="Verify both groups exist"
TASK_3_HINT="getent group"
TASK_3_COMMAND_1="getent group rhcsa_devops rhcsa_audit"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts; groupdel rhcsa_devops 2>/dev/null || true; groupdel rhcsa_audit 2>/dev/null || true; rm -f /root/scripts/ensure-groups.sh; }
check_tasks(){
 [[ -f /root/scripts/ensure-groups.sh ]] && grep -q 'getent group' /root/scripts/ensure-groups.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/ensure-groups.sh ]] && /root/scripts/ensure-groups.sh >/dev/null 2>&1 && /root/scripts/ensure-groups.sh >/dev/null 2>&1 && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 getent group rhcsa_devops >/dev/null && getent group rhcsa_audit >/dev/null && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ groupdel rhcsa_devops 2>/dev/null || true; groupdel rhcsa_audit 2>/dev/null || true; rm -f /root/scripts/ensure-groups.sh; }
