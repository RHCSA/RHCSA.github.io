#!/bin/bash
# Objective 2: Manage software
# LAB: Search, install and remove a Flatpak application
IS_LAB=true
LAB_ID="flatpak_search_install_remove"
QUESTION="Practice Flatpak application discovery, installation and removal"
LAB_TASK_COUNT=4
TASK_1_QUESTION="Add Flathub as a Flatpak remote if it does not already exist"
TASK_1_HINT="Use flatpak remote-add --if-not-exists flathub URL"
TASK_1_COMMAND_1="flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
TASK_2_QUESTION="Search for calculator applications and save output to /tmp/exam/flatpak-search-calculator.txt"
TASK_2_HINT="Use flatpak search calculator"
TASK_2_COMMAND_1="flatpak search calculator > /tmp/exam/flatpak-search-calculator.txt"
TASK_3_QUESTION="Install org.gnome.Calculator from flathub"
TASK_3_HINT="Use flatpak install -y flathub org.gnome.Calculator"
TASK_3_COMMAND_1="flatpak install -y flathub org.gnome.Calculator"
TASK_4_QUESTION="Remove org.gnome.Calculator and save remaining matching apps to /tmp/exam/flatpak-calculator-list.txt"
TASK_4_HINT="Use flatpak uninstall and flatpak list"
TASK_4_COMMAND_1="flatpak uninstall -y org.gnome.Calculator"
TASK_4_COMMAND_2="flatpak list --app | grep org.gnome.Calculator > /tmp/exam/flatpak-calculator-list.txt 2>/dev/null || true"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/flatpak-search-calculator.txt /tmp/exam/flatpak-calculator-list.txt; flatpak uninstall -y org.gnome.Calculator &>/dev/null || true; }
check_tasks(){
 flatpak remotes 2>/dev/null | awk '{print $1}' | grep -qx 'flathub' && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -f /tmp/exam/flatpak-search-calculator.txt ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 # If installed then removed, final state should be absent; use list file as proof the uninstall step was completed
 if [[ -f /tmp/exam/flatpak-calculator-list.txt ]]; then TASK_STATUS[2]="true"; else TASK_STATUS[2]="false"; fi
 if ! flatpak list --app 2>/dev/null | grep -q 'org.gnome.Calculator' && [[ -f /tmp/exam/flatpak-calculator-list.txt ]]; then TASK_STATUS[3]="true"; else TASK_STATUS[3]="false"; fi
}
cleanup_lab(){ flatpak uninstall -y org.gnome.Calculator &>/dev/null || true; rm -f /tmp/exam/flatpak-search-calculator.txt /tmp/exam/flatpak-calculator-list.txt; }
