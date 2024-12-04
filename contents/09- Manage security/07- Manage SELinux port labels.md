## 07- Manage SELinux port labels:

### **RHCSA Exam Topic: Manage SELinux Port Labels**

In the **RHCSA exam**, managing **SELinux port labels** is an important topic. SELinux associates specific ports with services for enhanced security. If a service attempts to use a port that is not labeled correctly for that service, SELinux may deny access. You need to know how to view, add, modify, and delete SELinux port labels for services to ensure that they work correctly while maintaining security.

---

### **Key Concepts for Managing SELinux Port Labels**

1. **View Current Port Labels**: 
   The command `semanage port -l` is used to view existing port labels. This displays the ports and their associated SELinux types.

2. **Add or Modify SELinux Port Labels**: 
   If a service needs to run on a port that SELinux doesn't associate with it, you can modify or add a port label using the `semanage port` command.

3. **Delete SELinux Port Labels**: 
   You can remove a port label if it's no longer needed for a service.

---

### **1. View SELinux Port Labels**

To view all port labels associated with SELinux, use the `semanage port -l` command.

#### **Command**:
```bash
sudo semanage port -l
```

This lists all the ports and their associated SELinux contexts. You can narrow it down by searching for specific services or ports.

#### **Example**:
View all ports labeled for HTTP (web traffic):
```bash
sudo semanage port -l | grep http
```

Output (example):
```
http_port_t                    tcp      80, 443, 488, 8008, 8009, 8443
```

---

### **2. Add or Modify an SELinux Port Label**

If a service requires a custom port, you can assign it the appropriate SELinux context using the `semanage port` command.

#### **Command Syntax**:
```bash
sudo semanage port -a -t <SELinux_type> -p <protocol> <port_number>
```

- **-a**: Add a new port label.
- **-t**: Specify the SELinux type (e.g., `http_port_t` for HTTP).
- **-p**: Specify the protocol (`tcp` or `udp`).
- **port_number**: The port number to be labeled.

#### **Example**:

Suppose you want to allow the HTTP service to listen on port `8080`. You would add a new port label as follows:

```bash
sudo semanage port -a -t http_port_t -p tcp 8080
```

This command labels TCP port 8080 for HTTP services (`http_port_t`).

You can verify the change:
```bash
sudo semanage port -l | grep 8080
```

Output:
```
http_port_t                    tcp      8080
```

---

### **3. Modify an Existing Port Label**

If a service’s SELinux port label needs to be modified (e.g., if you need to change the protocol), you can use `-m` instead of `-a` to modify the label.

#### **Command**:
```bash
sudo semanage port -m -t <SELinux_type> -p <protocol> <port_number>
```

#### **Example**:

Change port `8080` from `tcp` to `udp` for HTTP:
```bash
sudo semanage port -m -t http_port_t -p udp 8080
```

---

### **4. Remove an SELinux Port Label**

To remove a custom SELinux port label, use the `-d` option with `semanage port`.

#### **Command**:
```bash
sudo semanage port -d -t <SELinux_type> -p <protocol> <port_number>
```

#### **Example**:

Remove the port label for `8080` (assuming it was previously labeled for `http_port_t`):
```bash
sudo semanage port -d -t http_port_t -p tcp 8080
```

You can confirm the removal with:
```bash
sudo semanage port -l | grep 8080
```

---

### **5. Example RHCSA Exam Questions and Answers**

#### **Question 1: Assign a new SELinux label to a custom HTTP port**

**Task**: Configure SELinux to allow the HTTP service to listen on port `8081`. Verify the change.

**Answer**:
1. Add the new SELinux label for HTTP on port `8081`:
   ```bash
   sudo semanage port -a -t http_port_t -p tcp 8081
   ```

2. Verify the change:
   ```bash
   sudo semanage port -l | grep 8081
   ```

---

#### **Question 2: Remove a custom SELinux port label**

**Task**: Remove the SELinux port label for HTTP service on port `8081`.

**Answer**:
1. Remove the port label:
   ```bash
   sudo semanage port -d -t http_port_t -p tcp 8081
   ```

2. Verify the removal:
   ```bash
   sudo semanage port -l | grep 8081
   ```

---

#### **Question 3: List all SELinux labels for ports associated with SSH**

**Task**: Display all ports labeled for SSH.

**Answer**:
```bash
sudo semanage port -l | grep ssh
```

Output (example):
```
ssh_port_t                     tcp      22
```

---

### **6. Persistent Changes for SELinux Port Labels**

Changes made to SELinux port labels using `semanage` are **persistent** across reboots. Once added, modified, or removed, the new port label configuration remains in place until changed manually again.

---

### **Summary**

For the **RHCSA exam** on **RHEL 9**, managing SELinux port labels involves knowing how to view, add, modify, and delete port labels. You should be able to:

1. **List SELinux port labels** using `semanage port -l`.
2. **Add new port labels** with `semanage port -a`.
3. **Modify existing port labels** using `semanage port -m`.
4. **Delete port labels** with `semanage port -d`.
