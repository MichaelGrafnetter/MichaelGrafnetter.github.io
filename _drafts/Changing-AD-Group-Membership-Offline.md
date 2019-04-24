---
id: 5431
title: Changing AD Group Membership Offline
date: 2015-10-21T13:54:22+00:00
author: Michael Grafnetter
layout: post
guid: https://www.dsinternals.com/?p=5431
permalink: /en/?p=5431
image: /wp-content/uploads/primary_group.png
categories:
  - Uncategorized
---
<p style="text-align: justify;">
  Spôsobov, ako sa&nbsp;dá <strong>hacknúť doménový kontrolér</strong>, ak útočník získa fyzický prístup k&nbsp;jeho systémovému disku, existuje veľa. Za&nbsp;zmienku stojí napríklad podvrhnutie <a href="https://www.dsinternals.com/sk/offline-zmena-sid-history/">SID History</a>, o&nbsp;ktorom som nedávno písal, alebo <a href="https://www.sevecek.com/Lists/Posts/Post.aspx?ID=213">notoricky známe</a> nahradenie nástroja <strong>Klávesnica na&nbsp;obrazovke</strong> príkazovým riadkom.
</p>

<p style="text-align: justify;">
  Zo všetkých druhov útokov sa&nbsp;mi najviac páči <strong>offline úprava Active Directory databázy</strong>. Možnosť takéhoto zásahu do&nbsp;DC je&nbsp;známa už dávno, veď aj&nbsp;kvôli tomu vznikla funkcia <a href="https://technet.microsoft.com/en-us/library/cc732801(v=ws.10).aspx">Read-Only Domain Controller</a>. Na&nbsp;druhú stranu, keďže je&nbsp;štruktúra Active Directory databázy veľmi komplikovaná a&nbsp;takmer nulovo zdokumentovaná, neexistujú skoro žiadne verejne dostupné nástroje pomocou ktorých by&nbsp;sa&nbsp;dal takýto útok realizovať. Tie, ktoré <a href="https://www.dsinternals.com/sk/offline-zmena-sid-history/">poznám</a>, sa&nbsp;výhradne sústredia na&nbsp;už spomínanú úpravu SID History. Preto som sa&nbsp;rozhodol vytvoriť powershellovský príkaz <strong>Set-ADDBPrimaryGroup</strong>, ktorý slúži na&nbsp;offline zmenu členstva v&nbsp;skupinách.
</p>

<!--more-->

### Realizácia útoku

<p style="text-align: justify;">
  Predpokladajme, že&nbsp;v AD už máme neprivilegovaný účet, napríklad April, ktorý je&nbsp;členom skupiny <strong>Domain Users</strong> a&nbsp;my by&nbsp;sme ho&nbsp;radi zaradili do&nbsp;skupiny <strong>Domain Admins</strong>. To&nbsp;môžeme spraviť dvomi cestami, buď modifikáciou atribútu <strong>member</strong> na&nbsp;skupine alebo atribútu <strong>primaryGroupId</strong> na&nbsp;používateľskom účte. Ja som si&nbsp;zvolil tú druhú možnosť, pretože je&nbsp;jednoduchšia.
</p>

<p style="text-align: justify;">
  Potrebujeme ešte poznať <a href="https://msdn.microsoft.com/en-us/library/cc246018.aspx">RID</a> cieľovej skupiny. Z&nbsp;<a href="https://support.microsoft.com/en-us/kb/243330">dokumentácie</a> ľahko dohľadáme, že&nbsp;skupina Domain Admins má RID <strong>512</strong>, Domain Users <strong>513</strong> a&nbsp;Domain Controllers <strong>516</strong>. Použiť by&nbsp;sme samozrejme mohli RID ľubovoľnej globálnej a&nbsp;univerzálnej skupiny, ktorá je&nbsp;v doméne účtu April.
</p>

Na&nbsp;zapnutom DC nám potom stačí spustiť túto sekvenciu príkazov:

<pre title="Primary Group ID" class="lang:ps decode:true ">Import-Module .\DSInternals
Stop-Service ntds -Force
$db = 'C:\Windows\NTDS\ntds.dit'
Set-ADDBPrimaryGroup -DBPath $db -SamAccountName 'April' -PrimaryGroupId 512 -Verbose
Start-Service ntds
</pre>

Výsledok môžeme overiť pohľadom do&nbsp;konzole Active Directory Users and&nbsp;Computers:

<img class="aligncenter size-full wp-image-2881" src="https://www.dsinternals.com/wp-content/uploads/primary_group.png" alt="primary_group" width="424" height="546" srcset="https://www.dsinternals.com/wp-content/uploads/primary_group.png 424w, https://www.dsinternals.com/wp-content/uploads/primary_group-233x300.png 233w" sizes="(max-width: 424px) 100vw, 424px" /> 

<p style="text-align: justify;">
  Pri offline prístupe na&nbsp;disk (boot z&nbsp;flashky či&nbsp;pripojenie HDD/VHD do&nbsp;iného PC) samozrejme nie sú nutné príkazy na&nbsp;zastavenie a&nbsp;spustenie služby Active Directory Domain Services (ntds).
</p>

<p style="text-align: justify;">
  Po nábehu služby ntds sa&nbsp;zmena členstva v&nbsp;skupinách automaticky zreplikuje na&nbsp;ostatné doménové kontroléry. Pokiaľ to&nbsp;nie je&nbsp;žiadúce chovanie, stačí spustiť príkaz Set-ADDBPrimaryGroup s&nbsp;prepínačom <strong>-SkipMetaUpdate</strong> a&nbsp;zmena ostane len&nbsp;na napadnutom DC. Zníži sa&nbsp;tým šanca na&nbsp;odhalenie útoku.
</p>

### Poznámky

<li style="text-align: justify;">
  Príkaz Set-ADDBPrimaryGroup vie vyhľadať účty používateľov a&nbsp;počítačov na&nbsp;základe <strong>login</strong>u, <strong>SID</strong>u, <strong>GUID</strong>u a&nbsp;LDAP <strong>distinguished name</strong> (DN).
</li>
<li style="text-align: justify;">
  Existencia RIDu skupiny zatiaľ nie je&nbsp;kontrolovaná. Je&nbsp;tak možné zadať akékoľvek číslo <strong>od&nbsp;1 do&nbsp;2<sup>30</sup></strong>. Nepodporuje tak novú funkciu Windows Server 2012, ktorá umožňuje <a href="http://blogs.technet.com/b/askds/archive/2012/08/10/managing-rid-issuance-in-windows-server-2012.aspx">odomknúť 31. bit</a>, ale&nbsp;to&nbsp;snáď nikto nebude potrebovať.
</li>
<li style="text-align: justify;">
  Príkaz k&nbsp;svojmu behu vyžaduje aspoň <strong>PowerShell 3</strong>.
</li>
<li style="text-align: justify;">
  Úprava súboru ntds.dit je&nbsp;možná len&nbsp;<strong>z&nbsp;tej istej verzie Windows</strong> (napríklad 6.1), z&nbsp;ktorej pochádza tento súbor. Je&nbsp;to&nbsp;spôsobené tým, že&nbsp;každá nová verzia Windows mierne upravuje formát ESE databázy. Riešením by&nbsp;bolo distribuovať s&nbsp;mojiím PowerShell modulom aj&nbsp;rôzne verzie systémovej knižnice <strong>esent.dll</strong>, ale&nbsp;to&nbsp;by bolo hrubé porušenie licenčnýh podmienok.
</li>
<li style="text-align: justify;">
  Použitie tohto nástroja je&nbsp;možné výhradne na&nbsp;<strong>výskumné a&nbsp;testovacie účely</strong>. Neručím za&nbsp;žiadne škody, ktoré by&nbsp;mohli vzniknúť jeho využitím.
</li>

### Získanie programu

<p style="text-align: justify;">
  Príkaz Set-ADDBPrimaryGroup je&nbsp;súčasťou poslednej verzie môjho PowerShell modulu DSInternals, ktorý si&nbsp;môžete <a href="https://www.dsinternals.com/sk/na-stiahnutie/">bezplatne stiahnuť</a>.
</p>