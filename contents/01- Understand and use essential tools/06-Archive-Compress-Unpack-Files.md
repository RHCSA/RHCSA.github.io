# Archive, Compress, Unpack, and Uncompress Files Using tar, gzip, and bzip2

## Table of Contents
1. [Introduction](#introduction)
2. [Understanding Archive vs Compression](#understanding-archive-vs-compression)
3. [The tar Command](#the-tar-command)
4. [The gzip Command](#the-gzip-command)
5. [The bzip2 Command](#the-bzip2-command)
6. [Creating Compressed Archives](#creating-compressed-archives)
7. [Practice Questions](#practice-questions)
8. [Quick Reference](#quick-reference)
9. [Summary](#summary)

---

## Introduction

In the RHCSA exam, you must demonstrate proficiency in archiving and compressing files using `tar`, `gzip`, and `bzip2`. These tools are essential for:
- Creating backups
- Transferring multiple files efficiently
- Reducing storage space
- Packaging files for distribution

---

## Understanding Archive vs Compression

| Concept | Description | Tool |
|---------|-------------|------|
| **Archive** | Combines multiple files into a single file (no size reduction) | `tar` |
| **Compression** | Reduces file size using algorithms | `gzip`, `bzip2` |
| **Compressed Archive** | Archive that is also compressed | `tar` with `-z` or `-j` |

**Key Point:** `tar` creates archives (also called tarballs). `gzip` and `bzip2` compress files. They are often used together.

---

## The tar Command

### Basic Syntax
```bash
tar [OPTIONS] [ARCHIVE_NAME] [FILES/DIRECTORIES]
```

### Essential tar Options (MUST KNOW)

| Option | Long Option | Description |
|--------|-------------|-------------|
| `-c` | `--create` | Create a new archive |
| `-x` | `--extract` | Extract files from an archive |
| `-t` | `--list` | List contents of an archive |
| `-v` | `--verbose` | Verbose output (show files being processed) |
| `-f` | `--file` | Specify archive filename (ALWAYS required except stdin/stdout) |
| `-z` | `--gzip` | Compress/decompress with gzip |
| `-j` | `--bzip2` | Compress/decompress with bzip2 |
| `-p` | `--preserve-permissions` | Preserve file permissions |
| `-C` | `--directory` | Change to directory before operation |

### File Extension Conventions

| Extension | Description | Options Used |
|-----------|-------------|--------------|
| `.tar` | Uncompressed tar archive | `-cvf` / `-xvf` |
| `.tar.gz` or `.tgz` | gzip compressed tar archive | `-cvzf` / `-xvzf` |
| `.tar.bz2` or `.tbz2` | bzip2 compressed tar archive | `-cvjf` / `-xvjf` |

---

## The gzip Command

### Basic Syntax
```bash
gzip [OPTIONS] [FILE]
gunzip [FILE.gz]
```

### gzip Options

| Option | Description |
|--------|-------------|
| `-d` | Decompress (same as `gunzip`) |
| `-k` | Keep original file after compression |
| `-c` | Write to stdout, keep original file |
| `-v` | Verbose (show compression ratio) |
| `-r` | Recursive (compress files in directories) |
| `-1` to `-9` | Compression level (1=fastest, 9=best compression) |
| `-l` | List compression information |

### Key Behaviors
- **Default behavior**: Original file is replaced with `.gz` version
- **To keep original**: Use `-k` or redirect with `-c`
- `gunzip` is equivalent to `gzip -d`
- `zcat` is equivalent to `gunzip -c` (decompress to stdout)

---

## The bzip2 Command

### Basic Syntax
```bash
bzip2 [OPTIONS] [FILE]
bunzip2 [FILE.bz2]
```

### bzip2 Options

| Option | Description |
|--------|-------------|
| `-d` | Decompress (same as `bunzip2`) |
| `-k` | Keep original file after compression |
| `-c` | Write to stdout, keep original file |
| `-v` | Verbose (show compression ratio) |
| `-1` to `-9` | Compression level (1=fastest, 9=best compression) |

### Key Behaviors
- **Default behavior**: Original file is replaced with `.bz2` version
- **Better compression** than gzip but slower
- `bunzip2` is equivalent to `bzip2 -d`
- `bzcat` is equivalent to `bunzip2 -c` (decompress to stdout)

---

## The xz Command

`xz` provides better compression than both gzip and bzip2, but is slower.

### Basic Syntax
```bash
xz [OPTIONS] [FILE]
unxz [FILE.xz]
```

### xz Options

| Option | Description |
|--------|-------------|
| `-d` | Decompress (same as `unxz`) |
| `-k` | Keep original file after compression |
| `-c` | Write to stdout, keep original file |
| `-v` | Verbose (show compression ratio) |
| `-1` to `-9` | Compression level (1=fastest, 9=best compression) |

### Examples

```bash
# Compress a file (removes original)
xz file.txt

# Compress and keep original
xz -k file.txt

# Decompress
unxz file.txt.xz
xz -d file.txt.xz
xz --decompress file.txt.xz

# View compressed file without decompressing
xzcat file.txt.xz
```

### tar with xz Compression

| Task | Command |
|------|---------|
| Create xz archive | `tar -cvJf archive.tar.xz files/` |
| Extract xz archive | `tar -xvJf archive.tar.xz` |
| List xz archive contents | `tar -tvJf archive.tar.xz` |

**Note:** Use uppercase `-J` for xz compression with tar.

---

## The zip/unzip Commands

The `zip` format is useful for cross-platform compatibility.

```bash
# Compress a directory recursively
zip -r archive.zip directory/

# Extract a zip archive
unzip archive.zip

# Extract to specific directory
unzip archive.zip -d /destination/

# List contents without extracting
unzip -l archive.zip
```

---

## Compression Comparison

| Tool | Extension | Compression | Speed | tar Option |
|------|-----------|-------------|-------|------------|
| gzip | .gz | Good | Fast | `-z` |
| bzip2 | .bz2 | Better | Slower | `-j` |
| xz | .xz | Best | Slowest | `-J` |

---

## Creating Compressed Archives

### Common tar+compression Combinations

| Task | Command |
|------|---------|
| Create gzip archive | `tar -cvzf archive.tar.gz files/` |
| Create bzip2 archive | `tar -cvjf archive.tar.bz2 files/` |
| Extract gzip archive | `tar -xvzf archive.tar.gz` |
| Extract bzip2 archive | `tar -xvjf archive.tar.bz2` |
| List gzip archive contents | `tar -tvzf archive.tar.gz` |
| List bzip2 archive contents | `tar -tvjf archive.tar.bz2` |

---

## Practice Questions

### Question 1: Create a tar Archive
**Task:** Create an uncompressed tar archive named `backup.tar` containing all files in `/etc/sysconfig/`.

**Solution:**
```bash
tar -cvf backup.tar /etc/sysconfig/
```

**Explanation:**
- `-c`: Create a new archive
- `-v`: Verbose output
- `-f backup.tar`: Specify the archive filename
- `/etc/sysconfig/`: Source directory to archive

---

### Question 2: Create a gzip Compressed Archive
**Task:** Create a gzip compressed tar archive named `logs.tar.gz` containing all `.log` files in `/var/log/`.

**Solution:**
```bash
tar -cvzf logs.tar.gz /var/log/*.log
```

**Explanation:**
- `-c`: Create archive
- `-v`: Verbose
- `-z`: Compress with gzip
- `-f logs.tar.gz`: Output filename
- `/var/log/*.log`: All log files

---

### Question 3: Create a bzip2 Compressed Archive
**Task:** Create a bzip2 compressed archive named `home_backup.tar.bz2` of the `/home/user1` directory.

**Solution:**
```bash
tar -cvjf home_backup.tar.bz2 /home/user1
```

**Explanation:**
- `-j`: Compress with bzip2
- Better compression ratio than gzip, but takes longer

---

### Question 4: Extract an Archive to Current Directory
**Task:** Extract all contents of `archive.tar.gz` to the current directory.

**Solution:**
```bash
tar -xvzf archive.tar.gz
```

**Explanation:**
- `-x`: Extract
- `-v`: Verbose
- `-z`: Decompress gzip
- `-f archive.tar.gz`: Archive file

---

### Question 5: Extract an Archive to a Specific Directory
**Task:** Extract `backup.tar.gz` to the `/tmp/restore` directory.

**Solution:**
```bash
mkdir -p /tmp/restore
tar -xvzf backup.tar.gz -C /tmp/restore
```

**Explanation:**
- `-C /tmp/restore`: Change to this directory before extracting
- The directory must exist before extraction

---

### Question 6: List Contents of an Archive Without Extracting
**Task:** View the contents of `data.tar.bz2` without extracting it.

**Solution:**
```bash
tar -tvjf data.tar.bz2
```

**Explanation:**
- `-t`: List (table of contents)
- `-v`: Verbose (shows permissions, owner, size, date)
- `-j`: bzip2 compressed
- `-f`: Specify archive file

---

### Question 7: Extract a Single File from an Archive
**Task:** Extract only the file `etc/passwd` from `system.tar.gz`.

**Solution:**
```bash
tar -xvzf system.tar.gz etc/passwd
```

**Explanation:**
- Specify the exact path as it appears in the archive
- Use `tar -tvzf` first to see the exact path of files

---

### Question 8: Compress a File Using gzip
**Task:** Compress the file `/var/log/messages` using gzip while keeping the original file.

**Solution:**
```bash
gzip -k /var/log/messages
```

**Alternative (using stdout):**
```bash
gzip -c /var/log/messages > /var/log/messages.gz
```

**Explanation:**
- `-k`: Keep original file
- Without `-k`, the original file is replaced

---

### Question 9: Decompress a gzip File
**Task:** Decompress `data.gz` to its original form.

**Solution:**
```bash
gunzip data.gz
```

**Alternative:**
```bash
gzip -d data.gz
```

**Explanation:**
- `gunzip` and `gzip -d` are equivalent
- The `.gz` file is replaced with the uncompressed file

---

### Question 10: Compress a File Using bzip2
**Task:** Compress `largefile.txt` using bzip2 with maximum compression.

**Solution:**
```bash
bzip2 -9 largefile.txt
```

**Explanation:**
- `-9`: Maximum compression (slowest)
- Default is `-9` for bzip2
- Creates `largefile.txt.bz2`

---

### Question 11: Decompress a bzip2 File While Keeping the Compressed Version
**Task:** Decompress `archive.bz2` but keep the original compressed file.

**Solution:**
```bash
bunzip2 -k archive.bz2
```

**Alternative:**
```bash
bzip2 -dk archive.bz2
```

**Explanation:**
- `-k`: Keep the original compressed file
- `-d`: Decompress

---

### Question 12: View Compressed File Contents Without Decompressing
**Task:** View the contents of `readme.gz` without decompressing it.

**Solution:**
```bash
zcat readme.gz
```

**Alternative:**
```bash
gunzip -c readme.gz
```

**For bzip2 files:**
```bash
bzcat readme.bz2
```

---

### Question 13: Create Archive with Preserved Permissions
**Task:** Create a tar archive of `/etc` with preserved permissions, named `etc_backup.tar`.

**Solution:**
```bash
tar -cvpf etc_backup.tar /etc
```

**Explanation:**
- `-p`: Preserve permissions (important for system backups)
- Essential when restoring system configuration files

---

### Question 14: Create Archive Excluding Certain Files
**Task:** Create a gzip compressed archive of `/home` excluding all `.mp3` files.

**Solution:**
```bash
tar -cvzf home_backup.tar.gz --exclude='*.mp3' /home
```

**Explanation:**
- `--exclude='pattern'`: Exclude files matching the pattern
- Multiple `--exclude` options can be used

---

### Question 15: Append Files to an Existing Archive
**Task:** Add the file `/etc/hosts` to an existing archive `config.tar`.

**Solution:**
```bash
tar -rvf config.tar /etc/hosts
```

**Explanation:**
- `-r`: Append to archive
- **Note:** Cannot append to compressed archives (`.tar.gz` or `.tar.bz2`)

---

### Question 16: Extract with Directory Structure Stripped
**Task:** Extract files from `backup.tar.gz` removing the leading directory components (extract files directly).

**Solution:**
```bash
tar -xvzf backup.tar.gz --strip-components=1
```

**Explanation:**
- `--strip-components=N`: Strip N leading directory components
- Useful when you don't want the original directory structure

---

### Question 17: Create Archive from File List
**Task:** Create an archive from a list of files stored in `filelist.txt`.

**Solution:**
```bash
tar -cvf archive.tar -T filelist.txt
```

**Explanation:**
- `-T filelist.txt`: Read file names from the specified file
- Each filename should be on a separate line

---

### Question 18: Check gzip File Integrity
**Task:** Verify the integrity of `data.tar.gz` without extracting.

**Solution:**
```bash
gzip -t data.tar.gz && echo "File OK"
```

**For tar archive integrity:**
```bash
tar -tzf data.tar.gz > /dev/null && echo "Archive OK"
```

---

### Question 19: Create Archive of Multiple Directories
**Task:** Create a single compressed archive containing `/etc/ssh`, `/etc/pam.d`, and `/etc/security`.

**Solution:**
```bash
tar -cvzf security_config.tar.gz /etc/ssh /etc/pam.d /etc/security
```

**Explanation:**
- Multiple source directories can be specified
- All will be included in a single archive

---

### Question 20: Extract and Overwrite Existing Files
**Task:** Extract `update.tar.gz` overwriting any existing files without prompting.

**Solution:**
```bash
tar -xvzf update.tar.gz --overwrite
```

**Explanation:**
- `--overwrite`: Replace existing files without asking
- Default behavior is to overwrite, but explicit option ensures it

---

### Question 21: Compare Compression Ratios
**Task:** Compress `large_file.txt` with both gzip and bzip2 and compare the results.

**Solution:**
```bash
# Compress with gzip
gzip -c large_file.txt > large_file.txt.gz

# Compress with bzip2
bzip2 -c large_file.txt > large_file.txt.bz2

# Compare sizes
ls -lh large_file.txt*
```

**Expected Result:**
- bzip2 typically produces smaller files but takes longer
- gzip is faster but slightly larger files

---

### Question 22: Extract Specific Directory from Archive
**Task:** Extract only the `home/user1/Documents` directory from `full_backup.tar.gz`.

**Solution:**
```bash
tar -xvzf full_backup.tar.gz home/user1/Documents
```

**Explanation:**
- Specify the exact path as it appears in the archive
- Use `tar -tvzf` to list contents first if unsure

---

### Question 23: Create Archive with Absolute Paths
**Task:** Create an archive preserving absolute paths (not recommended but sometimes needed).

**Solution:**
```bash
tar -cvPf absolute_backup.tar /etc/passwd /etc/shadow
```

**Explanation:**
- `-P`: Don't strip leading `/` from paths
- Use with caution - can overwrite system files on extraction
- Default behavior removes leading `/` for safety

---

### Question 24: Recursive gzip Compression
**Task:** Compress all files in `/var/log/old/` recursively using gzip.

**Solution:**
```bash
gzip -rv /var/log/old/
```

**Explanation:**
- `-r`: Recursive operation
- Each file is compressed individually
- Use tar for a single archive of the directory

---

### Question 25: Extract to Stdout and Pipe to Another Command
**Task:** Extract a specific file from an archive and count its lines without creating a file on disk.

**Solution:**
```bash
tar -xzf archive.tar.gz -O path/to/file.txt | wc -l
```

**Explanation:**
- `-O` or `--to-stdout`: Extract to standard output
- Useful for piping to other commands
- No files are created on disk

---

## Quick Reference

### tar Commands Summary

| Action | Command |
|--------|---------|
| Create tar archive | `tar -cvf archive.tar files/` |
| Create tar.gz archive | `tar -cvzf archive.tar.gz files/` |
| Create tar.bz2 archive | `tar -cvjf archive.tar.bz2 files/` |
| Extract tar archive | `tar -xvf archive.tar` |
| Extract tar.gz archive | `tar -xvzf archive.tar.gz` |
| Extract tar.bz2 archive | `tar -xvjf archive.tar.bz2` |
| Extract to specific dir | `tar -xvzf archive.tar.gz -C /path/` |
| List tar contents | `tar -tvf archive.tar` |
| List tar.gz contents | `tar -tvzf archive.tar.gz` |
| Extract single file | `tar -xvzf archive.tar.gz path/file` |
| Append to archive | `tar -rvf archive.tar newfile` |
| Preserve permissions | `tar -cvpf archive.tar files/` |

### gzip Commands Summary

| Action | Command |
|--------|---------|
| Compress file | `gzip filename` |
| Compress keeping original | `gzip -k filename` |
| Decompress file | `gunzip filename.gz` |
| Decompress keeping compressed | `gunzip -k filename.gz` |
| View without decompressing | `zcat filename.gz` |
| Test integrity | `gzip -t filename.gz` |
| Show compression info | `gzip -l filename.gz` |
| Maximum compression | `gzip -9 filename` |
| Fastest compression | `gzip -1 filename` |

### bzip2 Commands Summary

| Action | Command |
|--------|---------|
| Compress file | `bzip2 filename` |
| Compress keeping original | `bzip2 -k filename` |
| Decompress file | `bunzip2 filename.bz2` |
| Decompress keeping compressed | `bunzip2 -k filename.bz2` |
| View without decompressing | `bzcat filename.bz2` |
| Maximum compression | `bzip2 -9 filename` |

### Option Memory Aids

| Letter | Meaning |
|--------|---------|
| **c** | **C**reate |
| **x** | e**X**tract |
| **t** | lis**T** (table of contents) |
| **v** | **V**erbose |
| **f** | **F**ile (archive name follows) |
| **z** | g**Z**ip |
| **j** | bzip2 (**j** looks like a hook for bz) |
| **p** | **P**reserve permissions |
| **C** | **C**hange directory |

---

## Summary

### Key Points for the RHCSA Exam

1. **tar options order**: Options can be combined; `-f` must come last before filename
   ```bash
   tar -cvzf archive.tar.gz files/   # Correct
   tar -cvfz archive.tar.gz files/   # WRONG - z would be treated as filename
   ```

2. **Compression comparison**:
   - `gzip`: Faster, moderate compression, uses `.gz`
   - `bzip2`: Slower, better compression, uses `.bz2`

3. **Default behaviors to remember**:
   - `gzip`/`bzip2` replace original files (use `-k` to keep)
   - `tar` removes leading `/` from paths (use `-P` to preserve)
   - Extract goes to current directory (use `-C` to change)

4. **Cannot do with compressed archives**:
   - Append files (`-r`)
   - Update files (`-u`)
   - Delete files (`--delete`)

5. **Always use `-f` with tar** to specify the archive filename

6. **Common exam tasks**:
   - Create compressed backups of directories
   - Extract archives to specific locations
   - List archive contents without extracting
   - Compress/decompress individual files
   - Preserve permissions during archive creation

### Exam Tips

- Practice the common combinations until they become automatic
- Remember that `tar` auto-detects compression when extracting (you can use just `tar -xvf` for any format)
- Use `tar -tvf` to inspect archive contents before extracting
- Always verify important backups with `tar -tvf` or test extraction
