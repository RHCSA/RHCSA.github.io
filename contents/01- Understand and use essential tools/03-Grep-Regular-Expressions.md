# Use grep and Regular Expressions to Analyze Text

## RHCSA Exam Topic Overview

The `grep` command is one of the most essential text-processing tools in Linux. It searches for patterns within files and outputs matching lines. For the RHCSA exam, you must know how to use `grep` with basic and extended regular expressions to filter and analyze text efficiently.

---

## 1. Understanding grep

### What is grep?

**grep** stands for **G**lobal **R**egular **E**xpression **P**rint. It searches input files for lines containing a match to a given pattern and prints the matching lines.

### Basic Syntax

```bash
grep [OPTIONS] PATTERN [FILE...]
```

| Component | Description |
|-----------|-------------|
| `OPTIONS` | Flags that modify grep behavior |
| `PATTERN` | The search pattern (string or regex) |
| `FILE` | One or more files to search |

---

## 2. Essential grep Options for RHCSA

### Most Important Options

| Option | Long Form | Description |
|--------|-----------|-------------|
| `-i` | `--ignore-case` | Case-insensitive search |
| `-v` | `--invert-match` | Print lines that do NOT match |
| `-n` | `--line-number` | Show line numbers |
| `-c` | `--count` | Count matching lines |
| `-l` | `--files-with-matches` | List only filenames with matches |
| `-L` | `--files-without-match` | List filenames without matches |
| `-r` | `--recursive` | Search directories recursively |
| `-w` | `--word-regexp` | Match whole words only |
| `-x` | `--line-regexp` | Match entire lines only |
| `-o` | `--only-matching` | Print only the matched part |
| `-E` | `--extended-regexp` | Use Extended Regular Expressions (ERE) |
| `-F` | `--fixed-strings` | Treat pattern as fixed string (no regex) |
| `-A n` | `--after-context=n` | Print n lines after match |
| `-B n` | `--before-context=n` | Print n lines before match |
| `-C n` | `--context=n` | Print n lines before and after match |
| `-e` | `--regexp=PATTERN` | Specify multiple patterns |
| `-f` | `--file=FILE` | Read patterns from a file |
| `-q` | `--quiet` | Quiet mode (no output, exit status only) |
| `-s` | `--no-messages` | Suppress error messages |
| `-H` | `--with-filename` | Print filename with output |
| `-h` | `--no-filename` | Suppress filename in output |

---

## 3. Regular Expressions Fundamentals

### What are Regular Expressions?

Regular expressions (regex) are patterns used to match character combinations in strings. grep supports three types:

| Type | Option | Description |
|------|--------|-------------|
| BRE | `-G` (default) | Basic Regular Expressions |
| ERE | `-E` | Extended Regular Expressions |
| PCRE | `-P` | Perl-Compatible Regular Expressions |

> **RHCSA Focus**: You mainly need to know BRE and ERE for the exam.

---

## 4. Basic Regular Expressions (BRE)

### Metacharacters in BRE

| Character | Meaning | Example | Matches |
|-----------|---------|---------|---------|
| `.` | Any single character | `a.c` | abc, aXc, a1c |
| `*` | Zero or more of preceding | `ab*c` | ac, abc, abbc |
| `^` | Start of line | `^root` | Lines starting with "root" |
| `$` | End of line | `bash$` | Lines ending with "bash" |
| `[]` | Character class | `[abc]` | a, b, or c |
| `[^]` | Negated character class | `[^0-9]` | Any non-digit |
| `\` | Escape special character | `\.` | Literal dot |
| `\<` | Beginning of word | `\<root` | Words starting with "root" |
| `\>` | End of word | `root\>` | Words ending with "root" |

### BRE Interval Expressions (require backslash)

| Pattern | Meaning |
|---------|---------|
| `\{n\}` | Exactly n occurrences |
| `\{n,\}` | n or more occurrences |
| `\{n,m\}` | Between n and m occurrences |

### BRE Grouping and Back-references

| Pattern | Meaning |
|---------|---------|
| `\(pattern\)` | Group pattern (captured) |
| `\1`, `\2` | Back-reference to captured group |

---

## 5. Extended Regular Expressions (ERE)

When using `grep -E` (or `egrep`), the following metacharacters work without escaping:

### ERE Metacharacters

| Character | Meaning | Example | Matches |
|-----------|---------|---------|---------|
| `.` | Any single character | `a.c` | abc, aXc |
| `*` | Zero or more of preceding | `ab*c` | ac, abc, abbc |
| `+` | One or more of preceding | `ab+c` | abc, abbc (not ac) |
| `?` | Zero or one of preceding | `ab?c` | ac, abc |
| `^` | Start of line | `^root` | Lines starting with "root" |
| `$` | End of line | `bash$` | Lines ending with "bash" |
| `[]` | Character class | `[abc]` | a, b, or c |
| `[^]` | Negated character class | `[^0-9]` | Any non-digit |
| `\|` | Alternation (OR) | `cat\|dog` | cat or dog |
| `()` | Grouping | `(ab)+` | ab, abab, ababab |
| `{n}` | Exactly n occurrences | `a{3}` | aaa |
| `{n,}` | n or more occurrences | `a{2,}` | aa, aaa, aaaa |
| `{n,m}` | Between n and m | `a{2,4}` | aa, aaa, aaaa |

### BRE vs ERE Comparison

| Feature | BRE | ERE |
|---------|-----|-----|
| Zero or more | `*` | `*` |
| One or more | Not available | `+` |
| Zero or one | Not available | `?` |
| Alternation | `\|` | `|` |
| Grouping | `\(\)` | `()` |
| Interval | `\{n,m\}` | `{n,m}` |

---

## 6. POSIX Character Classes

These work inside bracket expressions `[[:class:]]`:

| Class | Description | Equivalent |
|-------|-------------|------------|
| `[[:alnum:]]` | Alphanumeric | `[A-Za-z0-9]` |
| `[[:alpha:]]` | Alphabetic | `[A-Za-z]` |
| `[[:digit:]]` | Digits | `[0-9]` |
| `[[:lower:]]` | Lowercase letters | `[a-z]` |
| `[[:upper:]]` | Uppercase letters | `[A-Z]` |
| `[[:space:]]` | Whitespace characters | space, tab, newline |
| `[[:blank:]]` | Space and tab only | space, tab |
| `[[:punct:]]` | Punctuation characters | `!"#$%&'()*+,-./:;<=>?@[\]^_{|}~` |
| `[[:xdigit:]]` | Hexadecimal digits | `[0-9A-Fa-f]` |

> **Important**: Note the double brackets: `[[:digit:]]` not `[:digit:]`

---

## 7. Anchoring and Word Boundaries

### Line Anchors

| Anchor | Meaning |
|--------|---------|
| `^` | Beginning of line |
| `$` | End of line |
| `^$` | Empty line |

### Word Boundaries

| Anchor | Meaning |
|--------|---------|
| `\<` | Beginning of word |
| `\>` | End of word |
| `\b` | Word boundary (either end) |
| `\B` | Non-word boundary |

---

## 8. Real-World Exam Practice Questions

### Question 1: Search for a User in /etc/passwd

**Task**: Find all lines in `/etc/passwd` that contain the username "root".

**Solution**:
```bash
grep 'root' /etc/passwd
```

**Output**:
```
root:x:0:0:root:/root:/bin/bash
```

---

### Question 2: Case-Insensitive Search

**Task**: Search for "error" in `/var/log/messages` regardless of case.

**Solution**:
```bash
grep -i 'error' /var/log/messages
```

---

### Question 3: Count Matching Lines

**Task**: Count how many lines in `/etc/passwd` contain "/bin/bash".

**Solution**:
```bash
grep -c '/bin/bash' /etc/passwd
```

---

### Question 4: Display Line Numbers

**Task**: Find "Failed" in `/var/log/secure` and show line numbers.

**Solution**:
```bash
grep -n 'Failed' /var/log/secure
```

---

### Question 5: Match Lines Starting with a Pattern

**Task**: Find all lines in `/etc/passwd` that start with "root".

**Solution**:
```bash
grep '^root' /etc/passwd
```

---

### Question 6: Match Lines Ending with a Pattern

**Task**: Find all users whose shell ends with "bash" in `/etc/passwd`.

**Solution**:
```bash
grep 'bash$' /etc/passwd
```

---

### Question 7: Find Empty Lines

**Task**: Find all empty lines in a configuration file.

**Solution**:
```bash
grep '^$' /etc/ssh/sshd_config
```

**To count them**:
```bash
grep -c '^$' /etc/ssh/sshd_config
```

---

### Question 8: Invert Match (Exclude Lines)

**Task**: Display all lines in `/etc/passwd` that do NOT contain "nologin".

**Solution**:
```bash
grep -v 'nologin' /etc/passwd
```

---

### Question 9: Filter Out Comments and Empty Lines

**Task**: Display only active configuration lines (no comments, no empty lines) from a config file.

**Solution**:
```bash
grep -v '^#' /etc/ssh/sshd_config | grep -v '^$'
```

**Or using ERE**:
```bash
grep -Ev '^#|^$' /etc/ssh/sshd_config
```

---

### Question 10: Match Whole Words Only

**Task**: Find the word "root" but not "chroot" or "rootless".

**Solution**:
```bash
grep -w 'root' /etc/passwd
```

---

### Question 11: Match Multiple Patterns (OR)

**Task**: Find lines containing either "root" or "admin" in `/etc/passwd`.

**Solution using ERE**:
```bash
grep -E 'root|admin' /etc/passwd
```

**Solution using multiple -e options**:
```bash
grep -e 'root' -e 'admin' /etc/passwd
```

---

### Question 12: Search Recursively in Directories

**Task**: Search for "ServerRoot" in all files under `/etc/httpd/`.

**Solution**:
```bash
grep -r 'ServerRoot' /etc/httpd/
```

**Show only filenames**:
```bash
grep -rl 'ServerRoot' /etc/httpd/
```

---

### Question 13: Match Any Single Character

**Task**: Find all 3-letter words starting with "b" and ending with "t".

**Solution**:
```bash
grep '\<b.t\>' /usr/share/dict/words
```

This matches: bat, bet, bit, bot, but

---

### Question 14: Match a Range of Characters

**Task**: Find lines containing any digit in a file.

**Solution**:
```bash
grep '[0-9]' filename
```

---

### Question 15: Match Lines with Only Digits

**Task**: Find lines that contain only digits.

**Solution**:
```bash
grep '^[0-9]*$' filename
```

**Or with ERE**:
```bash
grep -E '^[0-9]+$' filename
```

---

### Question 16: Find IP Addresses

**Task**: Extract lines containing IP address patterns from a log file.

**Solution**:
```bash
grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /var/log/secure
```

---

### Question 17: Match Lines with Specific Length

**Task**: Find lines with exactly 10 characters.

**Solution**:
```bash
grep '^.\{10\}$' filename
```

**With ERE**:
```bash
grep -E '^.{10}$' filename
```

---

### Question 18: Context Lines (Before and After)

**Task**: Show 3 lines before and after each match of "error" in a log file.

**Solution**:
```bash
grep -C 3 'error' /var/log/messages
```

**Only lines after**:
```bash
grep -A 3 'error' /var/log/messages
```

**Only lines before**:
```bash
grep -B 3 'error' /var/log/messages
```

---

### Question 19: Find Files Containing a Pattern

**Task**: List all files in `/etc/` that contain the word "SELINUX".

**Solution**:
```bash
grep -rl 'SELINUX' /etc/
```

---

### Question 20: Find Non-HTTPS URLs (Security Audit)

**Task**: Find HTTP links that are NOT using HTTPS (potential security issue).

**Solution**:
```bash
grep -r 'http[^s]' /etc/
```

**Explanation**: The `[^s]` means "not followed by s", so `http[^s]` matches "http:" but not "https:".

---

### Question 21: Match Beginning of Word

**Task**: Find all words starting with "admin" in `/etc/passwd`.

**Solution**:
```bash
grep '\<admin' /etc/passwd
```

---

### Question 22: Escape Special Characters

**Task**: Search for a literal dot (.) in a file.

**Solution**:
```bash
grep '\.' filename
```

**Find IP pattern with literal dots**:
```bash
grep '192\.168\.1\.1' /etc/hosts
```

---

### Question 23: Match Repeated Characters

**Task**: Find lines with two or more consecutive "o" characters.

**Solution with BRE**:
```bash
grep 'oo\{1,\}' filename
```

**With ERE**:
```bash
grep -E 'o{2,}' filename
```

---

### Question 24: Using POSIX Character Classes

**Task**: Find lines starting with an uppercase letter.

**Solution**:
```bash
grep '^[[:upper:]]' filename
```

---

### Question 25: Find Lines with Alphanumeric Start

**Task**: Find lines that start with any alphanumeric character.

**Solution**:
```bash
grep '^[[:alnum:]]' filename
```

---

### Question 26: Match Using Back-references

**Task**: Find lines where a character is immediately repeated.

**Solution**:
```bash
grep '\(.\)\1' filename
```

This finds: aa, bb, 11, ##, etc.

---

### Question 27: Quiet Mode for Scripting

**Task**: Check if a file contains "ENABLED" and use it in a script condition.

**Solution**:
```bash
if grep -q 'ENABLED' /etc/sysconfig/selinux; then
    echo "SELinux is enabled"
else
    echo "SELinux is not enabled"
fi
```

---

### Question 28: Print Only the Matched Part

**Task**: Extract only the matched email addresses from a file.

**Solution**:
```bash
grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' filename
```

---

### Question 29: Search in Compressed Files

**Task**: Search for "error" in a gzipped log file.

**Solution**:
```bash
zgrep 'error' /var/log/messages.1.gz
```

---

### Question 30: Copy Matching Lines to File (Exam Style)

**Task**: Find all lines in `/usr/share/xml/iso-codes/iso_639_3.xml` that contain the string "ng". Copy these lines to `/root/list` in their original order. The output file must **not** contain empty lines, and all lines must be exact copies of the original matching lines.

<details>
<summary>Show Solution</summary>

```bash
grep 'ng' /usr/share/xml/iso-codes/iso_639_3.xml | grep -v '^$' > /root/list
```

**Explanation:**
- `grep 'ng'` finds all lines containing "ng"
- `grep -v '^$'` removes any empty lines
- `> /root/list` redirects output to the file

**Alternative approach:**
```bash
grep 'ng' /usr/share/xml/iso-codes/iso_639_3.xml > /root/list
```
> If the source file doesn't have empty lines matching the pattern, the simpler version works.

**Verification:**
```bash
cat /root/list | head
wc -l /root/list
grep -c '^$' /root/list   # Should return 0
```
</details>

---

### Question 31: Extract Lines Without Empty Lines

**Task**: Extract all lines containing "error" from `/var/log/messages` to `/tmp/errors.txt`, excluding any empty lines.

<details>
<summary>Show Solution</summary>

```bash
sudo grep -i 'error' /var/log/messages | grep -v '^$' > /tmp/errors.txt
```

**Alternative using grep with extended regex:**
```bash
sudo grep -iE 'error' /var/log/messages | grep -v '^$' > /tmp/errors.txt
```
</details>

---

## 9. Common Exam Scenarios

### Scenario A: Finding Users with Specific Shell

Find all users who use `/bin/bash`:
```bash
grep '/bin/bash$' /etc/passwd
```

### Scenario B: Finding Failed Login Attempts

```bash
grep -i 'failed' /var/log/secure
```

### Scenario C: Extracting Usernames from /etc/passwd

```bash
grep -oE '^[^:]+' /etc/passwd
```

### Scenario D: Finding Commented Lines

```bash
grep '^#' /etc/ssh/sshd_config
```

### Scenario E: Finding Non-Commented Configuration Lines

```bash
grep -v '^#' /etc/ssh/sshd_config | grep -v '^$'
```

---

## 10. Exit Status

Understanding exit status is important for scripting:

| Exit Status | Meaning |
|-------------|---------|
| 0 | Match found |
| 1 | No match found |
| 2 | Error occurred |

**Example usage in scripts**:
```bash
grep -q 'pattern' file && echo "Found" || echo "Not found"
```

---

## 11. Important Tips for RHCSA Exam

1. **Quote your patterns**: Always use single quotes around patterns to prevent shell interpretation
   ```bash
   grep 'pattern' file    # Correct
   grep pattern file      # May work, but risky
   ```

2. **Use -E for complex patterns**: Extended regex is easier to read
   ```bash
   grep -E 'word1|word2|word3' file
   ```

3. **Remember the difference**:
   - `grep` = BRE (need to escape `()`, `{}`, `|`)
   - `grep -E` = ERE (no escaping needed for `+`, `?`, `()`, `{}`, `|`)

4. **For searching configuration files**:
   ```bash
   grep -Ev '^#|^$' /etc/config.conf
   ```

5. **For finding files containing patterns**:
   ```bash
   grep -rl 'pattern' /path/to/search/
   ```

6. **Word boundaries prevent partial matches**:
   ```bash
   grep -w 'root' /etc/passwd    # Only "root", not "chroot"
   ```

---

## Quick Reference Table

| Task | Command |
|------|---------|
| Case-insensitive search | `grep -i 'pattern' file` |
| Invert match | `grep -v 'pattern' file` |
| Show line numbers | `grep -n 'pattern' file` |
| Count matches | `grep -c 'pattern' file` |
| Match whole word | `grep -w 'pattern' file` |
| Recursive search | `grep -r 'pattern' directory/` |
| Multiple patterns (OR) | `grep -E 'pat1\|pat2' file` |
| Lines starting with | `grep '^pattern' file` |
| Lines ending with | `grep 'pattern$' file` |
| Empty lines | `grep '^$' file` |
| Non-empty lines | `grep '.' file` |
| Lines with digits | `grep '[0-9]' file` |
| Lines without digits | `grep -v '[0-9]' file` |
| Context (before/after) | `grep -C 3 'pattern' file` |
| Quiet mode (scripting) | `grep -q 'pattern' file` |
| Show only match | `grep -o 'pattern' file` |
| Fixed string (no regex) | `grep -F 'literal' file` |

---

## Regex Quick Reference

| Pattern | Description | Example |
|---------|-------------|---------|
| `.` | Any single character | `a.c` matches abc |
| `*` | Zero or more | `ab*c` matches ac, abc, abbc |
| `+` (ERE) | One or more | `ab+c` matches abc, abbc |
| `?` (ERE) | Zero or one | `ab?c` matches ac, abc |
| `^` | Start of line | `^root` |
| `$` | End of line | `bash$` |
| `[abc]` | Character class | `[aeiou]` matches vowels |
| `[^abc]` | Negated class | `[^0-9]` matches non-digits |
| `[a-z]` | Range | `[A-Za-z]` matches letters |
| `\|` (ERE) | Alternation | `cat\|dog` |
| `{n}` | Exactly n times | `a{3}` matches aaa |
| `{n,m}` | n to m times | `a{2,4}` matches aa, aaa, aaaa |
| `\<` | Word start | `\<root` |
| `\>` | Word end | `root\>` |
| `[[:class:]]` | POSIX class | `[[:digit:]]` |

---

## Summary

For the RHCSA exam, master these grep skills:
- Basic pattern searching with various options
- Using `^` and `$` anchors
- Character classes `[]` and POSIX classes `[[:class:]]`
- Word boundaries `\<` and `\>`
- Case-insensitive and inverted searches
- Recursive directory searching
- Combining grep with pipes for text processing
- Using `grep -E` for extended regular expressions
- Context lines with `-A`, `-B`, `-C`
- Scripting with `-q` for exit status checks
