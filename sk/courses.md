---
title: Školenia
lang: sk
layout: page
ref: courses
image: /assets/images/blackhat_2019_michael.jpg
permalink: /sk/skolenia/
redirect_from:
  - /sk/kurzy/
  - /sk/courses/
  - /kurzy/
  - /skolenia/
fa_class: fas fa-graduation-cap
---

![Logo GOPAS](/assets/images/gopas-logo.svg){: width="200px" style="float: left; margin-right: 10px" } Popri konzultáciách a&nbsp;bezpečnostnom výskume doručujem v&nbsp;počítačovej škole [GOPAS](https://www.gopas.cz/) na&nbsp;pobočkách v&nbsp;Prahe, Brne a&nbsp;Bratislave niekoľko mojich vlastných kurzov. Pri návrhu osnov týchto pokročilých školení som čerpal zo svojich dlhoročných [praktických skúseností s&nbsp;danou problematikou](/sk/projekty/) a&nbsp;ich obsah sa&nbsp;snažím neustále aktualizovať, aby kráčal s&nbsp;dobou.

Momentálne sú v&nbsp;ponuke tieto kurzy:

* This is a TOC placeholder.
{:toc}

## GOC213: Hacking a&nbsp;pentesting Active Directory

### Anotácia

Školenie [Hacking a&nbsp;pentesting Active Directory](https://www.gopas.cz/windows-server-hacking-and-pentesting-active-directory_goc213) vás podrobne zoznámi s&nbsp;metodikami, ktoré sa používajú pri reálnych útokoch na&nbsp;Active Directory a&nbsp;pri penetračných testoch. Všetky preberané útoky si&nbsp;budete môcť prakticky vyskúšať (nielen) s&nbsp;pomocou [Kali Linux](https://www.kali.org/).

### Osnova

- Skenovanie prostredia
  - Dolovanie DNS záznamov
  - Enumerácia objektov
  - Kontrola nastavení protokolov, vrátane LDAP, SMB, NetBIOS a&nbsp;SAMR
- Iniciálny prienik
  - Online slovníkové útoky na heslá, password spraying a credential stuffing
  - Offline útoky na Active Directory, dešifrovanie DPAPI a DPAPI-NG
  - MITM útoky, NBNS/LLMNR/mDNS Spoofing, NTLM Relay, Kerberos Relay a WebDAV
- Elevácia oprávnení a laterálny pohyb
  - Krádež prihlasovacích údajov a útoky Pass-the-Hash, Pass-the-Ticket, Silver Ticket, Overpass-the-Hash či DCSync
  - Vynútenie autentifikácie pomodou Coersion útokov
  - Kerberoasting a AS-REP roasting
  - Offline brute-forcing hesiel pomocou grafických kariet
  - Bezpečnosť certifikačnej autority a PKI
  - PKINIT a Shadow Credentials
  - Útoky na autentifikáciu pomocou čipových kariet
  - Kompromitácia vzťahov dôveryhodnosti
- Perzistencia
  - Skeleton Key
  - Golden Ticket útok
  - Skryté objekty a oprávnenia (DACL)
  - Zneužitie KDC Proxy
- Detekcia a prevencia útokov
  - Odporúčané bezpečnostné nastavenia radičov a pracovných staníc
  - Bezpečnostný audit Active Directory
  - Kontrola kvality hesiel
  - Microsoft Defender for Identity a Microsoft Defender for Endpoint

## GOC218: Entra ID pre&nbsp;správcov Active Directory

### Anotácia

Kurz [Entra ID pre&nbsp;správcov Active Directory](https://www.gopas.cz/microsoft-365-azure-active-directory-pro-spravce-active-directory_goc218)
je určený pre&nbsp;všetkých správcov Active Directory Domain Services (AD DS) a&nbsp;Federation Services (AD FS), kterých zajíma, ako funguje cloudové Active Directory. Kurz do&nbsp;hĺbky pokrýva problematiku nasadenia Entra ID, historicky nazývaného Azure Active Directory, jeho prepojenie s&nbsp;existujúcim Active Directory a&nbsp;integráciu s&nbsp;aplikáciami tretích strán, vrátane Entra ID Application Proxy. Nemalý priestor je&nbsp;venovaný tiež správnemu zabezpečeniu Entra ID, vrátane riadenia prístupu, auditovania a&nbsp;viacfázovej autentifikácie (MFA). Dôraz je&nbsp;kladený aj&nbsp;na&nbsp;možnosti automatizácie a&nbsp;auditovania pomocou PowerShellu. Na&nbsp;rozdiel od&nbsp;oficiálnych kurzov so&nbsp;širokým záberom sa&nbsp;skutočne jedná o&nbsp;deep-dive kurz.

### Osnova

- Bezpečná správa cloudového adresára
  - Správa používateľských účtov a skupín
  - Konfigurácia Entra ID Password Protection
  - Viacfázová autentifikácia (MFA)
  - Bezheslová autentifikácia, Passkeys / FIDO2, Windows Hello for Business
  - Samoobslužný reset hesiel (SSPR)
  - Entra ID Identity Protection
  - Entra ID Privileged Identity Management (PIM)
  - Správa licencií
  - Automatizácia operácií pomocou PowerShell
- Hybridná identita
  - Synchronizácia objektov pomocou Entra ID Connect
  - Synchronizácia hesiel
  - Pass-through authentication
  - Seamless SSO
  - Primary Refresh Token (PRT)
  - Cloud Kerberos Trust
  - Federácia domén s&nbsp;Active Directory Federation Services (ADFS)
- Správa počítačov a&nbsp;mobilných zariadení
  - Entra ID join a&nbsp;Autopilot
  - Hybrid domain join
  - Registrácia zariadení
  - Integrácia s Microsoft Intune
  - Politiky podmieneného prístupu
- Správa aplikácií
  - Integrácia s&nbsp;Microsoft Azure a&nbsp;Office 365
  - Registrácia SAML a OpenID Connect aplikácií
  - Publikovanie aplikácií pomocou Entra ID Application Proxy
  - Azure AD Domain Services
- Entra ID Governance
  - Auditovanie účtov, oprávnení a&nbsp;aplikácií v&nbsp;Entra&nbsp;ID
  - Automatizácia procesov

## GOC210: Pokročilý PowerShell pre&nbsp;programátorov a&nbsp;DevOps

### Anotácia

Na kurze [Pokročilý PowerShell pre&nbsp;programátorov a&nbsp;DevOps](https://www.gopas.cz/pokrocily-powershell-pro-programatory-a-devops_goc210) sa&nbsp;dozviete, ako v&nbsp;PowerShelli skriptovať na&nbsp;profesionálnej úrovni, využívať C#, Win32 API, WMI a&nbsp;ďalšie DCOM objekty, vyvíjať zložité moduly a&nbsp;používať PowerShell nielen k&nbsp;testovaniu vlastných aplikácií a&nbsp;.NET komponent, ale&nbsp;aj&nbsp;k&nbsp;automatizácií ich inštalácie a&nbsp;nasadenia kódu do&nbsp;produkcie.

### Osnova

- Ako (ne)písať komplexnejšie skripty
- Robustné PowerShell moduly a&nbsp;kód, ktorý minimalizuje chyby programátora
- Spracovanie konfiguračných súborov
- Tvorba MAML a Markdown dokumentácie pomocou nástroja PlatyPS
- Priame použitie .NET knižníc a&nbsp;COM objektov
- Kompilovaný C# kód
- Pokročilá vzdialená správa pomocou WMI a&nbsp;CIM
- Automatické testy s nástrojom Pester
- Nasadenie systémov pomocou PowerShell Desired State Configuration (DSC) a&nbsp;Azure Automation
- Kontinuálna integrácia s GitHub Actions
