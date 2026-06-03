# Use Exit Codes and Debugging

## Objective

Exit codes are used in shell scripting to indicate whether a command or script completed successfully. A value of `0` typically indicates success, while non-zero values indicate an error or failure condition.

In this exercise, you will create a shell script that checks for the existence of a file and returns different exit codes based on the result. You will also verify the script's exit status after execution.

This exercise demonstrates how exit codes can be used to control script behavior and provide feedback to users and automated processes.

### Learning Outcomes

After completing this exercise, you will be able to:

* Create and execute shell scripts.
* Check whether a file exists.
* Use exit codes to indicate success or failure.
* Verify script exit status using shell commands.
* Understand how exit codes are used in Linux automation.

### Estimated Time

**10 Minutes**

---

## Access Information

Connect to the Linux virtual machine using the credentials provided below.

### SSH Command

```bash
ssh <inject key="VMUserName" enableCopy="true"/>@<inject key="VMPublicDNSName" enableCopy="true"/>
```

### Username

```text
<inject key="VMUserName" enableCopy="true"/>
```

### Password

```text
<inject key="VMPassword" enableCopy="true"/>
```

> **Note:** If prompted to verify the server fingerprint during the first connection attempt, type **yes** and press **Enter**.

---

## Environment Information

A sample file has been preconfigured for this exercise.

File location:

```bash
/opt/data/testfile.txt
```

Verify that the file exists:

```bash
ls -l /opt/data/testfile.txt
```

Expected output:

```text
/opt/data/testfile.txt
```

---

# Task : Create a Script Using Exit Codes

> **Note:** Follow the specified file names and paths exactly to ensure validation succeeds.

### Step 1: Navigate to the Scripts Directory

```bash
cd ~/scripts
```

Verify your current location:

```bash
pwd
```

Expected output:

```text
/home/<inject key="VMUserName" enableCopy="true"/>/scripts
```

---

### Step 2: Create the Script

Create a new shell script:

```bash
nano file_check.sh
```

---

### Step 3: Configure the Script

Configure the script to:

* Check whether the following file exists:

```bash
/opt/data/testfile.txt
```

* Display:

```text
File exists.
```

when the file is present.

* Display:

```text
File not found.
```

when the file is missing.

* Return:

```text
Exit Code 0
```

for success.

* Return:

```text
Exit Code 1
```

for failure.

---

### Step 4: Save the Script

Save and exit Nano:

```text
Ctrl + O
Enter
Ctrl + X
```

---

### Step 5: Make the Script Executable

```bash
chmod +x file_check.sh
```

Verify permissions:

```bash
ls -l file_check.sh
```

Expected output should include:

```text
-rwx
```

---

### Step 6: Execute the Script

Run the script:

```bash
./file_check.sh
```

Expected output:

```text
File exists.
```

---

### Step 7: Verify the Exit Code

Immediately after running the script, execute:

```bash
echo $?
```

Expected output:

```text
0
```

---

## Success Criteria

Your solution is successful when:

* A script named `file_check.sh` exists.
* The script checks for `/opt/data/testfile.txt`.
* The script displays a status message.
* The script returns exit code `0` when the file exists.
* The script returns exit code `1` when the file does not exist.

---

## Validation Requirements

Validation will verify that:

* `~/scripts/file_check.sh` exists.
* The script contains success and failure exit codes.
* The script checks for `/opt/data/testfile.txt`.
* The script returns exit code `0` when the file exists.
* The script returns exit code `1` when the file is missing.

<validation step="DEBUG-TASK1" />

---

## Completion Criteria

You have successfully completed this exercise when:

* A shell script named `file_check.sh` exists.
* The script verifies file existence.
* The script uses exit codes correctly.
* Validation completes successfully.

---

## Summary

In this exercise, you created a shell script that checks whether a file exists and returns appropriate exit codes to indicate success or failure. Exit codes are widely used in Linux administration, automation, monitoring, and orchestration tools to determine whether commands and scripts completed successfully.
