# Configure Firewall Settings Using firewall-cmd/firewalld

## RHCSA Exam Objective
> Configure firewall settings using firewall-cmd/firewalld

---

## Introduction

This topic covers firewall configuration as part of system security. Detailed firewall management with services, ports, zones, and rich rules is covered in [Section 08-04: Restrict Network Access Using firewall-cmd](../08-%20Manage%20basic%20networking/04-Restrict-Network-Access-Firewalld.md).

This file provides a security-focused quick reference for common exam scenarios.

---

## Quick Reference

### Firewall Status
```bash
firewall-cmd --state
systemctl status firewalld
```

### Enable and Start Firewalld
```bash
sudo systemctl enable --now firewalld
```

### Allow Services
```bash
# Add service permanently
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

### Allow Ports
```bash
# Add port permanently
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

### Block Specific IP (Rich Rule)
```bash
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="10.0.0.99" drop'
sudo firewall-cmd --reload
```

### Verify Configuration
```bash
firewall-cmd --list-all
firewall-cmd --list-services
firewall-cmd --list-ports
```

---

## Common Exam Scenarios

### Scenario 1: Allow Web Server Traffic
```bash
sudo firewall-cmd --permanent --add-service=http --add-service=https
sudo firewall-cmd --reload
```

### Scenario 2: Allow Custom Application Port
```bash
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload
```

### Scenario 3: Secure Server - Block IP
```bash
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.100" reject'
sudo firewall-cmd --reload
```

---

## Summary

For comprehensive firewall configuration including zones, multiple services, and detailed rich rules, see [Section 08-04](../08-%20Manage%20basic%20networking/04-Restrict-Network-Access-Firewalld.md).

**Key points:**
1. Always use `--permanent` for persistent rules
2. Always `--reload` after making changes
3. Verify with `firewall-cmd --list-all`
