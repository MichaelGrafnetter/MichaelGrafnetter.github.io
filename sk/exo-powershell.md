---
ref: exo-powershell-demos
title: Exchange Online PowerShell Course
date: 2023-10-15T00:00:00+00:00
layout: page
lang: sk
permalink: /exo/
sitemap: false
---

## Agenda
{:.no_toc}

1. This is a TOC placeholder.
{:toc}

## PowerShell Introduction

### PowerShell Versions

| PowerShell Edition | Latest Version |
|--------------------|----------------|
| Desktop            | 5.1            |
| [Core]             | 7.3.8          |

[Core]: https://github.com/PowerShell/PowerShell

### Command Line vs. Scripts

#### Command Execution from PowerShell

```powershell
PS > Get-Date
```

#### Script Execution from Command Prompt

```batchfile
C:\>powershell.exe -File test.ps1
```

#### Script Execution from PowerShell

```powershell
PS > .\test.ps1
```

### PowerShell Terminals and Editors

- `powershell.exe`
- `powershell_ise.exe`
- [Windows Terminal](https://apps.microsoft.com/detail/windows-terminal/9N0DX20HK701)
- [Visual Studio Code](https://code.visualstudio.com/)

### Service Health Status REST API

- [Service Health Status Web](https://status.office365.com/api/feed/)
- Microsoft 365 Admin Center Status RSS: `https://status.office365.com/api/feed/mac`
- Power Platform Admin Center RSS: `https://status.office365.com/api/feed/ppac`

### Basic Syntax

#### Cmdlets

```powershell
Invoke-RestMethod -Name 'https://status.office365.com/api/feed/mac' -UseBasicParsing
```

#### Parameters

#### Aliases

#### Comments

#### Help System

### Keyboard Shortcuts

## Working with Pipeline

### Measure-Object

### Formatting Cmdlets

### Select-Object

### Where-Object

### Foreach-Object

## File Input/Output

### Text Files

### CSV

## Variables, Data Types, and Arithmetic

### Numbers

### Strings

### Date and Time

### Arrays

### Hash Tables

### JSON

### XML

## PowerShell Modules for Exchange Online

| API                          | PowerShell Module          |  Connect                 | List Users        |
|------------------------------|----------------------------|--------------------------|-------------------|
| Exchange Online PowerShell   | [ExchangeOnlineManagement] | `Connect-ExchangeOnline` | `Get-User`        |
| Microsoft Graph API          | [Microsoft.Graph.*]        | `Connect-MgGraph`        | `Get-MgUser`      |
| ~~Azure AD Graph API~~       | [AzureAD]                  | `Connect-AzureAD`        | `Get-AzureADUser` |
| ~~MSOnline V1 PowerShell~~   | [MSOnline]                 | `Connect-MsolService`    | `Get-MsolUser`    |
| Azure Resource Manager       | [Az.Resources]             | `Connect-AzAccount`      | `Get-AzADUser`    |

[ExchangeOnlineManagement]: https://www.powershellgallery.com/packages/ExchangeOnlineManagement
[Microsoft.Graph.*]: https://www.powershellgallery.com/packages?q=Microsoft.Graph
[AzureAD]: https://www.powershellgallery.com/packages/AzureAD
[MSOnline]: https://www.powershellgallery.com/packages/MSOnline
[Az.Resources]: https://www.powershellgallery.com/packages/Az.Resources

[Find Azure AD and MSOnline cmdlets in Microsoft Graph PowerShell](https://learn.microsoft.com/en-us/powershell/microsoftgraph/azuread-msoline-cmdlet-map)

## Exchange Online PowerShell

### Basics

```powershell
Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force

Import-Module -Name ExchangeOnlineManagement

Get-Command -Module ExchangeOnlineManagement

Connect-ExchangeOnline -ShowBanner:$false -AzureADAuthorizationEndpointUri https://login.microsoftonline.com/aadcourse.onmicrosoft.com

Get-ConnectionInformation

Get-Command -Module tmpEXO_*

Get-EXOMailbox -ResultSize Unlimited

Get-User -ResultSize Unlimited

Get-User -ResultSize Unlimited | Format-Table -Auto -Property Name,DisplayName,RemotePowerShellEnabled

Set-User -Identity chris@contoso.onmicrosoft.com -RemotePowerShellEnabled $true

Disconnect-ExchangeOnline -Confirm:$false
```

### Filtering

### Mailbox Creation

### Mailbox Permission Reporting

### Role-Based Access Control

## Microsoft Graph API

### Directory Operations

### Managing Licenses

## PowerShell Scripts

### Naming Conventions

### Execution Policy

### Script Parameters

### Functions

#### Prompt

```powershell
function prompt() { 'PS > ' }
Clear-Host
```

### Loops

## Background Tasks

### App Registration

### Permissions

### Authentication

### Scheduled Tasks

## Error Handling

## Further Reading
