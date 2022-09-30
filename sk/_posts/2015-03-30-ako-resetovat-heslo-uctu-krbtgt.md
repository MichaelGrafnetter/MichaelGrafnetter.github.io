---
ref: 2291
title: Ako resetovať heslo účtu krbtgt
date: 2015-03-30T15:51:33+00:00
layout: post
lang: sk
permalink: /sk/ako-resetovat-heslo-uctu-krbtgt/
tags:
    - 'Active Directory'
    - PowerShell
    - Security
---

V&nbsp;prípade kompromitácie niektorého z doménových radičov hrozí, že sa útočník dostal k heslu krbtgt účtu, vďaka čomu môže začat [vystavovať ľubovoľné Kerberos tikety](https://rycon.hu/papers/goldenticket.html "mimikatz - Golden Ticket") a získať tak práva ktoréhokoľvek používateľa či&nbsp;služby. To&nbsp;je katastrofický scenár, pretože si&nbsp;nikdy nemôžete byť istí, čo všetko tam útočník stihol napáchať a kde všade si&nbsp;ponechal zadné vrátka. V&nbsp;takejto situácii je najbezpečnejšie obnoviť celý AD forest zo zálohy, alebo ho&nbsp;rovno preinštalovať.

<!--more-->

Pokiaľ sa rozhodnete pre obnovu forestu, nezabudnite 2-krát po sebe [resetovať heslo účtu krbtgt](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc734032(v=ws.10) "KDC Password Configuration"). Táto operácia môže mať tiež nepríjemné následky, lebo&nbsp;si prestanú dôverovať doménové kontroléry a nebude medzi nimi fungovať replikácia. Ak to nastane, je&nbsp;nutné dočasne zakázať službu Kerberos na&nbsp;všetkých serveroch, ktoré zatiaľ nemajú doreplikovanú novú verziu hesla a následne ich reštartovať. Po reštarte si&nbsp;natiahnu Kerberos tikety od serveru s novým heslom a mali by&nbsp;sa&nbsp;s ním úspešne zreplikovať. Potom je&nbsp;na nich možné službu Kerberos znovu spustiť.

Je&nbsp;vidno, že v&nbsp;závislosti od&nbsp;veľkosti prostredia sa&nbsp;jedná o&nbsp;komplikovaný proces náchylný na&nbsp;chyby a&nbsp;výpadky. Páni z&nbsp;Microsoft Consulting Services našťastie [zverejnili skript](https://github.com/microsoft/New-KrbtgtKeys.ps1 "Reset the krbtgt account password/keys"), ktorý tento postup značne zjednodušuje. Stačí spustiť nasledujúcu sekvenciu príkazov a&nbsp;nechať sa&nbsp;previesť Wizardom:

```powershell
Set-ExecutionPolicy RemoteSigned
.\Reset-KrbtgtInteractive.ps1
```

Skript pred zmenou najprv overí dostupnosť všetkých doménových kontrolérov a&nbsp;po&nbsp;resete vynúti replikáciu nového hesla na&nbsp;všetky DC.