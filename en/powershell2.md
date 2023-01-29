---
ref: wug-powershell-ad-audit
title: Active Directory Security Assessment with PowerShell
date: 2023-01-29T00:00:00+00:00
layout: page
lang: en
permalink: /en/wug-powershell-ad-audit/
sitemap: false
---

## Generic Techniques

### Event Logs

#### Get-EventLog Cmdlet

```powershell
Get-EventLog -ComputerName localhost -After ([DateTime]::Today) -LogName System -Source 'Service Control Manager' |
    Where-Object EventID -eq 7036 |
    Select-Object -Property @{ n='ComputerName'; e={$PSItem.MachineName} },
                            @{ n='Time'; e={$PSItem.TimeGenerated}},
                            @{ n='ServiceName'; e = {$PSItem.ReplacementStrings[0]} },
                            @{ n='State'; e = {$PSItem.ReplacementStrings[1]}}
```

#### Get-WinEvent Cmdlet

```powershell
Get-WinEvent -ComputerName localhost -FilterHashtable @{
    LogName = 'System'
    ProviderName = 'Service Control Manager'
    Id = 7036
} |
    Select-Object -Property @{n='ComputerName';e={$PSItem.MachineName}},
                            @{n='Date';e={$PSItem.TimeCreated.Date}},
                            @{n='ServiceName';e={$PSItem.Properties.Value[0]}},
                            @{n='State';e={$PSItem.Properties.Value[1]}} |
    Sort-Object -Property ServiceName,Date |
    Group-Object -Property ServiceName,Date |
    Select-Object -Property @{ n = 'ServiceName'; e = { $PSItem.Group[0].ServiceName } },
                            @{ n = 'Date'; e = { $PSItem.Group[0].Date } },
                            Count |
    Out-GridView
```

### ActiveDirectory PowerShell Module

#### Stale Accounts

```powershell
$3monthsAgo = (Get-Date).AddMonths(-3)
Get-ADUser -Filter { Enabled -eq $true -and (LastLogonDate -lt $3monthsAgo -or LastLogonDate -notlike '*') } `
           -Properties LastLogonDate,PasswordLastSet |
    Sort-Object -Property LastLogonDate |
    Format-Table -Property Name,SamAccountName,LastLogonDate,PasswordLastSet
```

#### Kerberos-Enabled Accounts

```powershell
Get-ADUser -Filter { Enabled -eq $true -and ServicePrincipalNames -like '*' } `
           -Properties ServicePrincipalNames,UseDESKeyOnly,KerberosEncryptionType |
    Format-Table -Property SamAccountName,ServicePrincipalNames,KerberosEncryptionType,UseDESKeyOnly
```

#### Module Installation

##### Windows Optional Feature

![Optional Features List](/assets/images/optional_features.png)

Issues
  - Requires Administrative permissions.
  - Requires Internet connectivity.
  - Fails in many WSUS environments.

##### Import DLLs

[Nikhil Mittal's AD Module Clone](https://github.com/samratashok/ADModule)

```powershell
iex (new-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/samratashok/ADModule/master/Import-ActiveDirectory.ps1');Import-ActiveDirectory
```

## PowerShell-Based Assessment Tools

### Purple Knight

- [Purple Knight Web](https://www.purple-knight.com/)
- [Security Indicators](https://www.purple-knight.com/security-indicators/)
- [Direct Download](https://www.purple-knight.com/resources/)

![](https://www.purple-knight.com/wp-content/uploads/images_screenshots/image-pk-home-step01find-768x614.png)

### AD ACL Scanner

[AD ACL Scanner GitHub](https://github.com/canix1/ADACLScanner)

![](https://github.com/canix1/ADACLScanner/raw/master/src/ADACLScan7.0_Permission.png)

![](https://github.com/canix1/ADACLScanner/raw/master/src/ADACLScan6.0.png)

![](https://github.com/canix1/ADACLScanner/raw/master/src/effectiverights.gif)

### PowerView
- [PowerView GitHub](https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1)
- [PowerView Intro](https://www.ired.team/offensive-security-experiments/active-directory-kerberos-abuse/active-directory-enumeration-with-powerview)

## DSInternals

```powershell
Install-PackageProvider -Name NuGet -Scope CurrentUser -Force
Install-Module -Name DSInternals -Scope CurrentUser -Force
Get-ADReplAccount -All -Server dc.contoso.com |
    Test-PasswordQuality -WeakPasswords 'Pa$$w0rd','WUG2023','January2023'
```

[Have I Been Pwned Passwords](https://haveibeenpwned.com/Passwords)

## Desired State Configuration (DSC)

### DSC Intro

Referenced Resources
- [NetworkingDsc](https://www.powershellgallery.com/packages/NetworkingDsc)
- [LAPS](https://www.microsoft.com/en-us/download/details.aspx?id=46899)
- [SecurityPolicyDsc](https://www.powershellgallery.com/packages/SecurityPolicyDsc/)
- [AuditPolicyDsc](https://www.powershellgallery.com/packages/AuditPolicyDsc)

```powershell
Configuration WindowsServerSecurityBaseline
{
    Import-DscResource –ModuleName PSDesiredStateConfiguration
    Import-DscResource –ModuleName NetworkingDsc
    Import-DscResource –ModuleName SecurityPolicyDsc

    Node localhost
    {
        LocalConfigurationManager
        {
            ConfigurationModeFrequencyMins = 120
            RebootNodeIfNeeded = $false
            ConfigurationMode = 'ApplyAndAutoCorrect'
            ActionAfterReboot = 'ContinueConfiguration'
        }

        Service DisableSpooler
        {
            Name = 'Spooler'
            State = 'Stopped'
            StartupType = 'Disabled'
        }

        Registry RDPRestrictedAdmin
        {
            Key = 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa'
            ValueName = 'DisableRestrictedAdmin'
            ValueData = 0
            ValueType = 'Dword'
            Ensure = 'Present'
            Force = $true
        }

        WindowsFeature DisablePowerShell2
        {
            Name = 'PowerShell-V2'
            Ensure = 'Absent'
        }

        Package LAPS
        {
            Name  = 'Local Administrator Password Solution'
            Path = 'https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x64.msi'
            ProductId = 'EA8CB806-C109-4700-96B4-F1F268E5036C'
        }

        FirewallProfile ServerDomainProfile
        {
            Name = 'Domain'
            AllowLocalFirewallRules = 'False'
            DefaultInboundAction = 'Block'
        }

        FirewallProfile ServerPrivateProfile
        {
            Name = 'Private'
            AllowLocalFirewallRules = 'False'
            DefaultInboundAction = 'Block'
        }

        FirewallProfile ServerPublicProfile
        {
            Name = 'Public'
            AllowLocalFirewallRules = 'False'
            DefaultInboundAction = 'Block'
        }

        UserRightsAssignment RDPPermissions_ExcludeUsers
        {
            Policy = 'Allow_log_on_through_Remote_Desktop_Services'
            Identity = 'Domain Users','Authenticated Users'
            Ensure = 'Absent'
        }
    }
}

WindowsServerSecurityBaseline -OutputPath .

Test-DscConfiguration -Path .\WindowsServerSecurityBaseline -Verbose

Set-DscLocalConfigurationManager -Path .\WindowsServerSecurityBaseline -Force

Start-DscConfiguration -Path .\WindowsServerSecurityBaseline -Wait -Force -Verbose
```

### Security Baseline Tooling
- [Microsoft Security Compliance Toolkit 1.0 ](https://www.microsoft.com/en-us/download/details.aspx?id=55319)
- [Microsoft Security Compliance Manager 4.0](https://www.microsoft.com/en-us/download/details.aspx?id=53353)
- [Quickstart: Convert Group Policy into DSC](https://learn.microsoft.com/en-us/powershell/dsc/quickstarts/gpo-quickstart)
- [BaselineManagement](https://www.powershellgallery.com/packages/BaselineManagement)

![Policy Viewer](https://techcommunity.microsoft.com/t5/image/serverpage/image-id/119320i7FDC58E883D5F3BA)

```powershell
Install-PackageProvider -Name NuGet -Scope AllUsers -Force
Install-Module -Name BaselineManagement -Scope AllUsers -Force
Update-Module -Force -Verbose
Set-Item -Path WSMan:\localhost\MaxEnvelopeSizekb -Value 8192 -Force
ConvertFrom-GPO -Path 'C:\Users\Admin\Downloads\Windows-11-v22H2-Security-Baseline\GPOs\' -OutputConfigurationScript
```

### Center for&nbsp;Internet Security (CIS) Benchmarks
- [CIS Benchmarks](https://www.cisecurity.org/benchmark/microsoft_windows_server)
- [CIS DSC](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC)

### Security Technical Implementation Guides (STIGs)

- [STIGs](https://public.cyber.mil/stigs/)
- [Windows Server 2019 STIG](https://www.stigviewer.com/stig/windows_server_2019/)
- [PowerSTIG](https://github.com/microsoft/PowerStig)

```powershell
Install-Module -Name PowerStig -Scope AllUsers -Force
Get-Stig -ListAvailable | Format-Table
Set-Item -Path WSMan:\localhost\MaxEnvelopeSizekb -Value 8192 -Force

Configuration DnsServerBaseline
{
    param
    (
        [parameter()]
        [string]
        $NodeName = 'localhost'
    )

    Import-DscResource -ModuleName PowerStig

    Node $NodeName
    {
        WindowsDnsServer DnsSettings
        {
            OsVersion   = '2012R2'
            StigVersion = '2.5'
            DomainName  = 'contoso.com'
            ForestName  = 'contoso.com'
            Exception   = @{"V-58697.a"=@{'Identity'='Administrators,DnsAdministrators'}}
        }
    }
}

DnsServerBaseline -OutputPath .

$results = Test-DscConfiguration -Path .\DnsServerBaseline -Verbose
$results
$results.ResourcesInDesiredState.ResourceId
$results.ResourcesNotInDesiredState.ResourceId
```

## Pester

### DomainController.Tests.ps1

```powershell
<#
.SYNOPSIS
Invokes DC tests using Pester.

#>

#Requires -Version 5 -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

Param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string] $DCName = 'localhost'
)

Describe 'Domain Controller' {
    Context 'Print Spooler Service' {
        BeforeAll {
            Add-Type -AssemblyName System.ServiceProcess
        }
        It 'Print Spooler should be disabled' {
            Get-Service -Name Spooler -ComputerName $DCName -ErrorAction Stop |
                Select-Object -ExpandProperty StartType |
                Should -Be ([System.ServiceProcess.ServiceStartMode]::Disabled)
        }

        It 'Print Spooler should be stopped' {
            Get-Service -Name Spooler -ComputerName $DCName -ErrorAction Stop |
                Select-Object -ExpandProperty Status |
                Should -Be ([System.ServiceProcess.ServiceControllerStatus]::Stopped)
        }
    }

    Context 'Availability' {
        BeforeDiscovery {
            [hashtable[]] $ports = @{ Port = 389; Service = 'LDAP' },
                                   @{ Port = 636; Service = 'LDAPS' },
                                   @{ Port = 445; Service = 'SMB' }
        }

        It 'Server DC should be pingable' {
            Test-Connection -ComputerName $DCName -Quiet -Count 1 | Should -BeTrue
        }

        It '<Service> (TCP port <Port>) should be reachable on DC' -TestCases $ports {
            param([int] $Port, [string] $Service)

            Test-NetConnection -Port $Port -ComputerName $DCName |
                Select-Object -ExpandProperty TcpTestSucceeded |
                Should -BeTrue
        }
    }
}
```

### ADGroups.Tests.ps1

```powershell
<#
.SYNOPSIS
Invokes Group Membership tests using Pester.

#>

#Requires -Version 5 -Modules ActiveDirectory,@{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

Describe 'Group Membership' {
    Context 'Empty Groups' {
        BeforeDiscovery {
            [string[]] $groupNames = 'Schema Admins',
                                     'Print Operators',
                                     'Remote Desktop Users',
                                     'Account Operators'
            [hashtable[]] $groups = $groupNames | ForEach-Object { @{ Group = $PSItem } }
        }

        It 'The "<Group>" group should be empty' -TestCases $groups {
            param([string] $Group)

            Get-ADGroupMember -Identity $Group -ErrorAction Stop | 
                Should -HaveCount 0
        }
    }
}
```

### Test Runner

#### Basic

```powershell
Invoke-Pester -Path .\Tests\ -Output Detailed
```

#### Run.ps1

```powershell
<#
.SYNOPSIS
Invokes all Pester tests and generates a HTML report.

#>

#Requires -Version 5 -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

$htmlHead = @'
<style type="text/css">
    table, th, td {
          border: 1px solid;
          border-spacing: 0px;
    }
</style>
<script
    src="https://code.jquery.com/jquery-3.6.0.slim.min.js"
	integrity="sha256-u7e5khyithlIdTpu22PHhENmPcRdFiHRjhAuHcs05RI="
	crossorigin="anonymous">
</script>
<script>
// Colorize table rows based on Success/Failure using jQuery (does not work in MSIE).
$(document).ready(function() {
    $("td").each(function(){
        if($(this).text() == "Passed"){
            $(this).parent().css("background-color", "#77dd77");
        } else if($(this).text() == "Failed"){
            $(this).parent().css("background-color", "#ff6961");
        } else if($(this).text() == "Inconclusive" || $(this).text() == "Skipped"){
            $(this).parent().css("background-color", "#fdfd96");
        }
    })
});
</script>
<title>Services</title>
'@

$resultsFile = Join-Path -Path $PSScriptRoot -ChildPath 'results.html'

Invoke-Pester -Path $PSScriptRoot -PassThru |
    Select-Object -ExpandProperty Tests | 
    Select-Object -Property @{ n = 'Category'; e = { $PSItem.Path[0] }},
                            @{ n = 'Context';  e = { $PSItem.Path[1] }},
                            ExpandedName,
                            Result,
                            @{ n = 'Error'; e = { $PSItem.ErrorRecord.DisplayErrorMessage } } |
    ConvertTo-Html -PreContent '<h1>Test Results</h1>' -Head $htmlHead |
    Out-File -FilePath $resultsFile -Encoding utf8 -Force
```
