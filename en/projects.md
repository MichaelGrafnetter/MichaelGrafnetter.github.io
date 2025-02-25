---
title: Projects
lang: en
layout: page
ref: projects
permalink: /en/projects/
redirect_from:
  - /en/downloads/
image: /assets/images/dsinternals_password_quality.png
fa_class: fas fa-download
---

## DSInternals PowerShell Module

The [DSInternals PowerShell Module](https://www.powershellgallery.com/packages/DSInternals) exposes several internal features of&nbsp;Active Directory and&nbsp;Azure Active Directory. These include [FIDO2 and&nbsp;NGC key auditing](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-AzureADUserEx.md#get-azureaduserex), [offline ntds.dit file manipulation](https://github.com/MichaelGrafnetter/DSInternals/tree/master/Documentation/PowerShell#cmdlets-for-offline-active-directory-operations), [password auditing](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Test-PasswordQuality.md#test-passwordquality), [DC recovery from&nbsp;IFM backups](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/New-ADDBRestoreFromMediaScript.md#new-addbrestorefrommediascript), and&nbsp;[password hash calculation](https://github.com/MichaelGrafnetter/DSInternals/tree/master/Documentation/PowerShell#cmdlets-for-password-hash-calculation).

The most popular feature of&nbsp;DSInternals is&nbsp;probably the&nbsp;[Test-PasswordQuality cmdlet](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Test-PasswordQuality.md#test-passwordquality), which&nbsp;can&nbsp;check Active Directory passwords against the&nbsp;list of&nbsp;leaked passwords published at [Have I&nbsp;Been Pwned (HIBP)](https://haveibeenpwned.com/):

![Sample Test-PasswordQuality output](/assets/images/dsinternals_password_quality.png)

More information on the&nbsp;DSInternals module:

- [PowerShell Gallery](https://www.powershellgallery.com/packages/DSInternals)
- [Documentation](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Readme.md)
- [Source Code](https://github.com/MichaelGrafnetter/DSInternals)

Interestingly, the&nbsp;DSInternals PowerShell module was allegedly used in&nbsp;the&nbsp;SolarWinds attacks, according to&nbsp;[Symantec's report on the&nbsp;Raindrop malware](https://symantec-enterprise-blogs.security.com/blogs/threat-intelligence/solarwinds-raindrop-malware):

![Example of&nbsp;Raindrop victim timeline](/assets/images/solorigate.webp)

> DISCLAIMER: Features exposed through this&nbsp;module are&nbsp;not supported by&nbsp;Microsoft and&nbsp;it&nbsp;is&nbsp;therefore not intended to&nbsp;be&nbsp;used in&nbsp;production environments. Improper use might cause irreversible damage to&nbsp;domain controllers or&nbsp;negatively impact domain security.

## DSInternals Framework

The same features as&nbsp;in&nbsp;the&nbsp;DSInternals PowerShell module are&nbsp;also available through the
[NuGet packages for&nbsp;.NET](https://www.nuget.org/profiles/DSInternals).

To my knowledge, the&nbsp;following products utilize DSInternals:

- [Semperis Active Directory Forest Recovery](https://www.semperis.com/adf-recovery/)
- [Lithnet Password Protection for&nbsp;Active Directory](https://github.com/lithnet/ad-password-protection)
- [Delinea Weak Password Finder](https://delinea.com/resources/weak-password-finder-tool-active-directory/)

## Domain Controller Firewall Tool

The goal of the [Domain Controller Firewall Tool (DCFWTool)](https://firewall.dsinternals.com) is to steamline the host-based firewall configuration process.
This PowerShell-based tool provides a flexible and repeatable way of deploying a secure DC firewall configuration within minutes. The accompanying whitepaper also serves as a comprehensive source of Windows Firewall-related information.

![Domain Controller Firewall Tool Visual Studio Code support](/assets/images/dc-firewall-intellisense.png)

## Administrative Template (ADMX) for&nbsp;Microsoft Defender ASR

This [custom administrative template (ADMX)](https://github.com/MichaelGrafnetter/defender-asr-admx) for Microsoft Defender Attack Surface Reduction (ASR)
greatly improves the user experience by providing a standalone setting for each ASR rule:

![Custom ADMX Group Policy Result Screenshot](/assets/images/asr-admx-group-policy-result.png)

## Entra ID Passkey Registration PowerShell Module

The [DSInternals.Passkeys PowerShell Module](https://www.powershellgallery.com/packages/DSInternals.Passkeys) can be used by Entra ID administrators to register passkeys (i.e. FIDO2 security keys or Microsoft Authenticator app) on behalf of other users:

![Screenshot of Passkey registration in Entra ID using PowerShell](/assets/images/dsinternals-passkeys.png)

To demonstrate the full capabilities of the WebAuthn Win32 API, I have also created a desktop application called [FIDO2 UI](https://github.com/MichaelGrafnetter/webauthn-interop/releases/latest) as part of this project:

![FIDO2 UI Screenshot](/assets/images/fido2-ui.png)

.NET developers can easily integrate these capabilities into their own applications by utilizing my [NuGet packages](https://www.nuget.org/packages?q=DSInternals.Win32.WebAuthn).

## Delinea Weak Password Finder

As part of&nbsp;a&nbsp;cooperation with&nbsp;[Thycotic](https://delinea.com/thycotic/) (now Delinea) I&nbsp;have developed the&nbsp;initial version of&nbsp;the&nbsp;[Weak Password Finder for&nbsp;Active Directory](https://delinea.com/resources/weak-password-finder-tool-active-directory/).

![Screenshot from&nbsp;a&nbsp;report generated by&nbsp;Delinea Weak Password Finder](/assets/images/thycotic_report1.png)

## Administrative Template (ADMX) for&nbsp;YubiKey Smart Card Minidriver

I have created [this ADMX administrative template](https://github.com/MichaelGrafnetter/yubikey-minidriver-admx) that&nbsp;allows administrators to&nbsp;easily deploy the&nbsp;configuration of&nbsp;the&nbsp;[YubiKey Smart Card Minidriver](https://www.yubico.com/products/services-software/download/smart-card-drivers-tools/) through&nbsp;the&nbsp;Active Directory Group Policy. It&nbsp;can&nbsp;also be&nbsp;used on standalone computers to&nbsp;unlock some&nbsp;features of&nbsp;the&nbsp;YubiKey Minidriver that&nbsp;are&nbsp;disabled by&nbsp;default, like controlling the&nbsp;touch policy or&nbsp;blocking the&nbsp;generation of&nbsp;unsafe keys (ROCA).

![Group Policy Editor Screenshot](/assets/images/yubikey-admx.png)

## Active Directory and&nbsp;Entra&nbsp;ID Security Research

### CVE-2024-20692: Microsoft Local Security Authority Subsystem Service Information Disclosure Vulnerability

While analyzing the&nbsp;network traffic generated by&nbsp;the&nbsp;Windows Local Security Authority Subsystem Service (LSASS), I&nbsp;discovered the&nbsp;[CVE-2024-20692](https://msrc.microsoft.com/update-guide/vulnerability/CVE-2024-20692) vulnerability. An&nbsp;attacker could exploit it&nbsp;by&nbsp;convincing, or&nbsp;waiting for, a&nbsp;user to&nbsp;connect to&nbsp;an&nbsp;Active Directory Domain Controller and&nbsp;then stealing network secrets. When&nbsp;the&nbsp;vulnerability is&nbsp;successfully exploited this&nbsp;could allow the&nbsp;attacker to&nbsp;retrieve sensitive data in&nbsp;plain-text which&nbsp;could be&nbsp;exploited for&nbsp;further attacks.

### AD Privilege Escalation through Windows Hello

In 2019 I&nbsp;have discovered multiple attack vectors against the&nbsp;implementation of&nbsp;Windows Hello for&nbsp;Business in&nbsp;Active Directory. I&nbsp;made my discoveries publicly available at the&nbsp;Black Hat Europe conference. Both the&nbsp;[recording](/en/video-black-hat-europe-2019-talk/) and&nbsp;[slide deck](/en/black-hat-europe-2019-slides/) are&nbsp;publicly available.

![ROCA Vulnerable NGC Keys in&nbsp;Active Directory](/assets/images/roca.png)

As part of&nbsp;coordinated vulnerability disclosure, Microsoft has issued the&nbsp;[ADV190026 security advisory](https://msrc.microsoft.com/update-guide/en-US/vulnerability/ADV190026) called *Microsoft Guidance for&nbsp;cleaning up orphaned keys generated on vulnerable TPMs and&nbsp;used for&nbsp;Windows Hello for&nbsp;Business* and&nbsp;released the&nbsp;[WHfBTools PowerShell module](https://support.microsoft.com/en-us/topic/using-whfbtools-powershell-module-for-cleaning-up-orphaned-windows-hello-for-business-keys-779d1f3f-bb2d-c495-0f6b-9aeb940eeafb) a&nbsp;day before&nbsp;my Black Hat talk.

### Active Directory Shadow Credentials Attack

As part of&nbsp;my research of&nbsp;Windows Hello for&nbsp;Business internals, I&nbsp;have developed routines for&nbsp;injecting NGC keys to&nbsp;the&nbsp;`msDS-KeyCredentialLink` AD attribute This&nbsp;technique was later [popularized by&nbsp;Elad Shamir](https://posts.specterops.io/shadow-credentials-abusing-key-trust-account-mapping-for-takeover-8ee1a53566ab) from&nbsp;SpecterOps, who&nbsp;coined the&nbsp;name *Shadow Credentials*. Manipulating `msDS-KeyCredentialLink` has since&nbsp;become a&nbsp;well-known technique among pentesters and&nbsp;adversaries.

![Auditing Shadow Credentials using DSInternals](/assets/images/ngc_audit.png)

If an&nbsp;attacker can&nbsp;modify this&nbsp;attribute of&nbsp;an&nbsp;account, they can&nbsp;impersonate it&nbsp;through Kerberos PKINIT. This&nbsp;can&nbsp;lead to&nbsp;either privilege escalation or&nbsp;persistence. As&nbsp;a&nbsp;side-effect, UnPAC-the-Hash attack can&nbsp;also be&nbsp;performed against the&nbsp;target account, leading to&nbsp;the&nbsp;exposure of&nbsp;its NT hash. Some&nbsp;thus call it&nbsp;a&nbsp;targeted DCSync attack.

My original code is&nbsp;currently part of&nbsp;these hacktools:

- [KrbRelayUp](https://github.com/Dec0ne/KrbRelayUp)
- [Whisker](https://github.com/eladshamir/Whisker)
- [Impacket](https://github.com/SecureAuthCorp/impacket)
- [pydsinternals](https://github.com/p0dalirius/pydsinternals)

### Security Vulnerability in&nbsp;Azure AD Graph API

In 2020 I&nbsp;have discovered that&nbsp;Azure Active Directory Graph API was exposing DPAPI encryption keys of&nbsp;every user to&nbsp;all other users in&nbsp;the&nbsp;same AAD tenant through the&nbsp;`searchableDeviceKey` user attribute. This&nbsp;security issue had already been fixed by&nbsp;Microsoft, based on my vulnerability report.

![Listing DPAPI encryption keys using DSInternals](/assets/images/aad_dpapi.png)

### Azure AD Silver Ticket Attack

In 2017 I&nbsp;was the&nbsp;first to&nbsp;publicly describe the&nbsp;possibility to&nbsp;perform the&nbsp;[silver ticket attack against Azure Active Directory](/en/impersonating-office-365-users-mimikatz/) by&nbsp;misusing the&nbsp;**Seamless Single Sign-on** feature, while&nbsp;it&nbsp;was still in&nbsp;preview. This&nbsp;attack can&nbsp;be&nbsp;used to&nbsp;impersonate any user against Office 365 or&nbsp;any other service connected to&nbsp;Azure Active Directory.

![Silver Ticket Attack against Azure AD](/assets/images/aad_sso3.png)

As a&nbsp;response to&nbsp;these security concerns, Microsoft has implemented the&nbsp;ability to&nbsp;roll over the&nbsp;password of&nbsp;the&nbsp;`AZUREADSSOACC$` account and&nbsp;[recommends doing so&nbsp;at least every 30 days](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sso-faq#how-can-i-roll-over-the-kerberos-decryption-key-of-the--azureadsso--computer-account-).

### Azure AD Password Hash Synchronization Reverse Engineering

Long before&nbsp;Microsoft had [proper documentation](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-password-hash-synchronization#detailed-description-of-how-password-hash-synchronization-works) on the&nbsp;Azure Active Directory password hash synchronization feature, I&nbsp;was able to&nbsp;reverse engineer the&nbsp;Azure AD Connect tool and&nbsp;[discover the&nbsp;exact hash function used by&nbsp;Azure Active Directory](/en/how-azure-active-directory-connect-syncs-passwords/).

![OrgIdHash](/assets/images/ps_orgidhash.png)

As a&nbsp;response to&nbsp;my feedback, Microsoft has increased the&nbsp;number of&nbsp;SHA256 iterations from&nbsp;100 to&nbsp;1000. Also based on my original article, the&nbsp;algorithm had been implemented in&nbsp;`hashcat`, a&nbsp;popular password cracking tool, as&nbsp;[hash mode 12800 (MS-AzureSync PBKDF2-HMAC-SHA256)](https://hashcat.net/wiki/doku.php?id=example_hashes).
