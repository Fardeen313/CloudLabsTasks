# **Scenario 2: Monitor Service and Restart**

## **Lab Overview**

In this assessment, you will use Linux shell scripting to monitor and manage system services. You will verify the status of the Apache HTTP Server (HTTPD), simulate a service outage by stopping the service, and then create a shell script that automatically detects and starts the service when it is not running.

Service monitoring and recovery are common administrative responsibilities in Linux environments. Automating these tasks helps ensure application availability and reduces manual intervention during service failures.

## **Scenario**

You have recently joined an Infrastructure Operations team as a Linux Administrator.

The organization hosts several business applications that depend on the Apache HTTP Server (HTTPD) to deliver web content. Service interruptions can impact application availability and user experience.

Your manager has asked you to verify the status of the HTTPD service, simulate a service outage, and develop a monitoring script that automatically starts the service whenever it is found to be stopped.

You have been provided access to a Linux virtual machine with HTTPD preinstalled and configured.

## **Solution**

To address this requirement, you will first manually stop the HTTPD service and verify that it is no longer running. You will then create a shell script that checks the service status and automatically starts the service if it is inactive.

The solution demonstrates common Linux administration tasks including service management, conditional logic, process monitoring, and automated recovery using shell scripting.

---

## **Assessment Objectives**

### **Task 1: Stop the HTTPD Service**

Verify the current status of the HTTPD service and manually stop it.

The service must:

* Be verified as running before the task begins.
* Be stopped successfully.
* Show an inactive status after being stopped.

---

### **Task 2: Create a Service Monitoring Script**

Create a shell script named:

```bash
monitor_service.sh
```

The script must:

* Check the status of the HTTPD service.
* Determine whether the service is running.
* Start the service if it is not running.
* Display an appropriate status message.
* Execute successfully without errors.

---

## Environment Information

The Apache HTTP Server (HTTPD) has been preinstalled and configured on the virtual machine.

You can verify the current status of the service using:

```bash
sudo systemctl status httpd
```

or

```bash
sudo systemctl is-active httpd
```

---

## **Implementation Steps**

## **Task 1 : Stop the HTTPD Service**

### **Task Overview**

In this task, you will manually stop the HTTPD service and verify that it is no longer running.

### Step 1: Verify Current Service Status

Run:

```bash
sudo systemctl is-active httpd
```

**Expected output:**

```text
active
```

---

### Step 2: Stop the Service

Stop the HTTPD service:

```bash
sudo systemctl stop httpd
```

---

### Step 3: Verify the Service Has Stopped

Run:

```bash
sudo systemctl is-active httpd
```

Expected output:

```text
inactive
```

---

After completing the task, click the **Validation** tab.

<validation step="dfb21bdb-d7ab-4a73-88b8-9123867891d8" />

---

## **Task 2: Create a Service Monitoring Script**

### **Task Overview**

In this task, you will create a shell script that checks whether the HTTPD service is running and automatically starts it if it is stopped.

> Note: Follow the specified file names and paths exactly to ensure validation succeeds.

### Step 1: Navigate to the Scripts Directory

Run:

```bash
cd ~/scripts
```

Verify your location:

```bash
pwd
```

Expected output:

```text
/home/<inject key="VMUserName" enableCopy="true"/>/scripts
```

---

### Step 2: Create the Monitoring Script

Create a new script named:

```bash
nano monitor_service.sh
```

---

### Step 3: Configure the Script

Configure the script to:

* Check the status of the HTTPD service.
* Determine whether the service is running.
* Start the service if it is not running.
* Display an appropriate status message.

The script must monitor the following service:

```text
httpd
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

Assign execute permissions:

```bash
chmod +x monitor_service.sh
```

Verify permissions:

```bash
ls -l monitor_service.sh
```

Expected output should contain:

```text
-rwx
```

---

### Step 6: Execute the Script

Run:

```bash
./monitor_service.sh
```

---

### Step 7: Verify the Service Status

Verify that the HTTPD service is running:

```bash
sudo systemctl is-active httpd
```

Expected output:

```text
active
```

---

After completing the task, click the **Validation** tab.

<validation step="0d980599-73b0-41a3-b768-87c5c004307d" />

---

## **Instructions**

* Connect to the Linux virtual machine.
* Verify the HTTPD service status.
* Stop the HTTPD service.
* Confirm that the service is inactive.
* Navigate to the scripts directory.
* Create the monitoring script.
* Make the script executable.
* Execute the script.
* Verify that the service starts automatically.
* Complete both validation checks.

---

## **Evaluation Criteria**

Your submission will be evaluated based on:

### Task 1

* Correctly stopping the HTTPD service.
* Successfully verifying the service state.
* Validation completion.

### Task 2

* Correct creation of the monitoring script.
* Proper use of service status checks.
* Correct implementation of conditional logic.
* Successful service recovery.
* Validation completion.

---

## **Validation Requirements**

### Task 1 Validation

Validation will verify:

* The HTTPD service has been stopped.
* The service state is:

```text
inactive
```

### Task 2 Validation

Validation will verify:

* The file `~/scripts/monitor_service.sh` exists.
* The script references the `httpd` service.
* The script executes successfully.
* The HTTPD service is running after script execution.

---

## **Completion Criteria**

You have successfully completed the assessment when:

* The HTTPD service has been manually stopped.
* A service monitoring script has been created.
* The script automatically starts the HTTPD service when required.
* The HTTPD service is running after script execution.
* Both validation steps complete successfully.

You have successfully completed the Assessment.
