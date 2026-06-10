# Shell Scripting Assessment Lab

## Lab Overview

In this lab, you will use Linux shell scripting to automate log analysis tasks commonly performed by system administrators and support engineers. You will create a shell script that reads a preconfigured application log file, extracts error-related entries, and generates a summary showing the total number of errors detected.

Log analysis is an essential operational activity used for troubleshooting application failures, identifying system issues, and monitoring service health across Linux environments.

## Scenario

You have recently joined an IT Operations team as a Linux Support Engineer.

The organization hosts several business applications that generate log files containing important operational information. Support teams regularly review these logs to identify failures, troubleshoot incidents, and monitor application health.

Your manager has asked you to automate the log analysis process by creating a shell script that scans an application log file, extracts all error entries, and generates a summary report showing the total number of errors detected.

You have been provided access to a Linux virtual machine containing a preconfigured application log file and must create a shell script to perform the required analysis.

## Solution

To address this requirement, you will create a shell script that reads data directly from the application log file, filters entries containing error messages, and displays both the matching log entries and a summary count.

The solution should automate a common troubleshooting task frequently performed in Linux environments while demonstrating core shell scripting concepts such as file handling, text filtering, counting matching records, and displaying formatted output.

## Learning Objectives

After completing this lab, you will be able to:

* Read data from a log file using a shell script.
* Filter log entries based on specific keywords.
* Count matching log entries.
* Display summarized output in the terminal.
* Create and execute executable shell scripts.

## Estimated Time

**20 Minutes**

---

## Environment Information

A sample application log file has been preconfigured on the virtual machine.

Log file location:

```bash
/opt/logs/application.log
```

Review the contents of the log file:

```bash
cat /opt/logs/application.log
```

Expected sample entries:

```
 [error] Database connection failed
 [error] Backend timeout
 [error] Authentication failed
```

> Note: Do not modify the contents of the log file. Validation will verify the script against the existing log data.

---

## Assessment Objectives

### Review the Application Log File

Inspect the contents of the application log file and identify all error-related entries.

### Create the Log Parsing Script

Create a shell script named:

```bash
parse_logs.sh
```

The script must:

* Read data from `/opt/logs/application.log`
* Display all entries containing `[error]`
* Display the total number of matching error entries

### Make the Script Executable

Assign execute permissions to the script and verify that it can be executed successfully.

### Execute the Script

Run the script and verify that it displays:

* All error entries found in the log file
* A summary count of total errors

---

# Detailed Instructions

## Step 1: Review the Log File

Display the contents of the application log file:

```bash
cat /opt/logs/application.log
```

You should identify the error entries contained within the log file.

---

## Step 2: Navigate to the Scripts Directory

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

## Step 3: Create the Shell Script

Create a new shell script named:

```bash
nano parse_logs.sh
```

---

## Step 4: Configure the Script

The script must:

* Read the application log file located at:

```bash
/opt/logs/application.log
```

* Display all log entries containing:

```text
[error]
```

* Display the total number of matching error entries.

---

## Step 5: Save the Script

Save and exit Nano:

```text
Ctrl + O
Enter
Ctrl + X
```

---

## Step 6: Make the Script Executable

Assign execute permissions:

```bash
chmod +x parse_logs.sh
```

Verify permissions:

```bash
ls -l parse_logs.sh
```

Expected output should contain:

```text
-rwx
```

---

## Step 7: Execute the Script

Run the script:

```bash
./parse_logs.sh
```

---

## Expected Output

The script output should display entries similar to:

```text
[error] Database connection failed
[error] Backend timeout
[error] Authentication failed

Total Errors: 3
```

---

## Validation Check

Validation will verify the following:

* The file `~/scripts/parse_logs.sh` exists.
* The script is executable.
* The script reads data from `/opt/logs/application.log`.
* Only error entries are displayed.
* The total error count is displayed.
* The script executes successfully without errors.

<validation step="7bd312ef-23f1-4a65-b833-a6c7e5399e5b" />

---

## Evaluation Criteria

Your submission will be evaluated based on:

* Correct creation of the shell script
* Proper reading of the application log file
* Accurate filtering of error entries
* Correct calculation of the total error count
* Successful script execution
* Validation completion

---

## Completion Criteria

You have successfully completed the assessment when:

* A shell script named `parse_logs.sh` exists in the scripts directory.
* The script reads data from `/opt/logs/application.log`.
* The script displays all error entries.
* The script displays the total error count.
* Validation completes successfully.

You have successfully completed the Assessment.
