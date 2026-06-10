# **Scenario 3: Automate Script Execution Using Cron**

## **Lab Overview**

In this assessment, you will create a shell script that generates a simple system report and configure a cron job to execute the script automatically at scheduled intervals.

System administrators commonly use cron jobs to automate repetitive tasks such as generating reports, collecting system information, monitoring services, and performing routine maintenance. By automating these activities, organizations can improve operational efficiency and reduce manual effort.

## **Scenario**

You have recently joined the Linux Operations team as a System Administrator.

The organization requires automated system reporting to help monitor server activity and maintain historical records of system events. Your manager has requested that you create a shell script that records the current date and time into a log file and then schedule the script to execute automatically using cron.

You have been provided access to a Linux virtual machine and must complete the reporting automation solution.

## **Solution**

To address this requirement, you will create a shell script named **system_report.sh** that appends the current date and time to a log file located at:

```bash
/tmp/system_report.log
```

After creating and testing the script, you will configure a cron job to execute the script automatically every minute, ensuring that new timestamp entries are continuously added to the report file.

---

## **Assessment Objectives**

### **Task 1: Create a Scheduled Reporting Script**

Create a shell script named:

```bash
system_report.sh
```

The script must:

* Append the current date and time to `/tmp/system_report.log`
* Execute successfully without errors
* Generate report output automatically when executed

---

### **Task 2: Configure a Cron Job**

Create a cron job that executes:

```bash
~/scripts/system_report.sh
```

The cron job must:

* Run automatically every minute
* Continue generating new timestamp entries
* Execute without manual intervention

---

## **Implementation Steps**

### **Task 1: Create the Reporting Script**

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
nano system_report.sh
```

---

### Step 3: Configure the Script

The script must append the current date and time to:

```bash
/tmp/system_report.log
```

Example output:

```text
Wed Jun 3 10:15:01 UTC 2026
```

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
chmod +x system_report.sh
```

Verify permissions:

```bash
ls -l system_report.sh
```

Expected output should include:

```text
-rwx
```

---

### Step 6: Test the Script

Execute:

```bash
./system_report.sh
```

Verify output:

```bash
cat /tmp/system_report.log
```

You should see a timestamp entry.

---
 After completing the task, click the **Validation** tab

<validation step="65ec2094-7768-48a6-a5fa-2a714c795f49" />

---

### **Task 2: Configure Automated Execution**

### Step 1: Open Crontab Editor

Run:

```bash
crontab -e
```

---

### Step 2: Create Scheduled Task

Configure the script to execute every minute.

The scheduled task must execute:

```bash
/home/<inject key="VMUserName" enableCopy="true"/>/scripts/system_report.sh
```

---

### Step 3: Save the Crontab

Save and exit the editor.

---

### Step 4: Verify Cron Configuration

Display configured cron jobs:

```bash
crontab -l
```

Verify that your scheduled task appears in the output.

---

### Step 5: Verify Automated Execution

Wait approximately one minute.

Review the report file:

```bash
cat /tmp/system_report.log
```

You should observe additional timestamp entries being appended automatically.

Example:

```text
Wed Jun 3 10:15:01 UTC 2026
Wed Jun 3 10:16:01 UTC 2026
Wed Jun 3 10:17:01 UTC 2026
```

---
 After completing the task, click the **Validation** tab
<validation step="1be7e975-2f79-4a15-af99-35df686db6cc" />

---

## **Instructions**

* Connect to the Linux virtual machine.
* Navigate to the scripts directory.
* Create the required shell script.
* Ensure the script writes output to `/tmp/system_report.log`.
* Make the script executable.
* Verify script functionality before scheduling.
* Configure a cron job to execute the script automatically.
* Verify automated execution before validation.

---

## **Evaluation Criteria**

Your submission will be evaluated based on:

* Correct creation of the shell script
* Proper log file generation
* Successful execution of the script
* Correct cron configuration
* Automated report generation
* Successful completion of all validation checks

---

## **Completion Criteria**

You have successfully completed the assessment when:

* A shell script named `system_report.sh` exists in the scripts directory.
* The script appends timestamps to `/tmp/system_report.log`.
* A cron job executes the script every minute.
* New log entries are generated automatically.
* Both validation steps complete successfully.

You have successfully completed the Assessment.
