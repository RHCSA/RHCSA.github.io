## 06- Restore default file contexts:

### **RHCSA Exam Topic: Restore Default File Contexts**

In the **RHCSA exam**, restoring the default SELinux file contexts is a key task. SELinux uses contexts to manage access control for files, processes, and ports, and it’s important to know how to restore these contexts to their defaults in case they are changed or corrupted.

---

### **1. Understanding Default File Contexts**

SELinux defines default contexts for files based on their location and usage. For example, web content in `/var/www` should have the context `httpd_sys_content_t`, while configuration files in `/etc` should have contexts like `etc_t`.

Sometimes, file contexts may be modified or set incorrectly due to manual changes or package installation. In such cases, restoring the correct SELinux contexts is important for security and system functionality.

---

### **2. How to Restore Default File Contexts**

The primary command to restore default SELinux contexts is `restorecon`. This command reads the default context from the SELinux policy and applies it to files and directories.

#### **Command**:
```bash
restorecon -Rv /path/to/file_or_directory
```

- **-R**: Recursively apply to directories.
- **-v**: Verbose mode to display the changes made.

#### **Example**:
To restore the default SELinux context for files in `/var/www/html`:

```bash
sudo restorecon -Rv /var/www/html
```

This will scan the `/var/www/html` directory and reset any SELinux contexts to the policy-defined defaults.

---

### **3. Example RHCSA Exam Questions and Answers**

#### **Question 1: Restore the default SELinux context for the `/var/www/html` directory.**

**Task**: The SELinux contexts for some files in the `/var/www/html` directory have been modified. Use a command to restore the default SELinux context for the entire directory.

**Answer**:
```bash
sudo restorecon -Rv /var/www/html
```

This command will recursively restore the correct contexts for all files and directories under `/var/www/html` based on the SELinux policy.

---

#### **Question 2: Ensure persistent SELinux contexts for a file that has been manually modified.**

**Task**: A file `/etc/myconfig.conf` has had its context changed. Restore the default context and ensure it is set persistently.

**Answer**:

1. Restore the default context:
   ```bash
   sudo restorecon -v /etc/myconfig.conf
   ```

2. Confirm the default context is applied:
   ```bash
   ls -Z /etc/myconfig.conf
   ```

---

### **4. Persistent Changes with `restorecon`**

The `restorecon` command restores default file contexts **persistently** based on the current SELinux policy. Once you run `restorecon`, the changes are permanent unless the file context is changed again manually or by another process.

---

### **5. Use of `semanage fcontext` for Long-Term Context Management**

In some cases, SELinux contexts might need to be modified. The **`semanage fcontext`** command is used to add new rules for file contexts, but these new contexts can always be restored using `restorecon` if needed.

---

### **6. Checking SELinux Contexts**

Before restoring, you can check the current context of a file using the `ls -Z` command.

#### **Command**:
```bash
ls -Z /path/to/file
```

This will show the current SELinux context of the file, and you can compare it with what the policy expects.

---

### **7. Verifying Default Contexts**

To verify whether a file's context is the expected default one, you can use `matchpathcon`, which shows the default context based on the SELinux policy.

#### **Command**:
```bash
matchpathcon /path/to/file
```

#### **Example**:
```bash
matchpathcon /var/www/html
```

This will return the expected SELinux context for `/var/www/html`. You can compare this with the actual context shown by `ls -Z`.

---

### **8. Example RHCSA-Style Scenario**

#### **Scenario**:
After an update, some files in the `/etc` directory have incorrect SELinux contexts, causing services to fail. You need to restore the SELinux contexts of the entire `/etc` directory to their default state.

#### **Solution**:

1. **List the SELinux contexts** for the files in `/etc`:
   ```bash
   ls -Z /etc
   ```

2. **Restore the default SELinux contexts**:
   ```bash
   sudo restorecon -Rv /etc
   ```

This will scan all files in the `/etc` directory and restore them to their default contexts as defined by the SELinux policy.

---

### **Key Concepts for the RHCSA Exam**

1. **Command**: Use `restorecon` to restore default file contexts.
2. **Persistent Changes**: `restorecon` makes changes persistent by applying the correct context based on the SELinux policy.
3. **Check Contexts**: Use `ls -Z` to check the current context of files and `matchpathcon` to see the expected default context.
4. **Recursion**: Use `-R` with `restorecon` to restore contexts recursively for entire directories.

---

### **Summary**

In the RHCSA exam, knowing how to **restore default SELinux file contexts** is essential for maintaining the system's security and functionality. On **RHEL 9**, using the `restorecon` command is the primary way to ensure that files and directories have the correct, policy-defined SELinux contexts.
