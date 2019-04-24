---
id: 7971
title: Zoznam príkazov PowerShell modulu DSInternals
date: 2016-08-07T11:51:36+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/3931-revision-v1/
permalink: /3931-revision-v1/
---
<p style="text-align: justify;">
  Tu je&nbsp;zoznam príkazov, ktoré nájdete v&nbsp;najnovšej verzii PowerShell modulu DSInternals, 2.16. K&nbsp;väčšine z&nbsp;nich som žiaľ ešte nestihol spísať dokumentáciu.
</p>

### Offline práca s&nbsp;Active Directory databázou

<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/sk/offline-zmena-sid-history/">Add-ADDBSidHistory</a></strong> &#8211; Pridá SID History k&nbsp;vybranému účtu v&nbsp;súbore ntds.dit.
</li>
<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/sk/offline-zmena-clenstva-v-skupinach/">Set-ADDBPrimaryGroup</a></strong> &#8211; Zmení primárne členstvo v&nbsp;skupine vybranému účtu v&nbsp;súbore ntds.dit.
</li>
  * **Get-ADDBDomainController** &#8211; Zobrazí informácie o&nbsp;súbore ntds.dit.
  * **Set-ADDBDomainController** &#8211; Zmení hodnoty USN a&nbsp;Epoch v&nbsp;súbore ntds.dit.
  * **Get-ADDBSchemaAttribute** &#8211; Zobrazí zoznam LDAP atribútov zo súboru ntds.dit.
  * [**Get-ADDBAccount**](https://www.dsinternals.com/sk/vykradanie-hesiel-zo-zalohy-active-directory/) &#8211; Dešifruje heslá, hashe a&nbsp;kerberos kľúče uložené v&nbsp;súbore ntds.dit.
  * **Get-ADDBBackupKey**
  * [**Get-BootKey**](https://www.dsinternals.com/sk/vykradanie-hesiel-zo-zalohy-active-directory/) &#8211; Extrahuje Boot Key (AKA Syskey) z&nbsp;registrového súboru.
  * **Set-ADDBBootKey**
  * **Remove-ADDBObject** &#8211; Fyzicky zmaže objekt z&nbsp;databázy, pričom poškodí jej integritu, lebo&nbsp;nezanechá tombstone a&nbsp;nezneplatní linky.

### Online práca s&nbsp;Active Directory databázou

<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/sk/vykradanie-hesiel-z-active-directory-na-dialku/">Get-ADReplAccount</a></strong> &#8211; Cez&nbsp;protokol MS-DRSR získa heslá, hashe a&nbsp;kerberos kľúče používateľov uložené v&nbsp;Active Directory.
</li>
  * **Set-SamAccountPasswordHash** &#8211; Nastaví hashe hesla vybranému Active Directory či&nbsp;lokálnemu účtu cez&nbsp;protokol MS-SAMR.
  * **Get-ADReplBackupKey**

### Počítanie hashov

<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/sk/zverejneny-powershell-modul-dsinternals/">ConvertTo-NTHash</a></strong> &#8211; Vypočíta NT hash zo zadaného hesla.
</li>
<li style="text-align: justify;">
  <strong>ConvertTo-NTHashDictionary</strong>
</li>
<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/sk/zverejneny-powershell-modul-dsinternals/">ConvertTo-LMHash</a></strong> &#8211; Vypočíta LM hash zo zadaného hesla.
</li>
<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/sk/ako-funguje-synchronizacia-hesiel-z-on-premise-ad-do-azure-ad/">ConvertTo-OrgIdHash</a></strong> &#8211; Vypočíta Azure Active Directory hash (AKA OrgId hash) zo zadaného hesla.
</li>

### Dešifrovanie hesiel

<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/sk/zverejneny-powershell-modul-dsinternals/">ConvertFrom-GPPrefPassword</a></strong> &#8211; Dešifruje heslo uložené v Group Policy Preferences.
</li>
<li style="text-align: justify;">
  <strong>ConvertTo-GPPrefPassword</strong> &#8211; Zašifruje heslo pre&nbsp;uloženie do Group Policy Preferences.
</li>
<li style="text-align: justify;">
  <strong><a href="https://www.dsinternals.com/sk/zverejneny-powershell-modul-dsinternals/">ConvertFrom-UnattendXmlPassword</a></strong> &#8211; Dekóduje heslo uložené v&nbsp;súbore unattend.xml.
</li>
<li style="text-align: justify;">
  <strong>ConvertTo-UnicodePassword</strong> &#8211; Zakóduje heslo pre&nbsp;uloženie do&nbsp;súboru unattend.xml alebo LDIF.
</li>

### Pomocné príkazy

<li style="text-align: justify;">
  <strong>Test-PasswordQuality</strong>
</li>
<li style="text-align: justify;">
  <strong>Save-DPAPIBlob</strong>
</li>
<li style="text-align: justify;">
  <strong>ConvertTo-Hex</strong> &#8211; Prevedie binárne dáta na&nbsp;hexadecimálny reťazec.
</li>