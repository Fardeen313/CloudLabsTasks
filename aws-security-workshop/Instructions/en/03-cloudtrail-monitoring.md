# 📡 Exercise 3 – CloudTrail Monitoring

<div style="background: linear-gradient(135deg, #1a1a2e, #e94560); padding: 20px; border-radius: 10px; color: white; margin-bottom: 20px;">

AWS CloudTrail records **all API activity** in your AWS account — giving you full visibility into who did what, when, and from where.

</div>

---

## 📋 Exercise Overview

<table>
  <tr style="background-color:#e94560; color:white;">
    <th>Task</th>
    <th>Action</th>
    <th>Estimated Time</th>
  </tr>
  <tr style="background-color:#ffeef1;">
    <td>✅ Task 1</td>
    <td>Open CloudTrail</td>
    <td>2 mins</td>
  </tr>
  <tr style="background-color:#ffeef1;">
    <td>✅ Task 2</td>
    <td>Create Trail</td>
    <td>5 mins</td>
  </tr>
  <tr style="background-color:#ffeef1;">
    <td>✅ Task 3</td>
    <td>Verify Logs</td>
    <td>3 mins</td>
  </tr>
</table>

---

## 🔎 Task 1: Open CloudTrail

1. In the **AWS Console** top search bar, type:
```
   CloudTrail
```

   ![Search CloudTrail](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task1-search-cloudtrail.png)

2. Click on **CloudTrail** from the search results to open the service.

   ![CloudTrail Dashboard](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task1-cloudtrail-dashboard.png)

---

## 🛤️ Task 2: Create Trail

1. On the CloudTrail dashboard, click **Create trail**.

   ![Create Trail](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task2-create-trail.png)

2. Enter the trail name using your AWS Account ID:

<table>
  <tr style="background-color:#e94560; color:white;">
    <th>Field</th>
    <th>Value</th>
  </tr>
  <tr style="background-color:#ffeef1;">
    <td><strong>Trail Name</strong></td>
    <td>SecurityTrail-<inject key="AWSAccountID" enableCopy="true" style="color:blue"/></td>
  </tr>
</table>

   ![Trail Name](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task2-trail-name.png)

3. Under **Storage location**, keep the default S3 bucket settings.

   ![S3 Settings](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task2-s3-settings.png)

4. Ensure **All Regions** is enabled to capture activity across your entire account.

   ![All Regions](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task2-all-regions.png)

5. Click **Create Trail**.

   ![Create Trail Final](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task2-create-trail-final.png)

---

<div style="background-color:#fff3cd; padding:15px; border-left:5px solid #ffc107; border-radius:5px;">

⏳ **Please wait 2–3 minutes** for the trail to be fully created before proceeding to Task 3.

</div>

---

## 🔍 Task 3: Verify Logs

1. In the left navigation panel, click **Event History**.

   ![Event History](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task3-event-history.png)

2. You will see a list of all recorded API calls in your account. Review the logged events.

   ![Logged Events](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task3-logged-events.png)

3. Use the **Filter** option to search for specific events by resource type or user.

   ![Filter Events](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task3-filter-events.png)

---

<div style="background-color:#d4edda; padding:15px; border-left:5px solid #28a745; border-radius:5px;">

## ✅ Summary

You have successfully:

- ✔️ Opened the CloudTrail service
- ✔️ Created a trail named **SecurityTrail-**<inject key="AWSAccountID" enableCopy="true" style="color:blue"/>
- ✔️ Verified API activity logs in Event History

Click **Next** to proceed to **Summary**.

</div>


<!-- # Exercise 3 – CloudTrail Monitoring

AWS CloudTrail records all API activity in your AWS account.

## Task 1: Open CloudTrail

1. In AWS Console search for **CloudTrail**.

2. Click **CloudTrail** service.

## Task 2: Create Trail

1. Click **Create trail**.

2. Trail name:

SecurityTrail-<inject key="AWSAccountID"/>

3. Enable **All Regions**.

4. Click **Create Trail**.

## Wait Time

Trail creation may take **2–3 minutes**.

## Task 3: Verify Logs

1. Open **Event History**.

2. Review logged API calls.

## Summary

CloudTrail is now recording activity for your AWS account. -->