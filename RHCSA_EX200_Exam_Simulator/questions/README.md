# Question and Lab File Format

This file tells how to write a lab or a question for the simulator. For the steps to send your change (fork, branch, test, pull request), read [CONTRIBUTING.md](../../CONTRIBUTING.md).

## Folders

Each folder is one RHCSA EX200 objective. The simulator shows all `.sh` files of a folder, sorted by file name.

| Folder | Objective | Content (2026-11-15) |
|---|---|---|
| 1 | Understand and use essential tools | 81 labs, 1 question |
| 2 | Manage software | 12 labs |
| 3 | Create simple shell scripts | 23 labs |
| 4 | Operate running systems | 11 labs, 4 questions |
| 5 | Configure local storage | 10 labs |
| 6 | Create and configure file systems | Help wanted |
| 7 | Deploy, configure, and maintain systems | 3 labs |
| 8 | Manage basic networking | 1 lab, 2 demo labs |
| 9 | Manage users and groups | Help wanted |
| 10 | Manage security | Help wanted |

Each folder also has a `more_questions_will_be_added_here_<N>.sh` placeholder.

## File types

| Type | File name | Use it when |
|---|---|---|
| Lab | `lab_<name>.sh` | The student can do the task in a terminal and a script can check the result. Use a lab when possible. |
| Question | `question_<name>.sh` | A lab cannot do it, for example a reboot into GRUB or a root password reset. |

## Lab template

```bash
#!/bin/bash
# Objective N: <objective name>
# LAB: <lab title>

IS_LAB=true
LAB_ID="unique_lab_id"

QUESTION="One line that tells what the lab is about"
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, answer, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Set /tmp/script.sh to 755 (rwxr-xr-x)"
TASK_1_ANSWER="Use chmod with octal mode 755"
TASK_1_COMMAND_1="chmod 755 /tmp/script.sh"

# Task 2
TASK_2_QUESTION="Set /tmp/private.txt to 600 (rw-------)"
TASK_2_ANSWER="Use chmod with octal mode 600"
TASK_2_COMMAND_1="chmod 600 /tmp/private.txt"

# Prepare the lab environment (runs before the student starts)
prepare_lab() {
    echo -e "  ${DIM}• Creating test files...${RESET}"
    touch /tmp/script.sh /tmp/private.txt
    chmod 644 /tmp/script.sh /tmp/private.txt
    sleep 0.3
}

# Check task completion - TASK_STATUS[0] is task 1
check_tasks() {
    if [[ "$(stat -c %a /tmp/script.sh 2>/dev/null)" == "755" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    if [[ "$(stat -c %a /tmp/private.txt 2>/dev/null)" == "600" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Remove everything the lab made (runs when the student stops the lab)
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/script.sh /tmp/private.txt
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
```

A real lab of this type: [1/lab_chmod_octal.sh](1/lab_chmod_octal.sh).

### Lab fields

| Name | Required | What it does |
|---|---|---|
| `IS_LAB=true` | Yes | Marks the file as a lab. |
| `LAB_ID` | Yes | Unique ID. Do not use the same ID in two files. |
| `QUESTION` | Yes | Lab title in the list and at the top of the lab. |
| `YOUTUBE_VIDEO` | No | Video in the **Lab Video Practice** tab. |
| `LAB_TASK_COUNT` | Yes | Number of tasks (1 to 10). |
| `TASK_N_QUESTION` | Yes | Text of task N. |
| `TASK_N_ANSWER` | No | Short explanation. The **Answer** button shows it above the commands. |
| `TASK_N_COMMAND_1` to `TASK_N_COMMAND_9` | Yes (at least 1) | Commands that do task N. The **Answer** panel shows them with **Copy** and **Send** buttons. |
| `prepare_lab()` | Yes | Puts the system in a known state. |
| `check_tasks()` | Yes | Sets `TASK_STATUS[i]` to `"true"` or `"false"`. Index 0 is task 1. |
| `cleanup_lab()` | Yes | Removes what the lab made and puts back system files. |

Old files use `TASK_N_HINT` instead of `TASK_N_ANSWER`. The old name still works, but use `TASK_N_ANSWER` in new files.

### Optional features

| Feature | What it does | Example |
|---|---|---|
| `check_prerequisites()` | Sets `PREREQ_OK=false` and `PREREQ_MESSAGE` when the machine cannot run the lab. The lab does not start. | [5/lab_lvm_pv_vg_lv.sh](5/lab_lvm_pv_vg_lv.sh) |
| `prepare_lab_2()`, `prepare_lab_3()` ... | Adds more terminal tabs. `PREPARE_LAB_N_NAME` sets the tab name. `PREPARE_LAB_N_COMMAND` runs a command in the tab. | [8/lab_multi_terminal_demo.sh](8/lab_multi_terminal_demo.sh) |
| Container lab | Starts a Rocky Linux 10 container and connects the terminal to it. | [2/lab_container_install_httpd.sh](2/lab_container_install_httpd.sh) |
| Values from `prepare_lab` | Shows a value that `prepare_lab` selects (a disk name, a PID) in the task text. Save the value in a state file and read it at the top of the lab file. | [5/lab_lvm_pv_vg_lv.sh](5/lab_lvm_pv_vg_lv.sh) |

## Question template

```bash
#!/bin/bash
# Objective N: <objective name>
# Question: <title>

QUESTION="You forgot the root password. Reset it without reinstalling the system."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"
ANSWER="1. Reboot the system.
2. At the GRUB menu, press the 'e' key.
3. ..."
```

A question has no `IS_LAB` line. The student clicks **Show Answer** to see `ANSWER`. Example: [4/question_reset_root_password.sh](4/question_reset_root_password.sh).

## Rules

1. Put each value in double quotes on its own `NAME="..."` line. The web interface reads the values with a regular expression, so do not put a double quote (`"`) inside a value. Use single quotes.
2. In `TASK_N_COMMAND_N`, write a literal `$` as `\$`. Example: `echo \$HOME`. If you do not, bash replaces `$HOME` when it loads the file. See [1/lab_here_document.sh](1/lab_here_document.sh).
3. Write `${VAR}` without `\` only for a variable that the lab file sets itself, for example `${DISK1}`.
4. Labs run as root on the real machine. Never change the disk that holds `/`. Make a backup of each system file in `prepare_lab()` and put it back in `cleanup_lab()`.
5. A check must not pass before the student does the task.
6. Use these colors in messages: `${DIM}`, `${RESET}`, `${GREEN}`, `${RED}`, `${YELLOW}`, `${CYAN}`.

## Checklist

- [ ] The file is in the correct folder (1 to 10) and has a `.sh` extension.
- [ ] The file name is `lab_<name>.sh` or `question_<name>.sh`.
- [ ] `LAB_ID` is unique.
- [ ] `LAB_TASK_COUNT` is the same as the number of tasks.
- [ ] Each task has `TASK_N_QUESTION` and at least `TASK_N_COMMAND_1`.
- [ ] Each literal `$` in a command is written `\$`.
- [ ] `check_tasks()` sets one `TASK_STATUS` entry for each task.
- [ ] `cleanup_lab()` removes everything that the lab made.
- [ ] You tested the lab on Rocky Linux 10 in the web interface.
