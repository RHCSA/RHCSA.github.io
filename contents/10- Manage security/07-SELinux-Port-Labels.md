# Manage SELinux Port Labels

## Overview

SELinux controls which network ports services can bind to. When you need to run a service on a non-standard port, you must add the appropriate SELinux port label. This is a key RHCSA exam objective.

---

## Understanding Port Labels

### How SELinux Port Control Works

- Each service type has allowed ports defined by SELinux policy
- A service can only bind to ports with matching labels
- Standard ports are pre-labeled (e.g., port 80 → `http_port_t`)
- Custom ports need labels added manually

### Common Port Types

| SELinux Type | Standard Ports | Service |
|--------------|----------------|---------|
| `http_port_t` | 80, 443, 8080 | Apache/nginx |
| `ssh_port_t` | 22 | SSH |
| `smtp_port_t` | 25, 465, 587 | Mail (SMTP) |
| `mysqld_port_t` | 3306 | MySQL/MariaDB |
| `dns_port_t` | 53 | DNS (named) |
| `ftp_port_t` | 21 | FTP |
| `postgresql_port_t` | 5432 | PostgreSQL |

---

## Viewing Port Labels

### List All Port Labels

```bash
# List all SELinux port definitions
sudo semanage port -l

# Filter for specific type
sudo semanage port -l | grep http_port_t

# Filter for specific port number
sudo semanage port -l | grep -w 22
```

### Example Output

```
$ sudo semanage port -l | grep http
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
```

### Check if Port is Available

```bash
# See what type a specific port has
sudo semanage port -l | grep -w 8080

# Or check if port is labeled
sudo semanage port -l | grep ":8080\|8080,"
```

---

## Adding Port Labels

### Syntax

```bash
sudo semanage port -a -t <type> -p <protocol> <port>
```

### Parameters

| Parameter | Description | Values |
|-----------|-------------|--------|
| `-a` | Add port | - |
| `-t` | SELinux type | `http_port_t`, etc. |
| `-p` | Protocol | `tcp`, `udp` |
| `<port>` | Port number | 1-65535 |

### Examples

```bash
# Add port 8443 for Apache (HTTPS alternative)
sudo semanage port -a -t http_port_t -p tcp 8443

# Add custom SSH port
sudo semanage port -a -t ssh_port_t -p tcp 2222

# Add custom MySQL port
sudo semanage port -a -t mysqld_port_t -p tcp 3307
```

---

## Modifying Port Labels

### Change Port Type

```bash
# Modify existing port's type
sudo semanage port -m -t http_port_t -p tcp 8888
```

> **Note**: Use `-m` (modify) when the port already has a different type assigned.

### When to Use Modify vs Add

| Situation | Use |
|-----------|-----|
| Port has no SELinux label | `-a` (add) |
| Port has different label | `-m` (modify) |
| Port already has correct label | Nothing needed |

---

## Deleting Port Labels

### Remove Custom Port Label

```bash
# Delete port label
sudo semanage port -d -t http_port_t -p tcp 8443
```

> **Note**: You can only delete custom (locally added) port labels, not default policy ports.

---

## Port Range Support

### Adding Port Ranges

```bash
# Add range of ports
sudo semanage port -a -t http_port_t -p tcp 8080-8090
```

### Listing Shows Ranges

```
http_port_t    tcp    80, 443, 8080-8090, 9000
```

---

## Common Scenarios

### Run Apache on Port 8080

```bash
# 1. Check if 8080 already has http_port_t
sudo semanage port -l | grep http_port_t
# Already includes 8080 in standard policy

# 2. If not, add it
sudo semanage port -a -t http_port_t -p tcp 8080

# 3. Configure Apache
sudo vi /etc/httpd/conf/httpd.conf
# Listen 8080

# 4. Restart Apache
sudo systemctl restart httpd
```

### Change SSH to Port 2222

```bash
# 1. Add new port to SELinux
sudo semanage port -a -t ssh_port_t -p tcp 2222

# 2. Verify
sudo semanage port -l | grep ssh_port_t

# 3. Update SSH config
sudo vi /etc/ssh/sshd_config
# Port 2222

# 4. Update firewall
sudo firewall-cmd --permanent --add-port=2222/tcp
sudo firewall-cmd --reload

# 5. Restart SSH
sudo systemctl restart sshd
```

### Run MariaDB on Alternative Port

```bash
# 1. Add port
sudo semanage port -a -t mysqld_port_t -p tcp 3307

# 2. Configure MariaDB
sudo vi /etc/my.cnf.d/mariadb-server.cnf
# port=3307

# 3. Restart service
sudo systemctl restart mariadb
```

---

## Troubleshooting Port Issues

### Check for SELinux Denial

```bash
# Check audit log for port-related denials
sudo ausearch -m avc -ts recent | grep "bind"

# Check journal for SELinux messages
sudo journalctl -t setroubleshoot | tail
```

### Common Error Messages

In `/var/log/audit/audit.log`:
```
type=AVC msg=: avc: denied { name_bind } for pid=1234 comm="httpd" src=8888 
scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:reserved_port_t:s0 
tclass=tcp_socket
```

This means: httpd cannot bind to port 8888 (has `reserved_port_t`, needs `http_port_t`)

### Fix with semanage

```bash
# Based on error, add proper port type
sudo semanage port -a -t http_port_t -p tcp 8888
```

---

## Practice Questions

### Question 1: List HTTP Ports
Show all ports currently assigned the `http_port_t` SELinux type.

<details>
<summary>Show Solution</summary>

```bash
sudo semanage port -l | grep http_port_t
```

**Output:**
```
http_port_t    tcp    80, 81, 443, 488, 8008, 8009, 8443, 9000
```

</details>

---

### Question 2: Add Custom HTTP Port
Allow Apache to listen on TCP port 8888.

<details>
<summary>Show Solution</summary>

```bash
# Add port to http_port_t
sudo semanage port -a -t http_port_t -p tcp 8888

# Verify
sudo semanage port -l | grep http_port_t

# Now Apache can bind to 8888
```

</details>

---

### Question 3: Check SSH Port
Verify what SELinux port type is assigned to TCP port 22.

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Search by port
sudo semanage port -l | grep -w 22

# Method 2: Search by type
sudo semanage port -l | grep ssh_port_t
```

**Output:**
```
ssh_port_t    tcp    22
```

</details>

---

### Question 4: Change SSH Port
Configure SELinux to allow SSH to run on port 2022 (keep port 22 as well).

<details>
<summary>Show Solution</summary>

```bash
# Add new port for SSH
sudo semanage port -a -t ssh_port_t -p tcp 2022

# Verify
sudo semanage port -l | grep ssh_port_t
# Should show: ssh_port_t    tcp    22, 2022

# Don't forget firewall!
sudo firewall-cmd --permanent --add-port=2022/tcp
sudo firewall-cmd --reload
```

</details>

---

### Question 5: Add Database Port
Allow MySQL to use port 33060 in addition to 3306.

<details>
<summary>Show Solution</summary>

```bash
# Add new MySQL port
sudo semanage port -a -t mysqld_port_t -p tcp 33060

# Verify
sudo semanage port -l | grep mysqld_port_t
```

**Output:**
```
mysqld_port_t    tcp    1186, 3306, 33060, 63132-63164
```

</details>

---

### Question 6: Delete Custom Port
Remove the custom SELinux port label for TCP port 8888.

<details>
<summary>Show Solution</summary>

```bash
# Delete the port label
sudo semanage port -d -t http_port_t -p tcp 8888

# Verify removal
sudo semanage port -l | grep 8888
# Should return nothing
```

> **Note**: Cannot delete ports defined in base policy, only custom additions.

</details>

---

### Question 7: Add Port Range
Allow Apache to bind to any port between 9000 and 9010.

<details>
<summary>Show Solution</summary>

```bash
# Add port range
sudo semanage port -a -t http_port_t -p tcp 9000-9010

# Verify
sudo semanage port -l | grep http_port_t
# Shows: ... 9000-9010 ...
```

</details>

---

### Question 8: Troubleshoot Port Binding
Apache fails to start on port 8123. Diagnose and fix the SELinux issue.

<details>
<summary>Show Solution</summary>

```bash
# 1. Check current port assignments
sudo semanage port -l | grep 8123
# Probably shows nothing or different type

# 2. Check SELinux denials
sudo ausearch -m avc -ts recent | grep 8123

# 3. Add the port
sudo semanage port -a -t http_port_t -p tcp 8123

# 4. Verify
sudo semanage port -l | grep http_port_t

# 5. Restart Apache
sudo systemctl restart httpd
```

</details>

---

### Question 9: Modify Existing Port Label
Port 9999 is currently labeled as `reserved_port_t`. Change it to `http_port_t`.

<details>
<summary>Show Solution</summary>

```bash
# Use -m (modify) because port already has a type
sudo semanage port -m -t http_port_t -p tcp 9999

# Verify
sudo semanage port -l | grep 9999
```

> **Note**: Use `-a` for new ports, `-m` to change existing.

</details>

---

### Question 10: Configure DNS Alternate Port
Configure SELinux to allow the DNS service (named) to listen on UDP port 5353.

<details>
<summary>Show Solution</summary>

```bash
# Add UDP port for DNS
sudo semanage port -a -t dns_port_t -p udp 5353

# Verify
sudo semanage port -l | grep dns_port_t

# Output shows both tcp and udp ports
```

</details>

---

## Quick Reference

| Task | Command |
|------|---------|
| List all ports | `sudo semanage port -l` |
| Filter by type | `sudo semanage port -l \| grep http_port_t` |
| Filter by port | `sudo semanage port -l \| grep -w 8080` |
| Add TCP port | `sudo semanage port -a -t type -p tcp port` |
| Add UDP port | `sudo semanage port -a -t type -p udp port` |
| Add port range | `sudo semanage port -a -t type -p tcp start-end` |
| Modify port | `sudo semanage port -m -t type -p proto port` |
| Delete port | `sudo semanage port -d -t type -p proto port` |

---

## Common Port Types Reference

| Port Type | Common Ports | Services |
|-----------|--------------|----------|
| `http_port_t` | 80, 443, 8080, 8443 | Apache, nginx |
| `ssh_port_t` | 22 | SSH, SFTP |
| `smtp_port_t` | 25, 465, 587 | Postfix, sendmail |
| `dns_port_t` | 53 | BIND, named |
| `mysqld_port_t` | 3306 | MySQL, MariaDB |
| `postgresql_port_t` | 5432 | PostgreSQL |
| `ftp_port_t` | 21 | vsftpd, proftpd |
| `nfs_port_t` | 2049 | NFS |
| `ldap_port_t` | 389, 636 | OpenLDAP |
| `kerberos_port_t` | 88, 464, 749 | Kerberos |

---

## Summary

- SELinux controls which ports services can bind to
- Use `semanage port -l` to list current port labels
- Use `semanage port -a` to add new port labels
- Use `semanage port -m` to modify existing port labels
- Use `semanage port -d` to delete custom port labels
- Always specify `-t type`, `-p protocol`, and port number
- Port ranges supported: `8080-8090`
- Remember to also configure firewall rules for new ports
