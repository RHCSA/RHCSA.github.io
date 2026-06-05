#!/bin/bash
# Objective 2: Manage software
# LAB: Query installed RPM packages
IS_LAB=true
LAB_ID="rpm_query_installed"
QUESTION="Use rpm query options to inspect installed packages"
LAB_TASK_COUNT=4
TASK_1_QUESTION="Save the installed bash package version to /tmp/exam/rpmq-bash.txt"
TASK_1_HINT="Use rpm -q bash"
TASK_1_COMMAND_1="rpm -q bash > /tmp/exam/rpmq-bash.txt"
TASK_2_QUESTION="Save package information for bash to /tmp/exam/rpmi-bash.txt"
TASK_2_HINT="Use rpm -qi bash"
TASK_2_COMMAND_1="rpm -qi bash > /tmp/exam/rpmi-bash.txt"
TASK_3_QUESTION="Save the file list from bash to /tmp/exam/rpql-bash.txt"
TASK_3_HINT="Use rpm -ql bash"
TASK_3_COMMAND_1="rpm -ql bash > /tmp/exam/rpql-bash.txt"
TASK_4_QUESTION="Find the owning package of /bin/bash and save to /tmp/exam/rpmqf-bash.txt"
TASK_4_HINT="Use rpm -qf /bin/bash"
TASK_4_COMMAND_1="rpm -qf /bin/bash > /tmp/exam/rpmqf-bash.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/rpm*-bash.txt; }
check_tasks(){
 [[ -s /tmp/exam/rpmq-bash.txt ]] && grep -q '^bash-' /tmp/exam/rpmq-bash.txt && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -s /tmp/exam/rpmi-bash.txt ]] && grep -Eqi '^Name *: *bash|Name *: bash|^Name[[:space:]]+: bash' /tmp/exam/rpmi-bash.txt && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /tmp/exam/rpql-bash.txt ]] && grep -qE '/(usr/)?bin/bash' /tmp/exam/rpql-bash.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
 [[ -s /tmp/exam/rpmqf-bash.txt ]] && grep -q '^bash-' /tmp/exam/rpmqf-bash.txt && TASK_STATUS[3]="true" || TASK_STATUS[3]="false"
}
cleanup_lab(){ rm -f /tmp/exam/rpm*-bash.txt; }
