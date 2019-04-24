---
id: 1961
title: 'Ako na&nbsp;snapshot Active Directory databázy'
date: 2015-03-01T23:22:03+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/1071-revision-v1/
permalink: /1071-revision-v1/
---
Ako jeden z&nbsp;mechanizmov zálohovania Active Directory sa&nbsp;mi osvedčili každodenné snapshoty databázy. Nedajú sa&nbsp;síce použiť priamo k&nbsp;obnoveniu DC, ale&nbsp;v kombinácii s&nbsp;nástrojom [dsamain](https://technet.microsoft.com/en-us/library/cc772168.aspx "Dsamain") umožňujú veľmi rýchlo nahliadnuť do&nbsp;historického stavu domény.<!--more-->

## Snapshot Active Directory databázy

Štandardný postup získania snapshotu pomocou nástroja [ntdsutil](https://technet.microsoft.com/en-us/library/cc731620.aspx "ntdsutil snapshot") je&nbsp;nasledovný:

  1. Pripojiť sa&nbsp;k&nbsp;AD (príkaz activate instance ntds)
  2. Vytvoriť snapshot (príkaz create)
  3. Zobraziť zoznam snapshotov a&nbsp;poznačiť si&nbsp;číslo toho najnovšieho (príkaz list all)
  4. Pripojiť vytvorený snapshot ako podadresár C:\ (príkaz mount)
  5. Vykopírovať zo snapshotu súbor ntds.dit pomocou prieskumníka
  6. Odmountovať snapshot (príkaz unmount)
  7. Zmazať snapshot (príkaz delete)

Celý postup je&nbsp;vidno v&nbsp;nasledovnom screenshote:

<img class="aligncenter wp-image-1891 size-full" src="https://www.dsinternals.com/wp-content/uploads/ad_snapshot.png" alt="Active Directory Snapshot" width="677" height="343" srcset="https://www.dsinternals.com/wp-content/uploads/ad_snapshot.png 677w, https://www.dsinternals.com/wp-content/uploads/ad_snapshot-300x152.png 300w" sizes="(max-width: 677px) 100vw, 677px" /> 

## IFM záloha

Predošlý postup je&nbsp;trochu ťažkopádny, hlavne ak ho&nbsp;chceme zautomatizovať. Preto radšej využívam Install From&nbsp;Media (IFM) zálohy, ktoré na&nbsp;jeden príkaz urobia kroky 2-7 z&nbsp;predošlého postupu:

<img class="aligncenter wp-image-1901 size-full" src="https://www.dsinternals.com/wp-content/uploads/ad_ifm.png" alt="Install From&nbsp;Media Backup" width="677" height="391" srcset="https://www.dsinternals.com/wp-content/uploads/ad_ifm.png 677w, https://www.dsinternals.com/wp-content/uploads/ad_ifm-300x173.png 300w" sizes="(max-width: 677px) 100vw, 677px" /> 

Navyše prebehne aj&nbsp;defragmentácia databázy a&nbsp;odzálohovanie registrov. Výsledkom je&nbsp;táto adresárová štruktúra:

  * Adresár Active Directory 
      * Súbor ntds.dit &#8211; Defragmentovaná databáza
  * Adresár Registry 
      * Súbor SECURITY &#8211; Registry hive obsahujúci vetvu HKLM\Security
      * Súbor SYSTEM &#8211; Registry hive obsahujúci vetvu HKLM\System.

Registre sú súčasťou IFM zálohy preto, lebo&nbsp;hashe používateľských hesiel sú v&nbsp;databáze zasifrované pomocou tzv. SYSKEY/BOOTKEY, ktorý sa&nbsp;nachádza práve v&nbsp;registroch.

## Použitie IFM zálohy

Primárnym účelom tejto zálohy je&nbsp;jej použitie pri inštalácii nového doménového kontroléru na&nbsp;pobočke s&nbsp;pomalou konektivitou:

[<img class="aligncenter" src="https://i-technet.sec.s-msft.com/dynimg/IC586842.gif" alt="Install From&nbsp;Media Options" width="773" height="566" />](https://i-technet.sec.s-msft.com/dynimg/IC586842.gif)

Môžeme ju Nikto nám však nebráni si&nbsp;ntds.dit súbor z&nbsp;IFM zálohy primountovať pomocou nástroja dsamain, rovnako ako bežný snapshot. Nasledovná sekvencia príkazov sprístupní odzálohovanú databázu databázu cez&nbsp;protokol LDAP na&nbsp;porte 10389 a&nbsp;nasmeruje na&nbsp;ňu konzolu Active Directory Users and&nbsp;Computers:

<img class="aligncenter wp-image-1951 size-full" src="https://www.dsinternals.com/wp-content/uploads/dsamain1.png" alt="" width="677" height="163" srcset="https://www.dsinternals.com/wp-content/uploads/dsamain1.png 677w, https://www.dsinternals.com/wp-content/uploads/dsamain1-300x72.png 300w" sizes="(max-width: 677px) 100vw, 677px" /> 

## Automatizácia

Ostáva nám ešte zautomatizovať tvorbu IFM záloh. Môžeme k&nbsp;tomu použiť nasledujúci PowerShell skript, ktorý každú zálohu uloží do&nbsp;samostatného adresára, ktorý vo&nbsp;svojom názve obsahuje aktuálny čas a&nbsp;dátum:

<pre class="lang:ps decode:true">$date = Get-Date -Format 'yyyy-MM-dd HH-mm'
$folder = Join-Path 'C:\IFM' $date
ntdsutil 'activate instance ntds' ifm "create sysvol full `"$folder`"" quit quit</pre>

Tento skript potom stačí pravidelne spúšťať v&nbsp;rámci periodickej plánovanej úlohy. Nesmieme samozrejme zabudnúť na&nbsp;premazávanie starých záloh, aby nám nezaplnili disk.

## Záver

IFM zálohy nám v&nbsp;žiadnom prípade nenahradia System State zálohy, vytvárané pomocou Windows Server Backup alebo nástrojov tretích strán. Môžu ale&nbsp;poslúžiť ako ich doplnok, pretože k&nbsp;dátam v&nbsp;nich obsiahnutých sa&nbsp;typicky vieme dostať oveľa rýchlejšie, než k&nbsp;System State zálohám.