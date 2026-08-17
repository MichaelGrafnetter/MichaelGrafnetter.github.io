---
ref: black-hat-usa-26-pass-the-passkey
title: 'Pass-the-Passkey Family of&nbsp;Attacks na&nbsp;Black&nbsp;Hat&nbsp;USA&nbsp;26'
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

![Black Hat USA 26](../../assets/images/black-hat-usa-26-logo.png)

Prednáška **Pass-the-Passkey Family of&nbsp;Attacks** odznela na&nbsp;konferencii **Black Hat USA&nbsp;26** v&nbsp;Las Vegas **5.&nbsp;augusta&nbsp;2026**.

Publikované materiály sú teraz dostupné tu:

- [<i class="fas fa-file-pdf"></i>  Slide deck](../../assets/documents/bhus26-grafnetter-pass-the-passkey-slides.pdf)
- [<i class="fas fa-file-pdf"></i>  Whitepaper](../../assets/documents/pass-the-passkey-a4-v2.pdf)
- [<i class="fab fa-github"></i>  Nástroje: Pass-the-Passkey](https://github.com/SpecterOps/pass-the-passkey)
- [<i class="fab fa-github"></i>  Nástroje: WebAuthn Interop / Passkey UI / DSInternals.Passkeys](https://github.com/MichaelGrafnetter/webauthn-interop)

Passkey sa&nbsp;postupne stávajú novým štandardom prihlasovania &ndash; a&nbsp;náš výskum ukázal, že niektoré reálne implementácie sú zraniteľné voči útokom, ktoré sú principiálne podobné Pass-the-Hash a&nbsp;NTLM&nbsp;Relay. Túto kategóriu útokov sme nazvali **Pass-the-Passkey**.

V&nbsp;prednáške som ukázal:

- Implementáciu Passkey vo&nbsp;významnej cloudovej službe, ktorá je&nbsp;zraniteľná práve voči tým útokom, pred ktorými mala chrániť.
- Historické podpisy generované YubiKey kľúčmi uložené v&nbsp;čitateľnej podobe, ku&nbsp;ktorým majú prístup aj&nbsp;bežní (aj&nbsp;vzdialení) autentifikovaní používatelia.
- Impersonáciu privilegovaných identít s&nbsp;obídením vynucovania phishing-resistant MFA a&nbsp;bez&nbsp;detekcie populárnymi XDR riešeniami.
- Phishing, tampering, spoofing, fuzzing a&nbsp;prompt-flooding útoky proti Passkeys &ndash; niektoré z&nbsp;nich spustiteľné aj&nbsp;z&nbsp;kompromitovaných terminálových serverov alebo VM, prezentované cez populárnu C2 infraštruktúru.

Špecifikácia WebAuthn predpisuje 22-krokový proces validácie Passkey s&nbsp;netriviálnou kryptografiou a&nbsp;transakčnou logikou, takže urobiť pri&nbsp;implementácii chybu je&nbsp;jednoduché &ndash; dokonca aj&nbsp;pre&nbsp;firmy, ktoré sa&nbsp;na&nbsp;tvorbe štandardu podieľali. Otvorením zdrojového kódu našich nástrojov chceme ostatným pentesterom pomôcť odhaľovať ďalšie zraniteľnosti spôsobené nesprávnou verifikáciou Passkey.

Ďakujem všetkým, ktorí sa&nbsp;prednášky zúčastnili a&nbsp;poskytli spätnú väzbu.
