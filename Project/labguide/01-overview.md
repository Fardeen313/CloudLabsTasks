# Exercise 1 — Overview & Objectives

## Lab: Windows VM Automation Lab

Deploy a fully functional Windows Virtual Machine on Azure, authenticate via Service Principal, and automate Azure resource creation — fully integrated with the CloudLabs ODL platform.

---

## Lab Objectives

- Deploy a Windows Server 2019 VM with all networking resources using ARM templates
- Integrate with CloudLabs ODL using parameter tokens for automatic credential injection
- Write `TenantID`, `AppID`, `AppSecret` to `C:\temp\credentials.txt` inside the VM via CSE
- Authenticate to Azure using a Service Principal — fully non-interactive, no WAM popup
- Create a Storage Account and Blob Container programmatically via PowerShell
- Upload a sample `hello.txt` file to the Blob Container

---

## GitHub Repository — Source Files

All source files for this lab are available here:

- [Fardeen313/CloudLabsTasks](https://github.com/Fardeen313/CloudLabsTasks)
- [run.ps1](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/Project/run.ps1)
- [deploy.ps1](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/refs/heads/main/Project/deploy.ps1)
- [azuredeploy.json](https://github.com/Fardeen313/CloudLabsTasks/blob/main/Project/azuredeploy.json)
