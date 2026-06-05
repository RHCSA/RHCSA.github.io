#!/bin/bash
# Objective 2: Manage software
# LAB: Verify files installed by an RPM package
IS_LAB=true
LAB_ID="rpm_verify_config"
QUESTION="Use rpm verification and package file listing"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Save verification output for setup package to /tmp/exam/verify-setup.txt"
TASK_1_HINT="Use rpm -V setup; redirect output and allow non-zero exit"
TASK_1_COMMAND_1="rpm -V setup > /tmp/exam/verify-setup.txt 2>&1 || true"
TASK_2_QUESTION="Save documentation files from bash package to /tmp/exam/bash-docs.txt"
TASK_2_HINT="Use rpm -qd bash"
TASK_2_COMMAND_1="rpm -qd bash > /tmp/exam/bash-docs.txt"
TASK_3_QUESTION="Save configuration files from setup package to /tmp/exam/setup-configs.txt"
TASK_3_HINT="Use rpm -qc setup"
TASK_3_COMMAND_1="rpm -qc setup > /tmp/exam/setup-configs.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/verify-setup.txt /tmp/exam/bash-docs.txt /tmp/exam/setup-configs.txt; }
check_tasks(){
 [[ -f /tmp/exam/verify-setup.txt ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -s /tmp/exam/bash-docs.txt ]] && grep -Eqi 'doc|man|license' /tmp/exam/bash-docs.txt && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /tmp/exam/setup-configs.txt ]] && grep -q '^/etc' /tmp/exam/setup-configs.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /tmp/exam/verify-setup.txt /tmp/exam/bash-docs.txt /tmp/exam/setup-configs.txt; }
