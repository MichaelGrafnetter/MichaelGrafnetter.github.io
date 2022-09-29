---
ref: how-azure-active-directory-connect-syncs-passwords
title: 'Ako funguje synchronizácia hesiel z&nbsp;on-premise AD do&nbsp;Azure AD'
date: 2015-01-20T12:01:37+00:00
layout: post
lang: sk
permalink: /sk/ako-funguje-synchronizacia-hesiel-z-on-premise-ad-do-azure-ad/
tags:
    - 'Active Directory'
    - 'Microsoft Azure'
    - 'Office 365'
    - PowerShell
    - Security
---
<p align="justify">
  Článkov o tom, ako nakonfigurovať synchronizáciu hesiel z vnútrofiremného Active Directory do Azure AD / Office 365, či už pomocou pôvodného nástroja DirSync, alebo jeho novšej verzie s názvom Azure AD Connect, nájdete na internete hromadu a nie je&nbsp;to žiadna veda. Čo sa&nbsp;však nikde nedočítate, je to, ako presne táto synchronizácia funguje. A&nbsp;to&nbsp;je otázka, ktorú si&nbsp;určite položí každý správca, ktorému bezpečnosť nie je&nbsp;cudzia. Rozhodol som sa&nbsp;teda, že to preskúmam a podelím sa&nbsp;s Vami o výsledky svojho bádania.
</p>

<!--more-->

## Ako získava DirSync heslá z AD

<p align="justify">
  Niekoho by&nbsp;mohlo napadnúť, že to DirSync rieši odchytávaním zmeny hesiel pomocou <a title="Password Filters" href="http://msdn.microsoft.com/en-us/library/windows/desktop/ms721882(v=vs.85).aspx">Password Filters</a>, ale nie je&nbsp;tomu tak. Toto riešenie by&nbsp;totiž vyžadovalo zmenu hesiel všetkých používateľov a prítomnosť synchronizačného agenta na všetkých doménových kontroléroch, čo by nebolo veľmi pohodlné. DirSync preto z Active Directory získava existujúce heslá cez protokol <a title="MS-DRSR" href="http://msdn.microsoft.com/en-us/library/cc228086.aspx">MS-DRSR</a>, čo je technológia, pomocou ktorej si medzi sebou štandardne replikujú dáta doménové kontroléry. Jediný citlivý údaj, ktorý si&nbsp;DirSync z AD načítava, je atribút unicodePwd, ktorý obsahuje MD4 hash (nazývaný tiež NT Hash) používateľského hesla. DirSync sa&nbsp;tak v žiadnom prípade nedostane k plaintextovej podobe hesla.
</p>

Táto funkcionalita DirSyncu je&nbsp;implementovaná v knižnici _Microsoft.Online.PasswordSynchronization.Rpc.dll_.

## V&nbsp;akej podobe posiela DirSync heslá do Azure AD

<p align="justify">
  Je&nbsp;celkom známe, že MD4 hash sa&nbsp;používa v autentizačných protokoloch NTLM a Kerberos a je v podstate ekvivalentom hesla. Navyše sa&nbsp;z dnešného pohľadu jedná o zastaralú hashovaciu funkciu, ktorá sa&nbsp;pri heslách do 10 znakov dá efektívne prelomiť pomocou rainbow tables aj brute-force útoku. Z týchto dôvodov by nebolo veľmi bezpečné, keby DirSync posielal do cloudu priamo MD4 hashe. Preto s nimi spraví ešte túto transformáciu:
</p>

<p align="justify">
  Hashe, ktoré majú 16B, sú najprv skonvertované do kapitálkovej textovej hexadecimálnej reprezentácie, čím sa&nbsp;zväčšia na 32B. Ďalej sú prekódované do UTF-16 kódovania, čo ich roztiahne na 64B. Následne sa&nbsp;vygeneruje 10B náhodných dát, ktoré budú slúžiť ako tzv. soľ. Na to je&nbsp;na záver aplikovaná štandardná funkcia <a title="PBKDF2" href="http://en.wikipedia.org/wiki/PBKDF2">PBKDF2 </a>(Password-based Key Derivation Function 2) so 100 iteráciami hashu HMAC-SHA256, ktorej výstupom je hash dlhý 32B. Tento hash je&nbsp;interne nazývaný <strong>OrgId Hash</strong> a až v jeho podobe sú heslá odosielané na servery Microsoftu.
</p>

Schematicky vyzerá výpočet OrgId hashu nasledovne:

**OrgId Hash(NTHash)&nbsp;:= PBKDF2(UTF-16(ToUpper(ToHex(NTHash)))), RND(10), 100, HMAC-SHA256, 32)**

NT hash sa&nbsp;pri nastavení hesla v Active Directory vypočíta takto:

**NTHash(plaintext)&nbsp;:= MD4(UTF-16(plaintext))**

Po dosadení NT hashu do predošlého vzorca dostaneme kompletnú transformáciu, ktorá je aplikovaná na heslo, od jeho nastavenia až po odoslanie do Azure AD:

**OrgId Hash(plaintext)&nbsp;:= PBKDF2(UTF-16(ToUpper(ToHex(MD4(UTF-16(plaintext))))), RND(10), 100, HMAC-SHA256, 32)**

<p align="justify">
  <strong>Príklad:</strong> MD4 hash hesla „Pa$$w0rd” je&nbsp;v kapitálkovej hexadecimálnej reprezentácii nasledovný:
</p>

“**92937945B518814341DE3F726500D4FF**”

<p align="justify">
  Ak by&nbsp;k nemu DirSync vygeneroval soľ “<strong>317ee9d1dec6508fa510</strong>”, do Azure AD by bol odoslaný presne tento reťazec:
</p>

“**v1;PPH1_MD4,317ee9d1dec6508fa510,100, f4a257ffec53809081a605ce8ddedfbc9df9777b80256763bc0a6dd895ef404f;**”

<p align="justify">
  Vidíme, že reťazec obsahuje nielen OrgId hash vygenerovaný pomocou PBKDF2, ale aj číslo verzie hashu, soľ a počet iterácií. Z toho sa&nbsp;dá usúdiť, že už súčasná implementácia je pripravená na budúcu zmenu algoritmu, napríklad zvýšenie počtu iterácií či použitie inej hashovacej funkcie.
</p>

DirSync generuje OrgId hashe pomocou knižnice _Microsoft.Online.PasswordSynchronization.Cryptography.dll_.

## Súlad s&nbsp;FIPS

<p align="justify">
  Pokiaľ by&nbsp;ste na serveri, kde beží DirSync, vypli podporu algoritmov, ktoré nie sú v súlade so štandardom <a title="FIPS 140-2 - Annex A" href="http://csrc.nist.gov/publications/fips/fips140-2/fips1402annexa.pdf">FIPS 140-2</a>, nebude Vám DirSync bez nastavenia <a title="AAD Password Sync, Encryption and&nbsp;FIPS compliance" href="http://blogs.technet.com/b/ad/archive/2014/06/28/aad-password-sync-encryption-and-and-fips-compliance.aspx">patričnej výnimky</a> fungovať. Príčinou je&nbsp;samotný protokol MS-DRSR, ktorý prenáša MD4 hashe zašifrované kombináciou algoritmov RC4, MD5 a DES. Aby mohol DirSync tieto hashe dešifrovať, musí zákonite uvedené algoritmy použiť.
</p>

## Bezpečnostná analýza

<p align="justify">
  Popísanému algoritmu by&nbsp;sa&nbsp;dalo z bezpečnostného hľadiska vytknúť len jediné: V príslušnom <a title="PKCS #5: Password-Based Cryptography Specification" href="https://www.ietf.org/rfc/rfc2898.txt">RFC dokumente </a>z roku 2000 sa&nbsp;odporúča použiť PBKDF2 s aspoň 1000 iteráciami, kým DirSync ich používa iba 100. To je zvláštne rozhodnutie, pretože už vo Windows Vista bola interne používaná funkcia PBKDF2 s 10240 iteráciami. Argumentom by&nbsp;snáď mohla byť snaha znížiť záťaž autentizačných serverov. No rádovo 100-násobné zvýšenie počtu iterácií podľa nemá až tak drastický dopad na výkon: Môj rýchly a neobjektívny test ukázal, že kým 100 iterácií trvá na procesore Core i5 cca. 10ms, 10240 iterácií predĺži čas potrebný k&nbsp;výpočtu na&nbsp;stále prijateľných 60 ms. Tieto čísla treba brať s veľkou rezervou, ale na vytvorenie si&nbsp;obrazu stačia. Ako sme si&nbsp;už ale naznačili, počet iterácií sa&nbsp;pravdepodobne časom zmení.
</p>

<p align="justify">
  Druhé odporúčanie z RFC, dĺžku soli minimálne 8B, už DirSync použitím 10B spĺňa. Nekonvenčný je&nbsp;ešte spôsob natiahnutia MD4 hashu zo 16B na 64B, ale na bezpečnosť to&nbsp;nemá žiaden vplyv. Vďaka použitiu náhodnej soli sa&nbsp;nebudú zhodovať hashe prípadných duplicitných hesiel. To&nbsp;je obzvlášť dôležité u cloudovej služby, kde je&nbsp;možné predpokladať milióny účtov a tým pádom vyššiu pravdepodobnosť výskytu totožných hesiel v jednej databáze.
</p>

<p align="justify">
  Funkcia PBKDF2 je&nbsp;dnes pri použití rozumného hesla považovaná za bezpečnú. Aj keby sa&nbsp;k OrgId hashu dostala nepovolaná osoba, nepodarilo by&nbsp;sa&nbsp;jej ho&nbsp;zneužiť k preniknutiu do vnútrofiremnej siete. Preto z posielania hesiel v tejto podobe do Azure Active Directory zrejme neplynie bezpečnostné riziko.
</p>

## Ukážková implementácia

<p align="justify">
  Pre&nbsp;demonštračné účely som si&nbsp;naprogramoval moju vlastnú implementáciu OrgId hashu. Je&nbsp;sprístupnená cez PowerShell cmdlet <strong>ConvertTo-OrgIdHash</strong> v <a title="Na stiahnutie" href="https://www.dsinternals.com/sk/na-stiahnutie/">module DSInternals</a>. Tu je&nbsp;ukážka jeho použitia:
</p>

<img class="aligncenter wp-image-811 size-large" src="https://www.dsinternals.com/wp-content/uploads/2015/01/ps_orgidhash-1024x325.png" alt="PowerShell OrgId Hash Calculation" width="540" height="171" srcset="https://www.dsinternals.com/wp-content/uploads/2015/01/ps_orgidhash-1024x325.png 1024w, https://www.dsinternals.com/wp-content/uploads/2015/01/ps_orgidhash-300x95.png 300w, https://www.dsinternals.com/wp-content/uploads/2015/01/ps_orgidhash.png 1170w" sizes="(max-width: 540px) 100vw, 540px" /> 

&nbsp;