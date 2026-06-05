---
ref: black-hat-usa-26-pass-the-passkey
title: 'Pripravovaná prednáška: Pass-the-Passkey Family of&nbsp;Attacks na&nbsp;Black&nbsp;Hat&nbsp;USA&nbsp;26'
date: '2026-06-05T02:00:00+00:00'
layout: post
permalink: /sk/black-hat-usa-26-pass-the-passkey/
image: /assets/images/black-hat-usa-26-logo.png
lang: sk
tags:
    - Passkeys
    - WebAuthn
    - FIDO2
    - 'Entra ID'
    - Prednášky
    - Security
    - 'Black Hat'
---

[![Black Hat USA 26](../../assets/images/black-hat-usa-26-logo.png)](https://blackhat.com/us-26/briefings/schedule/?#pass-the-passkey-family-of-attacks-51821)

Na&nbsp;konferencii [**Black Hat USA&nbsp;26**](https://blackhat.com/us-26/) v&nbsp;Las Vegas, v&nbsp;termíne **1.&ndash;6.&nbsp;augusta 2026**, budem prezentovať svoj najnovší výskum [**Pass-the-Passkey Family of&nbsp;Attacks**](https://blackhat.com/us-26/briefings/schedule/?#pass-the-passkey-family-of-attacks-51821).

Passkey sa&nbsp;postupne stávajú novým štandardom prihlasovania &ndash; a&nbsp;náš výskum ukázal, že niektoré reálne implementácie sú zraniteľné voči útokom, ktoré sú principiálne podobné Pass-the-Hash a&nbsp;NTLM&nbsp;Relay. Túto kategóriu útokov sme nazvali **Pass-the-Passkey**.

V&nbsp;prednáške ukážem:

- Implementáciu Passkey vo&nbsp;významnej cloudovej službe, ktorá je&nbsp;zraniteľná práve voči tým útokom, pred ktorými mala chrániť.
- Historické podpisy generované YubiKey kľúčmi uložené v&nbsp;čitateľnej podobe, ku&nbsp;ktorým majú prístup aj&nbsp;bežní (aj&nbsp;vzdialení) autentifikovaní používatelia.
- Impersonáciu privilegovaných identít s&nbsp;obídením vynucovania phishing-resistant MFA a&nbsp;bez&nbsp;detekcie populárnymi XDR riešeniami.
- Phishing, tampering, spoofing, fuzzing a&nbsp;prompt-flooding útoky proti Passkeys &ndash; niektoré z&nbsp;nich spustiteľné aj&nbsp;z&nbsp;kompromitovaných terminálových serverov alebo VM, prezentované cez populárnu C2 infraštruktúru.

Špecifikácia WebAuthn predpisuje 22-krokový proces validácie Passkey s&nbsp;netriviálnou kryptografiou a&nbsp;transakčnou logikou, takže urobiť pri&nbsp;implementácii chybu je&nbsp;jednoduché &ndash; dokonca aj&nbsp;pre&nbsp;firmy, ktoré sa&nbsp;na&nbsp;tvorbe štandardu podieľali. Otvorením zdrojového kódu nášho nástroja chceme ostatným pentesterom pomôcť odhaľovať ďalšie zraniteľnosti spôsobené nesprávnou verifikáciou Passkey.

Pozrite si tiež&nbsp;[Black Hat Briefings prednášky a&nbsp;Arsenal prezentácie mojich kolegov zo&nbsp;SpecterOps](https://specterops.io/black-hat/).

Uvidíme sa v&nbsp;Las Vegas!
