---
id: 8071
title: 'List of&nbsp;Cmdlets in&nbsp;the&nbsp;DSInternals Module'
date: 2016-08-19T15:47:14+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/4901-revision-v1/
permalink: /4901-revision-v1/
---
<p style="text-align: justify;">
  Here is&nbsp;the list of&nbsp;cmdlets currently contained in&nbsp;the&nbsp;<a href="https://www.dsinternals.com/en/downloads/">DSInternals PowerShell module</a>:
</p>

<h3 style="text-align: justify;">
  Online operations with the&nbsp;Active Directory database
</h3>

<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/en/retrieving-active-directory-passwords-remotely/">Get-ADReplAccount</a></strong> &#8211; Reads one or&nbsp;more accounts through the&nbsp;<a href="https://msdn.microsoft.com/en-us/library/cc228086.aspx">DRSR</a> protocol, including secret attributes.
</li>
<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/en/dsinternals-powershell-module-released/">Set-SamAccountPasswordHash</a></strong> &#8211; Sets NT and&nbsp;LM hashes of&nbsp;an account through the&nbsp;<a href="https://msdn.microsoft.com/en-us/library/cc245476.aspx">SAMR</a> protocol.
</li>
<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/en/retrieving-dpapi-backup-keys-from-active-directory/">Get-ADReplBackupKey</a></strong> &#8211; Reads the&nbsp;DPAPI backup keys through the&nbsp;DRSR protocol.
</li>

<h3 style="text-align: justify;">
  Offline operations with the&nbsp;Active Directory database
</h3>

<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/en/dumping-ntds-dit-files-using-powershell/">Get-ADDBAccount</a></strong> &#8211; Reads one or&nbsp;more accounts from&nbsp;a&nbsp;ntds.dit file, including the <a href="https://msdn.microsoft.com/en-us/library/cc223126.aspx#gt_d01d16a8-7864-4c7f-acaa-8c695508d6e0">secret attributes</a>.
</li>
<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/en/dumping-ntds-dit-files-using-powershell/">Get-BootKey</a></strong> &#8211; Reads the&nbsp;BootKey (aka SysKey) from&nbsp;an online or&nbsp;offline SYSTEM <a href="https://msdn.microsoft.com/en-us/library/windows/desktop/ms724877(v=vs.85).aspx"><strong>registry hive</strong></a>.
</li>
<li style="text-align: justify;">
  <strong>Set-ADDBBootKey</strong> &#8211; Re-encrypts a ntds.dit with a&nbsp;new BootKey. Highly experimental!
</li>
<li style="text-align: justify;">
  <a href="https://www.dsinternals.com/en/retrieving-dpapi-backup-keys-from-active-directory/"><strong>Get-ADDBBackupKey</strong></a> &#8211; Reads the&nbsp;DPAPI backup keys from&nbsp;a&nbsp;ntds.dit file.
</li>
<li style="text-align: justify;">
  <strong>Add-ADDBSidHistory</strong> &#8211; Adds one or&nbsp;more values to&nbsp;the <a href="https://msdn.microsoft.com/en-us/library/ms679833(v=vs.85).aspx">sIDHistory</a> attribute of&nbsp;an object in&nbsp;a ntds.dit file.
</li>
<li style="text-align: justify;">
  <strong>Set-ADDBPrimaryGroup</strong> &#8211; Modifies the&nbsp;<a href="https://msdn.microsoft.com/en-us/library/ms679375(v=vs.85).aspx">primaryGroupId</a> attribute of&nbsp;an object in&nbsp;a ntds.dit file.
</li>
<li style="text-align: justify;">
  <strong>Get-ADDBDomainController</strong> &#8211; Reads information about the&nbsp;originating DC from&nbsp;a&nbsp;ntds.dit file, including domain name, domain SID, DC name and&nbsp;DC site.
</li>
<li style="text-align: justify;">
  <strong>Set-ADDBDomainController</strong> &#8211; Writes information about the&nbsp;DC to&nbsp;a ntds.dit file, including the&nbsp;highest commited USN and&nbsp;database epoch.
</li>
<li style="text-align: justify;">
  <strong>Get-ADDBSchemaAttribute</strong> &#8211; Reads AD schema from&nbsp;a&nbsp;ntds.dit file, including datatable column names.
</li>
<li style="text-align: justify;">
  <strong>Remove-ADDBObject</strong> &#8211; Physically removes specified object from&nbsp;a&nbsp;ntds.dit file, making it semantically inconsistent. Highly experimental!
</li>

<h3 style="text-align: justify;">
  Views
</h3>

The&nbsp;output of&nbsp;the **Get-ADDBAccount** and&nbsp;**Get-ADReplAccount** cmdlets can be formatted using these additional [Views](https://technet.microsoft.com/en-us/library/hh849966.aspx):

  * **HashcatNT** &#8211; NT hashes in&nbsp;[Hashcat](http://hashcat.net/oclhashcat/)&#8216;s format.
  * **HashcatLM** &#8211; LM hashes in&nbsp;Hashcat&#8217;s format.
  * **JohnNT** &#8211; NT hashes in&nbsp;the&nbsp;format supported by&nbsp;[John the&nbsp;Ripper](http://www.openwall.com/john/).
  * **JohnLM** &#8211; LM hashes in&nbsp;the&nbsp;format supported by&nbsp;John the&nbsp;Ripper.
  * **Ophcrack** &#8211; NT and&nbsp;LM hashes in&nbsp;[Ophcrack](http://ophcrack.sourceforge.net/)&#8216;s format.

### Password hash calculation

<li style="text-align: justify;">
  <a href="https://www.dsinternals.com/en/dsinternals-powershell-module-released/"><strong>ConvertTo-NTHash</strong></a> &#8211; Calculates NT hash of&nbsp;a given password.
</li>
<li style="text-align: justify;">
  <a href="https://www.dsinternals.com/en/auditing-active-directory-password-quality/"><strong>ConvertTo-NTHashDictionary</strong></a> &#8211; Creates a&nbsp;hash->password dictionary for&nbsp;use with the&nbsp;Test-PasswordQuality cmdlet.
</li>
<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/en/dsinternals-powershell-module-released/">ConvertTo-LMHash</a></strong> &#8211; Calculates LM hash of&nbsp;a given password.
</li>
<li style="text-align: justify;">
  <a href="https://www.dsinternals.com/en/how-azure-active-directory-connect-syncs-passwords/"><strong>ConvertTo-OrgIdHash</strong></a> &#8211; Calculates OrgId hash of&nbsp;a given password. Used by&nbsp;<a href="https://msdn.microsoft.com/en-us/library/azure/dn441214.aspx">Azure Active Directory Sync</a>.
</li>

### Password decryption

<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/en/dsinternals-powershell-module-released/">ConvertFrom-GPPrefPassword</a></strong> &#8211; Decodes a&nbsp;password from&nbsp;the&nbsp;format used by&nbsp;Group Policy Preferences.
</li>
<li style="text-align: justify;">
  <strong>ConvertTo-GPPrefPassword</strong> &#8211; Converts a&nbsp;password to&nbsp;the format used by&nbsp;Group Policy Preferences.
</li>
<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/en/dsinternals-powershell-module-released/">ConvertFrom-UnattendXmlPassword</a></strong> &#8211; Decodes a&nbsp;password from&nbsp;the&nbsp;format used in&nbsp;<a href="https://technet.microsoft.com/en-us/library/ff716178.aspx">unattend.xml</a> files.
</li>
<li style="text-align: justify;">
  <strong>ConvertTo-UnicodePassword</strong> &#8211; Converts a&nbsp;password to&nbsp;the format used in&nbsp;<a href="https://technet.microsoft.com/en-us/library/cc732280(v=ws.10).aspx">unattend.xml </a>or&nbsp;<a href="https://technet.microsoft.com/en-us/library/cc731033.aspx">*.ldif</a> files.
</li>
<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/en/retrieving-cleartext-gmsa-passwords-from-active-directory/">ConvertFrom-ADManagedPasswordBlob</a></strong> &#8211; Decodes the&nbsp;cleartext password from&nbsp;a&nbsp;<a href="http://blogs.technet.com/b/askpfeplat/archive/2012/12/17/windows-server-2012-group-managed-service-accounts.aspx">Group Managed Service Account</a> (GMSA) object.
</li>

### Miscellaneous

<li style="text-align: justify;">
  <a href="https://www.dsinternals.com/en/auditing-active-directory-password-quality/"><strong>Test-PasswordQuality</strong></a> &#8211; Performs AD audit, including checks for&nbsp;weak, duplicate, default and&nbsp;empty passwords.
</li>
<li style="text-align: justify;">
  <a href="https://www.dsinternals.com/en/retrieving-dpapi-backup-keys-from-active-directory/"><strong>Save-DPAPIBlob</strong></a> &#8211; Saves the&nbsp;output of&nbsp;the Get-ADReplBackupKey and&nbsp;Get-ADDBBackupKey cmdlets to&nbsp;a file.
</li>
<li style="text-align: justify;">
  <strong>ConvertTo-Hex</strong> &#8211; Helper cmdlet that&nbsp;converts binary input to&nbsp;the hexadecimal string format.
</li>

<p style="text-align: justify;">
  I&nbsp;promise to&nbsp;publish more information about my cmdlets in&nbsp;the&nbsp;near future.
</p>