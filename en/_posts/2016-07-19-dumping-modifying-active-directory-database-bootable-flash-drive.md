---
ref: 7611
title: 'Dumping and&nbsp;Modifying Active Directory Database Using a&nbsp;Bootable Flash Drive'
date: 2016-07-19T15:18:36+00:00
layout: post
lang: en
permalink: /en/dumping-modifying-active-directory-database-bootable-flash-drive/
tags:
    - 'Active Directory'
    - DPAPI
    - PowerShell
    - Security
---

Since version 2.15, the [DSInternals PowerShell Module](https://github.com/MichaelGrafnetter/DSInternals) fully supports [Windows PE](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-intro?view=windows-11), the free minimalistic edition of Windows. This means that all the nasty Active Directory database stuff can now be performed from a bootable flash drive or an ISO image, including:

- [Dumping NT hashes, kerberos keys and cleartext passwords](/en/dumping-ntds-dit-files-using-powershell/) from ntds.dit files.
- Modifying the SID History of user accounts and groups.
- Modifying the Primary Group ID of user accounts.
- [Extracting the DPAPI domain backup keys](/en/retrieving-dpapi-backup-keys-from-active-directory/).

![Windows PE DSInternals](../../assets/images/winpe.png)

<!--more-->
## Required access

These actions would of course require an attacker to have one of the following:

- Physical access to a domain controller (DC).
- Knowledge of DC’s baseboard management controller (BMC) credentials.
- Administrative access to a virtualized DC.

In an ideal world, only Domain Admins should have such non-trivial access to the core AD infrastructure, but the everyday reality is far from perfect.

## Creating the media

To create a bootable Windows PE media loaded with the DSInternals module, follow these steps:

1. Install the [Windows Assessment and Deployment Kit (ADK)](https://go.microsoft.com/fwlink/p/?LinkId=526803), including the Windows PE feature.
2. Click *Start*, and type *deployment*. Right-click *Deployment and Imaging Tools Environment* and then select *Run as administrator*.
3. Create a working copy of the Windows PE files. Specify either x86 or amd64:
```bat
copype amd64 C:\WinPE_amd64
```
4. Mount the Windows PE image:
```bat
Dism /Mount-Image /ImageFile:"C:\WinPE_amd64\media\sources\boot.wim" /index:1 /MountDir:"C:\WinPE_amd64\mount"
```
5. Add PowerShell support to Windows PE by adding a few [optional components](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-add-packages--optional-components-reference?view=windows-11), together with their associated language packs:
```bat
Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-WMI.cab"
Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-WMI_en-us.cab"
    
Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-NetFX.cab"
Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-NetFX_en-us.cab"
    
Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-Scripting.cab"
Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-Scripting_en-us.cab"
    
Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-PowerShell.cab"
Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-PowerShell_en-us.cab"
```
6. Add the [DSInternals PowerShell module](https://github.com/MichaelGrafnetter/DSInternals/releases) to the Windows PE image by copying it into the *C:\\WinPE\_amd64\\mount\\Windows\\system32\\ WindowsPowerShell\\v1.0\\Modules* folder.
7. [Add device drivers](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/add-and-remove-drivers-to-an-offline-windows-image?view=windows-11) to the Windows PE image:
```bat
Dism /Add-Driver /Image:"C:\WinPE_amd64\mount" /Driver:"C:\DriversToEmbed" /Recurse
```
8. Configure PowerShell to start automatically after boot by creating a file called *winpeshl.ini* in the *C:\\WinPE\_amd64\\mount\\Windows\\system32* folder, containing this text:
```ini
[LaunchApps]
wpeinit.exe
powershell.exe, -NoExit -NoLogo -ExecutionPolicy Bypass
```
9. [Create an ISO file](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/makewinpemedia-command-line-options?view=windows-11) containing the Windows PE files:
```bat
MakeWinPEMedia /ISO C:\WinPE_amd64 C:\WinPE_amd64\WinPE_amd64.iso
```
    
The&nbsp;same command can be used to&nbsp;create a&nbsp;bootable flash drive or&nbsp;VHD.

## Final thoughts

As&nbsp;you have seen, it is&nbsp;pretty straightforward to&nbsp;create a&nbsp;bootable flash drive that&nbsp;can be used to&nbsp;conquer an Active Directory domain through a&nbsp;physically accessible DC. One of&nbsp;the precautions a&nbsp;domain administrator can take is&nbsp;to&nbsp;encrypt all DCs using BitLocker or&nbsp;other tool that&nbsp;does full volume encryption. Deploying RODCs at smaller branch offices is&nbsp;also a&nbsp;good idea. The&nbsp;new features in&nbsp;Windows Server 2016, Virtual TPMs and&nbsp;Shielded VMs, also seem very promising in&nbsp;regards to&nbsp;DC security.