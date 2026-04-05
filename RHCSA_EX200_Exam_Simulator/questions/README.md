# RHCSA Questions and Labs - Contribution Guide

## 🎉 Welcome Contributors!

This is an **open source project** and we need your help! Currently, only **Chapter 01 (Understand and use essential tools)** has complete questions. We're looking for contributors to help add questions for chapters 2-10.

**Your contributions will help thousands of RHCSA exam candidates worldwide!**

---

## 🚀 How to Contribute

### Quick Start (3 Simple Steps)

1. **Fork the repository** on GitHub: https://github.com/RHCSA/RHCSA.github.io
2. **Add your question/lab** following the templates below
3. **Submit a Pull Request** - we'll review and merge it!

### What We Need

| Chapter | Topic | Status |
|---------|-------|--------|
| 1 | Understand and use essential tools | ✅ Complete (75+ labs) |
| 2 | Manage software | ❌ Needs questions |
| 3 | Create simple shell scripts | ❌ Needs questions |
| 4 | Operate running systems | ❌ Needs questions |
| 5 | Configure local storage | ❌ Needs questions |
| 6 | Create and configure file systems | ❌ Needs questions |
| 7 | Deploy, configure, and maintain systems | ❌ Needs questions |
| 8 | Manage basic networking | ❌ Needs questions |
| 9 | Manage users and groups | ❌ Needs questions |
| 10 | Manage security | ❌ Needs questions |

---

## 📁 Directory Structure

```
questions/
├── 1/   # Chapter 01: Understand and use essential tools ✅
├── 2/   # Chapter 02: Manage software
├── 3/   # Chapter 03: Create simple shell scripts
├── 4/   # Chapter 04: Operate running systems
├── 5/   # Chapter 05: Configure local storage
├── 6/   # Chapter 06: Create and configure file systems
├── 7/   # Chapter 07: Deploy, configure, and maintain systems
├── 8/   # Chapter 08: Manage basic networking
├── 9/   # Chapter 09: Manage users and groups
└── 10/  # Chapter 10: Manage security
```

---

## 🧪 Adding a New Lab Exercise (Hands-on Practice)

Labs are interactive exercises where students complete tasks in a real terminal. This is the **recommended format** for RHCSA practice!

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

# Question text (displayed as lab title)
QUESTION="Brief description of the lab task"

# Lab configuration
LAB_TASK_COUNT=2  # Number of tasks in this lab

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="First task description"
TASK_1_HINT="Hint for task 1"
TASK_1_COMMAND_1="command to complete task 1"

# Task 2
TASK_2_QUESTION="Second task description"
TASK_2_HINT="Hint for task 2"
TASK_2_COMMAND_1="command to complete task 2"

# Auto-generate HINT from commands (uses helper function from TUI)
HINT=$(_build_hint)

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

QUESTION="Configure firewall to allow HTTP and HTTPS traffic"

LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS
# =============================================================================

# Task 1
TASK_1_QUESTION="Enable and start firewalld service"
TASK_1_HINT="Use systemctl to enable and start the service"
TASK_1_COMMAND_1="systemctl enable --now firewalld"

# Task 2
TASK_2_QUESTION="Allow HTTP (port 80) through the firewall permanently"
TASK_2_HINT="Use firewall-cmd with --permanent flag"
TASK_2_COMMAND_1="firewall-cmd --permanent --add-service=http"

# Task 3
TASK_3_QUESTION="Allow HTTPS (port 443) through the firewall permanently"
TASK_3_HINT="Same as HTTP but for https service"
TASK_3_COMMAND_1="firewall-cmd --permanent --add-service=https"

# Auto-generate HINT from task commands
HINT=$(_build_hint)

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

---

## 📛 File Naming Convention

- **Labs:** `lab_<name>.sh` (e.g., `lab_hostname.sh`, `lab_firewall.sh`)


---

## 🎨 Available Variables in Lab Functions

The following variables are available from the main script:
- `${DIM}` - Dim text formatting
- `${RESET}` - Reset formatting
- `${GREEN}` - Green text
- `${RED}` - Red text
- `${YELLOW}` - Yellow text
- `${CYAN}` - Cyan text

---

## 💡 Tips for Contributors

1. **Test your questions/labs:** Run the main RHCSA script and navigate to your new question to test it
2. **Keep hints helpful:** Provide enough guidance without giving away the answer
3. **Lab preparation:** Always reset the environment to a known state so students can retry
4. **Task checks:** Make checks specific enough to validate correct completion

---

## 🔍 Example: Look at Existing Labs

The best way to learn is by example! Check out the existing labs in the `1/` directory:

```bash
ls -la questions/1/
```

Some good examples to study:
- `lab_chmod_symbolic.sh` - Simple file permissions lab
- `lab_tar_create.sh` - Archive creation lab
- `lab_grep_basic.sh` - Text searching lab

---

## 📝 Contribution Checklist

Before submitting your Pull Request:

- [ ] File is in the correct chapter directory (1-10)
- [ ] File has `.sh` extension
- [ ] File follows naming convention (`lab_*.sh` or `q*.sh`)
- [ ] `QUESTION` variable is clear and descriptive
- [ ] `HINT` provides helpful guidance
- [ ] For labs: `prepare_lab()` resets the environment properly
- [ ] For labs: `check_tasks()` correctly validates completion
- [ ] Tested on a RHEL/CentOS/Rocky Linux system

---

## 🤝 Need Help?

- **Questions?** Open an issue on GitHub
- **Found a bug?** Please report it!
- **Want to discuss ideas?** Start a GitHub Discussion

**Repository:** https://github.com/RHCSA/RHCSA.github.io

---

## 🏆 Contributors

Thank you to everyone who contributes to this project! Your work helps aspiring Linux system administrators achieve their RHCSA certification.

**Every contribution matters - even fixing a typo helps!**

---

*Made with ❤️*
