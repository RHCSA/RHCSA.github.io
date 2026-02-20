# Change Passwords and Adjust Password Aging

## RHCSA Exam Objective
> Change passwords and adjust password aging for local user accounts

---

## Introduction

Password management includes setting passwords and configuring password aging policies. The RHCSA exam tests your ability to use `passwd` and `chage` commands to manage password settings and expiration.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `passwd` | Change user password |
| `chage` | Change password aging settings |

## Key Files

| File | Purpose |
|------|---------|
| `/etc/shadow` | Password hashes and aging info |
| `/etc/login.defs` | Default password policies |

---

## /etc/shadow Format

```
username:password:lastchange:min:max:warn:inactive:expire:reserved
```

| Field | Description |
|-------|-------------|
| password | Encrypted password (! = locked, * = no password) |
| lastchange | Days since Jan 1, 1970 when password was last changed |
| min | Minimum days between password changes |
| max | Maximum days before password must be changed |
| warn | Days before expiration to warn user |
| inactive | Days after expiration before account is disabled |
| expire | Date when account expires (days since Jan 1, 1970) |

---

## Part 1: Setting Passwords

### Question 1: Set Password for User
**Task:** Set password for user "john".

<details>
<summary>Show Solution</summary>

```bash
sudo passwd john
```

**You will be prompted to enter and confirm the new password.**
</details>

---

### Question 2: Change Your Own Password
**Task:** Change your own password.

<details>
<summary>Show Solution</summary>

```bash
passwd
```

**You must enter current password first, then new password twice.**
</details>

---

### Question 3: Set Password Non-Interactively
**Task:** Set password "SecretPass123" for user "testuser" in a script.

<details>
<summary>Show Solution</summary>

```bash
echo "SecretPass123" | sudo passwd --stdin testuser
```

**Note:** `--stdin` reads password from standard input.
</details>

---

### Question 4: Force Password Change at Next Login
**Task:** Force user "john" to change password at next login.

<details>
<summary>Show Solution</summary>

```bash
sudo passwd -e john
```

**Or using chage:**
```bash
sudo chage -d 0 john
```

**This sets last password change to 0, forcing immediate change.**
</details>

---

### Question 5: Lock User Password
**Task:** Lock password for user "baduser".

<details>
<summary>Show Solution</summary>

```bash
sudo passwd -l baduser
```

**Verify (shows !! prefix in shadow):**
```bash
sudo grep baduser /etc/shadow
```

**Note:** This only locks password authentication. SSH keys may still work.
</details>

---

### Question 6: Unlock User Password
**Task:** Unlock password for user "baduser".

<details>
<summary>Show Solution</summary>

```bash
sudo passwd -u baduser
```
</details>

---

### Question 7: Check Password Status
**Task:** View password status for user "john".

<details>
<summary>Show Solution</summary>

```bash
sudo passwd -S john
```

**Output example:**
```
john PS 2024-03-15 0 99999 7 -1 (Password set, SHA512 crypt.)
```

**Status codes:**
- `PS` - Password Set
- `LK` - Locked
- `NP` - No Password
</details>

---

### Question 8: Delete User Password
**Task:** Remove password from user "nopassuser".

<details>
<summary>Show Solution</summary>

```bash
sudo passwd -d nopassuser
```

**Warning:** User can now login without password (security risk).
</details>

---

## Part 2: Password Aging with chage

### Question 9: View Password Aging Information
**Task:** Display password aging info for user "john".

<details>
<summary>Show Solution</summary>

```bash
sudo chage -l john
```

**Output:**
```
Last password change                                    : Mar 15, 2024
Password expires                                        : never
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 0
Maximum number of days between password change          : 99999
Number of days of warning before password expires       : 7
```
</details>

---

### Question 10: Set Password Maximum Age
**Task:** Set maximum password age to 90 days for user "john".

<details>
<summary>Show Solution</summary>

```bash
sudo chage -M 90 john
```

**User must change password every 90 days.**
</details>

---

### Question 11: Set Password Minimum Age
**Task:** Set minimum password age to 7 days for user "john".

<details>
<summary>Show Solution</summary>

```bash
sudo chage -m 7 john
```

**User cannot change password more frequently than every 7 days.**
</details>

---

### Question 12: Set Warning Days
**Task:** Warn user "john" 14 days before password expires.

<details>
<summary>Show Solution</summary>

```bash
sudo chage -W 14 john
```
</details>

---

### Question 13: Set Inactive Days
**Task:** Disable account 30 days after password expires.

<details>
<summary>Show Solution</summary>

```bash
sudo chage -I 30 john
```

**After 30 days of expired password, account is disabled.**
</details>

---

### Question 14: Set Account Expiration Date
**Task:** Set user "contractor" account to expire on December 31, 2024.

<details>
<summary>Show Solution</summary>

```bash
sudo chage -E 2024-12-31 contractor
```

**Verify:**
```bash
sudo chage -l contractor
```
</details>

---

### Question 15: Remove Account Expiration
**Task:** Remove account expiration date.

<details>
<summary>Show Solution</summary>

```bash
sudo chage -E -1 john
```

**Setting to -1 removes expiration.**
</details>

---

### Question 16: Set Last Password Change Date
**Task:** Set last password change to a specific date.

<details>
<summary>Show Solution</summary>

```bash
sudo chage -d 2024-01-01 john
```

**Set to 0 to force password change:**
```bash
sudo chage -d 0 john
```
</details>

---

### Question 17: Interactive chage
**Task:** Interactively set all password aging parameters.

<details>
<summary>Show Solution</summary>

```bash
sudo chage john
```

**This prompts for each field interactively.**
</details>

---

## Part 3: Exam Scenarios

### Question 18: Exam Scenario - Complete Password Policy
**Task:** Configure user "newuser" with:
- Password expires every 60 days
- Minimum 5 days between changes
- Warning 10 days before expiration
- Disable 7 days after expiration

<details>
<summary>Show Solution</summary>

```bash
sudo chage -M 60 -m 5 -W 10 -I 7 newuser
```

**Verify:**
```bash
sudo chage -l newuser
```
</details>

---

### Question 19: Exam Scenario - Temporary Account
**Task:** Create user "tempworker" that:
- Has password
- Account expires on 2024-06-30
- Must change password at first login

<details>
<summary>Show Solution</summary>

```bash
# Create user
sudo useradd tempworker

# Set password
sudo passwd tempworker

# Set account expiration
sudo chage -E 2024-06-30 tempworker

# Force password change at first login
sudo chage -d 0 tempworker
```

**Verify:**
```bash
sudo chage -l tempworker
```
</details>

---

### Question 20: Exam Scenario - Security Compliance
**Task:** Enforce password policy:
- Users must change password every 45 days
- Cannot reuse password for 7 days
- Get warning 7 days before expiration

<details>
<summary>Show Solution</summary>

```bash
sudo chage -M 45 -m 7 -W 7 username
```

**Apply to existing user "compliance":**
```bash
sudo chage -M 45 -m 7 -W 7 compliance
```
</details>

---

### Question 21: Exam Scenario - Lock and Expire
**Task:** User "exemployee" has left. Secure the account.

<details>
<summary>Show Solution</summary>

**Option 1 - Lock password:**
```bash
sudo passwd -l exemployee
```

**Option 2 - Expire account immediately:**
```bash
sudo chage -E 0 exemployee
```

**Option 3 - Both:**
```bash
sudo passwd -l exemployee
sudo chage -E 0 exemployee
```
</details>

---

### Question 22: View Shadow File Entry
**Task:** Understand the shadow file format.

<details>
<summary>Show Solution</summary>

```bash
sudo grep john /etc/shadow
```

**Example:**
```
john:$6$xyz...:19800:7:90:14:30::
```

**Fields:**
1. `john` - username
2. `$6$xyz...` - encrypted password ($6$ = SHA-512)
3. `19800` - last change (days since 1/1/1970)
4. `7` - min days
5. `90` - max days
6. `14` - warn days
7. `30` - inactive days
8. (empty) - expire date
</details>

---

## Quick Reference

### passwd Options
```bash
passwd                  # Change own password
passwd USER             # Change user's password (as root)
passwd -e USER          # Expire password (force change)
passwd -l USER          # Lock password
passwd -u USER          # Unlock password
passwd -d USER          # Delete password
passwd -S USER          # Show password status
passwd --stdin USER     # Read password from stdin
```

### chage Options
```bash
chage -l USER           # List aging info
chage -d DATE USER      # Set last change date (0 = force change)
chage -E DATE USER      # Set account expiration (-1 = never)
chage -m DAYS USER      # Minimum days between changes
chage -M DAYS USER      # Maximum days before change required
chage -W DAYS USER      # Warning days before expiration
chage -I DAYS USER      # Inactive days after expiration
```

### Common chage Settings
| Setting | Typical Value | Option |
|---------|---------------|--------|
| Maximum age | 90 days | `-M 90` |
| Minimum age | 7 days | `-m 7` |
| Warning | 7 days | `-W 7` |
| Inactive | 30 days | `-I 30` |
| Force change | immediate | `-d 0` |

---

## Summary

For the RHCSA exam, ensure you can:

1. **Set passwords** using `passwd`
2. **Force password change** using `passwd -e` or `chage -d 0`
3. **Lock/unlock passwords** using `passwd -l` and `passwd -u`
4. **View password aging** using `chage -l`
5. **Set password expiration** using `chage -M` (max days)
6. **Set account expiration** using `chage -E`
7. **Configure all aging parameters** (min, max, warn, inactive)
