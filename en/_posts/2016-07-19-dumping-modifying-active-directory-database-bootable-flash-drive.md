---
ref: 7611
title: 'Dumping and&nbsp;Modifying Active Directory Database Using a&nbsp;Bootable Flash Drive'
date: 2016-07-19T15:18:36+00:00
layout: post
lang: en
permalink: /en/dumping-modifying-active-directory-database-bootable-flash-drive/
---
<p style="text-align: justify;">
  Since&nbsp;version 2.15, the&nbsp;<a href="https://github.com/MichaelGrafnetter/DSInternals">DSInternals PowerShell Module</a> fully supports <a href="https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/winpe-intro">Windows PE</a>, the&nbsp;free minimalistic edition of&nbsp;Windows. This means that&nbsp;all the&nbsp;nasty Active Directory database stuff can now&nbsp;be performed from&nbsp;a&nbsp;bootable flash drive or&nbsp;an ISO image, including:
</p>

<li style="text-align: justify;">
  <a href="https://www.dsinternals.com/en/dumping-ntds-dit-files-using-powershell/">Dumping NT hashes, kerberos keys and&nbsp;cleartext passwords</a> from&nbsp;ntds.dit files.
</li>
<li style="text-align: justify;">
  Modifying the&nbsp;SID History of&nbsp;user accounts and&nbsp;groups.
</li>
<li style="text-align: justify;">
  Modifying the&nbsp;Primary Group ID of&nbsp;user accounts.
</li>
<li style="text-align: justify;">
  <a href="https://www.dsinternals.com/en/retrieving-dpapi-backup-keys-from-active-directory/">Extracting the&nbsp;DPAPI domain backup keys</a>.
</li>

[<img class="aligncenter size-full wp-image-7881" src="https://www.dsinternals.com/wp-content/uploads/winpe.png" alt="Windows PE DSInternals" width="570" height="189" srcset="https://www.dsinternals.com/wp-content/uploads/winpe.png 570w, https://www.dsinternals.com/wp-content/uploads/winpe-300x99.png 300w" sizes="(max-width: 570px) 100vw, 570px" />](https://www.dsinternals.com/wp-content/uploads/winpe.png)

### Required access

<p style="text-align: justify;">
  These actions would of&nbsp;course require an attacker to&nbsp;have one of&nbsp;the following:
</p>

<li style="text-align: justify;">
  Physical access to&nbsp;a domain controller (DC).
</li>
<li style="text-align: justify;">
  Knowledge of&nbsp;DC&#8217;s <span class="st">baseboard management controller (BMC) credentials.</span>
</li>
<li style="text-align: justify;">
  Administrative access to&nbsp;a virtualized DC.
</li>

<p style="text-align: justify;">
  In&nbsp;an ideal world, only Domain Admins should have such non-trivial access to&nbsp;the core AD infrastructure, but&nbsp;the&nbsp;everyday reality is&nbsp;far from&nbsp;perfect.
</p>

<h3 style="text-align: justify;">
  Creating the&nbsp;media
</h3>

<p style="text-align: justify;">
  To&nbsp;create a&nbsp;bootable Windows PE media loaded with the&nbsp;DSInternals module, follow these steps:
</p>

<li style="text-align: justify;">
  Install the&nbsp;<a href="http://go.microsoft.com/fwlink/p/?LinkId=526803">Windows Assessment and&nbsp;Deployment Kit (ADK)</a>, including the&nbsp;Windows PE feature.
</li>
<li style="text-align: justify;">
  Click <em>Start</em>, and&nbsp;type <em>deployment</em>. Right-click <em>Deployment and&nbsp;Imaging Tools Environment</em> and&nbsp;then select <em>Run as&nbsp;administrator</em>.
</li>
  1. Create a&nbsp;working copy of&nbsp;the Windows PE files. Specify either x86 or&nbsp;amd64: <pre class="lang:batch decode:true ">copype amd64 C:\WinPE_amd64</pre>

  2. Mount the&nbsp;Windows PE image: <pre class="lang:batch decode:true">Dism /Mount-Image /ImageFile:"C:\WinPE_amd64\media\sources\boot.wim" /index:1 /MountDir:"C:\WinPE_amd64\mount"</pre>

<li style="text-align: justify;">
  Add PowerShell support to&nbsp;Windows PE by&nbsp;adding a&nbsp;few <a href="https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/winpe-add-packages--optional-components-reference">optional components</a>, together with their associated language packs: <pre class="lang:batch decode:true">Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and&nbsp;Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-WMI.cab"  
Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and&nbsp;Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-WMI_en-us.cab"

Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and&nbsp;Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-NetFX.cab"  
Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and&nbsp;Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-NetFX_en-us.cab"

Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and&nbsp;Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-Scripting.cab"  
Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and&nbsp;Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-Scripting_en-us.cab"

Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and&nbsp;Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-PowerShell.cab"  
Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files\Windows Kits\10\Assessment and&nbsp;Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-PowerShell_en-us.cab"</pre>
</li>

<li style="text-align: justify;">
  Add the&nbsp;<a href="https://github.com/MichaelGrafnetter/DSInternals/releases">DSInternals PowerShell module</a> to&nbsp;the Windows PE image by&nbsp;copying it into the&nbsp;<em>C:\WinPE_amd64\mount\Windows\system32\ WindowsPowerShell\v1.0\Modules</em> folder.
</li>
  3. [Add device drivers](https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/winpe-add-drivers) to&nbsp;the Windows PE image: <pre class="lang:batch decode:true">Dism /Add-Driver /Image:"C:\WinPE_amd64\mount" /Driver:"C:\DriversToEmbed" /Recurse</pre>

<li style="text-align: justify;">
  Configure PowerShell to&nbsp;start automatically after&nbsp;boot by&nbsp;creating a&nbsp;file called <em>winpeshl.ini</em> in&nbsp;the&nbsp;<em>C:\WinPE_amd64\mount\Windows\system32</em> folder, containing this text: <pre class="lang:ini decode:true ">[LaunchApps]
wpeinit.exe
powershell.exe, -NoExit -NoLogo -ExecutionPolicy Bypass</pre>
</li>

  4. [Create an ISO file](https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/makewinpemedia-command-line-options?f=255&MSPPError=-2147217396) containing the&nbsp;Windows PE files: <pre class="lang:batch decode:true">MakeWinPEMedia /ISO C:\WinPE_amd64 C:\WinPE_amd64\WinPE_amd64.iso</pre>
    
    <p style="text-align: justify;">
      The&nbsp;same command can be used to&nbsp;create a&nbsp;bootable flash drive or&nbsp;VHD.
    </p>

### Final thoughts

<p style="text-align: justify;">
  As&nbsp;you have seen, it is&nbsp;pretty straightforward to&nbsp;create a&nbsp;bootable flash drive that&nbsp;can be used to&nbsp;conquer an Active Directory domain through a&nbsp;physically accessible DC. One of&nbsp;the precautions a&nbsp;domain administrator can take is&nbsp;to&nbsp;encrypt all DCs using BitLocker or&nbsp;other tool that&nbsp;does full volume encryption. Deploying RODCs at smaller branch offices is&nbsp;also a&nbsp;good idea. The&nbsp;new features in&nbsp;Windows Server 2016, Virtual TPMs and&nbsp;Shielded VMs, also seem very promising in&nbsp;regards to&nbsp;DC security.
</p>