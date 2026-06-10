# **Scenario 4: Check Web Server Availability**

## **Lab Overview**

In this assessment, you will create a shell script that verifies whether a web server is available and responding to requests.

Web server availability checks are commonly performed by system administrators and support teams to ensure that websites and applications remain accessible to users. Automating these checks helps identify service interruptions quickly and improves operational monitoring.

## **Scenario**

You have recently joined the Linux Operations team as a System Administrator.

The organization hosts several web-based applications that depend on the Apache HTTP Server (HTTPD). To ensure that these applications remain accessible, administrators regularly verify that the web server is running and responding correctly.

Your manager has asked you to create a shell script that checks the availability of the local web server and reports whether the service is accessible.

You have been provided access to a Linux virtual machine with Apache HTTP Server already installed and configured.

## **Solution**

To address this requirement, you will create a shell script named **check_server.sh** that uses the `curl` command to send a request to:

```bash
http://localhost
```

The script should determine whether the web server is responding and display an appropriate status message based on the result.

---

## **Assessment Objectives**

### Create a Web Server Availability Check Script

Create a shell script named:

```bash
check_server.sh
```

The script must:

* Use the `curl` command to check web server availability.
* Verify whether the local web server is responding.
* Display a success message when the server is available.
* Display a failure message when the server is unavailable.

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

Run:

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

Run:

```bash
./check_server.sh
```

Expected output:

```text
Server is available
```

---

## **Success Criteria**

Your solution is successful when:

* A shell script named `check_server.sh` exists.
* The script uses the `curl` command.
* The script verifies web server availability.
* The script executes successfully without errors.
* The script displays:

```text
Server is available
```

when the Apache web server is running.

---
 After completing the task, click the **Validation** tab
<validation step="31bcf261-df44-4636-ac7f-d7a4f776d17c" />

---

## **Instructions**

* Connect to the Linux virtual machine.
* Navigate to the scripts directory.
* Create the required shell script.
* Ensure the script uses the `curl` command.
* Configure the script to check `http://localhost`.
* Make the script executable before running it.
* Verify the output before performing validation.
* Do not modify the existing web server configuration.

---

## **Evaluation Criteria**

Your submission will be evaluated based on:

* Correct creation of the shell script.
* Proper use of the `curl` command.
* Accurate verification of web server availability.
* Successful script execution.
* Proper status message display.
* Successful validation completion.

---

## **Expected Output**

When the web server is available:

```text
Server is available
```

When the web server is unavailable:

```text
Server is unavailable
```

---

## **Completion Criteria**

You have successfully completed the assessment when:

* A shell script named `check_server.sh` exists in the scripts directory.
* The script uses `curl` to verify web server availability.
* The script displays the appropriate server status.
* Validation completes successfully.

You have successfully completed the Assessment.
