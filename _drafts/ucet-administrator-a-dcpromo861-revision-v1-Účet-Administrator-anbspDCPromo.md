---
id: 2781
title: 'Účet Administrator a&nbsp;DCPromo'
date: 2015-05-28T11:00:07+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/861-revision-v1/
permalink: /861-revision-v1/
---
<p align="justify">
  Vedeli ste, že potom, čo vytvoríte novú Active Directory doménu pomocou nástroja dcpromo (resp. cez&nbsp;Server Manager od&nbsp;Windows Server 2012), musíte zmeniť heslo účtu Administrator? Bez toho bude voči tomuto účtu fungovať Kerberos autentizácia iba so&nbsp;zastaralým šifrovaním RC4, ale už nie s moderným a bezpečným AES, ani s prehistorickým DES (nefunkčnosť DESu je vlastne skôr výhoda). Obdobne Vám nepôjde ani Digest autentizácia, kým NTLM pobeží bez problémov. Skoro nikto o tom nevie a v dokumentácii sa&nbsp;to tiež nedozviete.
</p>

<p align="justify">
  Prečo je&nbsp;tomu tak? Než pustíte dcpromo, lokálny účet Administrator je uložený v SAM databáze, kde sú heslá ukladané iba vo forme NT hashu (tzn. MD4). Potom, čo server povýšite  prvý doménový kontrolér v novovytvorenej doméne, SAM databáza sa&nbsp;prestane používať a účet Administrator sa&nbsp;aj s heslom naimportuje do Active Directory databázy a stane sa&nbsp;z neho prvý člen Domain Admins a&nbsp;ďalších privilegovaných skupín. Stále na ňom ale bude nastavený iba MD4 hash, ktorý sa&nbsp;využije pri NTLM alebo Kerberos RC4-HMAC autentizácii, no kľúče pre AES256, AES128, DES a Digest (MD5) budú prázdne. Až pri najbližšej zmene hesla sa&nbsp;všetky tieto kľúče vygenerujú a korektne uložia do databázy.
</p>

<p align="justify">
  Rada na&nbsp;záver: Z bezpečnostných dôvodov by ste samozrejme doménový účet Administrator nielenže nemali používať, ale mal by byť v ideálnom prípade zakázaný. Pri dodržiavaní tohto pravidla by&nbsp;ste na chovanie popisované v&nbsp;tomto článku nemali naraziť.
</p>