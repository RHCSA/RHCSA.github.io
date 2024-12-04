## 09- Diagnose and address routine SELinux policy violations:

### **RHCSA Exam Topic: Diagnose and Address Routine SELinux Policy Violations (RHEL 9)**

In the **RHCSA exam**, one of the critical topics is the ability to **diagnose and address SELinux policy violations**. SELinux (Security-Enhanced Linux) works by enforcing security policies that restrict services and users from performing actions outside their permitted range. Sometimes, SELinux blocks legitimate operations due to restrictive policies, and you need to diagnose and resolve these issues effectively.

---

### **Key Concepts for Diagnosing and Addressing SELinux Policy Violations**

1. **SELinux Modes**: 
   - **Enforcing**: SELinux enforces its policies and blocks non-permitted actions.
   - **Permissive**: SELinux logs violations but doesn't block actions.
   - **Disabled**: SELinux is turned off.

2. **Common Reasons for SELinux Policy Violations**:
   - Mislabeling of files.
   - Services trying to access files or network ports not permitted by the policy.
   - Booleans not set correctly to allow certain behaviors.

3. **Tools to Diagnose SELinux Violations**:
   - **Audit logs**: SELinux violations are logged in `/var/log/audit/audit.log`.
   - **ausearch**: Tool to search the audit log for SELinux issues.
   - **sealert**: Provides detailed information and recommendations for SELinux denials.
   - **restorecon**: Used to restore default SELinux file contexts.

---

### **1. Viewing SELinux Policy Violations (audit.log)**

The first step in diagnosing a violation is to check the audit log file where SELinux logs all denied operations.

#### **Command**:
```bash
sudo cat /var/log/audit/audit.log | grep AVC
```

This will display **Access Vector Cache (AVC)** denials, which are the key indicators of SELinux violations.

---

### **2. Using ausearch to Diagnose SELinux Violations**

You can use the `ausearch` command to filter the audit logs and focus on SELinux denials.

#### **Command**:
```bash
sudo ausearch -m avc -ts today
```

This command shows all AVC denials for the current day. You can also adjust the time range as needed.

#### Example Output:
```bash
type=AVC msg=audit(1630939395.265:221): avc:  denied  { write } for  pid=1292 comm="httpd" name="index.html" dev="sda1" ino=12345 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:default_t:s0 tclass=file
```

The important fields are:
- **denied**: Indicates the action was blocked.
- **comm**: The command/process responsible for the violation (e.g., `httpd`).
- **scontext**: The security context of the process.
- **tcontext**: The security context of the target file.

---

### **3. Resolving SELinux Policy Violations**

#### **Step 1: Mislabeling Files**

A common issue is mislabeling of files, where a file doesn't have the correct SELinux context. You can check the context of a file using the `ls -Z` command.

#### **Command**:
```bash
ls -Z /path/to/file
```

If the context is wrong, you can use `restorecon` to fix it.

#### **Command**:
```bash
sudo restorecon /path/to/file
```

This command restores the correct SELinux context for the file.

---

#### **Step 2: Troubleshooting with sealert**

You can use `sealert` from the **setroubleshoot** package to diagnose SELinux denials and get suggestions on how to fix them.

#### **Command**:
```bash
sudo sealert -a /var/log/audit/audit.log
```

This will provide a detailed explanation of SELinux denials and possible solutions.

#### Example Output:
```bash
SELinux is preventing /usr/sbin/httpd from write access to file /var/www/html/index.html.

You can resolve this issue by running:
restorecon -v /var/www/html/index.html
```

---

### **4. Persistent SELinux Changes**

Any changes you make must be **persistent**. For example, if a service is consistently blocked from accessing certain files due to policy, you might need to adjust **SELinux Booleans** or file contexts, and those changes should persist across reboots.

#### Example Scenario: HTTPD Access Denial

**Scenario**: Your web server (`httpd`) is denied access to `/var/www/html/index.html` because the file's context is incorrect.

1. **Diagnose the problem**:
   ```bash
   sudo ausearch -m avc -ts today
   ```

   Output:
   ```
   avc:  denied  { write } for  pid=1292 comm="httpd" name="index.html"
   ```

2. **Check the file's context**:
   ```bash
   ls -Z /var/www/html/index.html
   ```

   Output (incorrect context):
   ```
   unconfined_u:object_r:default_t:s0 index.html
   ```

3. **Restore the correct context**:
   ```bash
   sudo restorecon /var/www/html/index.html
   ```

4. **Verify the change**:
   ```bash
   ls -Z /var/www/html/index.html
   ```

   Correct Output:
   ```
   system_u:object_r:httpd_sys_content_t:s0 index.html
   ```

---

### **5. Example RHCSA Exam Questions and Answers**

#### **Question 1: Diagnose and resolve a violation where HTTPD is denied access to a web page**

**Task**: The `httpd` service is unable to access a web page in `/var/www/html`. Diagnose the issue and fix it. Ensure the solution is persistent.

**Answer**:
1. Search for AVC denials:
   ```bash
   sudo ausearch -m avc -ts today
   ```

2. Check the file's context:
   ```bash
   ls -Z /var/www/html/index.html
   ```

3. Restore the correct context:
   ```bash
   sudo restorecon /var/www/html/index.html
   ```

4. Verify that `httpd` can now access the file.

---

#### **Question 2: Enable a service to run in a context allowed by SELinux**

**Task**: You have installed an FTP service, but SELinux is preventing it from accessing users' home directories. Diagnose the problem and make the required changes to allow access. Ensure the solution is persistent.

**Answer**:
1. Use `ausearch` to find the AVC denials related to FTP:
   ```bash
   sudo ausearch -m avc -ts today
   ```

2. Check for any Booleans related to FTP access:
   ```bash
   sudo getsebool -a | grep ftp
   ```

3. Enable the required Boolean:
   ```bash
   sudo setsebool -P ftp_home_dir on
   ```

---

### **Summary**

For the **RHCSA exam** on **RHEL 9**, diagnosing and addressing SELinux policy violations includes:

1. **Checking SELinux violations** using audit logs and `ausearch`.
2. **Restoring file contexts** with `restorecon`.
3. **Using sealert** to get suggestions on how to resolve SELinux issues.
4. **Making changes persistent** using the correct flags or commands, such as `-P` for Booleans or restoring contexts permanently.
