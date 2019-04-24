---
id: 4971
title: 'The DSInternals PowerShell Module has&nbsp;been&nbsp;released'
date: 2015-09-29T20:21:26+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/1621-revision-v1/
permalink: /1621-revision-v1/
---
<p style="text-align: justify;">
  I&nbsp;have decided to&nbsp;publish the&nbsp;DSInternals PowerShell Module, which&nbsp;contains a few cmdlets I&nbsp;use during my lectures about Active Directory security. You can find it in the <a title="Downloads" href="https://www.dsinternals.com/en/downloads/">Downloads</a> section. It currently lacks any documentation, so&nbsp;<em>Get-Help</em> won&#8217;t give you nice results, but&nbsp;I&nbsp;am working on that.
</p>

### Examples

<pre title="Examples" class="lang:ps decode:true  ">Import-Module DSInternals
$pwd = ConvertTo-SecureString 'Pa$$W0rd' -AsPlainText -Force

# Calculate the&nbsp;NT and&nbsp;LM hashes
ConvertTo-NTHash $pwd
# Output: 92937945b518814341de3f726500d4ff

ConvertTo-LMHash $pwd
# Output: 727e3576618fa1754a3b108f3fa6cb6d

# Set AD account password hash using the&nbsp;SAMR protocol
Set-SamAccountPasswordHash -SamAccountName john -Domain ADATUM -NTHash '92937945b518814341de3f726500d4ff' -Server dc1.adatum.com

# Calculate the&nbsp;OrgId hash, that&nbsp;is&nbsp;sent to&nbsp;Azure Active Directory by&nbsp;DirSync
ConvertTo-OrgIdHash -NTHash '92937945b518814341de3f726500d4ff'
# Output: v1;PPH1_MD4,f76bc776428002f87f4b,100,0ab46c4a6351db87cc13323bb01eea073c90a52e376fffca559e57fbb19a441a;

# Decrypt a&nbsp;password from&nbsp;Group Policy Preferences
ConvertFrom-GPPrefPassword 'v9NWtCCOKEUHkZBxakMd6HLzo4+DzuizXP83EaImqF8'
# Output: Pa$$w0rd

# Decrypt a&nbsp;password from&nbsp;an unattend.xml file
ConvertFrom-UnattendXmlPassword 'UABhACQAJAB3ADAAcgBkAEEAZABtAGkAbgBpAHMAdAByAGEAdABvAHIAUABhAHMAcwB3AG8AcgBkAA=='
# Output: Pa$$w0rd
</pre>

### Error reporting

If&nbsp;you find an error in&nbsp;the&nbsp;DSInternals Powershell Module, I&nbsp;would be glad if&nbsp;you sent me an [e-mail](https://www.dsinternals.com/en/about/ "Kontakt").

### Planned features

I&nbsp;am currently working on these new features, but&nbsp;it will take me some time until&nbsp;they are production-ready:

  * <del>Offline modification of&nbsp;the ntds.dit file, including the&nbsp;sIDHistory and&nbsp;primaryGroupID attributes.</del> **Done**
  * Attribute-level authoritative restore of&nbsp;AD objects
  * <del>Remote export of&nbsp;account password hashes using the&nbsp;MS-DRSR protocol.</del> **Done**
  * Fully functional Get-Help
  * <del>MSI installer.</del> **Deprecated in&nbsp;favor of&nbsp;[PowerShellGet](https://www.powershellgallery.com/packages/DSInternals/).**