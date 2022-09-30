---
ref: retrieving-cleartext-gmsa-passwords
title: 'Retrieving Cleartext GMSA Passwords from&nbsp;Active Directory'
date: 2015-12-28T14:09:53+00:00
layout: post
lang: en
permalink: /en/retrieving-cleartext-gmsa-passwords-from-active-directory/
tags:
    - 'Active Directory'
    - LDAP
    - PowerShell
    - Security
---

Have you ever wondered how the&nbsp;automatically generated passwords of&nbsp;Group Managed Service Accounts (GMSA) look like? Well, you can fetch them from&nbsp;Active Directory in&nbsp;the&nbsp;same way as&nbsp;Windows Servers do&nbsp;and see yourself. Here is&nbsp;how:

## Creating a GMSA

To start experimenting, we need to have a GMSA first, so we create one:

```powershell
# Create a new KDS Root Key that will be used by DC to generate managed passwords
Add-KdsRootKey -EffectiveTime (Get-Date).AddHours(-10)

# Create a new GMSA
New-ADServiceAccount `
	-Name 'SQL_HQ_Primary' `
	-DNSHostName 'sql1.adatum.com'

```

<!--more-->

We can check the result in the *Active Directory Users and Computers* console:

![Group Managed Service Account](../../assets/images/gmsa.png)Unfortunately, the built-in GUI will not help us much when working with GMSAs. Although there is a [nice 3rd party tool](https://www.cjwdev.com/Software/MSAGUI/Info.html), we will stick to PowerShell.

## Setting the Managed Password ACL

Now&nbsp;we need to provide a list of&nbsp;principals that&nbsp;are allowed to&nbsp;retrieve the&nbsp;plaintext password from&nbsp;DCs through LDAP. Normally, we would grant this privilege to one or&nbsp;more servers (members of&nbsp;the same cluster/web farm). But&nbsp;we will grant the&nbsp;privilege to&nbsp;ourselves instead:

```powershell
Set-ADServiceAccount `
	-Identity 'SQL_HQ_Primary' `
	-PrincipalsAllowedToRetrieveManagedPassword 'Administrator'
```

Of course, you should not use the built-in Administrator account in a production environment.

## Retrieving the Managed Password

Now comes the fun part:

```powershell
# We have to explicitly ask for the value of the msDS-ManagedPassword attribute. Even a wildcard (*) would not work.
Get-ADServiceAccount `
	-Identity 'SQL_HQ_Primary' `
	-Properties 'msDS-ManagedPassword'

<#
Output:

DistinguishedName : CN=SQL_HQ_Primary,CN=Managed Service Accounts,DC=Adatum,DC=com
Enabled : True
msDS-ManagedPassword : {1, 0, 0, 0...}
Name : SQL_HQ_Primary
ObjectClass : msDS-GroupManagedServiceAccount
ObjectGUID : 5f8e24c5-bd21-43a4-95ab-c67939434e81
SamAccountName : SQL_HQ_Primary$
SID : S-1-5-21-3180365339-800773672-3767752645-4102
UserPrincipalName :

#>
```

Note that&nbsp;until now, we have only used regular, built-in cmdlets from&nbsp;the&nbsp;ActiveDirectory module, courtesy of&nbsp;Microsoft.

## Decoding the Managed Password

Let's have a&nbsp;look at the&nbsp;msDS-ManagedPassword attribute, that&nbsp;has been returned by&nbsp;the command above. It is&nbsp;a constructed attribute, which&nbsp;means that&nbsp;its value is&nbsp;calculated by&nbsp;DC from&nbsp;the&nbsp;KDS root key and&nbsp;the&nbsp;msDS-ManagedPasswordId attribute every time someone asks for&nbsp;it. Although&nbsp;documented, the&nbsp;cryptographic algorithm used is&nbsp;quite complicated. Furthermore, the&nbsp;value of&nbsp;the msDS-ManagedPasswordId gets re-generated every (msDS-ManagedPasswordInterval)-days (30 by&nbsp;default).

We see that the msDS-ManagedPassword attribute of our GMSA contains a sequence of bytes. It is a binary representation of the [MSDS-MANAGEDPASSWORD_BLOB](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/a9019740-3d73-46ef-a9ae-3ea8eb86ac2e) data structure, which contains some metadata in addition to the actual password. As there had been no publicly available tool to decode this structure, I have created one myself:

```powershell
# Save the blob to a variable
$gmsa = Get-ADServiceAccount `
	-Identity 'SQL_HQ_Primary' `
	-Properties 'msDS-ManagedPassword'
$mp = $gmsa.'msDS-ManagedPassword'

# Decode the data structure using the DSInternals module
ConvertFrom-ADManagedPasswordBlob $mp

<#
Output:

Version : 1
CurrentPassword : 湤ୟɰ橣낔饔ᦺ几᧾ʞꈠ⿕ՔὬ랭뷾햾咶郸�렇ͧ퀟᝘럓몚ꬶ佩䎖∘Ǐ㦗ן뱷鼹⽩Ⲃ⫝咽㠅Ｅ䠹鸞왶婰鞪
PreviousPassword :
QueryPasswordInterval : 29.17:15:36.3736817
UnchangedPasswordInterval : 29.17:10:36.3736817

#>
```

TADA!!! The CurrentPassword property contains the actual cleartext password of the GMSA in question. Why does it look like gibberish? Because it is just 256 bytes of pseudorandom data, interpreted as 128 UTF-16 characters. Good luck writing that on your keyboard. But if we [calculate its NT hash](/en/dsinternals-powershell-module-released/), it will match the [hash stored in AD](/en/dumping-ntds-dit-files-using-powershell/).

## Conclusion

We have seen that retrieving the value of GMSA passwords is quite easy. But don’t be afraid, there is no security hole in Active Directory. The cleartext password is always passed through an encrypted channel, it is automatically changed on a regular basis and even members of the Domain Admins group are not allowed to retrieve it by default. So do not hesitate and start using the (Group) Managed Service Accounts. They are much safer than using regular accounts for running services.

If you want to play more with this stuff, just [grab the DSInternals module](/en/downloads/). And for developers, the C# code I use to decode the structure can be found on [GitHub](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Src/DSInternals.Common/Data/Principals/ManagedPassword.cs).