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
| CTRL+C     | Copy, Stop the running program|
| CTRL+V     | Paste                         |
| CTRL+SPACE | IntelliSense                  |
| F8         | Run selection                 |
| TAB        | Code completion, Indent block |
| SHIFT+TAB  | Opposite direction of TAB     |
| F1         | Cmdlet help                   |
| ESC        | Clear the current command line|

## Working with Pipeline

### Counting Objects

```powershell
1,2,3 | Measure-Object

Get-ChildItem -Path .\Downloads -File | Measure-Object

Get-ChildItem -Path .\Downloads -File |
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

### Excluding Object Properties

```powershell
$mac,$ppac | Select-Object -Property title,status
```

### Renaming Object Properties

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

### Sorting Objects

```powershell
$mac,$ppac |
    Sort-Object -Property title -Descending -CaseSensitive -Culture 'cs-cz' |
    Format-Table -Property @{ n = 'Service'; e = { $PSItem.title  } },
                           @{ n = 'Status' ; e = { $PSItem.status } }
```

### Filtering Objects

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

# PS 7 Parallel ForEach
Get-Content -Path "$env:TEMP\uris.txt" |
    ForEach-Object -Parallel { Invoke-RestMethod -Uri $PSItem -UseBasicParsing } -ThrottleLimit 30
```

## File Input/Output

### Text Files

```powershell
'mac','ppac' |
    ForEach-Object { "https://status.office365.com/api/feed/$PSItem" } |
    ForEach-Object { Invoke-RestMethod -Uri $PSItem -UseBasicParsing } |
    Format-Table -Property title,status > "$env:TEMP\status.txt"

'mac','ppac' |
    ForEach-Object { "https://status.office365.com/api/feed/$PSItem" } |
    ForEach-Object { Invoke-RestMethod -Uri $PSItem -UseBasicParsing } |
    Format-Table -Property title,status |
    Out-File -FilePath "$env:TEMP\status.txt" -Encoding utf8 -Force -Append

notepad.exe "$env:TEMP\status.txt"
Get-Content -Path "$env:TEMP\status.txt"

'mac','ppac' |
    ForEach-Object { "https://status.office365.com/api/feed/$PSItem" } |
    Out-File -FilePath "$env:TEMP\uris.txt" -Encoding utf8

Get-Content -Path "$env:TEMP\uris.txt" |
    ForEach-Object { Invoke-RestMethod -Uri $PSItem -UseBasicParsing } |
    Format-Table -Property title,status
```

### CSV

```powershell
# Write to CSV
'mac','ppac' |
    ForEach-Object { "https://status.office365.com/api/feed/$PSItem" } |
    ForEach-Object { Invoke-RestMethod -Uri $PSItem -UseBasicParsing } |
    Select-Object -Property title,status |
    Export-Csv -Path "$env:TEMP\status.csv" -NoTypeInformation -Encoding UTF8 -Force -Delimiter ';'

# Tab: "`t"

# Read from CSV
Import-Csv -Path "$env:TEMP\status.csv" -Delimiter ';' -Encoding UTF8 | Out-GridView
```

### Working with Paths

```powershell
$tempFile = New-TemporaryFile
Join-Path -Path 'C:\Windows' -ChildPath 'system32'
Split-Path -Path C:\Windows\system32 -Parent
Split-Path -Path C:\Windows\system32 -Leaf
Resolve-Path -Path .
Test-Path -Path C:\Windows\system32\test.txt -PathType Leaf
```

## Variables, Data Types, and Arithmetic

### Numbers

```powershell
# Calculator
5*5
5/2
[Math]::PI
[Math]::Max(5,6)
[Math]::Pow(2,10)

# Unit conversion
43953952698 / (1024 * 1024 * 1024)
43953952698 / 1GB
4.7GB / 1.44MB

# Dynamically implicit typed variables
$number = 5 * 5
$number = 'Test'

# Strongly Typed Variables
[int] $number = 5 * 5
$number = 'Test'

[long] $number64 = 5*5
[short] $number16
[byte] $byte = 255
[double] $floatingPoint = 2.5

# Operators
5 -lt 10
5 -gt 10
5 -ge 5
5 -le 5
3 -eq 4
```

### Strings

```powershell
# Formatting
$first = 'John'
$last = 'Doe'
'{0}.{1}@contoso.com' -f $first.ToLowerInvariant(),$last.ToLowerInvariant()

# Properties and methods
'John'.Length
'John'.ToUpperInvariant()

# Wildcard matching
'john.doe@contoso.com' -like '*@contoso.com'
```

### Date and Time

```powershell
Get-Date
Get-Date -Year 2023 -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0 -Millisecond 0

(Get-Date).DayOfYear
(Get-Date).DayOfWeek
(Get-Date).AddMonths(-3).Date

(Invoke-RestMethod -Uri 'https://status.office365.com/api/feed/mac').pubDate
[datetime] $lastUpdated = 'Mon, 16 Oct 2023 13:12:00 Z'
[datetime] $now = Get-Date
$lastUpdated -ge $now.Date

(Get-Date -Year 1980 -Month 5 -Day 10).DayOfWeek

(Get-Date).ToString([cultureinfo] 'en-us')
(Get-Date).ToString([cultureinfo] 'cs-cz')
(Get-Date).ToString('yyyy-MM-dd_hh-mm-ss')
```

### Arrays

```powershell
[string] $url1 = 'https://status.office365.com/api/feed/mac'
[string] $url2 = 'https://status.office365.com/api/feed/ppac'

[string[]] $urls = $url1
$urls = $url1,$url2
$urls = @($url1,$url2)

$urls = ,$url1
$urls = @($url1)

$urls[0]
$urls[1]

$urls | ForEach-Object { Invoke-RestMethod -Uri $PSItem }

[string[]] $urls = @()
$urls.Count
$urls.IsFixedSize

[System.Collections.ArrayList] $urls = @()
$urls.Add($url1)
$urls.Add($url2)
$urls.Count

[System.Collections.Generic.List[int]] $integerList = @()
$integerList.Add(5)
$integerList.Add(10)
$integerList.Add('test')

[System.Collections.Generic.List[ipaddress]] $ips = @()
$ips.Add('10.10.0.1')
$ips.Add('10.10.0.1.5.5')
```

#### .NET Framework Collections

- [System.Collections](https://learn.microsoft.com/en-us/dotnet/api/system.collections?view=netframework-4.8.1)
- [System.Collections.Specialized](https://learn.microsoft.com/en-us/dotnet/api/system.collections.specialized?view=netframework-4.8.1)
- [System.Collections.Generic](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic?view=netframework-4.8.1)

### Hash Tables

```powershell
[hashtable] $pc1 = @{
    Name = 'PC01'
    IP = '10.214.0.7'
}

[hashtable] $pc2 = @{
    Name = 'PC02'
    IP = '10.214.0.8'
}

$pc1.Name
$pc1.IP
$pc1.Keys
$pc1.Values

@($pc1,$pc2) | ForEach-Object { 'Address of {0} is {1}.' -f $PSItem.Name,$PSItem.IP }
```

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

Connect-ExchangeOnline -ShowBanner:$false -AzureADAuthorizationEndpointUri https://login.microsoftonline.com/course.dsinternals.com

Get-ConnectionInformation

Get-Command -Module tmpEXO_*

Get-EXOMailbox -ResultSize Unlimited

Get-User -ResultSize Unlimited

Disconnect-ExchangeOnline -Confirm:$false
```

### PowerShell Access

```powershell
Get-User -ResultSize Unlimited | Format-Table -Auto -Property RecipientType,UserPrincipalName,RemotePowerShellEnabled

Set-User -Identity AdeleV@course.dsinternals.com -RemotePowerShellEnabled $true
```

### Filtering

```powershell
Get-User -Identity AdeleV@course.dsinternals.com
Get-User -Anr AdeleV
Get-User -Anr Johanna
# Interesting properties: RecipientType,UserPrincipalName,SKUAssigned,AccountDisabled,FirstName,LastName,City,Department,Phone,WindowsEmailAddress,IsDirSynced

Get-User -Filter 'City -eq "San Diego"'
Get-User -Filter 'City -eq "San Diego" -and FirstName -eq "Alex"'

Get-User -RecipientTypeDetails UserMailbox
Get-User -ResultSize 2
Get-User -ResultSize Unlimited

Get-User -PublicFolder

Get-EXORecipient | Format-Table -Property RecipientType,Identity,DisplayName,PrimarySmtpAddress

Get-EXOMailbox | Format-Table -Property RecipientType,DisplayName,UserPrincipalName,PrimarySmtpAddress

Get-MailContact
```

### User Modification

```powershell
Get-User -Anr JohannaL | Format-List -Property UserPrincipalName,City
Get-User -Anr JohannaL | Set-User -City Richmond -Confirm:$false
```

### Mailbox Permissions

```powershell
# Read and manage
Get-EXOMailboxPermission -Identity JohannaL
Get-Command -Name *MailboxPermission*
Add-MailboxPermission -Identity JohannaL -User AdeleV -AccessRights FullAccess,ReadPermission

# Sed as
Get-RecipientPermission -Identity JohannaL
Add-RecipientPermission -Identity JohannaL -Trustee LynneR -AccessRights SendAs -Confirm:$false

# Send on behalf
Get-Mailbox -Identity JohannaL | Format-List -Property Identity,GrantSendOnBehalfTo
Set-Mailbox -Identity JohannaL -GrantSendOnBehalfTo LeeG

# Forwarding
Get-Mailbox -ResultSize Unlimited | Format-Table -Property Name,PrimarySmtpAddress,ForwardingAddress,ForwardingSmtpAddress
Get-Mailbox -Filter 'ForwardingAddress -ne $null'
```

### Role-Based Access Control

```powershell
# Role Assignment
Get-RoleGroup
Get-RoleGroupMember -Identity 'Recipient Management'
Add-RoleGroupMember -Identity 'Recipient Management' -Member AdeleV

# Administrative Units
Get-administrativeUnit
Get-administrativeUnit -Identity HR
$adminUnitDN = (Get-AdministrativeUnit -Identity HR).DistinguishedName
Get-Recipient -RecipientPreviewFilter "AdministrativeUnits -eq '$adminUnitDN'"

Get-ManagementRole
Get-ManagementRole -Identity 'Mail Recipients'
Get-ManagementRoleAssignment
Get-ManagementRoleAssignment -RecipientWriteScope AdministrativeUnit

# Required to be executed once per organization: Enable-OrganizationCustomization
New-ManagementRoleAssignment -Role 'Mail Recipients' -RecipientAdministrativeUnitScope (Get-administrativeUnit -Identity HR) -User AdeleV
```

## Microsoft Graph API

### Basics

```powershell
Install-Module Microsoft.Graph.Authentication -Force
Install-Module Microsoft.Graph.Users -Force
Install-Module Microsoft.Graph.Identity.SignIns -Force
Install-Module Microsoft.Graph.Identity.DirectoryManagement -Force

Connect-MgGraph -TenantId course.dsinternals.com -ContextScope Process -Scopes User.Read.All,Group.Read.All # -UseDeviceCode -NoWelcome

Get-MgUser
Get-MgGroup
Get-MgApplication

Disconnect-MgGraph
```

[Microsoft Graph permissions reference](https://learn.microsoft.com/en-us/graph/permissions-reference)

### Filtering

```powershell
Connect-MgGraph -TenantId course.dsinternals.com -ContextScope Process -Scopes User.Read.All

Get-MgUser -UserId AdeleV@course.dsinternals.com
Get-MgUser -UserId a8d1b0ff-3de9-48bb-a209-95b01d2846eb

Get-MgUser -All -Filter "startsWith(DisplayName, 'Ad')"
Get-MgUser -All -Search '"Surname:Vance"' -ConsistencyLevel Eventual
Disconnect-MgGraph
```

[Advanced query capabilities on Azure AD objects](https://learn.microsoft.com/en-us/graph/aad-advanced-queries)

### Passwordless User Provisioning

```powershell
Connect-MgGraph -Scopes 'User.ReadWrite.All','UserAuthenticationMethod.ReadWrite.All'

# Generate a new random password
Add-Type -AssemblyName System.Web
$passwordProfile = @{
    Password = [System.Web.Security.Membership]::GeneratePassword(128,1)
    ForceChangePasswordNextSignIn = $false
}

$userAccount = 'jdoe@course.dsinternals.com'

# Create a new user account
New-MgUser -DisplayName 'John Doe' `
           -UserPrincipalName $userAccount `
           -PasswordProfile $passwordProfile `
           -AccountEnabled `
           -MailNickName 'JohnDoe' `
           -GivenName John `
           -Surname Doe

# Create a new Temporary Access Pass
New-MgUserAuthenticationTemporaryAccessPassMethod `
     -UserId $userAccount `
     -IsUsableOnce `
     -LifetimeInMinutes 60 | Format-List

# Delete any pre-existing Temporary Access Pass
$currentTempPass = Get-MgUserAuthenticationTemporaryAccessPassMethod -UserId $userAccount
if($null -ne $currentTempPass)
{
    Remove-MgUserAuthenticationTemporaryAccessPassMethod `
        -UserId $userAccount `
        -TemporaryAccessPassAuthenticationMethodId $currentTempPass.Id
}

# Delete the account
Remove-MgUser -UserId $userAccount

Disconnect-MgGraph
```

### Managing Licenses

```powewershell
Connect-MgGraph -TenantId course.dsinternals.com -ContextScope Process -Scopes User.ReadWrite.All,Organization.Read.All

$devLicense = Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq 'DEVELOPERPACK_E5'
Set-MgUserLicense -UserId AdeleV@course.dsinternals.com -AddLicenses @{SkuId = $devLicense.SkuId} -RemoveLicenses @()

# Disable some plans
$disabledPlans = $devLicense.ServicePlans | Where-Object ServicePlanName -in SWAY,CLIPCHAMP | Select-Object -ExpandProperty ServicePlanId
Set-MgUserLicense -UserId AdeleV@course.dsinternals.com -AddLicenses @(@{SkuId = $devLicense.SkuId; DisabledPlans = $disabledPlans }) -RemoveLicenses @()

Disconnect-MgGraph
```

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
