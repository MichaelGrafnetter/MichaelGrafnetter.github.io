---
ref: ad-context-menu
title: Extending Active Directory Context Menus with&nbsp;PowerShell
date: '2024-03-19T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/aduc-custom-context-menu.png
permalink: /en/extending-active-directory-aduc-context-menu-powershell/
---

Most Active Directory admins may not be aware that the *Active Directory Users and Computers* MMC snap-in can easily be [extended with custom context menu items](https://learn.microsoft.com/en-us/windows/win32/ad/registering-a-static-context-menu-item):

![Screenshot of a customized context menu in the Active Directory Users and Computers console](/assets/images/aduc-custom-context-menu.png)

Unfortunately, all examples that I have found online are written in the [deprecated](https://learn.microsoft.com/en-us/windows/whats-new/deprecated-features-resources#vbscript) *VBScript*. As I strongly prefer using *PowerShell*, I have come up with my own solution, which I would like to share publicly.

Let's say we wanted to be able to quickly connect to computers over the Remote Desktop Protocol (RDP). We first need to create a PowerShell script called `Connect-RDPRestrictedAdmin.ps1`, which will be invoked by the context menu:

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

The recommended location for such a script would be the SYSVOL directory in the forest-root domain, e.g., `\\contoso.com\NETLOGON\ContextMenu\Connect-RDPRestrictedAdmin.ps1`.

Since PowerShell scripts cannot be executed directly from the Windows shell, we also need to create a batch script called `Connect-RDPRestrictedAdmin.bat` and place it in the same directory. This helper script will properly launch the main PowerShell script:

```bat
@ECHO OFF
REM Execute a PowerShell script with the same name and pass-through all command line parameters
start powershell.exe -ExecutionPolicy Bypass -NoLogo -NoProfile -File "%~dpn0.ps1" %*
```

Finally, we need to register the helper script in Active Directory, which can only be performed by the members of the *Enterprise Admins* group:

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

Note that the context menu registration is language-specific. The script above therefore contains [language code identifiers (LCIDs)](https://learn.microsoft.com/en-us/previous-versions/office/developer/exchange-server-2003/ms872878(v=exchg.65)) of all languages supported by Active Directory out-of-the-box.

For inspiration, here are some additional examples of custom computer context menu items I use in production environments:

- RDP Restricted Admin (Default Credentials)
- RDP Restricted Admin (Prompt for Credentials)
- RDP Remote Credential Guard (Default Credentials)
- RDP Remote Credential Guard (Prompt for Credentials)
- PowerShell Session (Default Credentials)
- PowerShell Session (Prompt for Credentials)
- SSH Connection
- Restart Computer
- Wake-on-LAN
- Ping Computer
- Open Share C$
- Show Logged-On Users
