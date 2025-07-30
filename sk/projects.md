---
title: Projekty
lang: sk
layout: page
ref: projects
permalink: /sk/projekty/
redirect_from:
  - /sk/na-stiahnutie/
image: /assets/images/dsinternals_password_quality.png
fa_class: fas fa-download
---

## PowerShell modul DSInternals

[PowerShell modul DSInternals](https://www.powershellgallery.com/packages/DSInternals) sprístupňuje viaceré nedokumentované funkcie Active Directory a&nbsp;Azure Active Directory. Patria medzi ne [auditovanie FIDO2 a&nbsp;NGC kľúčov](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-AzureADUserEx.md#get-azureaduserex), [offline manipulácia so&nbsp;súborom ntds.dit](https://github.com/MichaelGrafnetter/DSInternals/tree/master/Documentation/PowerShell#cmdlets-for-offline-active-directory-operations), [audit hesiel](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Test-PasswordQuality.md#test-passwordquality), [obnova DC z&nbsp;IFM zálohy](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/New-ADDBRestoreFromMediaScript.md#new-addbrestorefrommediascript), and&nbsp;[počítanie odtlačkov hesiel](https://github.com/MichaelGrafnetter/DSInternals/tree/master/Documentation/PowerShell#cmdlets-for-password-hash-calculation).

Asi najobľúbenejšou funkciou modulu DSInternals je&nbsp;[príkaz Test-PasswordQuality](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Test-PasswordQuality.md#test-passwordquality), ktorý&nbsp;vie skontrolovať heslá v&nbsp;Active Directory voči zoznamu uniknutých hesiel publikovanom na&nbsp;stránke [Have I&nbsp;Been Pwned (HIBP)](https://haveibeenpwned.com/):

![Ukážka z&nbsp;výstupu príkazu Test-PasswordQuality](/assets/images/dsinternals_password_quality.png)

Viac informácií o&nbsp;tomto module:

- [PowerShell galéria](https://www.powershellgallery.com/packages/DSInternals)
- [Dokumentácia](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Readme.md)
- [Zdrojové kódy](https://github.com/MichaelGrafnetter/DSInternals)

PowerShell modul DSInternals bol údajne použitý aj&nbsp;pri útokoch v&nbsp;rámci tzv. SoloriGate, podľa [správy Symantecu o&nbsp;malvéri Raindrop](https://symantec-enterprise-blogs.security.com/blogs/threat-intelligence/solarwinds-raindrop-malware):

![Príklad časovej osi útoku malvéru Raindrop](/assets/images/solorigate.webp)

> VAROVANIE: Funkcionalita modulu DSInternals nie je&nbsp;podporovaná firmou Microsoft a&nbsp;preto nie je&nbsp;určený pre&nbsp;produkčné nasadenie. Jeho nesprávne použitie môže spôsobiť nevratné poškodenie doménového kontroléru alebo negatívne ovplyvniť bezpečosť domény.

## .NET knižnice DSInternals

Funkcionalitu PowerShell modulu je&nbsp;možné integrovať do&nbsp;iných aplikácií pomocou [NuGet balíčkov pre&nbsp;.NET](https://www.nuget.org/profiles/DSInternals).

Projekt DSInternals momentálne využívajú minimálne tieto produkty:

- [Semperis Active Directory Forest Recovery](https://www.semperis.com/adf-recovery/)
- [Lithnet Password Protection for&nbsp;Active Directory](https://github.com/lithnet/ad-password-protection)
- [Delinea Weak Password Finder](https://delinea.com/resources/weak-password-finder-tool-active-directory/)

## PowerShell modul DSInternals.Passkeys

[PowerShell modul DSInternals.Passkeys](https://www.powershellgallery.com/packages/DSInternals.Passkeys) umožňuje správcom Entra ID registrovať Passkey (bezpečnostné kľúčenky štandardu FIDO2 či&nbsp;aplikáciu Microsoft Authenticator) pre&nbsp;iných používateľov, bez nutnosti im nastavovať heslo:

![Screenshot z&nbsp;registrácie Passkey v&nbsp;Entra ID pomocou PowerShellu](/assets/images/dsinternals-passkeys.png)

Aby som mohol jednoducho demonštrovať možnosti Win32 API WebAuthn, vytvoril som ako súčasť tohoto projektu aj&nbsp;desktopovú aplikáciu [FIDO2 UI](https://github.com/MichaelGrafnetter/webauthn-interop/releases/latest):

![FIDO2 UI Screenshot](/assets/images/fido2-ui.png)

Vývojári .NET aplikácií môžu tiež jednoducho využiť túto funkcionalitu pomocou [mojich NuGet balíčkov](https://www.nuget.org/packages?q=DSInternals.Win32.WebAuthn).


## Delinea Weak Password Finder

Pre spoločnosť [Thycotic](https://delinea.com/thycotic/) (dnes Delinea) som kedysi vytvoril prvú verziu programu [Weak Password Finder for&nbsp;Active Directory](https://delinea.com/resources/weak-password-finder-tool-active-directory/).

![Screenshot z&nbsp;programu Delinea Weak Password Finder](/assets/images/thycotic_report1.png)

## ADMX šablóna pre&nbsp;YubiKey Smart Card Minidriver

Pred časom som vytvoril [ADMX šablónu](https://github.com/MichaelGrafnetter/yubikey-minidriver-admx), ktorá môže správcom uľahčiť centrálnu konfiguráciu [YubiKey Smart Card Minidriver](https://www.yubico.com/products/services-software/download/smart-card-drivers-tools/) cez&nbsp;Active Directory Group Policy.

![Group Policy Editor Screenshot](/assets/images/yubikey-admx.png)

## Bezpečnostný výskum Active Directory a&nbsp;Entra&nbsp;ID

### CVE-2024-20692: Zraniteľnosť v&nbsp;Microsoft Local Security Authority Subsystem Service (LSASS)

Počas analýzy sieťovej komunikácie Windows služby Local Security Authority Subsystem Service (LSASS) som objavil zraniteľnosť [CVE-2024-20692](https://msrc.microsoft.com/update-guide/vulnerability/CVE-2024-20692). Útočníkovi, ktorý je&nbsp;schopný pasívneho odposluchu sieťovej komunikácie, umožňuje získať citlivé dáta, ktoré&nbsp;je&nbsp;možné zneužiť pri ďalších útokoch na&nbsp;podnikovú sieť.

### Elevácia oprávnení cez&nbsp;Windows Hello for&nbsp;Business

V roku 2019 som objavil niekoľko nových vektorov útoku voči&nbsp;implementácii Windows Hello for&nbsp;Business v&nbsp;Active Directory. Výsledky môjho výskumu som prezentoval na&nbsp;konferencii Black Hat Europe, pričom [záznam prednášky](/sk/video-prednaska-black-hat-europe-2019/) aj&nbsp;[slajdy](/sk/slajdy-black-hat-europe-2019/) sú&nbsp;verejné dostupné.

![NGC kľúče so&nbsp;zraniteľnosťou ROCA v&nbsp;Active Directory](/assets/images/roca.png)

V rámci koordinovaného zverejnenia zraniteľnosti publikoval Microsoft
[bezpečnostné doporučenie ADV190026](https://msrc.microsoft.com/update-guide/en-US/vulnerability/ADV190026) nazvané *Microsoft Guidance for&nbsp;cleaning up orphaned keys generated on vulnerable TPMs and&nbsp;used for&nbsp;Windows Hello for&nbsp;Business* a&nbsp;vydal [PowerShell modul WHfBTools](https://support.microsoft.com/en-us/topic/using-whfbtools-powershell-module-for-cleaning-up-orphaned-windows-hello-for-business-keys-779d1f3f-bb2d-c495-0f6b-9aeb940eeafb) v&nbsp;predvečer mojej prednášky na&nbsp;konferenci Black Hat.

### Útok Shadow Credentials voči Active Directory

Počas skúmania Windows Hello for&nbsp;Business som vyvinul aj&nbsp;nástroj na&nbsp;pridávanie nových NGC kľúčov do&nbsp;AD atribútu `msDS-KeyCredentialLink`. Táto technika bola neskôr [spopularizovaná Eladom Shamirom](https://posts.specterops.io/shadow-credentials-abusing-key-trust-account-mapping-for-takeover-8ee1a53566ab) zo spoločnosti SpecterOps, ktorý pre&nbsp;ňu vymyslel názov *Shadow Credentials* (tieňové prihlasovacie údaje). Úprava atribútu `msDS-KeyCredentialLink` sa&nbsp;medzičasom stala dobre známou a&nbsp;obľúbenou technikou nielen medzi penetračnými testermi, ale&nbsp;aj&nbsp;medzi hackermi.

![Auditovanie Auditing Shadow Credentials pomocou DSInternals](/assets/images/ngc_audit.png)

Ak vie útočník upraviť tento atribút na&nbsp;nejakom účte, môže sa&nbsp;ako tento účet prihlásiť do&nbsp;AD cez&nbsp;protokol Kerberos PKINIT. To&nbsp;môže viesť buď k&nbsp;elevácii oprávnení, alebo k&nbsp;perzistencii. Vedľajším dôsledkom je, že&nbsp;je&nbsp;možné voči napadnutému účtu vykonať útok UnPAC-the-Hash a&nbsp;dostať sa&nbsp;tak k&nbsp;NT hashu používateľského hesla. Tento útok tak môžeme považovať za&nbsp;zacielený DCSync.

Moje pôvodné zdrojové kódy si&nbsp;svojim životom žijú aj&nbsp;v&nbsp;týchto hackerských nástrojoch:

- [KrbRelayUp](https://github.com/Dec0ne/KrbRelayUp)
- [Whisker](https://github.com/eladshamir/Whisker)
- [Impacket](https://github.com/SecureAuthCorp/impacket)
- [pydsinternals](https://github.com/p0dalirius/pydsinternals)

### Bezpečnostná zraniteľnosť v&nbsp;Azure AD Graph API

V roku 2020 som náhodou zistil, že&nbsp;prostredníctvom Azure AD Graph API sú&nbsp;nedopatrením sprístupnené šifrovacie kľúče DPAPI všekých používateľov ostatným používateľom daného AAD tenantu cez&nbsp;atribút `searchableDeviceKey`. Túto zraniteľnosť som nahlásil Microsoftu, ktorý ju následne ošetril.

![Zobrazenie kľúčov DPAPI pomocou DSInternals](/assets/images/aad_dpapi.png)

### Útok Silver Ticket voči Azure Active Directory

V roku 2017 som ako prvý verejne poukázal na&nbsp;možnosť vykonania [silver ticket útoku voči Azure Active Directory](/en/impersonating-office-365-users-mimikatz/), zneužitím funkcie **Seamless Single Sign-on**, ktorá v&nbsp;tom čase pritom ešte ani nebola všeobecne dostupná. Tento útok môže byť využitý k&nbsp;vydávaniu sa&nbsp;za&nbsp;ľubovoľného používateľa voči Office 365, Azure, alebo inej službe napojenej na&nbsp;Azure Active Directory.

![Silver Ticket útok voči Azure AD](/assets/images/aad_sso3.png)

Microsoft následne implementoval možnosť zmeniť heslo účtu `AZUREADSSOACC$` a&nbsp;[odporúča tak učiniť každých 30 dní](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sso-faq#how-can-i-roll-over-the-kerberos-decryption-key-of-the--azureadsso--computer-account-).

### Reverzné inžinierstvo Azure AD Connect

Dávno pred tým, než existovala [oficiálna dokumentácia](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-password-hash-synchronization#detailed-description-of-how-password-hash-synchronization-works) k&nbsp;funkcii synchronizácie hesiel v&nbsp;programe Azure Active Directory Connect, podarilo sa&nbsp;mi pomocou reverzného inžinierstva [odhaliť použitý kryptografický algoritmus](/en/how-azure-active-directory-connect-syncs-passwords/).

![OrgIdHash](/assets/images/ps_orgidhash.png)

V reakcii na&nbsp;moju spätnú väzbu zvýšil Microsoft počet iterácií SHA256 zo 100 na&nbsp;1000. A&nbsp;už&nbsp;deň po vydaní môjho článku bol do&nbsp;programu `hashcat`, populárneho nástroja na&nbsp;lámanie hesiel, pridaný [hash mode 12800 (MS-AzureSync PBKDF2-HMAC-SHA256)](https://hashcat.net/wiki/doku.php?id=example_hashes).
