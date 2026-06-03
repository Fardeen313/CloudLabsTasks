# Check Web Server Availability

## Objective

Web servers must be available and responsive to serve application content to users. System administrators frequently perform availability checks to verify that web services are running correctly and responding to requests.

In this exercise, you will create a shell script that uses `curl` to verify whether the local Apache web server is available and display the result.

This exercise demonstrates how shell scripting can be used to automate basic web service health checks in Linux environments.

### Learning Outcomes

After completing this exercise, you will be able to:

* Create and execute shell scripts.
* Use the `curl` command to test web server availability.
* Implement conditional logic in shell scripts.
* Display status messages based on command results.
* Automate simple service health checks.

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

# Task 1: Create a Web Server Availability Check Script

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
nano check_server.sh
```

---

### Step 3: Configure the Script

Configure the script to:

* Use `curl` to check whether the local web server is responding.
* Display a success message if the server is available.
* Display a failure message if the server is unavailable.

The script should check:

```text
http://localhost
```

Expected success output:

```text
Server is available
```

Expected failure output:

```text
Server is unavailable
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

```bash
chmod +x check_server.sh
```

Verify permissions:

```bash
ls -l check_server.sh
```

Expected output should include:

```text
-rwx
```

---

### Step 6: Execute the Script

Run the script:

```bash
./check_server.sh
```

Expected output:

```text
Server is available
```

---

## Success Criteria

Your solution is successful when:

* A shell script named `check_server.sh` exists.
* The script uses `curl` to check web server availability.
* The script executes successfully.
* The script displays:

```text
Server is available
```

when the Apache web server is running.

---

## Validation Requirements

Validation will verify that:

* `~/scripts/check_server.sh` exists.
* The script contains the `curl` command.
* The script executes successfully.
* The script reports server availability.
* The output contains:

```text
Server is available
```

<validation step="SERVERCHECK-TASK1" />

---

## Completion Criteria

You have successfully completed this exercise when:

* A shell script named `check_server.sh` exists in the scripts directory.
* The script uses `curl` to verify web server availability.
* The script displays the server status.
* Validation completes successfully.

---

## Summary

In this exercise, you created a shell script that checks whether a web server is available by sending an HTTP request using `curl`. This type of availability check is commonly used by system administrators and support teams to verify that web services are running and responding correctly.
