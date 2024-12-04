## 05- List and identify SELinux file and process context:

### **RHCSA Exam Topic: List and Identify SELinux File and Process Contexts**

In the RHCSA exam, understanding how to **list and identify SELinux file and process contexts** is crucial for securing and troubleshooting a system that uses SELinux, especially on **RHEL 9**.


---

### **1. What is SELinux Context?**

Each SELinux context consists of four parts:

- **User**: SELinux user (often `system_u`, `user_u`, or `unconfined_u`).
- **Role**: Role assigned to the user (commonly `object_r` for files).
- **Type**: Most important part, defines what processes and objects can interact. For example, `httpd_sys_content_t` for web content.
- **Level**: Security level (used with MLS/MCS systems, typically not configured in default RHEL).

#### **Example SELinux Context**:
```
system_u:object_r:httpd_sys_content_t:s0
```

---

### **2. Listing and Identifying File Contexts**

To view the SELinux context of files, you can use `ls` with the `-Z` option. This provides the security context of files and directories.

#### **Example: List File Contexts**:

```bash
ls -Z /path/to/directory
```

#### **Expected Output**:
```bash
-rw-r--r--. root root system_u:object_r:etc_t:s0  /etc/passwd
drwxr-xr-x. root root system_u:object_r:bin_t:s0  /usr/bin
```

- `system_u`: SELinux user.
- `object_r`: SELinux role (typically `object_r` for files).
- `etc_t`, `bin_t`: Type labels, which are important for access control.

---

### **3. Persistent Changes to File Contexts**

For the RHCSA exam, it’s important to know how to set file contexts **permanently**. This involves changing the context and ensuring the changes persist across reboots or relabels.

#### **Step 1: View File Context**

To identify the current SELinux context of a file:

```bash
ls -Z /path/to/file
```

#### **Step 2: Change File Context**

To change a file’s SELinux context permanently, use the `semanage fcontext` command. This will update the file context in SELinux’s database and ensure the change persists after a system relabel or reboot.

```bash
sudo semanage fcontext -a -t <type> /path/to/file
```

For example, to change the context of a file to `httpd_sys_content_t` (used for serving HTTP content):

```bash
sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/html(/.*)?"
```

This command will set the context for `/var/www/html` and all subfiles (`/.*`).

#### **Step 3: Apply File Contexts**

To apply the new context to files, use the `restorecon` command. This will enforce the context you set in the system.

```bash
sudo restorecon -Rv /var/www/html
```

- `-R`: Recursively apply to all files in the directory.
- `-v`: Verbose output to show changes being made.

---

### **4. Listing and Identifying Process Contexts**

To view the SELinux context of running processes, use the `ps` command with the `-Z` option.

#### **Example: List Process Contexts**:

```bash
ps -eZ | grep <process_name>
```

#### **Expected Output**:
```bash
system_u:system_r:httpd_t:s0    2456 ?        00:00:01 httpd
```

In this output:

- `system_u`: The SELinux user.
- `system_r`: The role.
- `httpd_t`: The type, which defines the domain or type for the `httpd` process.
- `s0`: Security level (not commonly modified in most RHCSA tasks).

---

### **5. Persistent Changes to Process Contexts**

To configure processes with the correct context, you typically ensure that the binaries they execute have the correct file context. SELinux uses the context of the executable file to determine the process context.

For example, ensuring the correct context for a web server:

1. **View the context of the executable**:
   ```bash
   ls -Z /usr/sbin/httpd
   ```

2. **Modify the context of the binary if needed**:
   ```bash
   sudo semanage fcontext -a -t httpd_exec_t /usr/sbin/httpd
   ```

3. **Apply the context**:
   ```bash
   sudo restorecon -v /usr/sbin/httpd
   ```

If the binary has the correct context (`httpd_exec_t` in this case), the process will automatically start with the appropriate process context.

---

### **6. Example RHCSA-Style Questions and Answers**

#### **Question 1: List the SELinux context of all files in `/var/www/html`.**

**Task:** Use a command to list the SELinux context of the `/var/www/html` directory.

**Answer:**
```bash
ls -Z /var/www/html
```

---

#### **Question 2: Persistently change the context of `/var/www/html` to serve HTTP content.**

**Task:** Change the SELinux context of `/var/www/html` to `httpd_sys_content_t` so that it can be used for web serving, and ensure the changes are persistent.

**Answer:**

1. Add the new context rule:
   ```bash
   sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/html(/.*)?"
   ```

2. Apply the new context to files:
   ```bash
   sudo restorecon -Rv /var/www/html
   ```

---

#### **Question 3: List the SELinux context of the `httpd` process.**

**Task:** Use a command to list the SELinux context of the `httpd` process.

**Answer:**
```bash
ps -eZ | grep httpd
```

---

### **7. Make the Changes Persistent**

- **File Context Changes**: Use `semanage fcontext` to add the new context to SELinux's policy database, ensuring that even after a reboot or relabel, the changes remain in place.
- **Process Context**: The context of processes is automatically managed based on the file context of the executable. Ensuring the correct context on executables is key to persistent process contexts.

---

### **Summary of RHCSA Skills for SELinux File and Process Contexts**

1. **List File Contexts**: Use `ls -Z` to list the SELinux contexts of files and directories.
2. **Change File Contexts Permanently**: Use `semanage fcontext -a` to add persistent rules for file contexts, followed by `restorecon` to apply the changes.
3. **List Process Contexts**: Use `ps -eZ` to view SELinux contexts for running processes.
4. **Ensure Process Contexts**: Modify the context of executable files to ensure processes run in the correct SELinux domain.

