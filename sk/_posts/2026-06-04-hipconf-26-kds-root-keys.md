---
ref: hipconf-26-kds-root-keys
title: 'Pripravovaná prednáška: KDS Root Keys and&nbsp;Where to&nbsp;Find Them na&nbsp;HIP&nbsp;Conf&nbsp;26'
date: '2026-06-04T00:00:00+00:00'
layout: post
permalink: /sk/hipconf-26-kds-root-keys/
image: /assets/images/hip-conf-26-logo.png
lang: sk
tags:
    - 'Active Directory'
    - BitLocker
    - LAPS
    - Prednášky
    - Security
    - HIP Conf
---

[![HIP Conf 26 &ndash; Nashville](../../assets/images/hip-conf-26-logo.png)](https://semperis.swoogo.com/hipconf26/agenda)

Po&nbsp;tom, čo svoj nový výskum o&nbsp;KDS Root Keys predstavím európskemu publiku na&nbsp;TROOPERS26 v&nbsp;Heidelbergu, sa&nbsp;veľmi teším na&nbsp;možnosť odprezentovať ho&nbsp;aj&nbsp;americkému publiku v&nbsp;ikonickom Nashville. Budem prednášať na&nbsp;konferencii [Hybrid Identity Protection Conference&nbsp;26](https://semperis.swoogo.com/hipconf26/agenda) v&nbsp;Nashville (Tennessee, USA) v&nbsp;termíne **8.&ndash;10.&nbsp;septembra 2026**. Moja prednáška *KDS Root Keys and&nbsp;Where to&nbsp;Find Them* je&nbsp;zaradená na&nbsp;**stredu 9.&nbsp;septembra o&nbsp;11:15** v&nbsp;tracku Identity Security Research.

KDS Root Keys sú kryptografické semienka, z&nbsp;ktorých Active Directory odvodzuje heslá pre&nbsp;gMSA a&nbsp;dMSA účty, šifruje tajomstvá Windows&nbsp;LAPS a&nbsp;zabezpečuje DPAPI-NG SID protectory. Ich&nbsp;získanie útočníkovi otvorí oveľa viac dverí, než&nbsp;len jeden účet. V&nbsp;prednáške ukážem online aj&nbsp;offline útoky prakticky proti&nbsp;všetkým spôsobom použitia KDS Root Keys, vrátane:

- Dešifrovania zväzkov chránených BitLocker SID Protectorom.
- Exportu súkromných RSA kľúčov zo&nbsp;skupinovo chránených PFX súborov.
- Získavania DNSSEC podpisových kľúčov (ZSK a&nbsp;KSK) z&nbsp;Active Directory.
- Obnovy connection stringov k&nbsp;databázam v&nbsp;ASP.NET Core aplikáciách.
- Hromadného exportu hesiel Windows LAPS a&nbsp;DSRM.
- Offline generovania hesiel pre&nbsp;gMSA a&nbsp;dMSA účty.

Predstavím aj&nbsp;novo objavený univerzálny útok proti&nbsp;DPAPI-NG SID protectorom, ktorý dokáže odšifrovať ľubovoľné tajomstvo bez&nbsp;nutnosti písať dešifrovač špecifický pre&nbsp;konkrétnu aplikáciu.

Uvidíme sa v&nbsp;Nashville!
