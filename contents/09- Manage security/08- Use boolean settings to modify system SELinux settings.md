## 08- Use boolean settings to modify system SELinux settings:

### **RHCSA Exam Topic: Use Boolean Settings to Modify System SELinux Settings (RHEL 9)**

In the **RHCSA exam**, understanding how to modify system behavior using SELinux Boolean settings is crucial. SELinux Booleans allow you to toggle specific features or restrictions without having to alter the SELinux policy directly. These Booleans are typically used to enable or disable optional security policies for different services.

---

### **Key Concepts for Managing SELinux Boolean Settings**

1. **View Current Boolean Settings**: 
   You can list all SELinux Boolean settings to see what’s currently available and their current states.

2. **Change Boolean Settings**: 
   You can enable or disable SELinux Booleans temporarily or persistently to adjust the system's security behavior.

3. **Persisting Boolean Changes**: 
   Temporary changes revert after a reboot, but persistent changes ensure the Boolean remains in effect even after restarting.

---

### **1. Viewing SELinux Boolean Settings**

You can list the current state of SELinux Booleans using the `getsebool` or `semanage boolean` command.

#### **Command**:
```bash
sudo getsebool -a
```

This command lists all SELinux Booleans along with their current states (on or off).

Alternatively, you can use `semanage boolean -l` to display a list of Booleans along with a brief description.

#### **Example**:
```bash
sudo getsebool -a | grep httpd
```

Output:
```
httpd_can_network_connect --> off
httpd_can_sendmail --> off
httpd_enable_cgi --> on
```

---

### **2. Temporarily Changing an SELinux Boolean**

To temporarily enable or disable a Boolean, use the `setsebool` command. This change only lasts until the next reboot unless explicitly made persistent.

#### **Command Syntax**:
```bash
sudo setsebool <boolean_name> on|off
```

#### **Example**:

Enable the `httpd_can_network_connect` Boolean to allow HTTPD to initiate network connections:
```bash
sudo setsebool httpd_can_network_connect on
```

You can verify the change with:
```bash
sudo getsebool httpd_can_network_connect
```

Output:
```
httpd_can_network_connect --> on
```

---

### **3. Making Boolean Changes Persistent**

To ensure the change persists across reboots, use the `-P` option with the `setsebool` command.

#### **Command**:
```bash
sudo setsebool -P <boolean_name> on|off
```

#### **Example**:

To persistently allow HTTPD to initiate network connections:
```bash
sudo setsebool -P httpd_can_network_connect on
```

This will keep the setting active even after rebooting the system.

---

### **4. Listing and Describing SELinux Booleans**

To get a list of SELinux Booleans and their descriptions, which provide information on what they control, use the `semanage boolean -l` command.

#### **Command**:
```bash
sudo semanage boolean -l
```

This lists all the Booleans and their descriptions. For example, the `httpd_can_network_connect` Boolean controls whether HTTPD can make network connections.

---

### **5. Example RHCSA Exam Questions and Answers**

#### **Question 1: Enable a Boolean to allow HTTPD to make network connections persistently**

**Task**: Configure the system to allow the HTTPD service to make network connections. Ensure the change is persistent across reboots.

**Answer**:
1. Set the Boolean:
   ```bash
   sudo setsebool -P httpd_can_network_connect on
   ```

2. Verify the change:
   ```bash
   sudo getsebool httpd_can_network_connect
   ```

---

#### **Question 2: Disable a Boolean to prevent HTTPD from sending mail persistently**

**Task**: Disable the `httpd_can_sendmail` Boolean to prevent HTTPD from sending mail. Make sure the change is persistent.

**Answer**:
1. Disable the Boolean:
   ```bash
   sudo setsebool -P httpd_can_sendmail off
   ```

2. Verify the change:
   ```bash
   sudo getsebool httpd_can_sendmail
   ```

---

#### **Question 3: List all Booleans related to the FTP service**

**Task**: Display all SELinux Booleans related to FTP services on the system.

**Answer**:
```bash
sudo getsebool -a | grep ftp
```

Example Output:
```
ftp_home_dir --> on
ftpd_anon_write --> off
ftpd_use_passive_mode --> on
```

---

### **6. Persistent Changes for SELinux Booleans**

SELinux Boolean settings are made persistent by using the `-P` option in the `setsebool` command. Without `-P`, the changes will revert after a reboot.

---

### **Summary**

For the **RHCSA exam** on **RHEL 9**, you need to be able to:

1. **View SELinux Booleans** using `getsebool -a` or `semanage boolean -l`.
2. **Change SELinux Booleans temporarily** with `setsebool`.
3. **Make persistent changes** using `setsebool -P` to ensure the settings survive reboots.
