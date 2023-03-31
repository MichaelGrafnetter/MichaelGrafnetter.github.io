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

| Method                                   | [PHR] | [Passwordless] | [SSPR] | Desktop | [RDP (AD)] | [RDP (AAD)] | [RADIUS] | [Mobile] | [Web] | Primary Factor | 2<sup>nd</sup> Factor |
|------------------------------------------|-------|----------------|------|-----------|------------|-------------|----------|----------|-------|----------------|------------|
| Password Only                            | ❌    |     ❌        |  ✅  |   ✅      |     ✅     |      ✅     |   ✅     |    ✅   |   ✅  |    ✅          |    ❌     |
| [FIDO2 Security Key]                     | ✅    |     ✅        |  ❌  |   ✅      |     ✅     |      ✅     |   ❌     |    ✅   |   ✅  |    ✅          |    ❌     |
| [Microsoft Authenticator (Push)]         | ❌    |     ❌        |  ✅  |   ❌      |     ❌     |      ✅     |   ✅     |    ✅   |   ✅  |    ❌          |    ✅     |
| [Microsoft Authenticator (Passwordless)] | ❌    |     ✅        |  ❌  |   ❌      |     ❌     |      ✅     |   ❌     |    ✅   |   ✅  |    ✅          |    ❌     |
| [Windows Hello for Business]             | ✅    |     ✅        |  ❌  |   ✅      |     ✅     |      ✅     |   ❌     |    ❌   |   ✅  |    ✅          |    ❌     |
| [Certificate on a Smart Card]            | ✅    |     ✅        |  ❌  |   ✅      |     ✅     |      ✅     |   ✅     |    ✅   |   ✅  |    ✅          |    ❌     |
| [Software TOTP Token]                    | ❌    |     ❌        |  ✅  |   ❌      |     ❌     |      ✅     |   ✅     |    ✅   |   ✅  |    ❌          |    ✅     |
| [Hardware OATH Token]                    | ❌    |     ❌        |  ✅  |   ❌      |     ❌     |      ✅     |   ✅     |    ✅   |   ✅  |    ❌          |    ✅     |
| [SMS]                                    | ❌    |     ❌        |  ✅  |   ❌      |     ❌     |      ✅     |   ✅     |    ✅   |   ✅  |    ✅          |    ✅     |
| [Temporary Access Pass]                  | ❌    |     ❌        |  ❌  |   ✅      |     ✅     |      ✅     |   ❌     |    ✅   |   ✅  |    ✅          |    ❌     |
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

- The table does not cover Federated MFA.
- RDP to AD-only joined devices with FIDO2 Security Keys, Windows Hello for Business, and Temporary Access Pass only work with the Remote Credential Guard and Restricted Admin features. The Azure AD Kerberos trust is required in some scenarios.
- The table might have gotten outdated since it had been created. Feel free to ping me if you discover any errors in it.