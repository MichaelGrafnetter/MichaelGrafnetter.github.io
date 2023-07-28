---
ref: aad-azure-ad-mfa-authentication-methods
title: Authentication Methods Available in&nbsp;Azure Active Directory
date: '2023-03-31T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/cover/aad-authentication-methods.png
permalink: /en/aad-azure-ad-mfa-authentication-methods/
---

## Authentication Method Comparison

| Method                                   | [PHR] | [Passwordless] | [SSPR] | Winlogon | [RDP (AD)] | [RDP (AAD)] | [RADIUS] | [Mobile] | [Web] | Primary Factor | 2<sup>nd</sup> Factor |
|------------------------------------------|-------|----------------|------|-----------|------------|-------------|----------|----------|-------|----------------|------------|
| Password Only                            | ❌    |     ❌        |  ✅  |   ✅      |     ✅     |      ✅     |   ✅     |    ✅   |   ✅  |    ✅          |    ❌     |
| [FIDO2 Security Key]                     | ✅    |     ✅        |  ❌  |   ✅      |      ◐     |      ✅     |   ❌     |    ◐   |   ✅  |    ✅          |    ✅     |
| [Microsoft Authenticator (Push)]         | ❌    |     ❌        |  ✅  |   ❌      |     ❌     |      ✅     |   ✅     |    ✅   |   ✅  |    ❌          |    ✅     |
| [Microsoft Authenticator (Passwordless)] | ❌    |     ✅        |  ❌  |   ❌      |     ❌     |      ✅     |   ❌     |    ✅   |   ✅  |    ✅          |    ❌     |
| [Windows Hello for Business]             | ✅    |     ✅        |  ❌  |   ✅      |      ◐     |      ✅     |   ❌     |    ❌   |   ✅  |    ✅          |    ❌     |
| [Certificate on a Smart Card]            | ✅    |     ✅        |  ❌  |   ✅      |     ✅     |      ✅     |   ✅     |    ◐    |   ✅  |    ✅          |    ✅     |
| [Software TOTP Token]                    | ❌    |     ❌        |  ✅  |   ❌      |     ❌     |      ✅     |   ✅     |    ✅   |   ✅  |    ❌          |    ✅     |
| [Hardware OATH Token]                    | ❌    |     ❌        |  ✅  |   ❌      |     ❌     |      ✅     |   ✅     |    ✅   |   ✅  |    ❌          |    ✅     |
| [SMS]                                    | ❌    |     ❌        |  ✅  |   ❌      |     ❌     |      ✅     |   ✅     |    ✅   |   ✅  |    ✅          |    ✅     |
| [Temporary Access Pass]                  | ❌    |     ❌        |  ❌  |   ✅      |      ◐     |      ✅     |   ❌     |    ✅   |   ✅  |    ✅          |    ❌     |
| [Voice Call]                             | ❌    |     ❌        |  ✅  |   ❌      |     ❌     |      ✅     |   ✅     |    ✅   |   ✅  |    ❌          |    ✅     |
| [Email OTP]                              | ❌    |     ❌        |  ✅  |   ❌      |     ❌     |      ✅     |   ❌     |    ✅   |   ✅  |    ✅          |    ❌     |
| [Security Questions]                     | ❌    |     ❌        |  ✅  |   ❌      |     ❌     |      ❌     |   ❌     |    ❌   |   ❌  |    ❌          |    ❌     |

[RDP (AD)]: https://learn.microsoft.com/en-us/troubleshoot/windows-server/remote/understanding-remote-desktop-protocol
[RADIUS]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/howto-mfa-nps-extension
[Web]: https://azure.microsoft.com/en-us/get-started/azure-portal
[Mobile]: https://www.microsoft.com/en-us/security/mobile-authenticator-app
[RDP (AAD)]: https://learn.microsoft.com/en-us/windows/client-management/connect-to-remote-aadj-pc
[SSPR]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-sspr-howitworks
[Passwordless]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-passwordless
[PHR]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-strengths#authentication-strengths
[FIDO2 Security Key]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-passwordless#fido2-security-keys
[Microsoft Authenticator (Push)]:https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-authenticator-app#notification-through-mobile-app
[Microsoft Authenticator (Passwordless)]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-authenticator-app#passwordless-sign-in
[Windows Hello for Business]:https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-passwordless#windows-hello-for-business
[Certificate on a Smart Card]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-certificate-based-authentication
[Software TOTP Token]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-oath-tokens#oath-software-tokens
[Hardware OATH Token]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-oath-tokens#oath-hardware-tokens-preview
[SMS]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/howto-authentication-sms-signin
[Temporary Access Pass]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/howto-authentication-temporary-access-pass
[Voice Call]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-phone-options#phone-call-verification
[Email OTP]: https://learn.microsoft.com/en-us/azure/active-directory/external-identities/one-time-passcode
[Security Questions]: https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-security-questions

## Notes

- The&nbsp;table does not cover Federated MFA.
- RDP to&nbsp;AD-only joined devices with&nbsp;FIDO2 Security Keys, Windows Hello for&nbsp;Business, and&nbsp;Temporary Access Pass only works with&nbsp;the&nbsp;Remote Credential Guard and&nbsp;Restricted Admin features. The&nbsp;Azure AD Kerberos trust is&nbsp;required in&nbsp;some&nbsp;scenarios.
- Smart card support depends on the&nbsp;specific OS and&nbsp;HW combination used.
- FIDO2 security keys [do not work on Android phones yet](https://learn.microsoft.com/en-us/azure/active-directory/authentication/fido2-compatibility?source=recommendations#supported-browsers).
- Even though mobile phones do not directly support Windows Hello for Business, it can still be used indirectly in the Microsoft Authenticator app with the OAuth 2.0 device code authentication flow:

  ![Microsoft Authenticator device code authentication flow screenshot](/assets/images/ios-oauth-device-code-authentication-flow.png)

## Disclaimer

The&nbsp;table might have gotten outdated since&nbsp;it&nbsp;had been created. Feel free to&nbsp;ping me if&nbsp;you discover any errors in&nbsp;it.
