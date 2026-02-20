# RHCSA Questions and Labs Directory

This directory contains all questions and lab exercises organized by RHCSA exam objectives.

## Directory Structure

```
questions/
├── 1/   # Objective 1: Understand and use essential tools
├── 2/   # Objective 2: Manage software
├── 3/   # Objective 3: Create simple shell scripts
├── 4/   # Objective 4: Operate running systems
├── 5/   # Objective 5: Configure local storage
├── 6/   # Objective 6: Create and configure file systems
├── 7/   # Objective 7: Deploy, configure, and maintain systems
├── 8/   # Objective 8: Manage basic networking
├── 9/   # Objective 9: Manage users and groups
└── 10/  # Objective 10: Manage security
```

## Adding a New Question

1. Navigate to the appropriate objective directory (0-9)
2. Create a new `.sh` file (e.g., `q2.sh`, `q3.sh`)
3. Add the following content:

```bash
#!/bin/bash
# Objective X: [Objective Name]
# Question N: [Brief description]

QUESTION="Your question text here"
ANSWER="The correct answer"
HINT="A helpful hint for the student"
```

**Example:** `questions/0/q2.sh`
```bash
#!/bin/bash
# Objective 0: Essential Tools
# Question 2: List files

QUESTION="What command lists files in a directory?"
ANSWER="ls - Use 'ls -la' to show all files including hidden ones with details"
HINT="This is one of the most basic commands. Think about 'listing' files."
```

## Adding a New Lab Exercise

1. Navigate to the appropriate objective directory (0-9)
2. Create a new `.sh` file with prefix `lab_` (e.g., `lab_firewall.sh`)
3. Add the following content:

```bash
#!/bin/bash
# Objective X: [Objective Name]
# LAB: [Lab Title]

# Mark this as a lab exercise
IS_LAB=true
LAB_ID="unique_lab_id"

# Question text (prefix with [LAB] for menu display)
QUESTION="[LAB] Brief description of the lab task"
ANSWER="Summary of the solution"
HINT="Detailed hints with step-by-step guidance"

# Lab configuration
LAB_TITLE="Human Readable Lab Title"
LAB_TASK_COUNT=2  # Number of tasks in this lab

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "First task description" ;;
        1) echo "Second task description" ;;
    esac
}

# Prepare the lab environment (reset state before lab starts)
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    # Add commands to prepare/reset the environment
    # e.g., remove files, reset configurations, etc.
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check first task
    if [[ some_condition ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check second task
    if [[ some_other_condition ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}
```

**Example:** `questions/9/lab_firewall.sh`
```bash
#!/bin/bash
# Objective 9: Security
# LAB: Firewall Configuration

IS_LAB=true
LAB_ID="firewall"

QUESTION="[LAB] Configure firewall to allow HTTP and HTTPS traffic"
ANSWER="Use firewall-cmd to add http and https services permanently"
HINT="Use 'firewall-cmd --permanent --add-service=http' and similar for https.\nDon't forget to reload with 'firewall-cmd --reload'."

LAB_TITLE="Firewall Configuration"
LAB_TASK_COUNT=3

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Enable and start firewalld service" ;;
        1) echo "Allow HTTP (port 80) through the firewall permanently" ;;
        2) echo "Allow HTTPS (port 443) through the firewall permanently" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Stopping firewalld...${RESET}"
    systemctl stop firewalld 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Removing existing rules...${RESET}"
    firewall-cmd --permanent --remove-service=http 2>/dev/null
    firewall-cmd --permanent --remove-service=https 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if firewalld is running
    if systemctl is-active firewalld &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check HTTP service
    if firewall-cmd --list-services 2>/dev/null | grep -q "http"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check HTTPS service
    if firewall-cmd --list-services 2>/dev/null | grep -q "https"; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}
```

## File Naming Convention

- **Questions:** `q1.sh`, `q2.sh`, `q3.sh`, etc.
- **Labs:** `lab_<name>.sh` (e.g., `lab_hostname.sh`, `lab_firewall.sh`)

Files are sorted alphabetically, so `lab_*` files will appear before `q*` files.
If you want labs to appear in a specific order, use numbering like:
- `lab_01_hostname.sh`
- `lab_02_firewall.sh`
- `q01.sh`
- `q02.sh`

## Available Variables in Lab Functions

The following variables are available from the main script:
- `${DIM}` - Dim text formatting
- `${RESET}` - Reset formatting
- `${GREEN}` - Green text
- `${RED}` - Red text
- `${YELLOW}` - Yellow text
- `${CYAN}` - Cyan text

## Tips

1. **Test your questions/labs:** Run the main RHCSA script and navigate to your new question to test it
2. **Keep hints helpful:** Provide enough guidance without giving away the answer
3. **Lab preparation:** Always reset the environment to a known state so students can retry
4. **Task checks:** Make checks specific enough to validate correct completion
