---
id: 3191
title: Offline zmena SID History
date: 2015-06-01T23:39:32+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/2481-revision-v1/
permalink: /2481-revision-v1/
---
<p style="text-align: justify;">
  Jedným z&nbsp;možných útokov na&nbsp;bezpečnosť Active Directory je&nbsp;podvrhnutie <a title="SID History" href="https://blog.thesysadmins.co.uk/admt-series-3-sid-history.html">SID History</a>. V&nbsp;Microsofte sú si&nbsp;toho plne vedomí a&nbsp;preto sú v&nbsp;Active Directory implementované 2 mechanizmy, ktoré zabraňujú efektívnemu zneužitiu SID History:
</p>

<li style="text-align: justify;">
  Hodnoty atribútu sIDHistory prichádzajúce z&nbsp;externých trustov sú vo&nbsp;východzom stave ignorované vďaka funkcii <a title="Configuring SID Filtering Settings" href="https://technet.microsoft.com/en-us/library/cc772633%28v=ws.10%29.aspx">SID Filtering</a>.
</li>
<li style="text-align: justify;">
  Atribút sIDHistory sa&nbsp;nedá len&nbsp;tak zmeniť na&nbsp;ľubovoľnú hodnotu ani pomocou konzoly Active Directory Users and&nbsp;Computers, ani cez&nbsp;PowerShell či&nbsp;nejaké API. Jediný podporovaný spôsob je&nbsp;použitie nástroja <a title="Active Directory Migration Tool" href="https://technet.microsoft.com/en-us/library/cc974332%28v=ws.10%29.aspx">ADMT</a>, ktorý vie prekopírovať existujúci SID z&nbsp;dôverovanej domény do&nbsp;SID History v&nbsp;dôverujúcej  doméne.
</li>

<p style="text-align: justify;">
  Ako však zapísať do&nbsp;SID History akúkoľvek hodnotu a&nbsp;obísť tak druhý z&nbsp;uvedených mechanizmov?
</p>

<!--more-->

### Existujúce riešenia

Možností je&nbsp;niekoľko a&nbsp;žiadna z&nbsp;nich nie je&nbsp;ideálna:

<ol type="A">
  <li>
    <a href="http://cosmoskey.blogspot.cz/2010/08/online-sidhistory-edit-sid-injection.html">Pridanie Samba 4 DC</a> <ul>
      <li>
        Postup: <ol>
          <li>
            Pridať do&nbsp;domény linuxový Samba 4 doménový kontrolér.
          </li>
          <li>
            Manuálne upraviť SID History v&nbsp;jeho LDAP databáze.
          </li>
          <li style="text-align: justify;">
            Prereplikovať z&nbsp;neho túto zmenu na&nbsp;Windows Server doménový kontrolér.
          </li>
          <li>
            Odobrať linuxový doménový kontrolér z&nbsp;domény.
          </li>
        </ol>
      </li>
      
      <li>
        Nevýhody: <ul>
          <li style="text-align: justify;">
            Nutnosť pridať nový DC, čo je&nbsp;nemalý zásah do&nbsp;domény a&nbsp;určite neostane bez povšimnutia.
          </li>
          <li style="text-align: justify;">
            Replikácia so&nbsp;Samba 4 nie vždy zafunguje úplne bezchybne, hlavne s&nbsp;najnovším Windows Server. To&nbsp;so sebou nesie riziko poškodenia doménových dát a&nbsp;preto toto riešenie nie je&nbsp;vhodné do&nbsp;produkcie.
          </li>
        </ul>
      </li>
    </ul>
  </li>
  
  <li>
    Offline úprava Active Directory databázy <ul>
      <li>
        Postup: <ol>
          <li>
            Zastaviť službu Active Directory Domain Services.
          </li>
          <li style="text-align: justify;">
            Zapísať hodnotu sIDHistory priamo do&nbsp;databázy (tzn. súboru ntds.dit) pomocou nástroja <a title="SHEdit" href="http://www.tbiro.com/projects/SHEdit/">SHEdit</a> alebo <a title="Безопасность в Active Directory " href="http://gexeg.blogspot.cz/2009/12/active-directory.html">ESEAddSidHistory</a>.
          </li>
          <li>
            Urobiť autoritatívne obnovenie dotknutých objektov.
          </li>
          <li>
            Znovu spustiť službu Active Directory Domain Services.
          </li>
        </ol>
      </li>
      
      <li>
        Nevýhody: <ul>
          <li style="text-align: justify;">
            Tieto nástroje vedia vyhľadávať používateľov podľa GUID, ale&nbsp;už nie podľa loginu či&nbsp;LDAP cesty.
          </li>
          <li>
            Prvý z&nbsp;nich podporuje maximálne Windows Server 2003.
          </li>
          <li>
            Nevedia do&nbsp;SID History zapísať viac hodnôt.
          </li>
          <li>
            Neupravia replikačné metadáta.
          </li>
          <li>
            Hodnotu SID History im treba zadať v&nbsp;binárnej podobe.
          </li>
          <li style="text-align: justify;">
            K&nbsp;zmenám nepoužívajú východzí tranzakčný log, ale&nbsp;vytvoria si&nbsp;nový log v&nbsp;tempe.
          </li>
          <li>
            Občas poškodia databázu.
          </li>
        </ul>
      </li>
    </ul>
  </li>
  
  <li>
    <a href="https://twitter.com/gentilkiwi/status/511244626456346624">Online hack</a> pomocou nástroja <a href="https://github.com/gentilkiwi/mimikatz">Mimikatz</a> <ul>
      <li>
        Postup: <ol>
          <li>
            Na&nbsp;bežiacom DC pustiť pod&nbsp;správcovským účtom <strong>mimikatz</strong>.
          </li>
          <li style="text-align: justify;">
            Prideliť procesu právo na&nbsp;neobmedzený prístup do&nbsp;pamäte pomocou príkazu<strong> privilege::debug</strong>.
          </li>
          <li>
            Spustiť príkaz <strong>misc::addsid</strong> so&nbsp;správnymi parametrami.
          </li>
        </ol>
      </li>
      
      <li>
        Nevýhody: <ul>
          <li style="text-align: justify;">
            Neumožňuje zapísať do&nbsp;SID History ľubovoľnú hodnotu, ale&nbsp;len&nbsp;SID existujúceho účtu vo&nbsp;foreste.
          </li>
          <li>
            Vyžaduje lokálnu operáciu na&nbsp;spustenom DC.
          </li>
          <li style="text-align: justify;">
            Jeho funkcionalita je&nbsp;postavená na&nbsp;binárnom opatchovaní pamäte procesu lsass tak, aby funkcia <a href="https://msdn.microsoft.com/en-us/library/ms675918(v=vs.85).aspx">DsAddSidHistory</a> nevyžadovala prístupové údaje do&nbsp;domény, z&nbsp;ktorej sa&nbsp;kopíruje SID. To&nbsp;pravdepodobne prestane fungovať s&nbsp;najbližšou aktualizáciou, ktorá sa&nbsp;bude týkať Active Directory. Nehovoriac o&nbsp;tom, že&nbsp;takýto zásah zásah môže v&nbsp;lepšom prípade zhodiť DC, v&nbsp;tom horšom ho&nbsp;poškodiť.
          </li>
        </ul>
      </li>
    </ul>
  </li>
</ol>

### Moje riešenie

<p style="text-align: justify;">
  Keďže všetky dostupné riešenia majú zásadné nedostatky, rozhodol som sa&nbsp;naprogramovať vlastný nástroj, Add-ADDBSidHistory, ktorý tiež robí offline modifikáciu databázy a&nbsp;má tieto vlastnosti:
</p>

  * Je&nbsp;spravený ako PowerShell 3+ príkaz a&nbsp;podporuje vstup cez&nbsp;pipeline.
<li style="text-align: justify;">
  Umožňuje do&nbsp;SID History zapísať ľubovoľnú hodnotu. Nové hodnoty SID History sú pridané k&nbsp;existujúcim, ak nie sú duplicitné.
</li>
<li style="text-align: justify;">
  Bezpečnostné objekty (používateľov, počítače a&nbsp;skupiny) vie vyhľadať na&nbsp;základe atribútov objectSid, objectGUID, sAMAccountName a&nbsp;distinguishedName. Pri vyhľadávaní na&nbsp;základe sAMAccountName odfiltruje zmazané a&nbsp;read-only objekty (kvôli GC). Ďalej využíva indexy, takže pracuje rýchlo aj&nbsp;nad databázou so&nbsp;150K+ objektami.
</li>
<li style="text-align: justify;">
  Upraví replikačné metadáta (atribúty uSNChanged, whenChanged, replPropertyMetaData a&nbsp;globálny čítač HighestCommittedUsn). Toto východzie chovanie sa&nbsp;dá zmeniť pomocou prepínača -SkipMetaUpdate.
</li>
<li style="text-align: justify;">
  Umožňuje zadať cestu k&nbsp;tranzakčným logom, pokiaľ nie sú uložené v&nbsp;databázovom adresári.
</li>
  * Vie sa&nbsp;zotaviť z&nbsp;chybových stavov vďaka využitiu tranzakcií.
  * Príkaz funguje na&nbsp;Windows Server 2012 R2 a&nbsp;2008 R2.

Príklad použitia:

<pre title="SID History" class="lang:ps decode:true">Import-Module .\DSInternals
Stop-Service ntds -Force
Add-ADDBSidHistory -SamAccountName April -SidHistory 'S-1-5-21-1868298443-3554975232-1738066521-500' -DBPath 'C:\Windows\NTDS\ntds.dit'
Start-Service ntds</pre>

Výsledok je&nbsp;potom nasledovný:

<img class="aligncenter size-full wp-image-2541" src="https://www.dsinternals.com/wp-content/uploads/sid_history.png" alt="Sid History" width="425" height="563" srcset="https://www.dsinternals.com/wp-content/uploads/sid_history.png 425w, https://www.dsinternals.com/wp-content/uploads/sid_history-226x300.png 226w" sizes="(max-width: 425px) 100vw, 425px" /> 

<p style="text-align: justify;">
  Príkaz je&nbsp;súčasťou PowerShell modulu DSInternals, ktorý nájdete v&nbsp;sekcii <a title="Na stiahnutie" href="https://www.dsinternals.com/sk/na-stiahnutie/">Na&nbsp;stiahnutie</a>. Budem rád za&nbsp;akúkoľvek spätnú väzbu.
</p>

<p style="text-align: justify;">
  POZOR: Pred akýmkoľvek zásahom do&nbsp;AD databázy ju vždy najprv odzálohujte!
</p>

### Plánované funkcie

<p style="text-align: justify;">
  Mám rozpracované aj&nbsp;ďalšie príkazy na&nbsp;offline manipuláciu s&nbsp;Active Directory databázou. Budú mať tieto možnosti:
</p>

  * Úprava používateľského atribútu primaryGroupId.
  * Autoritatívny restore objektov na&nbsp;úrovni jednotlivých atribútov.
<li style="text-align: justify;">
  Audit prítomnosti LM hashov, Kerberos DES/AES kľúčov a&nbsp;reverzibilne šifrovaných hesiel.
</li>
<li style="text-align: justify;">
  Výpis vlastností databázy, napríklad názov DC, doména, site, Invocation ID, DSA Epoch, highest commited USN,&#8230;
</li>
<li style="text-align: justify;">
  Výpis mapovania indexov na&nbsp;atribúty, napríklad INDEX_0015003 -> mail. To&nbsp;sa potom bude dať plne zužitkovať príkaz <a title="ntdsutil files" href="https://technet.microsoft.com/en-us/library/cc753900.aspx">ntdsutil space usage</a>.
</li>
<li style="text-align: justify;">
  Odstránenie niektorých závislostí, aby bolo možné príkazy spúšťať pod&nbsp;Windows PE 5.
</li>