---
ref: retrieving-cleartext-gmsa-passwords
title: 'Retrieving Cleartext GMSA Passwords from&nbsp;Active Directory'
date: 2015-12-28T14:09:53+00:00
layout: post
lang: en
permalink: /en/retrieving-cleartext-gmsa-passwords-from-active-directory/
---
<p style="text-align: justify;">
  Have you ever wondered how the&nbsp;automatically generated passwords of&nbsp;Group Managed Service Accounts (GMSA) look like? Well, you can fetch them from&nbsp;Active Directory in&nbsp;the&nbsp;same way as&nbsp;Windows Servers do&nbsp;and see yourself. Here is&nbsp;how:
</p>

### Creating a&nbsp;GMSA

To&nbsp;start experimenting, we need to&nbsp;have a&nbsp;GMSA first, so&nbsp;we create one:

<pre class="lang:ps decode:true"># Create a&nbsp;new KDS Root Key that&nbsp;will be used by&nbsp;DC to&nbsp;generate managed passwords
Add-KdsRootKey -EffectiveTime (Get-Date).AddHours(-10)

# Create a&nbsp;new GMSA
New-ADServiceAccount `
	-Name 'SQL_HQ_Primary' `
	-DNSHostName 'sql1.adatum.com'

</pre>

We can check the&nbsp;result in&nbsp;the&nbsp;_Active Directory Users and&nbsp;Computers_ console:

<p style="text-align: justify;">
  <img class="aligncenter wp-image-6821 size-full" src="https://www.dsinternals.com/wp-content/uploads/gmsa.png" alt="Group Managed Service Account" width="590" height="320" srcset="https://www.dsinternals.com/wp-content/uploads/gmsa.png 590w, https://www.dsinternals.com/wp-content/uploads/gmsa-300x163.png 300w" sizes="(max-width: 590px) 100vw, 590px" />Unfortunately, the&nbsp;built-in GUI will not help us much when&nbsp;working with GMSAs. Although&nbsp;there is&nbsp;a <a href="http://www.cjwdev.com/Software/MSAGUI/Info.html">nice 3rd party tool</a>, we will stick to&nbsp;PowerShell.
</p>

### Setting the&nbsp;Managed Password ACL

<p style="text-align: justify;">
  Now&nbsp;we need to provide a list of&nbsp;principals that&nbsp;are allowed to&nbsp;retrieve the&nbsp;plaintext password from&nbsp;DCs through LDAP. Normally, we would grant this privilege to one or&nbsp;more servers (members of&nbsp;the same cluster/web farm). But&nbsp;we will grant the&nbsp;privilege to&nbsp;ourselves instead:
</p>

<pre class="lang:default decode:true ">Set-ADServiceAccount `
	-Identity 'SQL_HQ_Primary' `
	-PrincipalsAllowedToRetrieveManagedPassword 'Administrator'

</pre>

<p style="text-align: justify;">
  Of&nbsp;course, you should not use the&nbsp;built-in Administrator account in&nbsp;a production environment.
</p>

### Retrieving the&nbsp;Managed Password

Now&nbsp;comes the&nbsp;fun part:

<pre class="lang:ps decode:true"># We have to&nbsp;explicitly ask for&nbsp;the&nbsp;value of&nbsp;the msDS-ManagedPassword attribute. Even&nbsp;a&nbsp;wildcard (*) would not work.
Get-ADServiceAccount `
	-Identity 'SQL_HQ_Primary' `
	-Properties 'msDS-ManagedPassword'

&lt;#
Output:

DistinguishedName&nbsp;: CN=SQL_HQ_Primary,CN=Managed Service Accounts,DC=Adatum,DC=com
Enabled&nbsp;: True
msDS-ManagedPassword&nbsp;: {1, 0, 0, 0...}
Name&nbsp;: SQL_HQ_Primary
ObjectClass&nbsp;: msDS-GroupManagedServiceAccount
ObjectGUID&nbsp;: 5f8e24c5-bd21-43a4-95ab-c67939434e81
SamAccountName&nbsp;: SQL_HQ_Primary$
SID&nbsp;: S-1-5-21-3180365339-800773672-3767752645-4102
UserPrincipalName&nbsp;:

#&gt;</pre>

<p style="text-align: justify;">
  Note that&nbsp;until now, we have only used regular, built-in cmdlets from&nbsp;the&nbsp;ActiveDirectory module, courtesy of&nbsp;Microsoft.
</p>

<h3 style="text-align: justify;">
  Decoding the&nbsp;Managed Password
</h3>

<p style="text-align: justify;">
  Let&#8217;s have a&nbsp;look at the&nbsp;msDS-ManagedPassword attribute, that&nbsp;has been returned by&nbsp;the command above. It is&nbsp;a constructed attribute, which&nbsp;means that&nbsp;its value is&nbsp;calculated by&nbsp;DC from&nbsp;the&nbsp;KDS root key and&nbsp;the&nbsp;msDS-ManagedPasswordId attribute every time someone asks for&nbsp;it. Although&nbsp;documented, the&nbsp;cryptographic algorithm used is&nbsp;quite complicated. Furthermore, the&nbsp;value of&nbsp;the msDS-ManagedPasswordId gets re-generated every (msDS-ManagedPasswordInterval)-days (30 by&nbsp;default).
</p>

<p style="text-align: justify;">
  We see that&nbsp;the&nbsp;msDS-ManagedPassword attribute of&nbsp;our GMSA contains a&nbsp;sequence of&nbsp;bytes. It is&nbsp;a binary representation of&nbsp;the <a href="https://msdn.microsoft.com/en-us/library/hh881234.aspx">MSDS-MANAGEDPASSWORD_BLOB</a> data structure, which&nbsp;contains some metadata in&nbsp;addition to&nbsp;the actual password. As&nbsp;there had been no publicly available tool to&nbsp;decode this structure, I&nbsp;have created one myself:
</p>

<pre class="lang:ps decode:true "># Save the&nbsp;blob to&nbsp;a variable
$gmsa = Get-ADServiceAccount `
	-Identity 'SQL_HQ_Primary' `
	-Properties 'msDS-ManagedPassword'
$mp = $gmsa.'msDS-ManagedPassword'

# Decode the&nbsp;data structure using the&nbsp;DSInternals module
ConvertFrom-ADManagedPasswordBlob $mp

&lt;#
Output:

Version&nbsp;: 1
CurrentPassword&nbsp;: 湤ୟɰ橣낔饔ᦺ几᧾ʞꈠ⿕ՔὬ랭뷾햾咶郸�렇ͧ퀟᝘럓몚ꬶ佩䎖∘Ǐ㦗ן뱷鼹⽩Ⲃ⫝咽㠅Ｅ䠹鸞왶婰鞪
PreviousPassword&nbsp;:
QueryPasswordInterval&nbsp;: 29.17:15:36.3736817
UnchangedPasswordInterval&nbsp;: 29.17:10:36.3736817

#&gt;</pre>

<p style="text-align: justify;">
  TADA!!! The&nbsp;CurrentPassword property contains the&nbsp;actual cleartext password of&nbsp;the GMSA in&nbsp;question. Why&nbsp;does it look like gibberish? Because&nbsp;it is&nbsp;just 256 bytes of&nbsp;pseudorandom data, interpreted as&nbsp;128 UTF-16 characters. Good luck writing that on your keyboard. But&nbsp;if&nbsp;we <a href="https://www.dsinternals.com/en/dsinternals-powershell-module-released/">calculate its NT hash</a>, it will match the <a href="https://www.dsinternals.com/en/dumping-ntds-dit-files-using-powershell/">hash stored in&nbsp;AD</a>.
</p>

<h3 style="text-align: justify;">
  Conclusion
</h3>

<p style="text-align: justify;">
  We have seen that&nbsp;retrieving the&nbsp;value of GMSA passwords is&nbsp;quite easy. But&nbsp;don&#8217;t be afraid, there is&nbsp;no security hole in&nbsp;Active Directory. The cleartext password is&nbsp;always passed through an encrypted channel, it is&nbsp;automatically changed on a&nbsp;regular basis and&nbsp;even&nbsp;members of&nbsp;the Domain  Admins group are not allowed to&nbsp;retrieve it by&nbsp;default. So&nbsp;do&nbsp;not hesitate and&nbsp;start using the&nbsp;(Group) Managed Service Accounts. They are much safer than&nbsp;using regular accounts for&nbsp;running services.
</p>

<p style="text-align: justify;">
  If&nbsp;you want to&nbsp;play more with this stuff, just <a href="https://www.dsinternals.com/en/downloads/">grab the&nbsp;DSInternals module</a>. And&nbsp;for developers, the&nbsp;C# code I&nbsp;use to&nbsp;decode the&nbsp;structure can be found on <a href="https://github.com/MichaelGrafnetter/DSInternals/blob/master/Src/DSInternals.Common/Data/Principals/ManagedPassword.cs">GitHub</a>.
</p>