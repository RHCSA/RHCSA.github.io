#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Persist an environment variable with profile.d
IS_LAB=true
LAB_ID="script_profiled_environment"
QUESTION="Create a profile.d script that exports an environment variable"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /etc/profile.d/rhcsa-editor.sh"
TASK_1_HINT="Use export EDITOR=vim"
TASK_1_COMMAND_1="echo 'export EDITOR=vim' > /etc/profile.d/rhcsa-editor.sh"
TASK_2_QUESTION="Ensure the file is readable and has .sh extension"
TASK_2_HINT="chmod 644 /etc/profile.d/rhcsa-editor.sh"
TASK_2_COMMAND_1="chmod 644 /etc/profile.d/rhcsa-editor.sh"
TASK_3_QUESTION="Verify a login shell receives EDITOR=vim"
TASK_3_HINT="bash -lc 'echo $EDITOR'"
TASK_3_COMMAND_1="bash -lc 'echo $EDITOR'"
HINT=$(_build_hint)
prepare_lab(){ rm -f /etc/profile.d/rhcsa-editor.sh; }
check_tasks(){
 [[ -f /etc/profile.d/rhcsa-editor.sh ]] && grep -q 'export EDITOR=vim' /etc/profile.d/rhcsa-editor.sh && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ $(stat -c %a /etc/profile.d/rhcsa-editor.sh 2>/dev/null) == 644 ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 bash -lc '[[ "$EDITOR" == "vim" ]]' && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /etc/profile.d/rhcsa-editor.sh; }
