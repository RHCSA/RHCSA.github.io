#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Create a large-file report
IS_LAB=true
LAB_ID="script_find_big_files"
QUESTION="Create a script that reports files larger than 1 MiB"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Use /tmp/exam/files as the scan directory"
TASK_1_HINT="prepare_lab creates sample files"
TASK_1_COMMAND_1="ls -lh /tmp/exam/files"
TASK_2_QUESTION="Create /root/scripts/bigfiles.sh using find"
TASK_2_HINT="find /tmp/exam/files -type f -size +1M"
TASK_2_COMMAND_1="cat > /root/scripts/bigfiles.sh <<'EOF'
#!/usr/bin/bash
mkdir -p /root/reports
find /tmp/exam/files -type f -size +1M -printf '%p %s\n' | sort > /root/reports/bigfiles.txt
EOF
chmod +x /root/scripts/bigfiles.sh"
TASK_3_QUESTION="Run the script and verify only large files are reported"
TASK_3_HINT="Only big.bin should match"
TASK_3_COMMAND_1="/root/scripts/bigfiles.sh && cat /root/reports/bigfiles.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /root/scripts /root/reports /tmp/exam/files; dd if=/dev/zero of=/tmp/exam/files/big.bin bs=1M count=2 &>/dev/null; echo small >/tmp/exam/files/small.txt; rm -f /root/scripts/bigfiles.sh /root/reports/bigfiles.txt; }
check_tasks(){
 [[ -f /tmp/exam/files/big.bin ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -x /root/scripts/bigfiles.sh ]] && grep -q 'find' /root/scripts/bigfiles.sh && grep -q -- '-size +1M' /root/scripts/bigfiles.sh && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 /root/scripts/bigfiles.sh >/dev/null 2>&1; grep -q 'big.bin' /root/reports/bigfiles.txt && ! grep -q 'small.txt' /root/reports/bigfiles.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /root/scripts/bigfiles.sh /root/reports/bigfiles.txt; rm -rf /tmp/exam/files; rmdir /tmp/exam 2>/dev/null || true; }
