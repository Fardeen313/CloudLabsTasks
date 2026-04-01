# 🔐 Exercise 2 – IAM Security

<div style="background: linear-gradient(135deg, #0f3460, #533483); padding: 20px; border-radius: 10px; color: white; margin-bottom: 20px;">

In this exercise you will create an **IAM Role** and configure it with the appropriate permissions.

</div>

---

## 📋 Exercise Overview

<table>
  <tr style="background-color:#0f3460; color:white;">
    <th>Task</th>
    <th>Action</th>
    <th>Estimated Time</th>
  </tr>
  <tr style="background-color:#e8f4fd;">
    <td>✅ Task 1</td>
    <td>Navigate to IAM</td>
    <td>2 mins</td>
  </tr>
  <tr style="background-color:#e8f4fd;">
    <td>✅ Task 2</td>
    <td>Create IAM Role</td>
    <td>5 mins</td>
  </tr>
  <tr style="background-color:#e8f4fd;">
    <td>✅ Task 3</td>
    <td>Configure Role</td>
    <td>3 mins</td>
  </tr>
</table>

---

## 🧭 Task 1: Navigate to IAM

1. Log in to the **AWS Console** using your credentials from the **Environment Details** tab.

2. In the top search bar, type:
```
   IAM
```

   ![Search IAM](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task1-search-iam.png)

3. Click on **IAM** from the search results.

   ![IAM Dashboard](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task1-iam-dashboard.png)

---

## 👤 Task 2: Create IAM Role

1. In the left navigation panel, select **Roles**.

   ![Select Roles](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task2-select-roles.png)

2. Click **Create Role**.

   ![Create Role](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task2-create-role.png)

3. Under **Trusted entity type**, select **AWS Service**.

   ![AWS Service](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task2-aws-service.png)

4. Under **Use case**, select **EC2**.

   ![Select EC2](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task2-select-ec2.png)

5. Click **Next**.

---

## ⚙️ Task 3: Role Configuration

1. On the permissions page, click **Next**.

2. Enter the role name:

<table>
  <tr style="background-color:#533483; color:white;">
    <th>Field</th>
    <th>Value</th>
  </tr>
  <tr style="background-color:#f3eeff;">
    <td><strong>Role Name</strong></td>
    <td>SecurityRole-<inject key="AWSAccountID" enableCopy="true" style="color:blue"/></td>
  </tr>
</table>

   ![Role Name](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task3-role-name.png)

3. Click **Create Role**.

   ![Create Role Final](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task3-create-role-final.png)

---

<div style="background-color:#d4edda; padding:15px; border-left:5px solid #28a745; border-radius:5px;">

## ✅ Summary

You have successfully:

- ✔️ Navigated to the IAM service
- ✔️ Created an IAM Role trusted by **EC2**
- ✔️ Named the role using your AWS Account ID: <inject key="AWSAccountID" enableCopy="true" style="color:blue"/>

Click **Next** to proceed to **Exercise 3 – CloudTrail Monitoring**.

</div>


<!-- # Exercise 2 – IAM Security

In this exercise you will create an IAM role.

## Task 1: Navigate to IAM

1. Log in to the AWS Console.

2. In the search bar type **IAM**.

3. Open the IAM service.

## Task 2: Create IAM Role

1. Select **Roles**.

2. Click **Create Role**.

3. Choose **AWS Service**.

4. Select **EC2**.

## Task 3: Role Configuration

Role name:

SecurityRole-<inject key="AWSAccountID"/>

5. Click **Create Role**.

## Summary

You successfully created an IAM role.
 -->
