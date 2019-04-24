---
id: 3011
title: 'Certifikačná autorita ČAK: Sodoma Gomora'
date: 2015-05-31T14:23:49+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/701-revision-v1/
permalink: /701-revision-v1/
---
<p align="justify">
  <a title="Česká Advokátní Komora" href="http://www.cak.cz/">Česká Advokátní Komora</a> (ČAK) vydáva všetkým advokátom a advokátskym koncipientom čipové <a title="Identifikační průkazy" href="http://www.cak.cz/scripts/detail.php?id=9008">identifikačné preukazy</a> postavené na kartách <a title="Crescendo C700" href="http://www.hidglobal.com/products/cards-and-credentials/crescendo/c700">HID Crescendo C700</a>. Nedávno som sa&nbsp;k jednému takémuto preukazu dostal, keď som pomáhal kamarátke s prístupom do dátovej schránky. Pri pohľade na certifikát vystavený certifikačnou autoritou ČAK, ktorý bol na čipe nahraný, som sa nestačil diviť vlastným očiam. Jedná sa&nbsp;o ukážkový príklad toho, ako by&nbsp;sa&nbsp;nemala nakonfigurovať certifikačná autorita.
</p>

<!--more-->

## Dump certifikátu

Tuto je&nbsp;anonymizovaný dump certifikátu získaný pomocou príkazu _certutil -dump_:

Version: 3  
Serial Number: 20b2a634beacb4be124f  
Signature Algorithm: sha512RSA  
Issuer: CN=CAK-CAWS  
NotBefore: 8/23/2014 11:46  
NotAfter: 8/23/2019 11:56  
Subject: CN=JUDr. KAREL NOVÁK  
Public Key Algorithm: RSA  
Public Key Length: 2048 bits  
Key Usage:

  * Digital Signature
  * Non-Repudiation
  * Key Encipherment
  * Data Encipherment

Enhanced Key Usage: Client Authentication  
Subject Alternative Name:

  * Other Name: Principal Name=&#8221;12458&#8243;
  * Other Name: Principal Name=&#8221;A&#8221;

CRL Distribution Points:

  * URL=http://win-js5ffai62i4/CertEnroll/CAK-CAWS(1).crl
  * URL=file://WIN-JS5FFAI62I4/CertEnroll/CAK-CAWS(1).crl

Authority Information Access:

  * URL=http://win-js5ffai62i4/CertEnroll/WIN-JS5FFAI62I4_CAK-CAWS(2).crt
  * URL=file://WIN-JS5FFAI62I4/CertEnroll/WIN-JS5FFAI62I4_CAK-CAWS(2).crt

<p align="justify">
  Dump nie je&nbsp;kompletný, pretože som pozmenil alebo odstránil všetky osobné informácie. Z tvaru CRL a AIA URL je&nbsp;jasné, že bol certifikát vydaný pomocou Active Directory Certificate Services, nakonfigurovanej pravdepodobne v režime Standalone Root CA.
</p>

## Chyby v&nbsp;konfigurácii

<p align="justify">
  Z&nbsp;certifikátu je&nbsp;vidno viacero nedostatkov v konfigurácii resp. politike CA. Toto sú najzávažnejšie z nich:
</p>

### Východzí názov serveru

<p align="justify">
  Názov serveru, na ktorom beží certifikačná autorita, je WIN-JS5FFAI62I4. Áno, je&nbsp;to&nbsp;východzí názov, ktorý si&nbsp;vygeneroval Windows Server v rámci inštalačného procesu a príslušný správca si&nbsp;nedal tú námahu ho premenovať. To je doslova amaterizmus.
</p>

### Nedostupné CRL a&nbsp;CDP

<p align="justify">
  Keby ste tento certifikát chceli na svojom počítači zvalidovať, tak máte smolu: Mimo internú sieť ČAKu sa&nbsp;Vám nepodarí stiahnuť Certificate Revocation List (CRL) ani certifikát certifikačnej autority na základe Authority Information Access (AIA). URL v certifikáte totiž obsahujú len NetBIOS názov serveru, namiesto nejakého verejného DNS názvu, napríklad http://www.cak.cz/ca/cak_caws_2014.crt. Nehovoriac o tom, že okrem HTTP URL je v certifikáte aj FILE (tzn. SMB) URL a to býva tiež dostupné len z intranetu.
</p>

<p align="justify">
  Keby sa&nbsp;jednalo o certifikáty používané len v rámci intranetu v sídle ČAK, tak nič nepoviem. Ale u certifikátov, ktoré majú byť používané v externom prostredí a sú vydávané širokému okruhu ľudí (v ČR je&nbsp;cca. 14 000 advokátov a koncipientov) sa&nbsp;podľa mňa jedná o zásadnú chybu.
</p>

### Konfliktný subjekt

<p align="justify">
  Vzhľadom k&nbsp;tomu, že v subjekte je uvedený len titul, krstné meno a priezvisko a v ČR sa&nbsp;pravdepodobne nájdu advokáti s rovnakým menom, budú určite vznikať konflikty. Chýba tam nejaký jednoznačný identifikátor, napríklad adresa pôsobnosti.
</p>

<p align="justify">
  Položka Subject Alternative Name (SAN) obsahuje číslo advokátskeho preukazu a nejednoznačnosť aspoň trochu napráva. Dojem ale kazí záhadný identifikátor Principal Name=&#8221;A&#8221;, ktorý zrejme nebude unikátny naprieč certifikátmi. Predpokladám, že to má odlíšiť advokáta (A) od koncipienta (K). To&nbsp;sa ovšem typicky rieši cez OU v subjekte alebo SAN dirName.
</p>

### Pofidérny middleware

Príliš veľkú dôveru vo mne nevzbudila ani aplikácia [Průvodce kartou ČAK](http://podpora.cak.cz/prukazy/ "Technická podpora pro identifikační průkazy"), ktorá má uľahčiť správu certifikátov na karte:

<img class="aligncenter wp-image-961 size-full" src="https://www.dsinternals.com/wp-content/uploads/pruvodce_kartou_cak.png" alt="Pruvodce kartou ČAK" width="709" height="549" srcset="https://www.dsinternals.com/wp-content/uploads/pruvodce_kartou_cak.png 709w, https://www.dsinternals.com/wp-content/uploads/pruvodce_kartou_cak-300x232.png 300w" sizes="(max-width: 709px) 100vw, 709px" /> 

## Certifikátov nie je&nbsp;nikdy dosť

<p align="justify">
  Otázny je&nbsp;aj samotný zmysel vydávania týchto certifikátov. Pokiaľ chcú advokáti pristupovať do dátovej schránky a&nbsp;robiť konverziu dokumentov, aj tak <a title="Konverzia dokumentov" href="http://www.cak.cz/scripts/detail.php?id=3451">potrebujú</a> mať kvalifikovaný a komerčný certifikát od riadnej certifikačnej autority. Takže dohromady má bežný advokát v&nbsp;ČR minimálne 3 rôzne certifikáty, ktoré si&nbsp;musí obnovovať pred ukončením ich platnosti. No a pri tom už človeku ostáva stáť rozum.
</p>

## Záver

<p align="justify">
  Celé to&nbsp;na mňa pôsobí dojmom, že CA ČAK bola šitá horúcou ihlou, bez zamyslenia sa&nbsp;nad jej účelom a konfiguráciou. To&nbsp;je ČAK skutočne tak chudobná organizácia, že musí šetriť na svojom IT a zveriť ho &#8220;bastličom&#8221;? Osobne by som niečo takéto v živote nepustil z ruky.
</p>

<p align="justify">
  Na&nbsp;celej veci som našiel len jedno pozitívum: Každý advokát dostane čipovú kartu, na ktorú si&nbsp;môže uložiť svoje certifikáty, ktoré sa&nbsp;mu tým pádom nebudú len tak &#8220;povaľovať&#8221; na disku či flashke. Niekto by&nbsp;mohol namietať, že k tomuto účelu predsa majú slúžiť nové čipové občianske preukazy, ale ich rozšírenosť je&nbsp;zatiaľ mizivá, pretože čip je v nich len za príplatok.
</p>