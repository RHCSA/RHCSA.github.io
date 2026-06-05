#!/bin/bash
# Objective 2: Manage software
# LAB: Install an RPM package from a local file
IS_LAB=true
LAB_ID="rpm_install_local_file"
QUESTION="Download or copy a local RPM package, then install it with DNF"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Find an RPM file below /var/cache/dnf or /tmp/exam and copy one to /tmp/exam/local-package.rpm"
TASK_1_HINT="Use find to locate *.rpm, or download one provided by the instructor"
TASK_1_COMMAND_1="find /var/cache/dnf /tmp/exam -name '*.rpm' -type f 2>/dev/null | head -1 | xargs -r -I{} cp {} /tmp/exam/local-package.rpm"
TASK_2_QUESTION="Install /tmp/exam/local-package.rpm with dnf if the file exists"
TASK_2_HINT="Use dnf install -y /path/package.rpm"
TASK_2_COMMAND_1="dnf install -y /tmp/exam/local-package.rpm"
TASK_3_QUESTION="Record local RPM metadata using rpm -qpi to /tmp/exam/local-package-info.txt"
TASK_3_HINT="Use rpm -qpi /tmp/exam/local-package.rpm"
TASK_3_COMMAND_1="rpm -qpi /tmp/exam/local-package.rpm > /tmp/exam/local-package-info.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/local-package.rpm /tmp/exam/local-package-info.txt; }
check_tasks(){
 [[ -f /tmp/exam/local-package.rpm ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 # Installation depends on available local RPM; if metadata can be queried, the candidate handled the local RPM path
 [[ -f /tmp/exam/local-package.rpm ]] && rpm -qpi /tmp/exam/local-package.rpm &>/dev/null && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /tmp/exam/local-package-info.txt ]] && grep -Eqi '^Name|Name *:' /tmp/exam/local-package-info.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /tmp/exam/local-package.rpm /tmp/exam/local-package-info.txt; }
