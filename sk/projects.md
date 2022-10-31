---
title: Projekty
lang: sk
ref: projects
permalink: /sk/projekty/
fa_class: fas fa-download
---

## PowerShell modul DSInternals

> VAROVANIE: Funkcionalita modulu DSInternals nie je&nbsp;podporovaná firmou Microsoft a&nbsp;preto nie je&nbsp;určený pre&nbsp;produkčné nasadenie. Jeho nesprávne použitie môže spôsobiť nevratné poškodenie doménového kontroléru alebo negatívne ovplyvniť bezpečosť domény.

[PowerShell modul DSInternals](https://www.powershellgallery.com/packages/DSInternals) sprístupňuje viaceré nedokumentované funkcie Active Directory a&nbsp;Azure Active Directory. Patria medzi ne [auditovanie FIDO2 a&nbsp;NGC kľúčov](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-AzureADUserEx.md#get-azureaduserex), [offline manipulácia so súborom ntds.dit](https://github.com/MichaelGrafnetter/DSInternals/tree/master/Documentation/PowerShell#cmdlets-for-offline-active-directory-operations), [audit hesiel](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Test-PasswordQuality.md#test-passwordquality), [obnova DC z&nbsp;IFM zálohy](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/New-ADDBRestoreFromMediaScript.md#new-addbrestorefrommediascript), and&nbsp;[počítanie odtlačkov hesiel](https://github.com/MichaelGrafnetter/DSInternals/tree/master/Documentation/PowerShell#cmdlets-for-password-hash-calculation).

Asi najobľúbenejšou funkciou modulu DSInternals je [príkaz Test-PasswordQuality](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Test-PasswordQuality.md#test-passwordquality), ktorý&nbsp;vie skontrolovať heslá v&nbsp;Active Directory voči zoznamu uniknutých hesiel publikovanom na&nbsp;stránke [Have I&nbsp;Been Pwned (HIBP)](https://haveibeenpwned.com/):

![Ukážka z výstupu príkazu Test-PasswordQuality](/assets/images/dsinternals_password_quality.png)

Viac informácií o tomto module:
- [PowerShell galéria](https://www.powershellgallery.com/packages/DSInternals)
- [Dokumentácia](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Readme.md)
- [Zdrojové kódy](https://github.com/MichaelGrafnetter/DSInternals)

## .NET knižnice DSInternals

Funkcionalitu PowerShell modulu je&nbsp;možné integrovať do&nbsp;iných aplikácií pomocou 
[NuGet balíčkov pre&nbsp;.NET](https://www.nuget.org/profiles/DSInternals).

Projekt DSInternals momentálne využívajú minimálne tieto produkty:
- [Semperis Active Directory Forest Recovery](https://www.semperis.com/adf-recovery/)
- [Lithnet Password Protection for&nbsp;Active Directory](https://github.com/lithnet/ad-password-protection)
- [Thycotic Weak Password Finder](https://thycotic.com/solutions/free-it-tools/weak-password-finder/)

## Thycotic Weak Password Finder

Pre spoločnosť [Thycotic](https://thycotic.com/) som kedysi vytvoril prvú verziu programu [Thycotic Weak Password Finder for&nbsp;Active Directory](https://thycotic.com/solutions/free-it-tools/weak-password-finder/).

![Screenshot z&nbsp;programu Thycotic Weak Password Finder](/assets/images/thycotic_report1.png)

## ADMX šablóna pre&nbsp;YubiKey Smart Card Minidriver

Pred časom som vytvoril [ADMX šablónu](https://github.com/MichaelGrafnetter/yubikey-minidriver-admx), ktorá môže správcom uľahčiť centrálnu konfiguráciu [YubiKey Smart Card Minidriver](https://www.yubico.com/products/services-software/download/smart-card-drivers-tools/) cez&nbsp;Active Directory Group Policy.

![Group Policy Editor Screenshot](/assets/images/yubikey-admx.png)
