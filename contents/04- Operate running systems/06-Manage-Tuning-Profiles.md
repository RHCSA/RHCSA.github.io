# Manage Tuning Profiles

## RHCSA Exam Objective
> Manage tuning profiles

---

## Introduction

Tuned is a dynamic adaptive system tuning daemon that optimizes system performance based on selected profiles. The RHCSA exam tests your ability to list, select, and manage tuning profiles using the `tuned-adm` command.

---

## Key Concepts

| Concept | Description |
|---------|-------------|
| tuned | Service that applies tuning profiles |
| tuned-adm | Command to manage tuning profiles |
| Profile | Collection of tuning settings for specific workload |

---

## Common Profiles

| Profile | Use Case |
|---------|----------|
| `balanced` | Balance between performance and power (default) |
| `powersave` | Maximum power saving |
| `throughput-performance` | Maximum throughput |
| `latency-performance` | Low latency |
| `network-latency` | Low network latency |
| `network-throughput` | High network throughput |
| `virtual-guest` | Optimized for virtual machines |
| `virtual-host` | Optimized for hypervisors |
| `desktop` | Optimized for desktop use |

---

## Practice Questions

### Question 1: Check if Tuned is Running
**Task:** Verify the tuned service is active.

<details>
<summary>Show Solution</summary>

```bash
systemctl status tuned
```

**Start and enable if needed:**
```bash
sudo systemctl enable --now tuned
```
</details>

---

### Question 2: List Available Profiles
**Task:** Display all available tuning profiles.

<details>
<summary>Show Solution</summary>

```bash
tuned-adm list
```

**Example Output:**
```
Available profiles:
- balanced
- desktop
- latency-performance
- network-latency
- network-throughput
- powersave
- throughput-performance
- virtual-guest
- virtual-host
Current active profile: balanced
```
</details>

---

### Question 3: View Active Profile
**Task:** Display the currently active tuning profile.

<details>
<summary>Show Solution</summary>

```bash
tuned-adm active
```

**Example Output:**
```
Current active profile: balanced
```
</details>

---

### Question 4: Set Profile for Throughput
**Task:** Set the system tuning profile to optimize for throughput performance.

<details>
<summary>Show Solution</summary>

```bash
sudo tuned-adm profile throughput-performance
```

**Verify:**
```bash
tuned-adm active
```
</details>

---

### Question 5: Set Profile for Virtual Machine
**Task:** Configure tuning for a system running as a virtual guest.

<details>
<summary>Show Solution</summary>

```bash
sudo tuned-adm profile virtual-guest
```
</details>

---

### Question 6: Set Profile for Power Saving
**Task:** Configure the system to maximize power saving.

<details>
<summary>Show Solution</summary>

```bash
sudo tuned-adm profile powersave
```
</details>

---

### Question 7: Set Profile for Low Latency
**Task:** Configure tuning for low-latency workloads.

<details>
<summary>Show Solution</summary>

```bash
sudo tuned-adm profile latency-performance
```
</details>

---

### Question 8: Get Profile Recommendation
**Task:** Get tuned's recommendation for this system.

<details>
<summary>Show Solution</summary>

```bash
tuned-adm recommend
```

**Example Output:**
```
virtual-guest
```

**Note:** tuned analyzes the system and recommends an appropriate profile.
</details>

---

### Question 9: Apply Recommended Profile
**Task:** Apply the system-recommended profile.

<details>
<summary>Show Solution</summary>

```bash
# Get recommendation
tuned-adm recommend

# Apply it
sudo tuned-adm profile $(tuned-adm recommend)

# Verify
tuned-adm active
```
</details>

---

### Question 10: Disable Tuned
**Task:** Turn off all tuned settings.

<details>
<summary>Show Solution</summary>

```bash
sudo tuned-adm off
```

**Verify:**
```bash
tuned-adm active
```

**Output:**
```
No current active profile.
```
</details>

---

### Question 11: View Profile Details
**Task:** Display the configuration of a specific profile.

<details>
<summary>Show Solution</summary>

```bash
# Profile files are located in:
cat /usr/lib/tuned/throughput-performance/tuned.conf

# Or for custom profiles:
cat /etc/tuned/profile-name/tuned.conf
```

**List profile directory:**
```bash
ls /usr/lib/tuned/
```
</details>

---

### Question 12: Exam Scenario - Database Server Tuning
**Task:** Configure a database server for maximum throughput.

<details>
<summary>Show Solution</summary>

```bash
# Ensure tuned is running
sudo systemctl enable --now tuned

# Set throughput profile
sudo tuned-adm profile throughput-performance

# Verify
tuned-adm active
```
</details>

---

### Question 13: Exam Scenario - Virtual Machine Configuration
**Task:** A newly deployed VM needs optimal tuning. Configure it.

<details>
<summary>Show Solution</summary>

```bash
# Check recommendation (should suggest virtual-guest)
tuned-adm recommend

# Apply virtual-guest profile
sudo tuned-adm profile virtual-guest

# Verify
tuned-adm active
```
</details>

---

### Question 14: Verify Profile is Applied
**Task:** Confirm that tuned settings are active.

<details>
<summary>Show Solution</summary>

```bash
tuned-adm verify
```

**Expected output:**
```
Verification succeeded, current system settings match the preset profile.
```
</details>

---

### Question 15: Combine Multiple Profiles
**Task:** Apply multiple profiles together.

<details>
<summary>Show Solution</summary>

```bash
# Combine profiles (space-separated)
sudo tuned-adm profile virtual-guest powersave
```

**Note:** Settings from the second profile override the first where there are conflicts.
</details>

---

## Tuned Profile Locations

| Location | Description |
|----------|-------------|
| `/usr/lib/tuned/` | System profiles (read-only) |
| `/etc/tuned/` | Custom profiles and configuration |
| `/etc/tuned/active_profile` | Currently active profile |

---

## Quick Reference

### Service Management
```bash
# Check status
systemctl status tuned

# Enable and start
systemctl enable --now tuned
```

### Profile Management
```bash
# List profiles
tuned-adm list

# View active
tuned-adm active

# Get recommendation
tuned-adm recommend

# Set profile
tuned-adm profile PROFILE_NAME

# Disable tuning
tuned-adm off

# Verify settings
tuned-adm verify
```

### Common Profiles
```bash
# Physical server - high throughput
tuned-adm profile throughput-performance

# Virtual machine guest
tuned-adm profile virtual-guest

# Low power usage
tuned-adm profile powersave

# Balanced (default)
tuned-adm profile balanced
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Start and enable tuned** service
2. **List available profiles** using `tuned-adm list`
3. **View active profile** using `tuned-adm active`
4. **Set a profile** using `tuned-adm profile NAME`
5. **Get recommendations** using `tuned-adm recommend`
6. **Know common profiles** (balanced, throughput-performance, virtual-guest, powersave)
7. **Disable tuned** using `tuned-adm off`
