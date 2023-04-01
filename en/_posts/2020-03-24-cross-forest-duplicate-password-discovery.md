---
ref: 9688
title: 'Cross-Forest Duplicate Password Discovery'
date: '2020-03-24T22:51:17+00:00'
layout: post
lang: en
image: /assets/images/HIBP.png
permalink: /en/cross-forest-duplicate-password-discovery/
---

The [Test-PasswordQuality cmdlet](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Test-PasswordQuality.md#test-passwordquality) now&nbsp;supports cross-domain and&nbsp;cross-forest duplicate password discovery and&nbsp;offline password hash comparison against HaveIBeenPwned:

```powershell
$contosoAccounts = Get-ADReplAccount -All -Server $env:LOGONSEVER
$adatumCred = Get-Credential -Message 'Admin credentials for the adatum.com domain:'
$adatumAccounts = Get-ADReplAccount -All -Server 'nyc-dc1.adatum.com' -Credential $adatumCred
$contosoAccounts + $adatumAccounts | Test-PasswordQuality -WeakPasswordHashesSortedFile 'pwned-passwords-ntlm-ordered-by-hash-v5.txt'
```

<!--more-->

The output of&nbsp;the&nbsp;previous script might look like this&nbsp;(with some&nbsp;parts omitted):

```
Active Directory Password Quality Report
----------------------------------------
...
Passwords of these accounts have been found in the dictionary:
ADATUM\larry_admin
CONTOSO\harry
...
These groups of accounts have the same passwords:
Group 1:
ADATUM\smith
ADATUM\srv_sql01
Group 2:
ADATUM\Administrator
ADATUM\joe_admin
CONTOSO\Administrator
CONTOSO\joe_admin
...
```

The example above uses the&nbsp;MS-DRSR protocol. Similar results can&nbsp;be&nbsp;achieved by&nbsp;using the&nbsp;`Get-ADDBAccount` cmdlet to&nbsp;read account information directly from&nbsp;a&nbsp;ntds.dit file.
