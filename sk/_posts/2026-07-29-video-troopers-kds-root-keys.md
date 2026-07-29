---
ref: video-troopers-kds-root-keys
title: 'Video: KDS Root Keys: All&nbsp;Secrets Finally Revealed'
date: '2026-07-29T00:00:00+00:00'
layout: post
permalink: /sk/video-troopers-kds-root-keys/
image: /assets/images/cover/troopers-kds-root-keys.jpg
lang: sk
tags:
    - 'Active Directory'
    - BitLocker
    - LAPS
    - Prednášky
    - Security
    - Video
    - TROOPERS
---

Záznam mojej prednášky z&nbsp;konferencie [TROOPERS26](https://troopers.de/) s&nbsp;názvom [**KDS Root Keys: All Secrets Finally Revealed**](https://troopers.de/troopers26/talks/fpkkra/):

{% include youtube.html id="ULpr1LUAhIc" title="TROOPERS26: KDS Root Keys: All Secrets Finally Revealed" %}

[![TROOPERS26 &ndash; Heidelberg](../../assets/images/troopers-26-logo.svg){: width="150px" style="float: left; margin-right: 10px" }](https://troopers.de/troopers26/talks/fpkkra/) Prednáška sa&nbsp;venuje online aj&nbsp;offline útokom prakticky proti&nbsp;všetkým spôsobom použitia KDS Root Keys, vrátane:

- Dešifrovania zväzkov chránených BitLocker SID Protectorom.
- Exportu súkromných RSA kľúčov zo&nbsp;skupinovo chránených PFX súborov.
- Získavania DNSSEC podpisových kľúčov (ZSK a&nbsp;KSK) z&nbsp;Active Directory.
- Obnovy connection stringov k&nbsp;databázam v&nbsp;ASP.NET Core aplikáciách.
- Hromadného exportu hesiel Windows LAPS a&nbsp;DSRM.
- Offline generovania hesiel pre&nbsp;gMSA a&nbsp;dMSA účty.

V&nbsp;prednáške predstavujem aj&nbsp;novo objavený univerzálny útok proti&nbsp;DPAPI-NG SID protectorom, ktorý dokáže odšifrovať ľubovoľné tajomstvo bez&nbsp;nutnosti písať dešifrovač špecifický pre&nbsp;konkrétnu aplikáciu.

[<i class="fas fa-file-pdf"></i> Slajdy z&nbsp;prednášky](../../assets/documents/troopers-kds-root-keys.pdf)
