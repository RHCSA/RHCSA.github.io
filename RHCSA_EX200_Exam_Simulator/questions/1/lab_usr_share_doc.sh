#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Explore /usr/share/doc Package Documentation

IS_LAB=true
LAB_ID="usr_share_doc"

QUESTION="[LAB] Find and explore package documentation in /usr/share/doc"

HINT="Task 1: ls /usr/share/doc/ | grep -i bash > /tmp/exam/bash_doc_dir.txt
       (Find bash documentation directory)

Task 2: ls /usr/share/doc/sudo*/ > /tmp/exam/sudo_files.txt
       (List files in sudo documentation)

Task 3: rpm -qd bash > /tmp/exam/bash_rpm_docs.txt
       (List all documentation files for bash package)"

LAB_TITLE="Package Docs (/usr/share/doc)"
LAB_TASK_COUNT=3

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Find bash documentation directory name, save to /tmp/exam/bash_doc_dir.txt" ;;
        1) echo "List files in sudo documentation, save to /tmp/exam/sudo_files.txt" ;;
        2) echo "List all doc files for bash using rpm, save to /tmp/exam/bash_rpm_docs.txt" ;;
    esac
}

prepare_lab() {
    echo "  • Creating /usr/share/doc lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    mkdir -p /tmp/exam
    echo "  • Lab environment ready"
}

check_tasks() {
    # Task 0: bash_doc_dir.txt should have bash directory name
    if [[ -f /tmp/exam/bash_doc_dir.txt ]]; then
        if grep -qi "bash" /tmp/exam/bash_doc_dir.txt 2>/dev/null; then
            TASK_STATUS[0]=true
        else
            TASK_STATUS[0]=false
        fi
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 1: sudo_files.txt should list files
    if [[ -f /tmp/exam/sudo_files.txt ]]; then
        local count=$(wc -l < /tmp/exam/sudo_files.txt 2>/dev/null)
        if [[ $count -ge 1 ]]; then
            TASK_STATUS[1]=true
        else
            TASK_STATUS[1]=false
        fi
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 2: bash_rpm_docs.txt should have file paths
    if [[ -f /tmp/exam/bash_rpm_docs.txt ]]; then
        if grep -q "/" /tmp/exam/bash_rpm_docs.txt 2>/dev/null; then
            TASK_STATUS[2]=true
        else
            TASK_STATUS[2]=false
        fi
    else
        TASK_STATUS[2]=false
    fi
}

cleanup_lab() {
    echo "  • Cleaning up lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    echo "  • Cleanup complete"
}
