## 11- Locate, read, and use system documentation including man, info, and files in  usr share doc

The RHCSA exam topic **"Locate, read, and use system documentation including man, info, and files in /usr/share/doc"** is crucial for system administration. As a Linux administrator, you must be able to find and use documentation effectively to resolve issues, understand command options, and configure services. On the RHCSA exam, you will likely need to reference **man pages**, **info pages**, and files in **`/usr/share/doc`** to understand commands and configuration options.

---

### **What You Need to Know:**
1. **Man pages**: A core source of documentation for commands and system configuration.
2. **Info pages**: An alternative and often more detailed documentation system.
3. **`/usr/share/doc`**: A directory containing additional documentation, including configuration examples, licenses, and more.
4. **`apropos` and `whatis`**: Useful commands for finding relevant man pages when you don’t know the exact command.
5. **`help`** and **`--help`**: For quick reference on built-in shell commands or program options.

---

### **1. Using `man` Pages**

Man (manual) pages are the primary source of documentation for most Linux commands. Each man page is divided into sections, with sections 1 (commands), 5 (file formats), and 8 (system administration commands) being the most commonly used for the RHCSA.

#### **Example Task 1: View the Man Page for a Command**

**Task:** Display the man page for the `tar` command.

**Command:**
```bash
man tar
```

**Explanation:**
- **`man tar`** opens the man page for the `tar` command, showing usage, options, and examples.
- You can scroll through the man page using the **arrow keys** or press **`q`** to quit.

#### **Example Task 2: Find Information on a Specific Option in a Man Page**

**Task:** Use the man page to find the option for creating a compressed gzip archive with `tar`.

**Command:**
1. Open the `tar` man page:
   ```bash
   man tar
   ```
2. Search for "gzip" by typing:
   ```bash
   /gzip
   ```

**Explanation:**
- **`/gzip`** allows you to search for the word "gzip" within the man page. This will show the `-z` option, which is used to compress with gzip.

---

### **2. Using `info` Pages**

**Info pages** are an alternative to man pages and often provide more detailed explanations, especially for GNU utilities.

#### **Example Task 3: View the Info Page for `tar`**

**Task:** Use the `info` system to view the documentation for `tar`.

**Command:**
```bash
info tar
```

**Explanation:**
- **`info tar`** opens the info page for `tar`, which might provide more in-depth information than the man page.
- You can navigate through the **info** page by using the arrow keys or pressing **`q`** to quit.

---

### **3. Using `/usr/share/doc`**

The **`/usr/share/doc`** directory contains additional documentation installed with packages, such as example configuration files, changelogs, and package-specific documentation.

#### **Example Task 4: Locate Documentation for a Specific Package**

**Task:** Find the additional documentation for the `httpd` package.

**Command:**
```bash
ls /usr/share/doc/httpd
```

**Explanation:**
- **`/usr/share/doc/httpd`** contains documentation for the `httpd` (Apache) package, such as the README, configuration examples, and more.

#### **Example Task 5: View a README File from `/usr/share/doc`**

**Task:** Read the README file for the `httpd` package.

**Command:**
```bash
cat /usr/share/doc/httpd/README
```

**Explanation:**
- **`cat`** displays the contents of the README file, which often contains useful information about the software package.

---

### **4. Searching for Relevant Documentation Using `apropos` and `whatis`**

If you don’t know the exact name of a command or need to find relevant commands for a specific task, you can use **`apropos`** and **`whatis`**.

#### **Example Task 6: Find Commands Related to Archiving**

**Task:** Use `apropos` to find commands related to archiving.

**Command:**
```bash
apropos archive
```

**Explanation:**
- **`apropos archive`** lists all commands and man pages related to archiving, such as `tar` and `gzip`. This is useful when you’re unsure of the exact command to use.

---

### **5. Using `--help` and Built-In Shell `help`**

Many commands have a `--help` option that provides a brief summary of the command’s usage and options. This is faster than reading the full man or info page.

#### **Example Task 7: Display Quick Help for the `cp` Command**

**Task:** Display the usage options for the `cp` command using `--help`.

**Command:**
```bash
cp --help
```

**Explanation:**
- **`cp --help`** shows a short description of the `cp` command’s usage and options, such as how to copy files recursively or preserve file attributes.

#### **Example Task 8: Get Help for a Built-In Shell Command**

**Task:** Display the built-in shell help for the `cd` command.

**Command:**
```bash
help cd
```

**Explanation:**
- **`help cd`** shows help for the `cd` command, which is built into the shell. This differs from man pages and is used for shell-specific commands like `cd`, `echo`, and `exit`.

---

### **6. Using Specific Sections of Man Pages**

Man pages are organized into sections, and sometimes multiple commands share the same name but belong to different sections. For example, `man 5 passwd` gives the documentation for the `passwd` file format, while `man 1 passwd` gives the documentation for the `passwd` command.

#### **Example Task 9: View the Man Page for the `passwd` File Format**

**Task:** View the man page for the `passwd` file (section 5).

**Command:**
```bash
man 5 passwd
```

**Explanation:**
- **`man 5 passwd`** displays the format and description of the `/etc/passwd` file, which contains user account information.

---

### **Summary of Skills for RHCSA Exam on System Documentation:**
1. **Locate and read man pages** for commands and configuration files.
2. **Use info pages** to get detailed information, especially for GNU utilities.
3. **Access documentation in `/usr/share/doc`** for specific packages.
4. **Search for relevant documentation** using `apropos` and `whatis`.
5. **Use `--help` and `help`** for quick reference on commands and shell built-ins.
6. **Understand how to access different sections** of man pages (e.g., `man 1`, `man 5`, `man 8`).
