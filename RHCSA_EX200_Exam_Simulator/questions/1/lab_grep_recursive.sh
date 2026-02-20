#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Grep Recursive Search

# This is a LAB exercise
IS_LAB=true
LAB_ID="grep_recursive"

QUESTION="[LAB] Use grep -r to search recursively in directories"
HINT="This lab has 2 tasks:\n\n1. Find all TODO lines recursively:\n   grep -r 'TODO' /tmp/project/ > /tmp/todos.txt\n\n2. List only filenames with FIXME:\n   grep -rl 'FIXME' /tmp/project/ > /tmp/fixme-files.txt\n\nTip: -r = recursive, -l = filenames only."

# Lab configuration
LAB_TITLE="Grep Recursive Search"
LAB_TASK_COUNT=2

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Find all lines containing 'TODO' in /tmp/project/ recursively, save to /tmp/todos.txt" ;;
        1) echo "List only filenames (not content) containing 'FIXME' in /tmp/project/, save to /tmp/fixme-files.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing files and directories...${RESET}"
    rm -rf /tmp/project /tmp/todos.txt /tmp/fixme-files.txt 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating project directory structure...${RESET}"
    mkdir -p /tmp/project/src /tmp/project/lib /tmp/project/docs
    sleep 0.2
    
    echo -e "  ${DIM}• Creating source files with TODO/FIXME comments...${RESET}"
    cat > /tmp/project/src/main.py << 'EOF'
#!/usr/bin/env python3
# Main application file

def main():
    # TODO: Add argument parsing
    print("Hello World")
    
    # TODO: Implement logging
    process_data()

def process_data():
    # FIXME: This function is too slow
    data = load_data()
    return data

if __name__ == "__main__":
    main()
EOF

    cat > /tmp/project/src/utils.py << 'EOF'
# Utility functions

def load_data():
    # TODO: Add error handling
    return []

def save_data(data):
    # FIXME: Not thread-safe
    pass

# TODO: Add unit tests
EOF

    cat > /tmp/project/lib/database.py << 'EOF'
# Database connection module

class Database:
    def __init__(self):
        # TODO: Add connection pooling
        self.connection = None
    
    def query(self, sql):
        # FIXME: SQL injection vulnerability
        pass
EOF

    cat > /tmp/project/docs/README.md << 'EOF'
# Project Documentation

## Overview
This is a sample project.

## TODO List
- TODO: Complete documentation
- Add more examples

## Known Issues
- FIXME: Memory leak in database module
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check todos.txt contains TODO lines from multiple files
    if [[ -f /tmp/todos.txt ]]; then
        local todo_count=$(grep -c 'TODO' /tmp/todos.txt 2>/dev/null)
        # Should have at least 5 TODO mentions
        if [[ $todo_count -ge 5 ]]; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check fixme-files.txt contains filenames only (not content)
    if [[ -f /tmp/fixme-files.txt ]]; then
        local file_count=$(wc -l < /tmp/fixme-files.txt 2>/dev/null)
        # Should have at least 3 files with FIXME
        if [[ $file_count -ge 3 ]]; then
            # Should contain file paths, not code content
            if grep -qE '\.py|\.md' /tmp/fixme-files.txt 2>/dev/null; then
                # Should NOT contain the actual FIXME text in output (just filenames)
                # grep -rl outputs: /tmp/project/src/main.py
                # grep -r outputs: /tmp/project/src/main.py:    # FIXME: This is slow
                # Check that lines look like paths (contain /tmp/project)
                if grep -q '/tmp/project' /tmp/fixme-files.txt 2>/dev/null; then
                    TASK_STATUS[1]="true"
                else
                    TASK_STATUS[1]="false"
                fi
            else
                TASK_STATUS[1]="false"
            fi
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/project /tmp/todos.txt /tmp/fixme-files.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
