---
ref: auditing-active-directory-password-quality
title: Auditing Active Directory Password Quality
date: 2016-08-07T13:15:43+00:00
layout: post
lang: en
permalink: /en/auditing-active-directory-password-quality/
tags:
    - 'Active Directory'
    - PowerShell
    - Security
---

## Overview

The latest version of the [DSInternals PowerShell Module](https://github.com/MichaelGrafnetter/DSInternals) contains a new cmdlet called `Test-PasswordQuality`, which is a powerful yet easy to use tool for Active Directory password auditing. It can detect **weak, duplicate, default, non-expiring or empty passwords** and find accounts that are violating **security best practices**. All domain administrators can now audit Active Directory passwords on a regular basis, without any special knowledge.

## Usage

The `Test-PasswordQuality` cmdlet accepts output of the [Get-ADDBAccount](/en/dumping-ntds-dit-files-using-powershell/) and [Get-ADReplAccount](/en/retrieving-active-directory-passwords-remotely/) cmdlets, so both **offline** (ntds.dit) and **online** (DCSync) analysis can be done:

```powershell
Get-ADReplAccount -All -Server LON-DC1 -NamingContext "dc=adatum,dc=com" |
   Test-PasswordQuality -WeakPasswordHashesFile .\pwned-passwords-ntlm-ordered-by-count.txt -IncludeDisabledAccounts
```

<!--more-->

Sample output:

```
Active Directory Password Quality Report
----------------------------------------

Passwords of these accounts are stored using reversible encryption:
  April
  Brad
  Don

LM hashes of passwords of these accounts are present:

These accounts have no password set:
  Guest
  nolan
  test

Passwords of these accounts have been found in the dictionary:
  adam
  peter

Historical passwords of these accounts have been found in the dictionary:
  april
  brad

These groups of accounts have the same passwords:
  Group 1:
    Aidan
    John
  Group 2:
    Joe
    JoeAdmin
    JoeVPN

These computer accounts have default passwords:
  LON-CL2$

Kerberos AES keys are missing from these accounts:
  Julian

Kerberos pre-authentication is not required for these accounts:
  Holly
  Chad

Only DES encryption is allowed to be used with these accounts:
  Holly
  Jorgen

These administrative accounts are allowed to be delegated to a service:
  Administrator
  April
  krbtgt

Passwords of these accounts will never expire:
  Administrator
  Guest

These accounts are not required to have a password:
  Guest
  Magnus
  Maria

```

Although the cmdlet output is formatted in a human readable fashion, it is still an object, whose properties can be accessed separately (e.g. `$result.WeakPassword`) to produce a desired output.

## Credits

I&nbsp;would like to&nbsp;thank [Jakob Heidelberg](https://twitter.com/jakobheidelberg) for [his idea](https://flemmingriis.com/get-badpasswords/) to&nbsp;use the&nbsp;DSInternals module for&nbsp;password auditing. A&nbsp;big thank you also goes to&nbsp;[Ondrej Sevecek](https://www.sevecek.com/EnglishPages/default.aspx) for&nbsp;sharing his comprehensive auditing tool called SAPHA, from&nbsp;which I&nbsp;borrowed ideas for&nbsp;a&nbsp;few tests.