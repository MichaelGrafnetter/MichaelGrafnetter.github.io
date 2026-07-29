---
ref: video-troopers-kds-root-keys
title: 'Video: KDS Root Keys: All&nbsp;Secrets Finally Revealed'
date: '2026-07-29T00:00:00+00:00'
layout: post
permalink: /en/video-troopers-kds-root-keys/
image: /assets/images/cover/troopers-kds-root-keys.jpg
lang: en
tags:
    - 'Active Directory'
    - BitLocker
    - LAPS
    - Security
    - Video
    - TROOPERS
---

Recording of&nbsp;my [TROOPERS26](https://troopers.de/) talk, [**KDS Root Keys: All Secrets Finally Revealed**](https://troopers.de/troopers26/talks/fpkkra/):

{% include youtube.html id="ULpr1LUAhIc" title="TROOPERS26: KDS Root Keys: All Secrets Finally Revealed" %}

[![TROOPERS26 &ndash; Heidelberg](../../assets/images/troopers-26-logo.svg){: width="150px" style="float: left; margin-right: 10px" }](https://troopers.de/troopers26/talks/fpkkra/) The talk dives into online and&nbsp;offline attacks against virtually every use case of&nbsp;KDS Root Keys, including:

- Decryption of&nbsp;volumes with BitLocker SID Protector enabled.
- Exporting RSA private keys from&nbsp;group-protected PFX files.
- Extracting DNSSEC signing keys (ZSK and&nbsp;KSK) from&nbsp;Active Directory.
- Recovering ASP.NET Core database connection strings.
- Bulk export of&nbsp;Windows LAPS and&nbsp;DSRM passwords.
- Generation of&nbsp;gMSA and&nbsp;dMSA passwords offline.

The talk also covers a&nbsp;newly discovered universal attack against DPAPI-NG SID protectors, allowing any application-encrypted secret to&nbsp;be unlocked without application-specific decryptors.

[<i class="fas fa-file-pdf"></i> TROOPERS26 slide deck](../../assets/documents/troopers-kds-root-keys.pdf)
