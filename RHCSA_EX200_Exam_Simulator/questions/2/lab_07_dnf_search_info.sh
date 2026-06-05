#!/bin/bash
# Objective 2: Manage software
# LAB: Search package metadata
IS_LAB=true
LAB_ID="dnf_search_info"
QUESTION="Use DNF to search for packages and inspect package information"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Search for packages related to httpd and save output to /tmp/exam/search-httpd.txt"
TASK_1_HINT="Use dnf search httpd"
TASK_1_COMMAND_1="dnf search httpd > /tmp/exam/search-httpd.txt"
TASK_2_QUESTION="Save package information for bash to /tmp/exam/info-bash.txt"
TASK_2_HINT="Use dnf info bash"
TASK_2_COMMAND_1="dnf info bash > /tmp/exam/info-bash.txt"
TASK_3_QUESTION="List available packages matching '*python*' to /tmp/exam/list-python.txt"
TASK_3_HINT="Use dnf list available '*python*'"
TASK_3_COMMAND_1="dnf list available '*python*' > /tmp/exam/list-python.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/search-httpd.txt /tmp/exam/info-bash.txt /tmp/exam/list-python.txt; }
check_tasks(){
 [[ -s /tmp/exam/search-httpd.txt ]] && grep -qi 'httpd' /tmp/exam/search-httpd.txt && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -s /tmp/exam/info-bash.txt ]] && grep -Eqi '^Name *: *bash|Name *: bash|^Name[[:space:]]+: bash' /tmp/exam/info-bash.txt && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /tmp/exam/list-python.txt ]] && grep -qi 'python' /tmp/exam/list-python.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /tmp/exam/search-httpd.txt /tmp/exam/info-bash.txt /tmp/exam/list-python.txt; }
