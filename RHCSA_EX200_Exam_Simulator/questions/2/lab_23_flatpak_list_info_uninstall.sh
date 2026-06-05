#!/bin/bash
# Objective 2: Manage software
# LAB: List and inspect installed Flatpak applications
IS_LAB=true
LAB_ID="flatpak_list_info_uninstall"
QUESTION="Use Flatpak list, info and uninstall commands"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Save all installed Flatpak applications to /tmp/exam/flatpak-apps.txt"
TASK_1_HINT="Use flatpak list --app"
TASK_1_COMMAND_1="flatpak list --app > /tmp/exam/flatpak-apps.txt"
TASK_2_QUESTION="Save all installed Flatpak runtimes to /tmp/exam/flatpak-runtimes.txt"
TASK_2_HINT="Use flatpak list --runtime"
TASK_2_COMMAND_1="flatpak list --runtime > /tmp/exam/flatpak-runtimes.txt"
TASK_3_QUESTION="Save detailed Flatpak installation information to /tmp/exam/flatpak-installations.txt"
TASK_3_HINT="Use flatpak --installations or flatpak list --columns"
TASK_3_COMMAND_1="flatpak --installations > /tmp/exam/flatpak-installations.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/flatpak-apps.txt /tmp/exam/flatpak-runtimes.txt /tmp/exam/flatpak-installations.txt; }
check_tasks(){
 [[ -f /tmp/exam/flatpak-apps.txt ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -f /tmp/exam/flatpak-runtimes.txt ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -f /tmp/exam/flatpak-installations.txt ]] && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /tmp/exam/flatpak-apps.txt /tmp/exam/flatpak-runtimes.txt /tmp/exam/flatpak-installations.txt; }
