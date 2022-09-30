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

Článkov o&nbsp;tom, ako nakonfigurovať synchronizáciu hesiel z&nbsp;vnútrofiremného Active Directory do&nbsp;Azure&nbsp;AD / Office 365, či&nbsp;už&nbsp;pomocou pôvodného nástroja DirSync, alebo&nbsp;jeho novšej verzie s&nbsp;názvom Azure AD Connect, nájdete na&nbsp;internete hromadu a&nbsp;nie je&nbsp;to&nbsp;žiadna veda. Čo sa&nbsp;však nikde nedočítate, je&nbsp;to, ako presne táto synchronizácia funguje. A&nbsp;to&nbsp;je otázka, ktorú si&nbsp;určite položí každý správca, ktorému bezpečnosť nie je&nbsp;cudzia. Rozhodol som sa&nbsp;teda, že to&nbsp;preskúmam a&nbsp;podelím sa&nbsp;s&nbsp;Vami o&nbsp;výsledky svojho bádania.

<!--more-->

## Ako získava DirSync heslá z&nbsp;AD

Niekoho by&nbsp;mohlo napadnúť, že&nbsp;to&nbsp;DirSync rieši odchytávaním zmeny hesiel pomocou&nbsp;[Password Filters](https://learn.microsoft.com/en-us/windows/win32/secmgmt/password-filters "Password Filters"), ale&nbsp;nie j&nbsp;tomu tak. Toto riešenie by&nbsp;totiž vyžadovalo zmenu hesiel všetkých používateľov a&nbsp;prítomnosť synchronizačného agenta na&nbsp;všetkých doménových kontroléroch, čo by&nbsp;nebolo veľmi pohodlné. DirSync preto z&nbsp;Active Directory získava existujúce heslá cez&nbsp;protokol [MS-DRSR](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-drsr/f977faaa-673e-4f66-b9bf-48c640241d47 "MS-DRSR"), čo&nbsp;je&nbsp;technológia, pomocou ktorej si&nbsp;medzi sebou štandardne replikujú dáta doménové kontroléry. Jediný citlivý údaj, ktorý si&nbsp;DirSync z&nbsp;AD načítava, je&nbsp;atribút unicodePwd, ktorý obsahuje MD4 hash (nazývaný tiež NT Hash) používateľského hesla. DirSync sa&nbsp;tak v&nbsp;žiadnom prípade nedostane k&nbsp;plaintextovej podobe hesla.

Táto funkcionalita DirSyncu je&nbsp;implementovaná v&nbsp;knižnici *Microsoft.Online.PasswordSynchronization.Rpc.dll*.

## V&nbsp;akej podobe posiela DirSync heslá do&nbsp;Azure AD

  Je&nbsp;celkom známe, že MD4 hash sa&nbsp;používa v autentizačných protokoloch NTLM a Kerberos a je v podstate ekvivalentom hesla. Navyše sa&nbsp;z dnešného pohľadu jedná o zastaralú hashovaciu funkciu, ktorá sa&nbsp;pri heslách do 10 znakov dá efektívne prelomiť pomocou rainbow tables aj brute-force útoku. Z týchto dôvodov by nebolo veľmi bezpečné, keby DirSync posielal do cloudu priamo MD4 hashe. Preto s nimi spraví ešte túto transformáciu:

Hashe, ktoré majú 16B, sú najprv skonvertované do&nbsp;kapitálkovej textovej hexadecimálnej reprezentácie, čím sa&nbsp;zväčšia na&nbsp;32B. Ďalej sú prekódované do&nbsp;UTF-16 kódovania, čo&nbsp;ich roztiahne na&nbsp;64B. Následne sa&nbsp;vygeneruje 10B náhodných dát, ktoré budú slúžiť ako tzv.&nbsp;soľ. Na&nbsp;to je na&nbsp;záver aplikovaná štandardná funkcia [PBKDF2 ](https://en.wikipedia.org/wiki/PBKDF2 "PBKDF2")(Password-based Key Derivation Function 2) so&nbsp;100 iteráciami hashu HMAC-SHA256, ktorej výstupom je&nbsp;hash dlhý 32B. Tento hash je&nbsp;interne nazývaný **OrgId Hash** a&nbsp;až&nbsp;v&nbsp;jeho podobe sú heslá odosielané na&nbsp;servery Microsoftu.

Schematicky vyzerá výpočet OrgId hashu nasledovne:

**OrgId Hash(NTHash)&nbsp;:= PBKDF2(UTF-16(ToUpper(ToHex(NTHash)))), RND(10), 100, HMAC-SHA256, 32)**

NT hash sa&nbsp;pri nastavení hesla v Active Directory vypočíta takto:

**NTHash(plaintext) := MD4(UTF-16(plaintext))**

Po dosadení NT hashu do&nbsp;predošlého vzorca dostaneme kompletnú transformáciu, ktorá je&nbsp;aplikovaná na&nbsp;heslo, od&nbsp;jeho nastavenia až po&nbsp;odoslanie do&nbsp;Azure&nbsp;AD:

**OrgId Hash(plaintext)&nbsp;:= PBKDF2(UTF-16(ToUpper(ToHex(MD4(UTF-16(plaintext))))), RND(10), 100, HMAC-SHA256, 32)**

**Príklad:** MD4 hash hesla „Pa$$w0rd” je v&nbsp;kapitálkovej hexadecimálnej reprezentácii nasledovný:

“**92937945B518814341DE3F726500D4FF**”

Ak&nbsp;by&nbsp;k&nbsp;nemu DirSync vygeneroval soľ “**317ee9d1dec6508fa510**”, do&nbsp;Azure&nbsp;AD by&nbsp;bol&nbsp;odoslaný presne tento reťazec:

“**v1;PPH1_MD4,317ee9d1dec6508fa510,100, f4a257ffec53809081a605ce8ddedfbc9df9777b80256763bc0a6dd895ef404f;**”

Vidíme, že&nbsp;reťazec obsahuje nielen OrgId hash vygenerovaný pomocou PBKDF2, ale&nbsp;aj&nbsp;číslo verzie hashu, soľ a&nbsp;počet iterácií. Z&nbsp;toho sa&nbsp;dá usúdiť, že už&nbsp;súčasná implementácia je&nbsp;pripravená na&nbsp;budúcu zmenu algoritmu, napríklad zvýšenie počtu iterácií či&nbsp;použitie inej hashovacej funkcie.

DirSync generuje OrgId hashe pomocou knižnice *Microsoft.Online.PasswordSynchronization.Cryptography.dll*.

## Súlad s&nbsp;FIPS

Pokiaľ by&nbsp;ste na&nbsp;serveri, kde beží DirSync, vypli podporu algoritmov, ktoré nie sú v&nbsp;súlade so&nbsp;štandardom [FIPS 140-2](https://csrc.nist.gov/publications/fips/fips140-2/fips1402annexa.pdf "FIPS 140-2 - Annex A"), nebude Vám DirSync bez&nbsp;nastavenia [patričnej výnimky](https://techcommunity.microsoft.com/t5/microsoft-entra-azure-ad-blog/aad-password-sync-encryption-and-fips-compliance/ba-p/243709 "AAD Password Sync, Encryption and FIPS compliance") fungovať. Príčinou je&nbsp;samotný protokol MS-DRSR, ktorý prenáša MD4 hashe zašifrované kombináciou algoritmov RC4, MD5 a&nbsp;DES. Aby mohol DirSync tieto hashe dešifrovať, musí zákonite uvedené algoritmy použiť.

## Bezpečnostná analýza

Popísanému algoritmu by&nbsp;sa&nbsp;dalo z&nbsp;bezpečnostného hľadiska vytknúť len&nbsp;jediné: V príslušnom [RFC dokumente ](https://www.ietf.org/rfc/rfc2898.txt "PKCS #5: Password-Based Cryptography Specification") z&nbsp;roku 2000 sa&nbsp;odporúča použiť PBKDF2 s&nbsp;aspoň 1000 iteráciami, kým DirSync ich používa iba&nbsp;100. To&nbsp;je&nbsp;zvláštne rozhodnutie, pretože už vo&nbsp;Windows Vista bola interne používaná funkcia PBKDF2 s&nbsp;10240 iteráciami. Argumentom by&nbsp;snáď mohla byť snaha znížiť záťaž autentizačných serverov. No&nbsp;rádovo 100-násobné zvýšenie počtu iterácií podľa nemá až&nbsp;tak&nbsp;drastický dopad na&nbsp;výkon: Môj rýchly a&nbsp;neobjektívny test ukázal, že&nbsp;kým 100 iterácií trvá na&nbsp;procesore Core i5 cca. 10ms, 10240 iterácií predĺži čas potrebný k&nbsp;výpočtu na&nbsp;stále prijateľných 60 ms. Tieto čísla treba brať s&nbsp;veľkou rezervou, ale na&nbsp;vytvorenie si&nbsp;obrazu stačia. Ako sme si už&nbsp;ale&nbsp;naznačili, počet iterácií s&nbsp;pravdepodobne časom zmení.

Druhé odporúčanie z&nbsp;RFC, dĺžku soli minimálne 8B, už&nbsp;DirSync použitím 10B spĺňa. Nekonvenčný je&nbsp;ešte spôsob natiahnutia MD4 hashu zo&nbsp;16B na&nbsp;64B, ale&nbsp;na&nbsp;bezpečnosť to&nbsp;nemá žiaden vplyv. Vďaka použitiu náhodnej soli sa&nbsp;nebudú zhodovať hashe prípadných duplicitných hesiel. To&nbsp;je obzvlášť dôležité u&nbsp;cloudovej služby, kde je&nbsp;možné predpokladať milióny účtov a&nbsp;tým pádom vyššiu pravdepodobnosť výskytu totožných hesiel v&nbsp;jednej databáze.

Funkcia PBKDF2 je&nbsp;dnes pri použití rozumného hesla považovaná za&nbsp;bezpečnú. Aj&nbsp;keby sa&nbsp;k&nbsp;OrgId hashu dostala nepovolaná osoba, nepodarilo by&nbsp;sa&nbsp;jej ho&nbsp;zneužiť k&nbsp;preniknutiu do&nbsp;vnútrofiremnej siete. Preto z&nbsp;posielania hesiel v&nbsp;tejto podobe do&nbsp;Azure Active Directory zrejme neplynie bezpečnostné riziko.

## Ukážková implementácia

Pre&nbsp;demonštračné účely som si&nbsp;naprogramoval moju vlastnú implementáciu OrgId hashu. Je&nbsp;sprístupnená cez&nbsp;PowerShell cmdlet **ConvertTo-OrgIdHash** v [module DSInternals](/sk/na-stiahnutie/ "Na stiahnutie"). Tu je&nbsp;ukážka jeho použitia:

![PowerShell OrgId Hash Calculation](../../assets/images/ps_orgidhash.png)