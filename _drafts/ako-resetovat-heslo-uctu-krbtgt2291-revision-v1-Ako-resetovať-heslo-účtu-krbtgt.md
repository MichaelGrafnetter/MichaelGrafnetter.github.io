---
id: 3891
title: Ako resetovať heslo účtu krbtgt
date: 2015-07-14T17:20:08+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/2291-revision-v1/
permalink: /2291-revision-v1/
---
<p style="text-align: justify;">
  V&nbsp;prípade kompromitácie niektorého z doménových radičov hrozí, že sa útočník dostal k&nbsp;heslu krbtgt účtu, vďaka čomu môže začat <a title="mimikatz - Golden Ticket" href="http://rycon.hu/papers/goldenticket.html">vystavovať ľubovoľné Kerberos tikety</a> a získať tak práva ktoréhokoľvek používateľa či&nbsp;služby. To&nbsp;je katastrofický scenár, pretože si&nbsp;nikdy nemôžete byť istí, čo všetko tam útočník stihol napáchať a kde všade si&nbsp;ponechal zadné vrátka. V&nbsp;takejto situácii je najbezpečnejšie obnoviť celý AD forest zo zálohy, alebo ho&nbsp;rovno preinštalovať.
</p>

<p style="text-align: justify;">
  Pokiaľ sa&nbsp;rozhodnete pre&nbsp;obnovu forestu, nezabudnite 2-krát po sebe <a title="KDC Password Configuration" href="https://technet.microsoft.com/en-us/library/cc734032.aspx">resetovať heslo účtu krbtgt</a>. Táto operácia môže mať tiež nepríjemné následky, lebo&nbsp;si prestanú dôverovať doménové kontroléry a nebude medzi nimi fungovať replikácia. Ak to nastane, je&nbsp;nutné dočasne zakázať službu Kerberos na&nbsp;všetkých serveroch, ktoré zatiaľ nemajú doreplikovanú novú verziu hesla a následne ich reštartovať. Po reštarte si&nbsp;natiahnu Kerberos tikety od serveru s novým heslom a mali by&nbsp;sa&nbsp;s ním úspešne zreplikovať. Potom je&nbsp;na nich možné službu Kerberos znovu spustiť.
</p>

<p style="text-align: justify;">
  Je&nbsp;vidno, že v závislosti od veľkosti prostredia sa&nbsp;jedná o komplikovaný proces náchylný na chyby a výpadky. Páni z Microsoft Consulting Services našťastie <a title="Reset the&nbsp;krbtgt account password/keys" href="https://gallery.technet.microsoft.com/Reset-the-krbtgt-account-581a9e51">zverejnili skript</a>, ktorý tento postup značne zjednodušuje. Stačí spustiť nasledujúcu sekvenciu príkazov a nechať sa&nbsp;previesť Wizardom:
</p>

<pre class="lang:ps">Set-ExecutionPolicy RemoteSigned
.\Reset-KrbtgtInteractive.ps1</pre>

<p style="text-align: justify;">
  Skript pred zmenou najprv overí dostupnosť všetkých doménových kontrolérov a po resete vynúti replikáciu nového hesla na všetky DC.
</p>