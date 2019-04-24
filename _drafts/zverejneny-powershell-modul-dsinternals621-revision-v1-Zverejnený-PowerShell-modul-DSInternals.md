---
id: 3861
title: Zverejnený PowerShell modul DSInternals
date: 2015-07-14T17:17:37+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/621-revision-v1/
permalink: /621-revision-v1/
---
<p style="text-align: justify;">
  Po dlhšom váhaní a prosbách účastníkov mojich prednášok som sa rozhodol zverejniť PowerShell modul DSInternals v sekcii <a title="Na stiahnutie" href="https://www.dsinternals.com/sk/na-stiahnutie/">Na stiahnutie</a>. Zatiaľ je to bez dokumentácie, takže <em>Get-Help</em> nebude dávať pekný výsledok, ale pracujem na tom.
</p>

### Príklady použitia

<pre title="Príklady použitia" class="lang:ps decode:true">Import-Module DSInternals
$pwd = ConvertTo-SecureString 'Pa$$W0rd' -AsPlainText -Force

# Výpočet NT a&nbsp;LM hashu
$ntHash = ConvertTo-NTHash $pwd
$lmHash = ConvertTo-LMHash $pwd

# Nastavenie hashu hesla v&nbsp;AD cez&nbsp;protokol SAMR
Set-SamAccountPasswordHash -SamAccountName john -Domain ADATUM -NTHash $ntHash -Server dc1.adatum.com

# Výpočet OrgId hashu, ktorý sa&nbsp;posiela do&nbsp;Azure Active Directory
ConvertTo-OrgIdHash -NTHash $ntHash

# Dešifrovanie hesla z&nbsp;Group Policy Preferences
ConvertFrom-GPPrefPassword 'v9NWtCCOKEUHkZBxakMd6HLzo4+DzuizXP83EaImqF8'

# Dešifrovanie hesla zo súboru unattend.xml
ConvertFrom-UnattendXmlPassword 'UABhACQAJAB3ADAAcgBkAEEAZABtAGkAbgBpAHMAdAByAGEAdABvAHIAUABhAHMAcwB3AG8AcgBkAA=='</pre>

### Hlásenie chýb

Ak náhodou natrafíte na nejakú chybu v module DSInternals, budem veľmi rád, ak ma na ňu upozorníte [e-mailom](https://www.dsinternals.com/sk/kontakt/ "Kontakt").

### Plánované funkcie

Do&nbsp;budúcna by&nbsp;som chcel rozšíriť PowerShell modul aj o tieto funkcie:

  * <del>Offline úprava súboru ntds.dit, hlavne atribútov sIDHistory a&nbsp;primaryGroupID.</del> **Hotovo**
  * Autoritatívny restore AD objektov na úrovni jednotlivých atribútov.
  * <del>Vzdialený export hashov používateľských hesiel.</del> **Hotovo**
  * Funkčný Get-Help
  * MSI inštalátor