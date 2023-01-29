---
ref: 2481
title: Offline zmena SID History
date: 2015-05-24T12:53:15+00:00
layout: post
lang: sk
image: /assets/images/sid_history.png
permalink: /sk/offline-zmena-sid-history/
tags:
    - 'Active Directory'
    - PowerShell
    - Security
    - 'SID History'
---

Jedným z&nbsp;možných útokov na&nbsp;bezpečnosť Active Directory je&nbsp;podvrhnutie [SID History](https://blog.thesysadmins.co.uk/admt-series-3-sid-history.html "SID History"). V&nbsp;Microsofte sú&nbsp;si&nbsp;toho plne vedomí a&nbsp;preto sú&nbsp;v&nbsp;Active Directory implementované 2 mechanizmy, ktoré zabraňujú efektívnemu zneužitiu SID History:

- Hodnoty atribútu sIDHistory prichádzajúce z&nbsp;externých trustov sú&nbsp;vo&nbsp;východzom stave ignorované vďaka funkcii [SID Filtering](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc772633(v=ws.10) "Configuring SID Filtering Settings").
- Atribút sIDHistory sa&nbsp;nedá len&nbsp;tak zmeniť na&nbsp;ľubovoľnú hodnotu ani&nbsp;pomocou konzoly Active Directory Users and&nbsp;Computers, ani cez&nbsp;PowerShell či&nbsp;nejaké API. Jediný podporovaný spôsob je&nbsp;použitie nástroja [ADMT](https://learn.microsoft.com/en-us/troubleshoot/windows-server/identity/support-for-admt-and-pes "Active Directory Migration Tool"), ktorý vie prekopírovať existujúci SID z&nbsp;dôverovanej domény do&nbsp;SID History v&nbsp;dôverujúcej doméne.

Ako však zapísať do&nbsp;SID History akúkoľvek hodnotu a&nbsp;obísť tak druhý z&nbsp;uvedených mechanizmov?

<!--more-->

> VAROVANIE: Funkcionalita modulu DSInternals nie je&nbsp;podporovaná firmou Microsoft a&nbsp;preto nie je&nbsp;určený pre&nbsp;produkčné nasadenie. Jeho nesprávne použitie môže spôsobiť nevratné poškodenie doménového kontroléru alebo negatívne ovplyvniť bezpečosť domény.

## Existujúce riešenia

Možností je&nbsp;niekoľko a&nbsp;žiadna z&nbsp;nich nie je&nbsp;ideálna:

1. [Pridanie Samba 4 DC](https://cosmoskey.blogspot.cz/2010/08/online-sidhistory-edit-sid-injection.html)
    - Postup: 
        1. Pridať do&nbsp;domény linuxový Samba 4 doménový kontrolér.
        2. Manuálne upraviť SID History v&nbsp;jeho LDAP databáze.
        3. Prereplikovať z&nbsp;neho túto zmenu na&nbsp;Windows Server doménový kontrolér.
        4. Odobrať linuxový doménový kontrolér z&nbsp;domény.
    - Nevýhody: 
        - Nutnosť pridať nový DC, čo je&nbsp;nemalý zásah do&nbsp;domény a&nbsp;určite neostane bez povšimnutia.
        - Replikácia so&nbsp;Samba 4 nie vždy zafunguje úplne bezchybne, hlavne s&nbsp;najnovším Windows Server. To&nbsp;so&nbsp;sebou nesie riziko poškodenia doménových dát a&nbsp;preto toto riešenie nie je&nbsp;vhodné do&nbsp;produkcie.
2. Offline úprava Active Directory databázy 
    - Postup: 
        1. Zastaviť službu Active Directory Domain Services.
        2. Zapísať hodnotu sIDHistory priamo do&nbsp;databázy (tzn. súboru ntds.dit) pomocou nástroja [SHEdit](http://www.tbiro.com/projects/shedit/ "SHEdit") alebo [ESEAddSidHistory](https://gexeg.blogspot.cz/2009/12/active-directory.html "Безопасность в Active Directory ").
        3. Urobiť autoritatívne obnovenie dotknutých objektov.
        4. Znovu spustiť službu Active Directory Domain Services.
    - Nevýhody: 
        - Tieto nástroje vedia vyhľadávať používateľov podľa GUID, ale&nbsp;už&nbsp;nie podľa loginu či&nbsp;LDAP cesty.
        - Prvý z&nbsp;nich podporuje maximálne Windows Server 2003.
        - Nevedia do&nbsp;SID History zapísať viac hodnôt.
        - Neupravia replikačné metadáta.
        - Hodnotu SID History im treba zadať v&nbsp;binárnej podobe.
        - K&nbsp;zmenám nepoužívajú východzí tranzakčný log, ale&nbsp;vytvoria si&nbsp;nový log v&nbsp;tempe.
        - Občas poškodia databázu.
3. [Online hack](https://twitter.com/gentilkiwi/status/511244626456346624) pomocou nástroja [Mimikatz](https://github.com/gentilkiwi/mimikatz)
    - Postup: 
        1. Na&nbsp;bežiacom DC pustiť pod&nbsp;správcovským účtom **mimikatz**.
        2. Prideliť procesu právo na&nbsp;neobmedzený prístup do&nbsp;pamäte pomocou príkazu **privilege::debug**.
        3. Spustiť príkaz **misc::addsid** so&nbsp;správnymi parametrami.
    - Nevýhody: 
        - Neumožňuje zapísať do&nbsp;SID History ľubovoľnú hodnotu, ale&nbsp;len&nbsp;SID existujúceho účtu vo&nbsp;foreste.
        - Vyžaduje lokálnu operáciu na&nbsp;spustenom DC.
        - Jeho funkcionalita je&nbsp;postavená na&nbsp;binárnom opatchovaní pamäte procesu lsass tak, aby funkcia [DsAddSidHistory](https://learn.microsoft.com/en-us/windows/win32/api/ntdsapi/nf-ntdsapi-dsaddsidhistoryw) nevyžadovala prístupové údaje do&nbsp;domény, z&nbsp;ktorej sa&nbsp;kopíruje SID. To&nbsp;pravdepodobne prestane fungovať s&nbsp;najbližšou aktualizáciou, ktorá sa&nbsp;bude týkať Active Directory. Nehovoriac o&nbsp;tom, že&nbsp;takýto zásah zásah môže v&nbsp;lepšom prípade zhodiť DC, v&nbsp;tom horšom ho&nbsp;poškodiť.

## Moje riešenie

Keďže všetky dostupné riešenia majú zásadné nedostatky, rozhodol som sa&nbsp;naprogramovať vlastný nástroj, Add-ADDBSidHistory, ktorý tiež robí offline modifikáciu databázy a&nbsp;má tieto vlastnosti:

- Je&nbsp;spravený ako PowerShell 3+ príkaz a&nbsp;podporuje vstup cez&nbsp;pipeline.
- Umožňuje do&nbsp;SID History zapísať ľubovoľnú hodnotu. Nové hodnoty SID History sú&nbsp;pridané k&nbsp;existujúcim, ak nie sú&nbsp;duplicitné.
- Bezpečnostné objekty (používateľov, počítače a&nbsp;skupiny) vie vyhľadať na&nbsp;základe atribútov objectSid, objectGUID, sAMAccountName a&nbsp;distinguishedName. Pri vyhľadávaní na&nbsp;základe sAMAccountName odfiltruje zmazané a&nbsp;read-only objekty (kvôli GC). Ďalej využíva indexy, takže pracuje rýchlo aj&nbsp;nad databázou so&nbsp;150K+ objektami.
- Upraví replikačné metadáta (atribúty uSNChanged, whenChanged, replPropertyMetaData a&nbsp;globálny čítač HighestCommittedUsn). Toto východzie chovanie sa&nbsp;dá zmeniť pomocou prepínača `-SkipMetaUpdate`.
- Umožňuje zadať cestu k&nbsp;tranzakčným logom, pokiaľ nie sú&nbsp;uložené v&nbsp;databázovom adresári.
- Vie sa&nbsp;zotaviť z&nbsp;chybových stavov vďaka využitiu tranzakcií.
- Príkaz funguje na&nbsp;Windows Server 2012 R2 a&nbsp;2008 R2.

Príklad použitia:

```powershell
Import-Module .\DSInternals
Stop-Service ntds -Force
Add-ADDBSidHistory -SamAccountName April -SidHistory 'S-1-5-21-1868298443-3554975232-1738066521-500' -DBPath 'C:\Windows\NTDS\ntds.dit'
Start-Service ntds
```

Výsledok je&nbsp;potom nasledovný:

![Sid History](../../assets/images/sid_history.png)

Príkaz je&nbsp;súčasťou PowerShell modulu DSInternals, ktorý nájdete v&nbsp;sekcii [Projekty](/sk/projekty/ "Projekty"). Budem rád za&nbsp;akúkoľvek spätnú väzbu.

POZOR: Pred akýmkoľvek zásahom do&nbsp;AD databázy ju vždy najprv odzálohujte!

## Plánované funkcie

Mám rozpracované aj&nbsp;ďalšie príkazy na&nbsp;offline manipuláciu s&nbsp;Active Directory databázou. Budú mať tieto možnosti:

- Úprava používateľského atribútu primaryGroupId.
- Autoritatívny restore objektov na&nbsp;úrovni jednotlivých atribútov.
- Audit prítomnosti LM hashov, Kerberos DES/AES kľúčov a&nbsp;reverzibilne šifrovaných hesiel.
- Výpis vlastností databázy, napríklad názov DC, doména, site, Invocation ID, DSA Epoch, highest commited USN,...
- Výpis mapovania indexov na&nbsp;atribúty, napríklad INDEX_0015003 -&gt; mail. To&nbsp;sa&nbsp;potom bude dať plne zužitkovať príkaz [ntdsutil space usage](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/cc753900(v=ws.11) "ntdsutil files").
- Odstránenie niektorých závislostí, aby bolo možné príkazy spúšťať pod&nbsp;Windows PE 5.
