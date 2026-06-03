# Monitor Service and Restart

## Objective

Services are critical components of Linux systems that provide application functionality and background processing. System administrators frequently monitor services to ensure they remain operational and can quickly recover from unexpected outages.

In this exercise, you will verify the status of the Apache HTTP Server (HTTPD), simulate a service outage by stopping the service, and then create a shell script that automatically detects and starts the service when it is not running.

This exercise demonstrates how shell scripting can be used to automate service monitoring and recovery tasks commonly performed in Linux administration.

### Learning Outcomes

After completing this exercise, you will be able to:

* Check the status of Linux services.
* Stop and start services using systemctl.
* Create shell scripts that monitor service status.
* Implement conditional logic within shell scripts.
* Automate basic service recovery operations.

### Estimated Time

**15 Minutes**

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

# Task 1: Stop the HTTPD Service

In this task, you will manually stop the HTTPD service.

### Step 1: Verify Current Service Status

Run:

```bash
sudo systemctl is-active httpd
```

Expected output:

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

## Success Criteria

The HTTPD service must be in the following state:

```text
inactive
```

You can verify this using:

```bash
sudo systemctl is-active httpd
```

<validation step="SERVICE-TASK1" />

---

# Task 2: Create a Service Monitoring Script

In this task, you will create a shell script that checks whether the HTTPD service is running and automatically starts it if it is stopped.

> **Note:** Follow the specified file names and paths exactly to ensure validation succeeds.

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

Expected output should include:

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

## Success Criteria

Your solution is successful when:

* A script named `monitor_service.sh` exists in the `~/scripts` directory.
* The script checks the status of the HTTPD service.
* The script references the `httpd` service.
* The script starts the service if it is not running.
* The script executes successfully without errors.
* The HTTPD service is running after the script executes.

You can verify the service status using:

```bash
sudo systemctl is-active httpd
```

Expected output:

```text
active
```

<validation step="SERVICE-TASK2" />

---

## Validation Requirements

### Task 1 Validation

Validation will verify that:

* The HTTPD service has been stopped.
* The service state is:

```text
inactive
```

### Task 2 Validation

Validation will verify that:

* The file `~/scripts/monitor_service.sh` exists.
* The script references the `httpd` service.
* The script executes successfully.
* The HTTPD service is running after script execution.

---

## Completion Criteria

You have successfully completed this exercise when:

* The HTTPD service has been manually stopped.
* A service monitoring script has been created.
* The script automatically starts the HTTPD service when required.
* The HTTPD service is running after script execution.
* Both validation steps complete successfully.

---

## Summary

In this exercise, you monitored the status of a Linux service and automated service recovery using a shell script. By implementing service status checks and conditional start logic, you created a simple monitoring solution that can help maintain service availability in Linux environments.
