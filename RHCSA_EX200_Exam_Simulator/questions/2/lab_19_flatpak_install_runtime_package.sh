#!/bin/bash
# Objective 2: Manage software
# LAB: Prepare the system for Flatpak management
IS_LAB=true
LAB_ID="flatpak_install_runtime_package"
QUESTION="Install Flatpak support as an RPM package and verify the command"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Install the flatpak RPM package"
TASK_1_HINT="Use dnf install -y flatpak"
TASK_1_COMMAND_1="dnf install -y flatpak"
TASK_2_QUESTION="Verify the installed flatpak RPM package and save to /tmp/exam/flatpak-rpm.txt"
TASK_2_HINT="Use rpm -q flatpak"
TASK_2_COMMAND_1="rpm -q flatpak > /tmp/exam/flatpak-rpm.txt"
TASK_3_QUESTION="Save flatpak version output to /tmp/exam/flatpak-version.txt"
TASK_3_HINT="Use flatpak --version"
TASK_3_COMMAND_1="flatpak --version > /tmp/exam/flatpak-version.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/flatpak-rpm.txt /tmp/exam/flatpak-version.txt; }
check_tasks(){
 rpm -q flatpak &>/dev/null && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -s /tmp/exam/flatpak-rpm.txt ]] && grep -q '^flatpak-' /tmp/exam/flatpak-rpm.txt && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /tmp/exam/flatpak-version.txt ]] && grep -qi 'Flatpak' /tmp/exam/flatpak-version.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /tmp/exam/flatpak-rpm.txt /tmp/exam/flatpak-version.txt; }
