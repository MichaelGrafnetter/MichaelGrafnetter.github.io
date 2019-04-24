---
id: 2051
title: 'Ako na&nbsp;snapshoty Active Directory databázy'
date: 2015-03-01T23:37:33+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/1071-revision-v1/
permalink: /1071-revision-v1/
---
<p align="justify">
  Ako jeden z mechanizmov zálohovania Active Directory sa mi osvedčili každodenné snapshoty databázy. Nedajú sa síce použiť priamo k obnoveniu DC, ale v kombinácii s nástrojom <a title="Dsamain" href="https://technet.microsoft.com/en-us/library/cc772168.aspx">dsamain</a> umožňujú veľmi rýchlo nahliadnuť do historického stavu domény.
</p>

<!--more-->

## Snapshot Active Directory databázy

Štandardný postup získania snapshotu pomocou nástroja [ntdsutil](https://technet.microsoft.com/en-us/library/cc731620.aspx "ntdsutil snapshot") je nasledovný:

  1. Pripojiť sa&nbsp;k&nbsp;AD (príkaz activate instance ntds)
  2. Vytvoriť snapshot (príkaz create)
  3. Zobraziť zoznam snapshotov a&nbsp;poznačiť si&nbsp;číslo toho najnovšieho (príkaz list all)
  4. Pripojiť vytvorený snapshot ako podadresár C:\ (príkaz mount)
  5. Vykopírovať zo snapshotu súbor ntds.dit pomocou prieskumníka
  6. Odmountovať snapshot (príkaz unmount)
  7. Zmazať snapshot (príkaz delete)

Celý postup je&nbsp;vidno na nasledovnom screenshote:

<img class="aligncenter wp-image-1891 size-full" src="https://www.dsinternals.com/wp-content/uploads/ad_snapshot.png" alt="Active Directory Snapshot" width="677" height="343" srcset="https://www.dsinternals.com/wp-content/uploads/ad_snapshot.png 677w, https://www.dsinternals.com/wp-content/uploads/ad_snapshot-300x152.png 300w" sizes="(max-width: 677px) 100vw, 677px" /> 

## IFM záloha

<p align="justify">
  Predošlý postup je trochu ťažkopádny, hlavne ak ho chceme zautomatizovať. Preto radšej využívam Install From&nbsp;Media (IFM) zálohy, ktoré na jeden príkaz urobia kroky 2-7 z predošlého postupu:
</p>

<img class="aligncenter wp-image-1901 size-full" src="https://www.dsinternals.com/wp-content/uploads/ad_ifm.png" alt="Install From&nbsp;Media Backup" width="677" height="391" srcset="https://www.dsinternals.com/wp-content/uploads/ad_ifm.png 677w, https://www.dsinternals.com/wp-content/uploads/ad_ifm-300x173.png 300w" sizes="(max-width: 677px) 100vw, 677px" /> 

Navyše prebehne aj&nbsp;defragmentácia databázy a odzálohovanie registrov. Výsledkom je táto adresárová štruktúra:

  * Adresár Active Directory 
      * Súbor ntds.dit &#8211; Defragmentovaná databáza
  * Adresár Registry 
      * Súbor SECURITY &#8211; Registry hive obsahujúci vetvu HKLM\Security
      * Súbor SYSTEM &#8211; Registry hive obsahujúci vetvu HKLM\System.

<p align="justify">
  Registre sú súčasťou IFM zálohy preto, lebo hashe používateľských hesiel sú v databáze zasifrované pomocou tzv. SYSKEY/BOOTKEY, ktorý sa nachádza práve v registroch.
</p>

## Použitie IFM zálohy

<p align="justify">
  Primárnym účelom tejto zálohy je jej použitie pri inštalácii nového doménového kontroléru na pobočke s pomalou konektivitou:
</p>

[<img class="aligncenter" src="https://i-technet.sec.s-msft.com/dynimg/IC586842.gif" alt="Install From&nbsp;Media Options" width="773" height="566" />](https://i-technet.sec.s-msft.com/dynimg/IC586842.gif)

<p align="justify">
  Nikto nám však nebráni si&nbsp;ntds.dit súbor z IFM zálohy primountovať pomocou nástroja dsamain, rovnako ako bežný snapshot. Nasledovná sekvencia príkazov sprístupní odzálohovanú databázu databázu cez protokol LDAP na porte 10389 a nasmeruje na ňu konzolu Active Directory Users and Computers:
</p>

<img class="aligncenter wp-image-1951 size-full" src="https://www.dsinternals.com/wp-content/uploads/dsamain1.png" alt="" width="677" height="163" srcset="https://www.dsinternals.com/wp-content/uploads/dsamain1.png 677w, https://www.dsinternals.com/wp-content/uploads/dsamain1-300x72.png 300w" sizes="(max-width: 677px) 100vw, 677px" /> 

## Automatizácia

<p align="justify">
  Ostáva nám ešte zautomatizovať tvorbu IFM záloh. Môžeme k tomu použiť nasledujúci PowerShell skript, ktorý každú zálohu uloží do samostatného adresára, ktorý vo svojom názve obsahuje aktuálny čas a dátum:
</p>

<pre class="lang:ps decode:true">$date = Get-Date -Format 'yyyy-MM-dd HH-mm'
$folder = Join-Path 'C:\IFM' $date
ntdsutil 'activate instance ntds' ifm "create sysvol full `"$folder`"" quit quit</pre>

<p align="justify">
  Tento skript potom stačí pravidelne spúšťať v rámci periodickej plánovanej úlohy. Nesmieme samozrejme zabudnúť na premazávanie starých záloh, aby nám nezaplnili disk.
</p>

## Záver

<p align="justify">
  IFM zálohy nám v žiadnom prípade nenahradia System State zálohy, vytvárané pomocou Windows Server Backup alebo nástrojov tretích strán. Môžu ale poslúžiť ako ich doplnok, pretože k dátam v nich obsiahnutých sa typicky vieme dostať oveľa rýchlejšie, než k System State zálohám.
</p>