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

```powershell
$PSVersionTable
```

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
Invoke-RestMethod -Uri 'https://status.office365.com/api/feed/mac' -UseBasicParsing
```

#### Parameters

```powershell
# Order of named parameters does not matter:
Invoke-RestMethod -Uri 'https://status.office365.com/api/feed/mac' -UseBasicParsing
Invoke-RestMethod -UseBasicParsing -Uri 'https://status.office365.com/api/feed/mac'

# Positional parameter
Invoke-RestMethod 'https://status.office365.com/api/feed/mac' -UseBasicParsing

# String parameter
Invoke-RestMethod -Uri 'https://status.office365.com/api/feed/mac' -UseBasicParsing
Invoke-RestMethod -Uri "https://status.office365.com/api/feed/mac" -UseBasicParsing
Invoke-RestMethod -Uri https://status.office365.com/api/feed/mac -UseBasicParsing

# Switch parameter
Invoke-RestMethod -Uri 'https://status.office365.com/api/feed/mac' -UseBasicParsing:$false

# Multiline Commands
Invoke-RestMethod -Uri 'https://status.office365.com/api/feed/mac' `
                  -UseBasicParsing
```

#### Aliases

```powershell
# Cmdlet alias
irm -Uri 'https://status.office365.com/api/feed/mac' `
    -UseBasicParsing

# Listing cmdlet aliases
Get-Alias
Get-Alias -Definition Invoke-RestMethod

# Parameter alias
irm -ur 'https://status.office365.com/api/feed/mac'
```

#### Comments

```powershell
# This is a single-line comment
Get-Date # Returns a date

<#
Multi-line
Comments
#>
```

#### Help System

```powershell
Get-Help -Name Invoke-RestMethod -Online
help Invoke-RestMethod -o
```

#### Case Sensitivity

```powershell
iNvOkE-rEstmeThoD -uRi 'https://status.office365.com/api/feed/mac'
```

### Keyboard Shortcuts

| Shortcut   | Description                   |
|------------|-------------------------------|
| CTRL+C     | Copy                          |
| CTRL+V     | Paste                         |
| CTRL+SPACE | IntelliSense                  |
| F8         | Run selection                 |
| TAB        | Code completion, Indent block |
| SHIFT+TAB  | Opposite direction of TAB     |
| F1         | Cmdlet help                   |

## Working with Pipeline

### Counting Objects

```powershell
1,2,3 | Measure-Object

Get-ChildItem -Path C:\Users\micha\Downloads -File | Measure-Object

Get-ChildItem -Path C:\Users\micha\Downloads -File |
    Measure-Object -Sum -Property Length
```

### Output Formatting
```powershell
Invoke-RestMethod -Uri 'https://status.office365.com/api/feed/mac' -UseBasicParsing |
    Format-List -Property title,status

Invoke-RestMethod -Uri 'https://status.office365.com/api/feed/mac' -UseBasicParsing |
    Format-Table -Property title,status


(Invoke-RestMethod -Uri 'https://status.office365.com/api/feed/mac'),
(Invoke-RestMethod -Uri 'https://status.office365.com/api/feed/ppac') | Format-Table -Property title,status

$mac = Invoke-RestMethod -Uri 'https://status.office365.com/api/feed/mac'
$ppac = Invoke-RestMethod -Uri 'https://status.office365.com/api/feed/ppac'

$mac,$ppac | Format-Table -Property title,status
```

### Grid View

```powershell
$mac,$ppac |
    Select-Object -Property title,status |
    Out-GridView -Title 'Service Availability' -Wait
```

### Excluding Properties

```powershell
$mac,$ppac | Select-Object -Property title,status
```

### Renaming Properties

```powershell
$mac,$ppac |
    Select-Object -Property @{ Name  = 'Service'; Expression = { $PSItem.title  } },
                            @{ Label = 'Status' ; Expression = { $PSItem.status } } |
    Out-GridView -Title 'Service Availability' -Wait

# Short hashtable key names
$mac,$ppac |
    Select-Object -Property @{ n = 'Service'; e = { $PSItem.title  } },
                            @{ n = 'Status' ; e = { $PSItem.status } } |
    Out-GridView -Title 'Service Availability' -Wait

# Formatting
$mac,$ppac |
    Format-Table -Property @{ n = 'Service'; e = { $PSItem.title  } },
                           @{ n = 'Status' ; e = { $PSItem.status } }
```

### Sorting

```powershell
$mac,$ppac |
    Sort-Object -Property title -Descending -CaseSensitive -Culture 'cs-cz' |
    Format-Table -Property @{ n = 'Service'; e = { $PSItem.title  } },
                           @{ n = 'Status' ; e = { $PSItem.status } }
```

### Filtering

```powershell
$mac,$ppac | Where-Object title -Like Microsoft*

# $mac,$ppac | Where-Object title -Like 'Microsoft Admin Center'
$mac,$ppac | Where-Object title -EQ 'Microsoft Admin Center'

# Boolean operators
$service = 'Microsoft Admin Center'
$mac,$ppac | Where-Object { $PSItem.title  -eq $service -and
                            $_.status      -eq 'Available' }
```

### Looping through Objects

```powershell
@('https://status.office365.com/api/feed/mac',
  'https://status.office365.com/api/feed/ppac') |
    ForEach-Object { Invoke-RestMethod -Uri $PSItem -UseBasicParsing } |
    Format-Table -Property title,status

'mac','ppac' |
    ForEach-Object { Invoke-RestMethod -Uri "https://status.office365.com/api/feed/$PSItem" -UseBasicParsing } |
    Format-Table -Property title,status
```

## File Input/Output

### Text Files

### CSV

## Variables, Data Types, and Arithmetic

```powershell
43953952698 / (1024 * 1024 * 1024)
43953952698 / 1GB
4.7GB / 1.44MB
```

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
