## 02- Change passwords and adjust password aging for local user accounts:

The RHCSA exam topic **"Change passwords and adjust password aging for local user accounts"** involves managing user passwords and setting policies related to password aging on **RHEL 9**. This includes setting new passwords, forcing password changes, controlling password expiration, and enforcing aging policies like maximum and minimum password age.

---

### **What You Need to Know:**
1. **Change user passwords**: Using the `passwd` command to set or change user passwords.
2. **Enforce password expiration**: Using `chage` to enforce password expiration, force users to change passwords, and set aging policies like minimum and maximum password lifetimes.
3. **Understanding password storage**: How passwords are stored in `/etc/shadow`.
4. **Ensuring persistence**: All password changes and aging policies should persist across reboots.

---

### **1. Changing Passwords for Local User Accounts**

You can change or reset passwords using the **`passwd`** command. It updates the password for the specified user and stores it in the **`/etc/shadow`** file in an encrypted format.

#### **Example Task 1: Set or Change the Password for a User**

**Task:** Change the password for the user **`jdoe`**.

1. **Change the user password**:
   ```bash
   sudo passwd jdoe
   ```

2. **Enter the new password** when prompted.

3. **Verify that the password is changed** by checking the timestamp in `/etc/shadow`:
   ```bash
   sudo grep jdoe /etc/shadow
   ```

#### **Example Output**:
```
jdoe:$6$Nn...G3$:19025:0:99999:7:::
```

**Explanation**:
- **`passwd jdoe`** prompts you to set a new password for the user **`jdoe`**. The password is stored in encrypted format in **`/etc/shadow`**.
- The numeric fields (like `19025`) represent the last password change in days since 1970-01-01, among other settings.

---

### **2. Adjusting Password Aging Policies**

Password aging is managed using the **`chage`** command, which allows you to define policies like how often a user must change their password, when the password expires, and when they are warned of an impending expiration.

#### **Understanding Password Aging Fields in `/etc/shadow`**

- **Last password change**: The number of days since the password was last changed.
- **Minimum days**: The minimum number of days between password changes.
- **Maximum days**: The maximum number of days a password is valid before it must be changed.
- **Warning period**: The number of days before password expiration that the user is warned.

---

#### **Example Task 2: Set Password Expiration for a User**

**Task:** Set the password for **`jdoe`** to expire every **90 days** with a **7-day warning**.

1. **Set the maximum password age to 90 days**:
   ```bash
   sudo chage -M 90 jdoe
   ```

2. **Set the warning period to 7 days**:
   ```bash
   sudo chage -W 7 jdoe
   ```

3. **Verify the password aging settings**:
   ```bash
   sudo chage -l jdoe
   ```

#### **Example Output**:
```
Last password change                                    : Sep 25, 2024
Password expires                                        : Dec 24, 2024
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 0
Maximum number of days between password change          : 90
Number of days of warning before password expires       : 7
```

**Explanation**:
- **`chage -M 90 jdoe`** sets the maximum password age to 90 days, meaning **`jdoe`** will be required to change their password every 90 days.
- **`chage -W 7 jdoe`** sets the warning period to 7 days, so **`jdoe`** will be warned 7 days before the password expires.
- **`chage -l jdoe`** lists the current password aging policy for the user, displaying when the password was last changed, the expiration date, and aging parameters.

---

### **3. Forcing a User to Change Password at Next Login**

To force a user to change their password upon their next login, you can use **`passwd --expire`** or **`chage -d 0`**. This sets the password to "expired," so the user must set a new password when they log in.

#### **Example Task 3: Force a User to Change Password at Next Login**

**Task:** Force **`jdoe`** to change their password at the next login.

1. **Expire the user's password**:
   ```bash
   sudo passwd --expire jdoe
   ```

2. **Verify that the password is expired**:
   ```bash
   sudo chage -l jdoe
   ```

#### **Example Output**:
```
Last password change                                    : password must be changed
Password expires                                        : password must be changed
```

**Explanation**:
- **`passwd --expire jdoe`** sets **`jdoe`**'s password as expired, requiring them to set a new password on their next login.
- **`chage -l jdoe`** confirms that the password must be changed.

---

### **4. Setting Minimum Days Between Password Changes**

To prevent users from changing their passwords too frequently (for example, to prevent them from reusing old passwords quickly), you can set a minimum number of days between password changes.

#### **Example Task 4: Set Minimum Days Between Password Changes**

**Task:** Set a minimum of **1 day** between password changes for the user **`jdoe`**.

1. **Set the minimum days between password changes**:
   ```bash
   sudo chage -m 1 jdoe
   ```

2. **Verify the changes**:
   ```bash
   sudo chage -l jdoe
   ```

#### **Example Output**:
```
Minimum number of days between password change          : 1
```

**Explanation**:
- **`chage -m 1 jdoe`** ensures that **`jdoe`** must wait at least 1 day before changing their password again.

---

### **5. Deactivating and Reactivating Accounts**

You can lock or deactivate user accounts temporarily by disabling the user's ability to log in. This is done using the **`passwd -l`** command, which locks the account by adding an exclamation mark (`!`) before the password hash in `/etc/shadow`.

#### **Example Task 5: Lock and Unlock a User Account**

**Task:** Lock the user **`jdoe`**'s account and later unlock it.

1. **Lock the user's account**:
   ```bash
   sudo passwd -l jdoe
   ```

2. **Verify the account is locked** by checking `/etc/shadow`:
   ```bash
   sudo grep jdoe /etc/shadow
   ```

#### **Example Output**:
```
jdoe:!$6$Nn...G3$:19025:0:99999:7:::
```

3. **Unlock the user's account**:
   ```bash
   sudo passwd -u jdoe
   ```

4. **Verify the account is unlocked**:
   ```bash
   sudo grep jdoe /etc/shadow
   ```

#### **Example Output (after unlocking)**:
```
jdoe:$6$Nn...G3$:19025:0:99999:7:::
```

**Explanation**:
- **`passwd -l jdoe`** locks the account by placing an exclamation mark (`!`) in front of the password hash in `/etc/shadow`, preventing the user from logging in.
- **`passwd -u jdoe`** unlocks the account by removing the exclamation mark.

---

### **6. Setting an Account Expiration Date**

You can set an expiration date for a user account, after which the user will no longer be able to log in. This is done using **`chage -E`**.

#### **Example Task 6: Set an Account Expiration Date**

**Task:** Set **`jdoe`**'s account to expire on **December 31, 2024**.

1. **Set the account expiration date**:
   ```bash
   sudo chage -E 2024-12-31 jdoe
   ```

2. **Verify the account expiration**:
   ```bash
   sudo chage -l jdoe
   ```

#### **Example Output**:
```
Account expires                                         : Dec 31, 2024
```

**Explanation**:
- **`chage -E 2024-12-31 jdoe`** sets **`jdoe`**'s account to expire on **December 31, 2024**, after which the account will be disabled, preventing the user from logging in.
- **`chage -l jdoe`** shows the expiration date for the account.

---

### **7. Understanding the `/etc/shadow` File**

The `/etc/shadow`

 file stores password hashes and password aging information for user accounts. Each line in `/etc/shadow` corresponds to a user account and contains fields for password management.

- **Username**: The user account name.
- **Password hash**: The encrypted password (or `!` for locked accounts).
- **Last password change**: The number of days since January 1, 1970, when the password was last changed.
- **Password aging fields**: Minimum days, maximum days, warning days, inactivity period, and account expiration date.

---

### Summary of Skills for RHCSA Exam on Managing Passwords and Aging for Local User Accounts:
1. **Set or change passwords** using the `passwd` command.
2. **Adjust password expiration and aging policies** using `chage`, including setting maximum days, warning periods, and minimum days between password changes.
3. **Force users to change passwords at the next login** using `passwd --expire`.
4. **Lock and unlock accounts** using `passwd -l` and `passwd -u`.
5. **Set account expiration dates** using `chage -E` and verify all settings using `chage -l`.
