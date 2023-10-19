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

Get-Mailbox -ResultSize Unlimited |
    Out-GridView -OutputMode Multiple |
    Disable-Mailbox -Archive -Confirm:$false
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
# Retrieving a specific user
Get-User -Identity 'AdeleV@course.dsinternals.com'

# Ambiguous Name Resolution
Get-User -Anr AdeleV
Get-User -Anr Johanna
# Interesting properties: RecipientType,UserPrincipalName,SKUAssigned,AccountDisabled,FirstName,LastName,City,Department,Phone,WindowsEmailAddress,IsDirSynced

# Filtering
Get-User -Filter 'City -eq "San Diego"'
Get-User -Filter 'City -eq "San Diego" -and FirstName -eq "Alex"'
Get-User -Filter { City -like 'S*' } | Format-Table -Property UserPrincipalName,City

Get-User -ResultSize Unlimited |
    Where-Object City -EQ 'San Diego' |
    Format-Table -Property UserPrincipalName,City

Get-User -ResultSize Unlimited |
    Where-Object { $PSItem.City -eq 'San Diego' } |
    Format-Table -Property UserPrincipalName,City

# Additional options
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

# Los Angeles => San Diego
Get-User -Filter {City -eq 'Los Angeles'} -RecipientTypeDetails UserMailbox |
    Set-User -City 'San Diego' -Confirm:$false
```

### Mailbox Permissions

```powershell
# Read and manage
Get-EXOMailboxPermission -Identity JohannaL
Get-Command -Name *MailboxPermission*
Add-MailboxPermission -Identity JohannaL -User AdeleV -AccessRights FullAccess,ReadPermission

# Send as
Get-RecipientPermission -Identity JohannaL
Add-RecipientPermission -Identity JohannaL -Trustee LynneR -AccessRights SendAs -Confirm:$false

# Send on behalf
Get-Mailbox -Identity JohannaL | Format-List -Property Identity,GrantSendOnBehalfTo
Set-Mailbox -Identity JohannaL -GrantSendOnBehalfTo LeeG

# Add value
$mb = Get-Mailbox -Identity JohannaL
Set-Mailbox -Identity $mb -GrantSendOnBehalfTo (@($mb.GrantSendOnBehalfTo) + 'AdeleV')

# Report
Get-Mailbox -ResultSize Unlimited -Filter 'GrantSendOnBehalfTo -ne $null' |
    Format-Table -Property Identity,GrantSendOnBehalfTo

# Forwarding
Get-Mailbox -Filter 'ForwardingAddress -ne $null -or ForwardingSmtpAddress -ne $null' -ResultSize Unlimited |
    Format-Table -Property PrimarySmtpAddress,ForwardingAddress,ForwardingSmtpAddress
```

Automation:

```powershell
@'
Recipient;SendAsTrustee
JohannaL;LynneR
LeeG;AdeleV
LeeG;JoniS
'@ > "$env:temp\sendas.csv"

Import-Csv -Path "$env:temp\sendas.csv" -Delimiter ';' | ForEach-Object {
    Add-RecipientPermission -Identity $PSItem.Recipient `
                            -Trustee $PSItem.SendAsTrustee `
                            -AccessRights SendAs `
                            -Confirm:$false `
                            -WarningAction SilentlyContinue
}
```

### Role-Based Access Control

```powershell
# Role Assignment
Get-RoleGroup
Get-RoleGroupMember -Identity 'Recipient Management'
Add-RoleGroupMember -Identity 'Recipient Management' -Member AdeleV

# Administrative Units
Get-AdministrativeUnit
Get-AdministrativeUnit -Identity HR
$adminUnitDN = (Get-AdministrativeUnit -Identity HR).DistinguishedName
Get-Recipient -RecipientPreviewFilter "AdministrativeUnits -eq '$adminUnitDN'"

Get-ManagementRole
Get-ManagementRole -Identity 'Mail Recipients'
Get-ManagementRoleAssignment
Get-ManagementRoleAssignment -RecipientWriteScope AdministrativeUnit

# Required to be executed once per organization: Enable-OrganizationCustomization
New-ManagementRoleAssignment -Role 'Mail Recipients' -RecipientAdministrativeUnitScope (Get-AdministrativeUnit -Identity HR) -User AdeleV
```

### Cmdlet Prefixes

```powershell
$cred = Get-Credential -Message 'Exchange on-prem credentials:' -UserName 'BANK\john'

Invoke-Command -ScriptBlock { Get-User } -Credential $cred -ComputerName ex01

$exchangeServer = New-PSSession -Credential $cred -ComputerName ex01
Import-PSSession -Session $exchangeServer -Module ExchangeManagement -Prefix OnPrem

Connect-ExchangeOnline -ShowBanner:$false -ErrorAction Stop -Prefix Cloud
```

## Microsoft Graph API

### Basics

```powershell
Install-Module Microsoft.Graph.Authentication -Scope CurrentUser -Force
Install-Module Microsoft.Graph.Users -Scope CurrentUser -Force
Install-Module Microsoft.Graph.Identity.SignIns -Scope CurrentUser -Force
Install-Module Microsoft.Graph.Identity.DirectoryManagement -Scope CurrentUser -Force
Install-Module Microsoft.Graph.Groups -Scope CurrentUser -Force
Install-Module Microsoft.Graph.Mail -Scope CurrentUser -Force
Install-Module Microsoft.Graph.Calendar -Scope CurrentUser -Force

# OR Install-Module Microsoft.Graph -Scope CurrentUser -Force

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

Get-MgUser -UserId 'AdeleV@course.dsinternals.com'
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

```powershell
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

Extensions:

- *.ps1
- *.psm1
- *.psd1
- *.format.ps1xml

### Execution Policy

```powershell
Get-ExecutionPolicy -List
Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
```

### Script Signing

```powershell
$cer = Get-Item -Path Cert:\CurrentUser\My\72FE8CD03DF1FB5DB18A07606281A52B5AB2F385

Set-AuthenticodeSignature -Certificate $cer `
                          -FilePath .\Import-EXOSendAsPermission.ps1 `
                          -TimestampServer http://timestamp.digicert.com `
                          -HashAlgorithm SHA256 `
                          -Force

Get-AuthenticodeSignature -FilePath .\Import-EXOSendAsPermission.ps1
```

### Script Parameters

#### Prompt

```powershell
function prompt() { 'PS > ' }
Clear-Host
```

### Conditions

### Error Handling

### Loops

### Strict Mode

```powershell
echo ($foo + 2)
Set-StrictMode -Version Latest
echo ($foo + 2)
Set-StrictMode -Off
```

### Console Output

```powershell
Write-Host 'Hello' -ForegroundColor DarkGreen -BackgroundColor DarkYellow
```

### Functions

```powershell
function Get-UserDisplayNameOrNull
{
    param($Identity)

    if($null -ne $Identity)
    {
        (Get-User -Identity $Identity).Displayname
    }
}

Get-User -ResultSize Unlimited |
    Select-Object -Property DisplayName,Department,Title,@{ n = 'Manager'; e = { Get-UserDisplayNameOrNull -Identity $PSItem.Manager }} |
    Out-GridView -Title 'Org Structure' -Wait
```

### Sample script

Contents of Import-EXOSendAsPermission.ps1:

```powershell
<#
.SYNOPSIS
Imports SendAs permissions from a CSV file into Exchange Online.

.DESCRIPTION
Sample CSV file contents:

Recipient;SendAsTrustee
JohannaL;LynneR
LeeG;AdeleV,JoniS

.PARAMETER CsvPath
Path to the CSV file with permissions.

.EXAMPLE
.\Import-EXOSendAsPermission

.EXAMPLE
.\Import-EXOSendAsPermission -CsvPath .\sendas.csv

.EXAMPLE
.\Import-EXOSendAsPermission.ps1 -ErrorAction Stop | Out-GridView

.NOTES
Author: Michael Grafnetter
Version: 1.1

#>

#Requires -Modules ExchangeOnlineManagement
#Requires -Version 3
##Requires -RunAsAdmin

param(
    [Parameter(Mandatory = $false, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [Alias('Path')]
    [string]
    $CsvPath = ".\sendas.csv"
)

Set-StrictMode -Version Latest

Import-Module -Name ExchangeOnlineManagement -ErrorAction Stop

# Connect-ExchangeOnline -ShowBanner:$false -ErrorAction Stop

try
{
    [bool] $fileExists = Test-Path -Path $CsvPath -PathType Leaf
    if(-not $fileExists)
    {
        Write-Error -Message 'File does not exist.' -ErrorAction Stop -Category ReadError -ErrorId 1003 -TargetObject $CsvPath
    }

    Write-Verbose -Message 'Loading the CSV file.'
    [PSCustomObject[]] $delegations = Import-Csv -Path $CsvPath -Delimiter ';' -ErrorAction Stop

    foreach($delegation in $delegations)
    {
        # Test the existence of the SendAsTrustee property
        [Microsoft.PowerShell.Commands.MemberDefinition] $sendAsTrusteeProperty =
            Get-Member -InputObject $delegation -Name SendAsTrustee -MemberType NoteProperty

        if($null -eq $sendAsTrusteeProperty -or [string]::IsNullOrWhiteSpace($delegation.SendAsTrustee))
        {
            Write-Error -Message 'Missing SendAsTrustee column value.' -Category InvalidData -ErrorId 1001 -TargetObject $delegation
            continue
        }

        # Test the existence of the Recipient property
        [Microsoft.PowerShell.Commands.MemberDefinition] $recipientProperty =
            Get-Member -InputObject $delegation -Name Recipient -MemberType NoteProperty

        if($null -eq $recipientProperty -or [string]::IsNullOrWhiteSpace($delegation.Recipient))
        {
            Write-Error -Message 'Missing Recipient column value.' -Category InvalidData -ErrorId 1002 -TargetObject $delegation
            continue
        }

        [string[]] $trustees = $delegation.SendAsTrustee -split ','

        foreach($truestee in $trustees)
        {
            Add-RecipientPermission -Identity $delegation.Recipient `
                                    -Trustee $truestee `
                                    -AccessRights SendAs `
                                    -Confirm:$false `
                                    -WarningAction SilentlyContinue
        }
    }
}
finally
{
    # Disconnect-ExchangeOnline -Confirm:$false
}
```

Contents of sendas.csv:

```csv
Recipient;SendAsTrustee
JohannaL;AdeleV
LeeG;AdeleV,JoniS
```

## Background Tasks

### App Registration

1. Generate a new self-signed certificate on your host PC by running the following PowerShell script as an administrator:

    ```powershell
    [X509Certificate] $cer =
        New-SelfSignedCertificate `
            -Subject "CN=$env:COMPUTERNAME Azure Script Authentication" `
            -KeyAlgorithm RSA `
            -KeyLength 2048 `
            -CertStoreLocation Cert:\LocalMachine\My `
            -KeyExportPolicy NonExportable `
            -Provider 'Microsoft Software Key Storage Provider' `
            -NotAfter (Get-Date).AddYears(1)

    Export-Certificate -Type CERT -Cert $cer -FilePath "$env:TEMP\AzureScriptAuthentication.cer" -Force
    ```

2. In the **App registrations** section of the Microsoft Entra Admin Center, create a new app with the following properties:
    - Name: User Reporting Script
    - Supported account types: Accounts in this organizational directory only
    - Certificates and secrets: Upload the `$env:TEMP\AzureScriptAuthentication.cer` certificate.
    - API permissions
        - Remove `User.Read`
        - Add `User.Read.All` (Microsoft Graph &rArr; Application permissions)
3. Locate the newly created service principal in the **Enterprise applications** section.
4. In the Permissions sub-section, grant admin consent to the app for the entire organization.
5. Run the following PowerShell script to test the configuration:

    ```powershell
    Connect-MgGraph -CertificateThumbprint e29266b47621392bd35aa708bbb8a49430334c73 `
                    -ClientId '0c14df71-f822-4f41-846a-b6bcd2383083' `
                    -TenantId 'ca78306c-8302-4aef-b696-1203d3e941a3' `
                    -ContextScope Process `
                    -NoWelcome

    Get-MgUser -All | Select-Object -Property DisplayName,Mail | Export-Csv -Path users.csv -NoTypeInformation

    Disconnect-MgGraph

    # OR

    Connect-ExchangeOnline  -CertificateThumbprint e29266b47621392bd35aa708bbb8a49430334c73  -AppId '0c14df71-f822-4f41-846a-b6bcd2383083' -Organization 'course.dsinternals.com'
    ```

    Do not forget to change the values of the `-ClientId`, `-TenantId`, and `Organization` parameters.

### Scheduled Tasks

```powershell
# Configure task execution interval
[datetime] $midnight = Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0
[int] $monday = 1
[ciminstance] $monthlyTrigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval $configuration.RunIntervalWeeks -DaysOfWeek $monday -At $midnight -RandomDelay (New-TimeSpan -Minutes 30) -ErrorAction Stop

# Locate powershell.exe
[string] $psPath = Get-Command -Name 'powershell.exe' -CommandType Application | Select-Object -ExpandProperty Path

# Locate the PS script to execute and generate PowerShell params
[string] $scriptPath = 'C:\Scripts\Generate-ExchangeReport.ps1'
[string] $psParams = '-ExecutionPolicy Bypass -NonInteractive -NoProfile -NoLogo -File "{0}"' -f $scriptPath
[ciminstance] $action = New-ScheduledTaskAction -Execute $psPath -Argument $psParams -WorkingDirectory $PSScriptRoot

# Create the task
[timespan] $taskExecutionLimit = (New-TimeSpan -Minutes 30)
[ciminstance] $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit $taskExecutionLimit -RunOnlyIfNetworkAvailable
[ciminstance] $newTask = Register-ScheduledTask `
                            -TaskName $configuration.TaskName `
                            -Description 'Generate Exchange reports on a monthly basis.' `
                            -Trigger $monthlyTrigger `
                            -Action $action `
                            -Principal 'NT AUTHORITY\Local Service' `
                            -Settings $settings `
                            -ErrorAction Stop `
                            -Force
```

## Further Reading

- [PowerShell 101](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/00-introduction)
- [Exchange Online PowerShell](https://learn.microsoft.com/en-us/powershell/exchange/exchange-online-powershell?view=exchange-ps)
- [Windows PowerShell 3.0 Language Quick Reference](https://download.microsoft.com/download/2/1/2/2122f0b9-0ee6-4e6d-bfd6-f9dcd27c07f9/ws12_quickref_download_files/powershell_langref_v3.pdf)
- [PowerShell Magazine](https://powershellmagazine.com/)
