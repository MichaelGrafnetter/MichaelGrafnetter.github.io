---
ref: black-hat-usa-26-pass-the-passkey
title: 'Upcoming Talk: Pass-the-Passkey Family of&nbsp;Attacks at&nbsp;Black&nbsp;Hat&nbsp;USA&nbsp;26'
date: '2026-06-05T02:00:00+00:00'
layout: post
permalink: /en/black-hat-usa-26-pass-the-passkey/
image: /assets/images/black-hat-usa-26-logo.png
lang: en
tags:
    - Passkeys
    - WebAuthn
    - FIDO2
    - 'Entra ID'
    - Security
    - 'Black Hat'
---

[![Black Hat USA 26](../../assets/images/black-hat-usa-26-logo.png)](https://blackhat.com/us-26/briefings/schedule/?#pass-the-passkey-family-of-attacks-51821)

I will be presenting my&nbsp;latest research [**Pass-the-Passkey Family of&nbsp;Attacks**](https://blackhat.com/us-26/briefings/schedule/?#pass-the-passkey-family-of-attacks-51821) at&nbsp;[**Black Hat USA&nbsp;26**](https://blackhat.com/us-26/) in&nbsp;Las Vegas, **August&nbsp;1&ndash;6, 2026**.

Passkeys are slowly but&nbsp;steadily becoming the norm &ndash; and&nbsp;our novel research has shown that several real-world implementations are vulnerable to&nbsp;attacks fundamentally similar to&nbsp;Pass-the-Hash and&nbsp;NTLM&nbsp;Relay. We&nbsp;call this category **Pass-the-Passkey**.

In the session I&nbsp;will demonstrate:

- A&nbsp;Passkey implementation in&nbsp;a&nbsp;major cloud service that is&nbsp;vulnerable to&nbsp;the very attacks it&nbsp;was designed to&nbsp;prevent.
- Past YubiKey signatures stored in&nbsp;cleartext and&nbsp;readable by&nbsp;authenticated unprivileged users &ndash; even remote ones.
- Impersonation of&nbsp;privileged identities while bypassing phishing-resistant MFA enforcement and&nbsp;staying invisible to&nbsp;popular XDR solutions.
- Passkey phishing, tampering, spoofing, fuzzing, and&nbsp;prompt-flooding techniques &ndash; some executable from&nbsp;compromised terminal hosts or&nbsp;VMs, demonstrated against a&nbsp;popular C2 framework.

The WebAuthn specification mandates a&nbsp;22-step Passkey validation process involving non-trivial cryptography and&nbsp;transactional processing, so&nbsp;making a&nbsp;mistake while implementing the spec is&nbsp;easy &ndash; even for&nbsp;companies that co-authored the standard. By&nbsp;open-sourcing our tooling, we&nbsp;aim to&nbsp;help other penetration testers discover many more vulnerabilities stemming from&nbsp;non-compliant Passkey verification.

Also check out the&nbsp;[Black Hat Briefings talks and&nbsp;Arsenal presentations of&nbsp;my&nbsp;colleagues from&nbsp;SpecterOps](https://specterops.io/black-hat/).

See you in&nbsp;Las Vegas!
