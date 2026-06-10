# **Scenario 5: Use Exit Codes and Debugging**

## **Lab Overview**

In this assessment, you will create a shell script that verifies whether a file exists and returns appropriate exit codes based on the result.

Exit codes are a fundamental part of Linux shell scripting and automation. They are commonly used by system administrators, monitoring tools, schedulers, and automation platforms to determine whether a command or script executed successfully.

## **Scenario**

You have recently joined a Linux Operations team as a Junior System Administrator.

The organization uses shell scripts to automate routine administrative tasks and relies on exit codes to determine whether those tasks complete successfully. Automated monitoring systems review these exit codes and trigger alerts whenever failures occur.

Your manager has asked you to create a shell script that verifies the existence of a specific file and returns different exit codes depending on whether the file is present or missing.

You have been provided access to a Linux virtual machine containing a preconfigured file that must be validated.

## **Solution**

To address this requirement, you will create a shell script named **file_check.sh** that checks whether a specific file exists.

The script must display an appropriate message indicating the result and return:

* Exit Code **0** when the file exists.
* Exit Code **1** when the file is missing.

You will then execute the script and verify its exit status using standard Linux shell commands.

---

## **Assessment Objectives**

### **Verify File Existence**

Check whether the following file exists:

```bash
/opt/data/testfile.txt
```

---

### **Create an Exit Code Validation Script**

Create a shell script named:

```bash
file_check.sh
```

The script must:

* Verify the existence of `/opt/data/testfile.txt`
* Display a success message when the file exists
* Display a failure message when the file is missing
* Return exit code `0` for success
* Return exit code `1` for failure

---

### **Verify Script Exit Status**

Execute the script and confirm that the appropriate exit code is returned.

---

## **Environment Information**

A sample file has been preconfigured for this assessment.

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

## **Implementation Steps**

### Step 1: Navigate to the Scripts Directory

Run:

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

Run:

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

Run:

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

## **Success Criteria**

Your solution is successful when:

* A script named `file_check.sh` exists.
* The script checks for `/opt/data/testfile.txt`.
* The script displays a status message.
* The script returns exit code `0` when the file exists.
* The script returns exit code `1` when the file does not exist.

 After completing the task, click the **Validation** tab
<validation step="33df1f62-1141-4bc2-bf22-cecb8bf6abe3" />

## **Instructions**

* Connect to the Linux virtual machine.
* Verify that `/opt/data/testfile.txt` exists.
* Navigate to the scripts directory.
* Create the required shell script.
* Configure the script to verify file existence.
* Ensure the script returns the correct exit codes.
* Make the script executable before running it.
* Verify the output and exit code before performing validation.

---

## **Evaluation Criteria**

Your submission will be evaluated based on:

* Correct creation of the shell script.
* Proper file existence verification.
* Accurate use of exit codes.
* Successful script execution.
* Correct status message display.
* Successful validation completion.

---

## **Expected Output**

When the file exists:

```text
File exists.
```

Followed by:

```bash
echo $?
```

Expected result:

```text
0
```

When the file does not exist:

```text
File not found.
```

Followed by:

```bash
echo $?
```

Expected result:

```text
1
```

---

## **Completion Criteria**

You have successfully completed the assessment when:

* A shell script named `file_check.sh` exists in the scripts directory.
* The script verifies file existence correctly.
* The script returns appropriate exit codes.
* Validation completes successfully.

You have successfully completed the Assessment.
