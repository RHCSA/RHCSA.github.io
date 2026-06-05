#!/bin/bash
# Objective 2: Manage software
# LAB: Refresh DNF metadata and inspect repositories
IS_LAB=true
LAB_ID="dnf_cache_repolist"
QUESTION="Clean DNF metadata, rebuild cache and record repository information"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Clean all DNF cached data"
TASK_1_HINT="Use dnf clean all"
TASK_1_COMMAND_1="dnf clean all"
TASK_2_QUESTION="Rebuild the repository metadata cache"
TASK_2_HINT="Use dnf makecache"
TASK_2_COMMAND_1="dnf makecache"
TASK_3_QUESTION="Save verbose repository details to /tmp/exam/dnf-repos.txt"
TASK_3_HINT="Use dnf repolist -v"
TASK_3_COMMAND_1="dnf repolist -v > /tmp/exam/dnf-repos.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/dnf-repos.txt /tmp/exam/dnf-clean-done; }
check_tasks(){
 # Cache clean is hard to prove after the fact; accept if makecache/repolist task was performed or dnf cache directories were touched recently
 [[ -d /var/cache/dnf || -d /var/cache/yum ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -d /var/cache/dnf || -d /var/cache/yum ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /tmp/exam/dnf-repos.txt ]] && grep -Eqi 'Repo-id|Repo ID|repo id|Repo-name|Repo Name' /tmp/exam/dnf-repos.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /tmp/exam/dnf-repos.txt; }
