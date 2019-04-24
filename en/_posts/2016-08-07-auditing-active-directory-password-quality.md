---
ref: auditing-active-directory-password-quality
title: Auditing Active Directory Password Quality
date: 2016-08-07T13:15:43+00:00
layout: post
lang: en
permalink: /en/auditing-active-directory-password-quality/
---
### Overview

<p style="text-align: justify;">
  The&nbsp;latest version of&nbsp;the <a href="https://github.com/MichaelGrafnetter/DSInternals">DSInternals PowerShell Module</a> contains a&nbsp;new cmdlet called <strong>Test-PasswordQuality</strong>, which&nbsp;is&nbsp;a powerful yet&nbsp;easy to&nbsp;use tool for&nbsp;Active Directory password auditing. It can detect <strong>weak, duplicate, default, non-expiring or&nbsp;empty passwords</strong> and&nbsp;find accounts that&nbsp;are violating <strong>security best practices</strong>. All domain administrators can now&nbsp;audit Active Directory passwords on a&nbsp;regular basis, without any special knowledge.
</p>

### Usage

<p style="text-align: justify;">
  The&nbsp;Test-PasswordQuality cmdlet accepts output of&nbsp;the <a href="https://www.dsinternals.com/en/dumping-ntds-dit-files-using-powershell/">Get-ADDBAccount</a> and&nbsp;<a href="https://www.dsinternals.com/en/retrieving-active-directory-passwords-remotely/">Get-ADReplAccount</a> cmdlets, so&nbsp;both <strong>offline</strong> (ntds.dit) and&nbsp;<strong>online</strong> (DCSync) analysis can be done:
</p>

<pre class="lang:ps decode:true  ">Get-ADReplAccount -All -Server LON-DC1 -NamingContext "dc=adatum,dc=com" |
   Test-PasswordQuality -WeakPasswordHashesFile .\pwned-passwords-ntlm-ordered-by-count.txt -IncludeDisabledAccounts

&lt;#
Sample output:

Active Directory Password Quality Report
----------------------------------------

Passwords of&nbsp;these accounts are stored using reversible encryption:
  April
  Brad
  Don

LM hashes of&nbsp;passwords of&nbsp;these accounts are present:

These accounts have no password set:
  Guest
  nolan
  test

Passwords of&nbsp;these accounts have been found in&nbsp;the&nbsp;dictionary:
  adam
  peter

Historical passwords of&nbsp;these accounts have been found in&nbsp;the&nbsp;dictionary:
  april
  brad

These groups of&nbsp;accounts have the&nbsp;same passwords:
  Group 1:
    Aidan
    John
  Group 2:
    Joe
    JoeAdmin
    JoeVPN

These computer accounts have default passwords:
  LON-CL2$

Kerberos AES keys are missing from&nbsp;these accounts:
  Julian

Kerberos pre-authentication is&nbsp;not required for&nbsp;these accounts:
  Holly
  Chad

Only DES encryption is&nbsp;allowed to&nbsp;be used with these accounts:
  Holly
  Jorgen

These administrative accounts are allowed to&nbsp;be delegated to&nbsp;a service:
  Administrator
  April
  krbtgt

Passwords of&nbsp;these accounts will never expire:
  Administrator
  Guest

These accounts are not required to&nbsp;have a&nbsp;password:
  Guest
  Magnus
  Maria

#&gt;</pre>

<p style="text-align: justify;">
  Although&nbsp;the&nbsp;cmdlet output is&nbsp;formatted in&nbsp;a human readable fashion, it is&nbsp;still an object, whose properties can be accessed separately (e.g. <span class="lang:ps decode:true crayon-inline ">$result.WeakPassword</span>) to&nbsp;produce a&nbsp;desired output.
</p>

### Credits

<p style="text-align: justify;">
  I&nbsp;would like to&nbsp;thank <a href="https://twitter.com/jakobheidelberg">Jakob Heidelberg</a> for&nbsp;<a href="http://flemmingriis.com/get-badpasswords/">his idea</a> to&nbsp;use the&nbsp;DSInternals module for&nbsp;password auditing. A&nbsp;big thank you also goes to&nbsp;<a href="http://www.sevecek.com/EnglishPages/default.aspx">Ondrej Sevecek</a> for&nbsp;sharing his comprehensive auditing tool called SAPHA, from&nbsp;which&nbsp;I&nbsp;borrowed ideas for&nbsp;a&nbsp;few tests.
</p>