# Create, Delete, and Modify Local Groups and Group Memberships

## RHCSA Exam Objective
> Create, delete, and modify local groups and group memberships

---

## Introduction

Groups simplify permission management by allowing multiple users to share access rights. The RHCSA exam tests your ability to manage groups and assign users to groups. Users have one primary group and can belong to multiple supplementary groups.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `groupadd` | Create a new group |
| `groupmod` | Modify a group |
| `groupdel` | Delete a group |
| `gpasswd` | Administer groups |
| `groups` | Show user's groups |
| `id` | Display user/group IDs |

## Key Files

| File | Purpose |
|------|---------|
| `/etc/group` | Group information |
| `/etc/gshadow` | Group passwords |

---

## /etc/group Format

```
groupname:password:GID:members
```

| Field | Description |
|-------|-------------|
| groupname | Name of the group |
| password | Usually x (password in gshadow) |
| GID | Group ID number |
| members | Comma-separated list of supplementary members |

---

## Part 1: Creating Groups

### Question 1: Create Basic Group
**Task:** Create a group named "developers".

<details>
<summary>Show Solution</summary>

```bash
sudo groupadd developers
```

**Verify:**
```bash
getent group developers
```
</details>

---

### Question 2: Create Group with Specific GID
**Task:** Create group "managers" with GID 5000.

<details>
<summary>Show Solution</summary>

```bash
sudo groupadd -g 5000 managers
```

**Verify:**
```bash
getent group managers
```

**Output:**
```
managers:x:5000:
```
</details>

---

### Question 3: Create System Group
**Task:** Create system group "myservice".

<details>
<summary>Show Solution</summary>

```bash
sudo groupadd -r myservice
```

**System groups have GID below 1000.**
</details>

---

## Part 2: Modifying Groups

### Question 4: Change Group Name
**Task:** Rename group "developers" to "devteam".

<details>
<summary>Show Solution</summary>

```bash
sudo groupmod -n devteam developers
```

**Verify:**
```bash
getent group devteam
```
</details>

---

### Question 5: Change Group GID
**Task:** Change GID of group "managers" to 6000.

<details>
<summary>Show Solution</summary>

```bash
sudo groupmod -g 6000 managers
```

**Note:** Files owned by old GID will need ownership update.
</details>

---

## Part 3: Deleting Groups

### Question 6: Delete a Group
**Task:** Delete group "oldteam".

<details>
<summary>Show Solution</summary>

```bash
sudo groupdel oldteam
```

**Note:** Cannot delete a group if it's a user's primary group.
</details>

---

## Part 4: Managing Group Membership

### Question 7: View User's Groups
**Task:** Display all groups for user "john".

<details>
<summary>Show Solution</summary>

```bash
groups john
```

**Or:**
```bash
id john
```

**Or:**
```bash
id -Gn john
```
</details>

---

### Question 8: View Group Members
**Task:** List all members of group "developers".

<details>
<summary>Show Solution</summary>

```bash
getent group developers
```

**Or:**
```bash
grep developers /etc/group
```

**Note:** Primary group members are not listed in /etc/group.
</details>

---

### Question 9: Add User to Group
**Task:** Add user "john" to group "developers".

<details>
<summary>Show Solution</summary>

**Method 1 - usermod (recommended):**
```bash
sudo usermod -aG developers john
```

**Method 2 - gpasswd:**
```bash
sudo gpasswd -a john developers
```

**Verify:**
```bash
groups john
```
</details>

---

### Question 10: Add User to Multiple Groups
**Task:** Add user "sarah" to groups "developers" and "testers".

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -aG developers,testers sarah
```

**Important:** Always use `-a` (append) to avoid removing existing groups.
</details>

---

### Question 11: Remove User from Group
**Task:** Remove user "john" from group "developers".

<details>
<summary>Show Solution</summary>

```bash
sudo gpasswd -d john developers
```

**Verify:**
```bash
groups john
```
</details>

---

### Question 12: Set User's Supplementary Groups
**Task:** Set user's supplementary groups to exactly "wheel" and "admin".

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -G wheel,admin john
```

**Warning:** Without `-a`, this replaces ALL supplementary groups!
</details>

---

### Question 13: Remove All Supplementary Groups
**Task:** Remove user from all supplementary groups.

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -G "" john
```

**This sets supplementary groups to empty.**
</details>

---

### Question 14: Change User's Primary Group
**Task:** Change primary group of "john" to "developers".

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -g developers john
```

**Verify:**
```bash
id john
```
</details>

---

## Part 5: Using gpasswd

### Question 15: Add Group Administrator
**Task:** Make user "admin1" an administrator of group "developers".

<details>
<summary>Show Solution</summary>

```bash
sudo gpasswd -A admin1 developers
```

**Group administrators can add/remove members.**
</details>

---

### Question 16: Add Multiple Members
**Task:** Add users "user1" and "user2" to group "project".

<details>
<summary>Show Solution</summary>

```bash
sudo gpasswd -M user1,user2 project
```

**Warning:** This replaces all current members!
</details>

---

## Part 6: Exam Scenarios

### Question 17: Exam Scenario - Create Project Team
**Task:** Create group "webteam" and add users "alice", "bob", and "charlie".

<details>
<summary>Show Solution</summary>

```bash
# Create group
sudo groupadd webteam

# Add users
sudo usermod -aG webteam alice
sudo usermod -aG webteam bob
sudo usermod -aG webteam charlie

# Verify
getent group webteam
```
</details>

---

### Question 18: Exam Scenario - User with Specific Groups
**Task:** Create user "newdev" with:
- Primary group: developers
- Supplementary groups: docker, git

<details>
<summary>Show Solution</summary>

```bash
# Ensure groups exist
sudo groupadd developers
sudo groupadd docker
sudo groupadd git

# Create user with groups
sudo useradd -g developers -G docker,git newdev

# Verify
id newdev
```
</details>

---

### Question 19: Exam Scenario - Reorganize Groups
**Task:** User "john" is in groups wheel, docker, developers. Remove him from docker.

<details>
<summary>Show Solution</summary>

```bash
sudo gpasswd -d john docker
```

**Verify:**
```bash
groups john
```
</details>

---

### Question 20: Exam Scenario - Department Change
**Task:** Move user "sarah" from "sales" group to "marketing" group (replacing membership).

<details>
<summary>Show Solution</summary>

```bash
# Remove from sales
sudo gpasswd -d sarah sales

# Add to marketing
sudo usermod -aG marketing sarah

# Verify
groups sarah
```
</details>

---

### Question 21: Find All Users in a Group
**Task:** Find all users who have "wheel" as supplementary group.

<details>
<summary>Show Solution</summary>

```bash
getent group wheel
```

**Output:**
```
wheel:x:10:user1,user2,user3
```

**Note:** This doesn't show users with wheel as primary group.
</details>

---

### Question 22: Create Shared Directory Group
**Task:** Create group "project" for shared directory access.

<details>
<summary>Show Solution</summary>

```bash
# Create group
sudo groupadd project

# Create directory
sudo mkdir /opt/project

# Set group ownership
sudo chown :project /opt/project

# Add users to group
sudo usermod -aG project user1
sudo usermod -aG project user2
```
</details>

---

## Quick Reference

### groupadd Options
```bash
groupadd GROUP              # Create group
groupadd -g GID GROUP       # Create with specific GID
groupadd -r GROUP           # Create system group
```

### groupmod Options
```bash
groupmod -n NEWNAME GROUP   # Rename group
groupmod -g GID GROUP       # Change GID
```

### groupdel
```bash
groupdel GROUP              # Delete group
```

### Group Membership
```bash
# Add to supplementary group
usermod -aG GROUP USER      # Append to groups (recommended)
gpasswd -a USER GROUP       # Add member

# Remove from group
gpasswd -d USER GROUP       # Remove member

# Set primary group
usermod -g GROUP USER       # Change primary group

# View groups
groups USER
id USER
getent group GROUP
```

### Primary vs Supplementary Groups
| Type | Description | Set By |
|------|-------------|--------|
| Primary | Default group for new files | `usermod -g` |
| Supplementary | Additional group memberships | `usermod -aG` |

---

## Summary

For the RHCSA exam, ensure you can:

1. **Create groups** using `groupadd`
2. **Modify groups** using `groupmod` (rename, change GID)
3. **Delete groups** using `groupdel`
4. **Add users to groups** using `usermod -aG` or `gpasswd -a`
5. **Remove users from groups** using `gpasswd -d`
6. **View group membership** using `groups`, `id`, or `getent group`
7. **Change primary group** using `usermod -g`
