---
ref: ad-context-menu
title: Extending Active Directory Context Menus with&nbsp;PowerShell
date: '2024-03-19T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/aduc-custom-context-menu.png
permalink: /en/extending-active-directory-aduc-context-menu-powershell/
---

Most Active Directory admins may not be&nbsp;aware that&nbsp;the&nbsp;*Active Directory Users and&nbsp;Computers* MMC snap-in can&nbsp;easily be&nbsp;[extended with&nbsp;custom context menu items](https://learn.microsoft.com/en-us/windows/win32/ad/registering-a-static-context-menu-item):

![Screenshot of&nbsp;a&nbsp;customized context menu in&nbsp;the&nbsp;Active Directory Users and&nbsp;Computers console](/assets/images/aduc-custom-context-menu.png)

Unfortunately, all examples that&nbsp;I&nbsp;have found online are&nbsp;written in&nbsp;the&nbsp;[deprecated](https://learn.microsoft.com/en-us/windows/whats-new/deprecated-features-resources#vbscript) *VBScript*. As&nbsp;I&nbsp;strongly prefer using *PowerShell*, I&nbsp;have come up with&nbsp;my own solution, which&nbsp;I&nbsp;would like to&nbsp;share publicly.

Let's say we wanted to&nbsp;be&nbsp;able to&nbsp;quickly connect to&nbsp;computers over the&nbsp;Remote Desktop Protocol (RDP). We first need to&nbsp;create a&nbsp;PowerShell script called `Connect-RDPRestrictedAdmin.ps1`, which&nbsp;will be&nbsp;invoked by&nbsp;the&nbsp;context menu:

```powershell
<#
.SYNOPSIS
Connects to the selected computer over the Remote Desktop Protocol (RDP) in the Restricted Admin mode.

.DESCRIPTION
This script is intended to be executed by the Active Directory Users and Computers MMC snap-in.

.PARAMETER ObjectPath
ADSI path to the AD object on which the context menu action is being invoked.

.PARAMETER ObjectType
Type/class of the object on which the context menu action is being invoked.

.EXAMPLE
Connect-RDPRestrictedAdmin.ps1 "LDAP://CN=PC01,CN=Computers,DC=contoso,DC=com" computer

#>
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $ObjectPath,

    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateSet('computer')]
    [string] $ObjectType
)

# Change the PowerShell window title
$Host.ui.RawUI.WindowTitle = 'Connecting over RDP...'

# Fetch the computer object from AD
[adsi] $computer = $ObjectPath

# Load the computer's FQDN
[string] $computerName = $computer.dNSHostName.ToString()

if([string]::IsNullOrEmpty($computerName))
{
    # Fall back to the NetBIOS name / CN, which is always populated
    $computerName = $computer.name.ToString()
}

# Connect using the built-in RDP client
mstsc.exe /restrictedAdmin /v:$computerName /f
```

<!--more-->

The recommended location for&nbsp;such a&nbsp;script would be&nbsp;the&nbsp;SYSVOL directory in&nbsp;the&nbsp;forest-root domain, e.g., `\\contoso.com\NETLOGON\ContextMenu\Connect-RDPRestrictedAdmin.ps1`.

Since PowerShell scripts cannot be&nbsp;executed directly from&nbsp;the&nbsp;Windows shell, we also need to&nbsp;create a&nbsp;batch script called `Connect-RDPRestrictedAdmin.bat` and&nbsp;place it&nbsp;in&nbsp;the&nbsp;same directory. This&nbsp;helper script will properly launch the&nbsp;main PowerShell script:

```bat
@ECHO OFF
REM Execute a PowerShell script with the same name and pass-through all command line parameters
start powershell.exe -ExecutionPolicy Bypass -NoLogo -NoProfile -File "%~dpn0.ps1" %*
```

Finally, we need to&nbsp;register the&nbsp;helper script in&nbsp;Active Directory, which&nbsp;can&nbsp;only be&nbsp;performed by&nbsp;the&nbsp;members of&nbsp;the&nbsp;*Enterprise Admins* group:

```powershell
<#
.SYNOPSIS
Registers custom context menu items for the Active Directory Users and Computers snap-in.

#>

#Requires -Modules ActiveDirectory
#Requires -RunAsAdministrator

Import-Module -Name ActiveDirectory -ErrorAction Stop

[Microsoft.ActiveDirectory.Management.ADRootDSE] $rootDSE = Get-ADRootDSE -ErrorAction Stop
[Microsoft.ActiveDirectory.Management.ADForest] $forest = Get-ADForest -Current LoggedOnUser -ErrorAction Stop

# The settings are stored in the configuration partition and are language-specific
[string] $computerDisplaySpecifierTemplate = 'CN=computer-Display,CN={0:X2},CN=DisplaySpecifiers,' + $rootDSE.configurationNamingContext

# Although this script only registers a single menu item, it can easily be modified to register additional ones.
# TODO: Translation into all languages supported by AD is needed.
[hashtable[]] $menuItems = @(
@{
    Order = 1
    Script = 'Connect-RDPRestrictedAdmin.bat'
    Labels = @(
        @{
            LCID = 0x409 # US English (en-us)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x405 # Czech (cs)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x407 # German (de)
            Text = 'RDP Eingeschränkter Admin'
        },@{
            LCID = 0x40C # French (fr)
            Text = 'RDP Administrateur restreint'
        },@{
            LCID = 0x404 # Chinese (zh-tw)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x406 # Danish (da)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x408 # Greek (el)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x410 # Italian (it)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x411 # Japanese (ja)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x412 # Korean (ko)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x413 # Dutch (nl)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x414 # Norwegian (no)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x415 # Polish (pl)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x416 # Portuguese/Brazil (pt-br)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x419 # Russian (ru)
            Text = 'RDP Ограниченный администратор'
        },@{
            LCID = 0x40B # Finnish (fi)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x40E # Hungarian (hu)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x41D # Swedish (sv)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x41F # Turkish (tr)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x804 # Chinese (zh-cn)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0x816 # Potruguese/Portugal (pt)
            Text = 'RDP Restricted Admin'
        },@{
            LCID = 0xC0A # Spanish (es)
            Text = 'RDP Restricted Admin'
        }
    )
}
)

# Scripts referenced by the context menus are placed in this directory
[string] $scriptDirectory = '\\{0}\NETLOGON\ContextMenu' -f $forest.RootDomain

foreach($menuItem in $menuItems)
{
    [string] $scriptPath = Join-Path -Path $scriptDirectory -ChildPath $menuItem.Script -ErrorAction Stop
    [int] $menuItemOrder = $menuItem.Order

    foreach($label in $menuItem.Labels)
    {
        # Perform the language-specific registration of a single context menu item
        [string] $computerDisplaySpecifier = $computerDisplaySpecifierTemplate -f $label.LCID
        [string] $contextMenuValue = '{0},{1},{2}' -f $menuItemOrder,$label.Text,$scriptPath
        Set-ADObject -Identity $computerDisplaySpecifier -Add @{ contextMenu = $contextMenuValue } -Verbose -ErrorAction Stop
    }
}
```

Note that&nbsp;the&nbsp;context menu registration is&nbsp;language-specific. The&nbsp;script above therefore contains [language code identifiers (LCIDs)](https://learn.microsoft.com/en-us/previous-versions/office/developer/exchange-server-2003/ms872878(v=exchg.65)) of&nbsp;all languages supported by&nbsp;Active Directory out-of-the-box.

For inspiration, here are&nbsp;some&nbsp;additional examples of&nbsp;custom computer context menu items I&nbsp;use in&nbsp;production environments:

- RDP Restricted Admin (Default Credentials)
- RDP Restricted Admin (Prompt for&nbsp;Credentials)
- RDP Remote Credential Guard (Default Credentials)
- RDP Remote Credential Guard (Prompt for&nbsp;Credentials)
- PowerShell Session (Default Credentials)
- PowerShell Session (Prompt for&nbsp;Credentials)
- SSH Connection
- Restart Computer
- Wake-on-LAN
- Ping Computer
- Open Share C$
- Show Logged-On Users
