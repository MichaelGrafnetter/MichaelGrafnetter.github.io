---
id: 1691
title: The DSInternals PowerShell Module has been released
date: 2015-02-28T17:20:20+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/1621-revision-v1/
permalink: /1621-revision-v1/
---
<p style="text-align: justify;">
  I&nbsp;have decided to&nbsp;publish the&nbsp;DSInternals PowerShell Module, which&nbsp;contains a&nbsp;few cmdlets I&nbsp;use during my lectures about Active Directory security. You can find it&nbsp;in&nbsp;the&nbsp;<a title="Downloads" href="https://www.dsinternals.com/en/downloads/">Downloads</a> section. It&nbsp;currently lacks any documentation, so&nbsp;<em>Get-Help</em> won&#8217;t give you nice results, but&nbsp;I&nbsp;am working on&nbsp;that.
</p>

### Examples

<pre title="Examples" class="lang:ps decode:true">Import-Module DSInternals
$pwd = ConvertTo-SecureString 'Pa$$W0rd' -AsPlainText -Force

# Calculate the&nbsp;NT and&nbsp;LM hashes
$ntHash = ConvertTo-NTHash $pwd
$lmHash = ConvertTo-LMHash $pwd

# Set AD account password hash using the&nbsp;SAMR protocol
Set-SamAccountPasswordHash -SamAccountName john -Domain ADATUM -NTHash $ntHash -Server dc1.adatum.com

# Calculate the&nbsp;OrgId hash, that&nbsp;is&nbsp;sent to&nbsp;Azure Active Directory by&nbsp;DirSync
ConvertTo-OrgIdHash -NTHash $ntHash

# Decrypt a&nbsp;password from&nbsp;Group Policy Preferences
ConvertFrom-GPPrefPassword 'v9NWtCCOKEUHkZBxakMd6HLzo4+DzuizXP83EaImqF8'

# Decrypt a&nbsp;password from&nbsp;an unattend.xml file
ConvertFrom-UnattendXmlPassword 'UABhACQAJAB3ADAAcgBkAEEAZABtAGkAbgBpAHMAdAByAGEAdABvAHIAUABhAHMAcwB3AG8AcgBkAA=='</pre>

### Error reporting

If&nbsp;you find an error in&nbsp;the&nbsp;DSInternals Powershell Module, I&nbsp;would be glad if&nbsp;you sent me an [e-mail](https://www.dsinternals.com/en/about/ "Kontakt").

### Planned features

I&nbsp;am currently working on these new features, but&nbsp;it will take me some time until&nbsp;they are production-ready:

  * Offline modification of&nbsp;the ntds.dit file, including the&nbsp;sIDHistory, primaryGroupID and&nbsp;userAccountControl attributes.
  * Attribute-level authoritative restore of&nbsp;AD objects
  * Remote export of&nbsp;account password hashes using the&nbsp;MS-DRSR protocol
  * Fully functional Get-Help
  * MSI installer