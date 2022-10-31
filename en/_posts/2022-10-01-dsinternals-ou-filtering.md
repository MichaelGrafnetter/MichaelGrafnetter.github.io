---
ref: dsinternals-ou-filtering
title: OU Filtering With&nbsp;DSInternals PowerShell Cmdlets
date: '2022-10-01T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/HIBP.png
permalink: /en/dsinternals-ou-filtering/
---

One of&nbsp;the&nbsp;most frequent questions I&nbsp;am asked about the&nbsp;[DSInternals PowerShell Module](https://github.com/MichaelGrafnetter/DSInternals) cmdlets that&nbsp;fetch password hashes from&nbsp;Active Directory ([Get-ADReplAccount](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-ADReplAccount.md#get-adreplaccount) and&nbsp;[Get-ADDBAccount](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-ADDBAccount.md#get-addbaccount)) is&nbsp;whether&nbsp;they could only return accounts from&nbsp;a&nbsp;specified organizational unit (OU). While&nbsp;OU-based filtering is&nbsp;not yet&nbsp;implemented in&nbsp;DSInternals directly, two PowerShell built-in features could be&nbsp;used to&nbsp;achieve this&nbsp;goal.

## A. Where-Object

The [Where-Object cmdlet](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/where-object?view=powershell-5.1) can easily be&nbsp;used to&nbsp;filter out unwanted objects based on any property, including OU:

```powershell
<#
Replicates all AD accounts (DCSync), filters them by the Admins OU,
and tests their passwords against Have I Been Pwned (HIBP) list.
#>
Get-ADReplAccount -All -Server 'dc01.contoso.com' |
    Where-Object DistinguishedName -like '*,OU=Admins,DC=contoso,DC=com' |
    Test-PasswordQuality -WeakPasswordHashesSortedFile pwned-passwords-ntlm-ordered-by-hash-v7.txt
```

<!--more-->

Sample output:

```
Active Directory Password Quality Report
----------------------------------------

Passwords of these accounts are stored using reversible encryption:
  CONTOSO\Administrator

LM hashes of passwords of these accounts are present:

These accounts have no password set:

Passwords of these accounts have been found in the dictionary:
  CONTOSO\Administrator
  CONTOSO\jdoe_admin

These groups of accounts have the same passwords:
  Group 1:
    CONTOSO\dholden_admin
    CONTOSO\jsmith_admin
  Group 2:
    CONTOSO\pgoldman_admin
    CONTOSO\sgates_admin

These computer accounts have default passwords:

Kerberos AES keys are missing from these accounts:
  CONTOSO\Administrator

Kerberos pre-authentication is not required for these accounts:

Only DES encryption is allowed to be used with these accounts:

These accounts are susceptible to the Kerberoasting attack:
  CONTOSO\jsmith_admin

These administrative accounts are allowed to be delegated to a service:
  CONTOSO\Administrator
  CONTOSO\dholden_admin
  CONTOSO\jsmith_admin

Passwords of these accounts will never expire:
  CONTOSO\Administrator

These accounts are not required to have a password:

These accounts that require smart card authentication have a password:
  CONTOSO\jsmith_admin
```

## B. Pipeline Input

The second option is&nbsp;to&nbsp;first fetch the&nbsp;desired accounts using the&nbsp;[Get-ADUser cmdlet](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-aduser) and&nbsp;then pipe them into DSInternals:

```powershell
<#
Fetches the list of all acounts from the Admins OU,
replicates their passwords, and checks them against the HIBP list.
#>
Get-ADUser -SearchBase 'OU=Admins,DC=contoso,DC=com' -Filter * |
    Select-Object -Property ObjectGuid |
    Get-ADReplAccount -Server 'dc01.contoso.com' |
    Test-PasswordQuality -WeakPasswordHashesSortedFile pwned-passwords-ntlm-ordered-by-hash-v7.txt
```

I will probably add these two examples to&nbsp;the&nbsp;[Get-Help documentation](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Readme.md).
