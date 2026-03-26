# AWS Security Workshop — Getting Started

## Welcome to the Lab

Welcome to the **Contoso Advanced AWS Security Workshop**. In this lab you will explore AWS security services using your own dedicated AWS account and a pre-configured Windows virtual machine.

---

## Lab Environment Details

Please use the following credentials and details throughout the workshop.

| Item | Value |
|------|-------|
| **AWS Account ID** | <inject key="AWSAccountId" enableCopy="true" style="color:blue"/> |
| **VM Username** | <inject key="VMUserName" enableCopy="true" style="color:blue"/> |
| **VM Password** | <inject key="VMPassword" enableCopy="true" style="color:blue"/> |
| **Deployment ID** | <inject key="DeploymentID" enableCopy="true"/> |

---

## Task 1 — Access Your Windows Virtual Machine

1. On the lab page, click on the **Lab Environment** tab to find your VM credentials.

2. Click the **Connect** button to launch the Windows VM in your browser via RDP over HTTPS.

3. Sign in using the credentials shown in the table above.

4. Once logged in, verify the following tools are available on the desktop:

   - **Power BI Desktop**
   - **Power Automate Desktop**
   - **n8n**
   - **VS Code**
   - **Brave Browser**
   - **Git Bash**

   > **Note:** If any tool shortcut is missing from the desktop, check the Start Menu.

---

## Task 2 — Verify Your AWS Account Access

1. Open **Brave Browser** from the desktop.

2. Navigate to [https://console.aws.amazon.com](https://console.aws.amazon.com).

3. Sign in using your AWS credentials provided in the Environment Details tab.

4. Once logged in, confirm your **Account ID** matches the value shown below:

   ```
   Account ID: <inject key="AWSAccountId" enableCopy="true"/>
   ```

5. In the top-right corner of the AWS Console, verify the account ID shown matches the one above.

   > **Note:** Each participant has their own dedicated AWS account. Your account ID is unique to you.

---

## Task 3 — Verify AWS CLI Access

1. Open **Git Bash** from the desktop.

2. Run the following command to confirm your AWS CLI is configured and connected to your account:

   ```bash
   aws sts get-caller-identity
   ```

3. The output should show your **Account ID** matching:

   ```
   <inject key="AWSAccountId" enableCopy="true" style="color:blue"/>
   ```

4. If you see your account ID in the output, your AWS CLI is correctly configured. Proceed to the next task.

---

## Task 4 — Explore AWS Security Services

1. In the AWS Console, navigate to the **Services** menu and search for **IAM**.

2. Open the **IAM Dashboard** and review the following:
   - Users
   - Roles
   - Policies

3. Open **VS Code** from the desktop and create a new file named `notes.txt`.

4. Document your findings from the IAM dashboard.

   > **Tip:** You can use the integrated terminal in VS Code to run AWS CLI commands directly.

---

## Summary

In this lab you have:

- Connected to your dedicated Windows VM
- Verified access to your individual AWS account (`<inject key="AWSAccountId"/>`)
- Confirmed AWS CLI connectivity
- Explored AWS IAM security services

Proceed to the next module using the navigation panel on the left.

---

> **Support:** If you face any issues during the lab, click the **Help** button on the lab page or contact your instructor.
