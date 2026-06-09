# Scenario 1 : Parse Log File


## Objective

Log files are an important source of information for troubleshooting application issues, identifying failures, and monitoring system activity. Administrators and support engineers frequently analyze log files to locate error messages and generate reports that help with operational investigations.

In this exercise, you will create a shell script that reads a preconfigured application log file, extracts all error-related entries, and generates a summary showing the total number of errors detected.

This exercise demonstrates how shell scripting can be used to automate repetitive log analysis tasks commonly performed in Linux environments.

### Learning Outcomes

After completing this exercise, you will be able to:

* Read data from a log file using a shell script.
* Filter log entries based on specific keywords.
* Count matching log entries.
* Display summarized output in the terminal.
* Create and execute executable shell scripts.

### Estimated Time

**20 Minutes**

---

## Environment Information

A sample application log file has been preconfigured on the virtual machine for this exercise.

Log file location:

```bash
/opt/logs/application.log
```

To understand the log file contents, review the file:

```bash
cat /opt/logs/application.log
```

Expected sample entries:

```text
[error] Database connection failed
[error] Backend timeout
[error] Authentication failed
```

> **Note:** Do not modify the contents of the log file. Validation will verify the script against the existing log data.

---

## Task: Parse Error Entries and Generate Summary

> **Note:** Follow the specified file names and paths exactly to ensure validation succeeds.

### Step 1: Review the Log File

Display the contents of the application log file:

```bash
cat /opt/logs/application.log
```

Identify all entries containing the keyword:

```text
ERROR
```

You should find a total of **3 error entries**.

---

### Step 2: Navigate to the Scripts Directory

Move to the scripts directory:

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

### Step 3: Create the Shell Script

Create a new shell script named:

```bash
nano parse_logs.sh
```

---

### Step 4: Configure the Script

The script must:

* Read data from:

  ```bash
  /opt/logs/application.log
  ```

* Display only entries containing:

  ```text
  [error]
  ```

* Display the total number of matching error entries.

---

### Step 5: Save the Script

Save and exit Nano:

```text
Ctrl + O
Enter
Ctrl + X
```

---

### Step 6: Make the Script Executable

Assign execute permissions:

```bash
chmod +x parse_logs.sh
```

Verify permissions:

```bash
ls -l parse_logs.sh
```

Expected output should include:

```text
-rwx
```

---

### Step 7: Execute the Script

Run the script:

```bash
./parse_logs.sh
```

---

## Success Criteria

The script output must display:

```text
[error] Database connection failed
[error] API timeout
[error] Authentication failure

Total Errors: 3
```

Your output must:

* Display all error entries found in the log file.
* Display the total number of error entries.
* Execute without errors.
* Read data directly from `/opt/logs/application.log`.

---

## Validation Requirements

Validation will verify the following:

* The file `~/scripts/parse_logs.sh` exists.
* The script reads data from `/opt/logs/application.log`.
* Only `[error]` entries are displayed.
* The total error count is displayed.
* The output contains:

```text
[error] Database connection failed
[error] API timeout
[error] Authentication failure
```

* The output contains:

```text
Total Errors: 3
```

* The script executes successfully without errors.

<validation step="7bd312ef-23f1-4a65-b833-a6c7e5399e5b" />

---

## Completion Criteria

You have successfully completed this exercise when:

* A shell script named `parse_logs.sh` exists in the scripts directory.
* The script reads the application log file.
* The script displays all error entries.
* The script displays the total error count.
* Validation completes successfully.

---

## Summary

In this exercise, you automated the process of reviewing application logs using a shell script. By filtering log entries and generating a summary count, you created a simple log analysis solution that can be used to support troubleshooting, incident investigation, and operational monitoring activities in Linux environments.
