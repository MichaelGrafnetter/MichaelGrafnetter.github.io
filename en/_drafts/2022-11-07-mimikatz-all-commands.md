---
ref: mimikatz-all-commands
title: 🥝 The Ultimate List of Mimikatz Commands
date: '2022-11-07T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/mimikatz_backupkeys.png
permalink: /en/mimikatz-all-commands/
---

## Introduction

This document is&nbsp;yet&nbsp;another attempt to&nbsp;create a&nbsp;comprehensive list of&nbsp;all [mimikatz](https://github.com/gentilkiwi/mimikatz) commands and&nbsp;their parameters. This&nbsp;is&nbsp;easier said than&nbsp;done, as&nbsp;new features are&nbsp;being added to&nbsp;mimikatz quite regularly and&nbsp;this&nbsp;guide is&nbsp;thus doomed to&nbsp;become outdated sooner or&nbsp;later. But&nbsp;hey, it's [hosted on GitHub](https://github.com/MichaelGrafnetter/MichaelGrafnetter.github.io/blob/main/en/_posts/2022-11-07-mimikatz-all-commands.md), so&nbsp;feel free to&nbsp;create a&nbsp;pull request if&nbsp;you find anything missing.

```yml
Synced to mimikatz version: 2.2.0 20191222
```

These are&nbsp;some&nbsp;other great information sources on mimikatz:

- 🥝 Benjamin Delpy's (the author of&nbsp;mimikatz) [Twitter @gentilkiwi](https://twitter.com/gentilkiwi)
- Sean Metcalf's [Unofficial Guide to&nbsp;Mimikatz & Command Reference](https://adsecurity.org/?page_id=1821)
- Charlie Bromberg's [The Hacker Recipes](https://tools.thehacker.recipes/mimikatz/modules)

## Mimikatz 101

| Command            | Description |
|--------------------|-------------|
| `::`               | List all mimikatz modules. |
| `standard::`       | List all commands in&nbsp;the&nbsp;`standard` module. |
| `standard::answer` | Run the&nbsp;`answer` command from&nbsp;the&nbsp;standard module. |
| `answer`           | Run the&nbsp;`answer` command from&nbsp;the&nbsp;standard module. Note that&nbsp;commands in&nbsp;the&nbsp;`standard` module do&nbsp;not need to&nbsp;be&nbsp;prefixed by&nbsp;module name with&nbsp;double colons. |

<!--more-->

## Standard Module

Basic mimikatz commands that&nbsp;do&nbsp;not require the&nbsp;module name to&nbsp;be&nbsp;specified.

### standard::exit

| Command | Description   |
|---------|---------------|
| `exit`  | Quit mimikatz |

#### Example

```
mimikatz # exit
Bye!
```

### standard::cls

| Command | Description |
|---------|-------------|
| `cls`   | Clear the&nbsp;screen (doesn't work with&nbsp;redirections, like PsExec) |

### standard::answer

| Command | Description
|---------|--
`answer` | Prints the&nbsp;answer to&nbsp;the&nbsp;Ultimate Question of&nbsp;Life, the&nbsp;Universe, and&nbsp;Everything

#### Example

```
mimikatz # answer
42.
```

### standard::coffee

Command | Description
--|--
`coffee` |  Please, make me some&nbsp;coffee!

#### Example

```
mimikatz # coffee

    ( (
     ) )
  .______.
  |      |]
  \      /
   `----'
```

### standard::sleep

| Command     | Description |
|-------------|-------------|
| `sleep`     | Sleep for&nbsp;1 second. |
| `sleep <N>` | Sleep for&nbsp;the&nbsp;specified amount of&nbsp;milliseconds. |

#### Example 1
```
mimikatz # sleep
Sleep : 1000 ms... End !
```

#### Example 2
```
mimikatz # sleep 2000
Sleep : 2000 ms... End !
```

### standard::log

| Command               | Description   |
|-----------------------|---------------|
| `log`                 | Start logging mimikatz input and&nbsp;output into a&nbsp;file called *mimikatz.log*. |
| `log <Log file path>` | Start logging mimikatz input and&nbsp;output into the&nbsp;specified file. |
| `log /stop`           | Stop logging. |

#### Example 1

```
mimikatz # log
Using 'mimikatz.log' for logfile : OK
```

#### Example 2

```
mimikatz # log /stop
Using '(null)' for logfile : OK
```

### standard::base64

Command | Description
--|--
`base64` | Display the&nbsp;current state of&nbsp;base64 settings.
`base64 /in:<true/false> /out:<true/false>` | Switch the&nbsp;file input/output to&nbsp;the&nbsp;base64 encoding.

#### Example 1

```
mimikatz # base64
isBase64InterceptInput  is false
isBase64InterceptOutput is false
```

#### Example 2

```
mimikatz # base64 /in:true /out:false
isBase64InterceptInput  is true
isBase64InterceptOutput is false
```

### standard::version

| Command         | Description                                        |
|-----------------|----------------------------------------------------|
| `version`       | Displays mimikatz and Windows version information. |
| `version /full` | Also displays versions of SSPI DLLs.               |
| `version /cab`  | Packs all Windows SSPI DLLs into a cabinet file.   |

#### Example 1

```
mimikatz # version

mimikatz 2.2.0 (arch x64)
Windows NT 10.0 build 22000 (arch x64)
msvc 150030729 207

> SecureKernel is running
> Credential Guard may be running
```

#### Example 2

```
mimikatz # version /full

mimikatz 2.2.0 (arch x64)
Windows NT 10.0 build 22000 (arch x64)
msvc 150030729 207

> SecureKernel is running
> Credential Guard may be running

lsasrv.dll      : 10.0.22000.978
msv1_0.dll      : 10.0.22000.856
tspkg.dll       : 10.0.22000.739
wdigest.dll     : 10.0.22000.434
kerberos.dll    : 10.0.22000.918
dpapisrv.dll    : 10.0.22000.978
cryptdll.dll    : 10.0.22000.653
samsrv.dll      : 10.0.22000.918
rsaenh.dll      : 10.0.22000.282
ncrypt.dll      : 10.0.22000.1
ncryptprov.dll  : 10.0.22000.856
wevtsvc.dll     : 10.0.22000.978
termsrv.dll     : 10.0.22000.708
```

#### Example 3

```
mimikatz # version /cab

mimikatz 2.2.0 (arch x64)
Windows NT 10.0 build 22000 (arch x64)
msvc 150030729 207

> SecureKernel is running
> Credential Guard may be running

CAB: mimikatz_x64_sysfiles_22000
 -> lsasrv.dll
 -> msv1_0.dll
 -> tspkg.dll
 -> wdigest.dll
 -> kerberos.dll
 -> dpapisrv.dll
 -> cryptdll.dll
 -> samsrv.dll
 -> rsaenh.dll
 -> ncrypt.dll
 -> ncryptprov.dll
 -> wevtsvc.dll
 -> termsrv.dll
```

### standard::cd

| Command     | Description                                  |
|-------------|----------------------------------------------|
| `cd`        | Displays the&nbsp;current working directory. |
| `cd <PATH>` | Changes the&nbsp;working directory.          |

#### Example 1

```
mimikatz # cd
C:\mimikatz\x64
```

#### Example 2

```
mimikatz # cd C:\Windows
Cur: C:\mimikatz\x64
New: C:\Windows
```

### standard::localtime

| Command     | Description                                           |
|-------------|-------------------------------------------------------|
| `localtime` | Displays system local date and&nbsp;time (OJ command) |

#### Example

```
mimikatz # localtime
Local: 11/6/2022 6:23:36 PM
Zone : Central European Standard Time
UTC  : 11/6/2022 5:23:36 PM
```

### standard::hostname

Command | Description
--|--
`hostname` | Displays the&nbsp;name the&nbsp;local computer.

#### Example

```
mimikatz # hostname
PC1.contoso.com (PC1)
```

## Kernel Driver Module

For more information on this&nbsp;module, see Matt Hand's article [Mimidrv In&nbsp;Depth: Exploring Mimikatz’s Kernel Driver](https://posts.specterops.io/mimidrv-in-depth-4d273d19e148).

### !+

| Command | Description                    |
|---------|--------------------------------|
| `!+`    | Load the `mimidrv.sys` driver. |

#### Example

```
mimikatz # !+
[*] 'mimidrv' service not present
[+] 'mimidrv' service successfully registered
[+] 'mimidrv' service ACL to everyone
[+] 'mimidrv' service started
```

### !-

| Command | Description                      |
|---------|----------------------------------|
| `!-`    | Unload the `mimidrv.sys` driver. |

#### Example

```
mimikatz # !-
[+] 'mimidrv' service stopped
[+] 'mimidrv' service removed
```

### !ping

| Command | Description                                |
|---------|--------------------------------------------|
| `!ping` | Ping the `mimidrv.sys` kernel mode driver. | 

#### Example

```
mimikatz # !ping
Input  : (null)
Output : pong
```

### !bsod

| Command | Description                      |
|---------|----------------------------------|
| `!bsod` | Invoke the Blue Screen of Death. |

### !filters

| Command    | Description                     |
|------------|---------------------------------|
| `!filters` | List filesystem filter drivers. |

#### Example

```
mimikatz # !filters
[00] \FileSystem\FltMgr
```

### !minifilters

| Command        | Description                         |
|----------------|-------------------------------------|
| `!minifilters` | List filesystem minifilter drivers. |

```
mimikatz # !minifilters
[00] bindflt
[01] DfsDriver
[02] DfsrRo
[03] storqosflt
[04] wcifs
[05] CldFlt
[06] FileCrypt
[07] npsvctrig
  [00] \Device\NamedPipe
    [0x19] READ
      PostCallback : 0xFFFFF80185DA8010 [npsvctrig.sys + 0x8010]
    [0x1a] WRITE
      PostCallback : 0xFFFFF80185DA8160 [npsvctrig.sys + 0x8160]
    [0x26] SHUTDOWN
      PostCallback : 0xFFFFF80185DA1010 [npsvctrig.sys + 0x1010]
[08] Wof
  [00] \Device\HarddiskVolume5
    [0x18] CLOSE
      PreCallback  : 0xFFFFF80181DD0010 [Wof.sys + 0x20010]
      PostCallback : 0xFFFFF80181DD16C0 [Wof.sys + 0x216c0]
    [0x19] READ
      PreCallback  : 0xFFFFF80181DD6D00 [Wof.sys + 0x26d00]
      PostCallback : 0xFFFFF80181DD65A0 [Wof.sys + 0x265a0]
    [0x1c] SET_INFORMATION
      PreCallback  : 0xFFFFF80181DB18B0 [Wof.sys + 0x18b0]
      PostCallback : 0xFFFFF80181DB2670 [Wof.sys + 0x2670]
    [0x1d] QUERY_EA
      PreCallback  : 0xFFFFF80181DB2460 [Wof.sys + 0x2460]
      PostCallback : 0xFFFFF80181DB3600 [Wof.sys + 0x3600]
    [0x1e] SET_EA
      PostCallback : 0xFFFFF80181DD80E0 [Wof.sys + 0x280e0]
    [0x1f] FLUSH_BUFFERS
      PreCallback  : 0xFFFFF80181DD0690 [Wof.sys + 0x20690]
      PostCallback : 0xFFFFF80181DD85B0 [Wof.sys + 0x285b0]
    [0x25] INTERNAL_DEVICE_CONTROL
      PreCallback  : 0xFFFFF80181DD78A0 [Wof.sys + 0x278a0]
    [0x26] SHUTDOWN
      PreCallback  : 0xFFFFF80181DD8870 [Wof.sys + 0x28870]
      PostCallback : 0xFFFFF80181DD2DE0 [Wof.sys + 0x22de0]
    [0x2b] SET_SECURITY
      PostCallback : 0xFFFFF80181DD53E0 [Wof.sys + 0x253e0]
```

### !modules

| Command    | Description              |
|------------|--------------------------|
| `!modules` | List the loaded drivers. |

#### Example

```
mimikatz # !modules
0xFFFFF8017FE0F000 - 17068032   ntoskrnl.exe
0xFFFFF8017FDA0000 - 24576      hal.dll
0xFFFFF8017FDB0000 - 45056      kd.dll
0xFFFFF8017F9F0000 - 3686400    mcupdate_GenuineIntel.dll
0xFFFFF80181000000 - 442368     CLFS.SYS
0xFFFFF8017FDC0000 - 163840     tm.sys
0xFFFFF80181070000 - 106496     PSHED.dll
0xFFFFF8017FDF0000 - 45056      BOOTVID.dll
0xFFFFF801811B0000 - 462848     FLTMGR.SYS
0xFFFFF80181260000 - 393216     msrpc.sys
0xFFFFF80181230000 - 167936     ksecdd.sys
0xFFFFF80181090000 - 1122304    clipsp.sys
0xFFFFF801812D0000 - 57344      cmimcext.sys
0xFFFFF80181910000 - 1556480    NDIS.SYS
0xFFFFF80185A40000 - 634880     mrxsmb.sys
0xFFFFF80185AE0000 - 110592     mpsdrv.sys
0xFFFFF80185B00000 - 311296     mrxsmb20.sys
0xFFFFF80185B50000 - 192512     rdpdr.sys
0xFFFFF8019C600000 - 1662976    HTTP.sys
0xFFFFF8019C7A0000 - 843776     peauth.sys
0xFFFFF8019C870000 - 81920      tcpipreg.sys
0xFFFFF8019CA50000 - 57344      mimidrv.sys
...
```

### !notifImage

| Command       | Description                                                        |
|---------------|--------------------------------------------------------------------|
| `!notifImage` | List drivers registered for image load (DLL or EXE) notifications. |

### !notifObject

| Command        | Description                                       |
|----------------|---------------------------------------------------|
| `!notifObject` | List drivers registered for object notifications. |

#### Example

```
mimikatz # !notifobject

 * Desktop
        Open        - 0xFFFFF801804810B0 [ntoskrnl.exe + 0x6720b0]
        Close       - 0xFFFFF80180500240 [ntoskrnl.exe + 0x6f1240]
        Delete      - 0xFFFFF8018050F510 [ntoskrnl.exe + 0x700510]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]
        OkayToClose - 0xFFFFF801804FF320 [ntoskrnl.exe + 0x6f0320]

 * Process
        Open        - 0xFFFFF801805B7D20 [ntoskrnl.exe + 0x7a8d20]
        Close       - 0xFFFFF801804F2070 [ntoskrnl.exe + 0x6e3070]
        Delete      - 0xFFFFF801805C13E0 [ntoskrnl.exe + 0x7b23e0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * RegistryTransaction
        Close       - 0xFFFFF8018050CF60 [ntoskrnl.exe + 0x6fdf60]
        Delete      - 0xFFFFF80180523E50 [ntoskrnl.exe + 0x714e50]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

  * File
        Close       - 0xFFFFF8018055AF80 [ntoskrnl.exe + 0x74bf80]
        Delete      - 0xFFFFF8018055AD00 [ntoskrnl.exe + 0x74bd00]
        Parse       - 0xFFFFF801804F3E80 [ntoskrnl.exe + 0x6e4e80]
        Security    - 0xFFFFF80180465410 [ntoskrnl.exe + 0x656410]
        QueryName   - 0xFFFFF80180466A50 [ntoskrnl.exe + 0x657a50]

 * Semaphore
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * EtwConsumer
        Open        - 0xFFFFF80180500E30 [ntoskrnl.exe + 0x6f1e30]
        Close       - 0xFFFFF80180512AF0 [ntoskrnl.exe + 0x703af0]
        Delete      - 0xFFFFF801805257C0 [ntoskrnl.exe + 0x7167c0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * FilterConnectionPort
        Close       - 0xFFFFF80181208630 [FLTMGR.SYS + 0x58630]
        Delete      - 0xFFFFF801812086C0 [FLTMGR.SYS + 0x586c0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Device
        Delete      - 0xFFFFF801805D0F00 [ntoskrnl.exe + 0x7c1f00]
        Parse       - 0xFFFFF8018055B230 [ntoskrnl.exe + 0x74c230]
        Security    - 0xFFFFF80180465410 [ntoskrnl.exe + 0x656410]

 * Directory
        Close       - 0xFFFFF801804FC660 [ntoskrnl.exe + 0x6ed660]
        Delete      - 0xFFFFF80180514290 [ntoskrnl.exe + 0x705290]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Thread
        Open        - 0xFFFFF801805B7C60 [ntoskrnl.exe + 0x7a8c60]
        Delete      - 0xFFFFF8018047AC30 [ntoskrnl.exe + 0x66bc30]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * PowerRequest
        Close       - 0xFFFFF801804C97E0 [ntoskrnl.exe + 0x6ba7e0]
        Delete      - 0xFFFFF801804CA410 [ntoskrnl.exe + 0x6bb410]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Driver
        Delete      - 0xFFFFF80180646D70 [ntoskrnl.exe + 0x837d70]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]
...
```

### !notifProcess

| Command         | Description |
|-----------------|-------------|
| `!notifProcess` | List drivers registered for process creation/termination notifications. |

```
mimikatz # !notifProcess
[00] 0xFFFFF80181406540 [cng.sys + 0x6540]
[01] 0xFFFFF8018124B4B0 [ksecdd.sys + 0x1b4b0]
[02] 0xFFFFF801822C7660 [tcpip.sys + 0x47660]
[03] 0xFFFFF801813894B0 [CI.dll + 0x794b0]
[04] 0xFFFFF80182C1A390 [dxgkrnl.sys + 0x1a390]
[05] 0xFFFFF8019C7DACF0 [peauth.sys + 0x3acf0]
```

### !notifReg

| Command     | Description                                               |
|-------------|-----------------------------------------------------------|
| `!notifReg` | List drivers registered for registry event notifications. |

### !notifThread

| Command        | Description                                             |
|----------------|---------------------------------------------------------|
| `!notifThread` | List drivers registered for thread event notifications. |

### !process

| Command    | Description                                 |
|------------|---------------------------------------------|
| `!process` | List processes running on the lcoal system. |

#### Example

```
mimikatz # !process
4       System          F-Tok   Sig 1e/1c [2-0-7]
100     Registry        F-Tok   Sig 00/00 [2-0-7]
344     smss.exe        F-Tok   Sig 3e/0c [1-0-6]
456     csrss.exe       F-Tok   Sig 3e/0c [1-0-6]
536     wininit.exe     F-Tok   Sig 3e/0c [1-0-6]
604     winlogon.exe    F-Tok   Sig 0c/00 [0-0-0]
672     services.exe    F-Tok   Sig 3e/0c [1-0-6]
692     lsass.exe       F-Tok   Sig 0c/00 [0-0-0]
900     svchost.exe     F-Tok   Sig 00/00 [0-0-0]
4460    LogonUI.exe     F-Tok   Sig 00/00 [0-0-0]
3596    win32calc.exe   F-Tok   Sig 00/00 [0-0-0]
5756    WmiPrvSE.exe    F-Tok   Sig 00/00 [0-0-0]
7120    msedge.exe      F-Tok   Sig 08/08 [0-0-0]
6940    mimikatz.exe    F-Tok   Sig 00/00 [0-0-0]
4508    conhost.exe     F-Tok   Sig 00/00 [0-0-0]
...
```

### !processPrivilege

| Command                      | Description                                     |
|------------------------------|-------------------------------------------------|
| `!processPrivilege`          | Grants all privileges to the current process.   |
| `!processPrivilege /pid:<N>` | Grants all privileges to the specified process. |

#### Example 1

```
mimikatz # !processPrivilege
All privileges for the access token from 3792/mimikatz.exe
```

#### Example 2
```
mimikatz # !processPrivilege /pid:708
All privileges for the access token from 708/lsass.exe
```

### !processProtect

Add or removes the process protection flag of a process.

| Parameter   | Description |
|-------------|-------------|
| `/process:` |
| `/pid:`     |
| `/remove`   |

#### Example

```
```

### !processToken

| Parameter   | Description |
|-------------|-------------|
| `/from:`    |
| `/to:`      |

### !sysenvdel

| Parameter      | Description |
|----------------|-------------|
| `/name:`       |
| `/guid:`       |
| `/attributes:` |

### !sysenvset

| Parameter   | Description |
|-------------|-------------|
`/name:` |
`/guid:` |
`/attributes:` |
`/data:` |

### !ssdt


#### Example
```
mimikatz # !ssdt
KeServiceDescriptorTable : 0xFFFFF80180C108C0 (477)
[    0] 0xFFFFF801801621E0 [ntoskrnl.exe + 0x3531e0]
[    1] 0xFFFFF801800A2900 [ntoskrnl.exe + 0x293900]
[    2] 0xFFFFF80180515BB0 [ntoskrnl.exe + 0x706bb0]
[    3] 0xFFFFF80180763730 [ntoskrnl.exe + 0x954730]
[    4] 0xFFFFF8018057F430 [ntoskrnl.exe + 0x770430]
[    5] 0xFFFFF8018022B170 [ntoskrnl.exe + 0x41c170]
[    6] 0xFFFFF80180571EA0 [ntoskrnl.exe + 0x762ea0]
[    7] 0xFFFFF80180583D90 [ntoskrnl.exe + 0x774d90]
[    8] 0xFFFFF801805710C0 [ntoskrnl.exe + 0x7620c0]
...
```

## Crypto Module

### crypto::providers

Command | Description
--|--
`crypto::providers` | Lists cryptographic providers.

#### Example

```
mimikatz # crypto::providers

CryptoAPI providers :
 0. RSA_FULL      ( 1)   - Microsoft Base Cryptographic Provider v1.0
 1. DSS_DH        (13)   - Microsoft Base DSS and Diffie-Hellman Cryptographic Provider
 2. DSS           ( 3)   - Microsoft Base DSS Cryptographic Provider
 3. RSA_FULL      ( 1) H - Microsoft Base Smart Card Crypto Provider
 4. DH_SCHANNEL   (18)   - Microsoft DH SChannel Cryptographic Provider
 5. RSA_FULL      ( 1)   - Microsoft Enhanced Cryptographic Provider v1.0
 6. DSS_DH        (13)   - Microsoft Enhanced DSS and Diffie-Hellman Cryptographic Provider
 7. RSA_AES       (24)   - Microsoft Enhanced RSA and AES Cryptographic Provider
 8. RSA_SCHANNEL  (12)   - Microsoft RSA SChannel Cryptographic Provider
 9. RSA_FULL      ( 1)   - Microsoft Strong Cryptographic Provider

CryptoAPI provider types:
 0. RSA_FULL      ( 1) - RSA Full (Signature and Key Exchange)
 1. DSS           ( 3) - DSS Signature
 2. RSA_SCHANNEL  (12) - RSA SChannel
 3. DSS_DH        (13) - DSS Signature with Diffie-Hellman Key Exchange
 4. DH_SCHANNEL   (18) - Diffie-Hellman SChannel
 5. RSA_AES       (24) - RSA Full and AES

CNG providers :
 0. Microsoft Key Protection Provider
 1. Microsoft Passport Key Storage Provider
 2. Microsoft Platform Crypto Provider
 3. Microsoft Primitive Provider
 4. Microsoft Smart Card Key Storage Provider
 5. Microsoft Software Key Storage Provider
 6. Microsoft SSL Protocol Provider
 7. Windows Client Key Protection Provider
 ```

### crypto::stores

Command | Description
--|--
`crypto::stores` | Lists certificate stores from&nbsp;the&nbsp;`CURRENT_USER` store location.
`crypto::stores /systemstore:<Store Location>` | Lists certificate stores from&nbsp;the&nbsp;specified location.

Possible values for&nbsp;the&nbsp;`/systemstore` parameter are:
- CURRENT_USER
- LOCAL_MACHINE
- CURRENT_SERVICE
- SERVICES
- USERS
- USER_GROUP_POLICY
- LOCAL_MACHINE_GROUP_POLICY
- LOCAL_MACHINE_ENTERPRISE

For more info on this&nbsp;topic, see the&nbsp;documentation for&nbsp;[System Store Locations](https://learn.microsoft.com/en-us/windows/win32/seccrypto/system-store-locations). 

#### Example 1

```
mimikatz # crypto::stores
Asking for System Store 'CURRENT_USER' (0x00010000)
 0. My
 1. Root
 2. Trust
 3. CA
 4. UserDS
 5. TrustedPublisher
 6. Disallowed
 7. AuthRoot
 8. TrustedPeople
 9. ClientAuthIssuer
10. ACRS
11. Local NonRemovable Certificates
12. REQUEST
13. SmartCardRoot
```

#### Example 2

```
mimikatz # crypto::stores /systemstore:LOCAL_MACHINE
Asking for System Store 'LOCAL_MACHINE' (0x00020000)
 0. My
 1. Root
 2. Trust
 3. CA
 4. TrustedPublisher
 5. Disallowed
 6. AuthRoot
 7. TrustedPeople
 8. ClientAuthIssuer
 9. FlightRoot
10. TestSignRoot
11. ACRS
12. Remote Desktop
13. REQUEST
14. SmartCardRoot
15. TrustedAppRoot
16. TrustedDevices
17. Windows Live ID Token Issuer
18. WindowsServerUpdateServices
```

### crypto::certificates

Lists or exports certificates from the specified store.

| Parameter | Description |
| `/export` |
| `/systemstore:` |
| `/store:` |
| `/silent` |
| `/nokey` |

Possible values for&nbsp;the&nbsp;`/systemstore` parameter are:
- CURRENT_USER
- LOCAL_MACHINE
- CURRENT_SERVICE
- SERVICES
- USERS
- USER_GROUP_POLICY
- LOCAL_MACHINE_GROUP_POLICY
- LOCAL_MACHINE_ENTERPRISE

Possible values for&nbsp;the&nbsp;`/store` parameter include:
- My
- Root
- Remote Desktop
- Trust
- CA
- TrustedPublisher
- ACRS
- ADDRESSBOOK
- AuthRoot
- ClientAuthIssuer
- 'Disallowed
- eSIM Certification Authorities
- FlightRoot
- Homegroup Machine Certificates
- ipcu
- Local NonRemovable Certificates
- REQUEST
- SmartCardRoot
- TestSignRoot'
- TrustedDevices
- TrustedPeople
- UserDS
- Windows Live ID Token Issuer

### crypto::keys

Lists or exports private keys containers.

Parameter | Description
--|--
`/export` |
`/provider:` |
`/providerype:` |
`/cngprovider:` |
`/machine` |
`/silent` |

Possible values for&nbsp;the&nbsp;`/cngprovider` parameter include:
- Microsoft Software Key Storage Provider
- Microsoft Smart Card Key Storage Provider
- Microsoft Platform Crypto Provider
- Microsoft Key Protection Provider
- Microsoft Passport Key Storage Provider
- Microsoft Primitive Provider
- Microsoft SSL Protocol Provider
- Windows Client Key Protection Provider

Possible values for&nbsp;the&nbsp;`/provider` parameter include:
- MS_DEF_DH_SCHANNEL_PROV
- MS_DEF_DSS_DH_PROV
- MS_DEF_DSS_PROV
- MS_DEF_PROV
- MS_DEF_RSA_SCHANNEL_PROV
- MS_DEF_RSA_SIG_PROV
- MS_ENH_DSS_DH_PROV
- MS_ENH_RSA_AES_PROV
- MS_ENHANCED_PROV
- MS_SCARD_PROV
- MS_STRONG_PROV

Possible values for&nbsp;the&nbsp;`/providerype` parameter include:
- PROV_RSA_FULL
- PROV_RSA_AES
- PROV_RSA_SIG
- PROV_RSA_SCHANNEL
- PROV_DSS
- PROV_DSS_DH
- PROV_DH_SCHANNEL
- PROV_FORTEZZA
- PROV_MS_EXCHANGE
- PROV_SSL

### crypto::sc

Command | Description
--|--
`crypto::sc` | Lists smartcard readers.

#### Example

```
mimikatz # crypto::sc
SmartCard readers:
 * Alcorlink USB Smart Card Reader 0
   | Vendor: Alcorlink
   | Model : USB Smart Card Reader
   ATR  : 3b1696417374726964

 * Avtor KP375-BLE 0
   | Vendor: Avtor
   | Model : KP375-BLE
```

### crypto::hash

Hash a&nbsp;password with&nbsp;optional username

Parameter | Description
--|--
`/password:` |
`/user:` |
`/count:` |

### crypto::system

Describe a&nbsp;Windows System Certificate (file, registry or&nbsp;hive)

Parameter | Description
--|--
`/export` |
`/file:` |

### crypto::scauth

Create an&nbsp;authentication certitifate (smartcard like) from&nbsp;a&nbsp;CA

Parameter | Description
--|--
`/caname:` |
`/upn:` |
`/pfx:` |
`/castore:` |
`/hw` |
`/csp:` |
`/pin:` |
`/nostore` |
`/crldp:` |
`/keysize:` |
`/cahash:` |
`/cn:` |
`/o:` |
`/ou:` |
`/c:` |

CSPs:
'MS_DEF_DH_SCHANNEL_PROV',
        'MS_DEF_DSS_DH_PROV',
        'MS_DEF_DSS_PROV',
        'MS_DEF_PROV',
        'MS_DEF_RSA_SCHANNEL_PROV',
        'MS_DEF_RSA_SIG_PROV',
        'MS_ENH_DSS_DH_PROV',
        'MS_ENH_RSA_AES_PROV',
        'MS_ENHANCED_PROV',
        'MS_SCARD_PROV',
        'MS_STRONG_PROV'

### crypto::certtohw

Try to&nbsp;export a&nbsp;software CA to&nbsp;a&nbsp;crypto (virtual)hardware

Parameter | Description
--|--
`/store:` |
`/name:` |
`/csp:` |
`/pin:` |


CSPs:
'MS_DEF_DH_SCHANNEL_PROV',
        'MS_DEF_DSS_DH_PROV',
        'MS_DEF_DSS_PROV',
        'MS_DEF_PROV',
        'MS_DEF_RSA_SCHANNEL_PROV',
        'MS_DEF_RSA_SIG_PROV',
        'MS_ENH_DSS_DH_PROV',
        'MS_ENH_RSA_AES_PROV',
        'MS_ENHANCED_PROV',
        'MS_SCARD_PROV',
        'MS_STRONG_PROV'

### crypto::capi

Command | Description
--|--
`crypto::capi` | Patch CryptoAPI layer for&nbsp;easy export


### crypto::cng

Command | Description
--|--
`crypto::cng` | Patch CNG service for&nbsp;easy export

### crypto::extract

Command | Description
--|--
`crypto::extract` | Extract keys from&nbsp;CAPI RSA/AES provider

### crypto::kutil

Command | Description
--|--
`crypto::kutil` |

### crypto::tpminfo

Command | Description
--|--
`crypto::tpminfo` |

```
mimikatz # crypto::tpminfo
TPM-Version:2.0 -Level:0-Revision:1.16-VendorID:'MSFT'-Firmware:538247443.1394722
```

## SekurLsa Module

Some commands to&nbsp;enumerate credentials...

### sekurlsa::msv

Command | Description
--|--
`sekurlsa::msv` | Lists LM & NTLM credentials

### sekurlsa::wdigest

Command | Description
--|--
`sekurlsa::wdigest` | Lists WDigest credentials

### sekurlsa::kerberos

Command | Description
--|--
`sekurlsa::kerberos` | Lists Kerberos credentials

### sekurlsa::tspkg

Command | Description
--|--
`sekurlsa::tspkg` | Lists TsPkg credentials

### sekurlsa::livessp

Command | Description
--|--
`sekurlsa::livessp` | Lists LiveSSP credentials

### sekurlsa::cloudap

Command | Description
--|--
`sekurlsa::cloudap` | Lists CloudAp credentials

### sekurlsa::ssp

Command | Description
--|--
`sekurlsa::ssp` | Lists SSP credentials

### sekurlsa::logonPasswords

Command | Description
--|--
`sekurlsa::logonPasswords` | Lists all available providers credentials

### sekurlsa::process

Command | Description
--|--
`sekurlsa::process` | Switch (or reinit) to&nbsp;LSASS process  context

#### Example
```
mimikatz # sekurlsa::process
Switch to PROCESS
```

### sekurlsa::minidump

Command | Description
--|--
`sekurlsa::minidump` | Switch (or reinit) to&nbsp;LSASS minidump context

### sekurlsa::bootkey

Command | Description
--|--
`sekurlsa::bootkey` | Set the&nbsp;SecureKernel Boot Key to&nbsp;attempt to&nbsp;decrypt LSA Isolated credentials

### sekurlsa::pth

Pass-the-hash

Parameter | Description
--|--
`/user:` |
`/domain:` |
`/luid:` |
`/ntlm:` |
`/aes128:` |
`/aes256:` |
`/impersonate` |
`/run:` |

### sekurlsa::krbtgt

Command | Description
--|--
`sekurlsa::krbtgt` |
### sekurlsa::dpapisystem

Command | Description
--|--
`sekurlsa::dpapisystem` | DPAPI_SYSTEM secret

### sekurlsa::trust

Command | Description
--|--
`sekurlsa::trust` | Antisocial

### sekurlsa::backupkeys

Command | Description
--|--
`sekurlsa::backupkeys` | Preferred Backup Master keys
`sekurlsa::backupkeys /export` |

### sekurlsa::tickets

Command | Description
--|--
`sekurlsa::backupkeys` | List Kerberos tickets
`sekurlsa::backupkeys /export` |

### sekurlsa::ekeys

Command | Description
--|--
`sekurlsa::ekeys` | List Kerberos Encryption Keys

### sekurlsa::dpapi

Command | Description
--|--
`sekurlsa::dpapi` | List Cached MasterKeys

### sekurlsa::credman

Command | Description
--|--
`sekurlsa::credman` | List Credentials Manager

## Kerberos Authenticatin Package Module

### kerberos::ptt

Command | Description
--|--
`kerberos::ptt <PATH TO *.kirbi>` | Pass-the-ticket

### kerberos::list

List ticket(s)

Command | Description
--|--
`kerberos::list` |
`kerberos::list /export` |

### kerberos::ask

Ask or&nbsp;get TGS tickets

Parameter | Description
--|--
`/target:` | /target examples: 'cifs', 'ldap', 'host', 'rpcss', 'http', 'mssql', 'wsman'
`/rc4` |
`/des` |
`/aes128` |
`/aes256` |
`/tkt` |
`/export` |
`/nocache` |

### kerberos::tgt

Command | Description
--|--
`kerberos::tgt` | Retrieve current TGT

### kerberos::purge

Command | Description
--|--
`kerberos::purge` | Purge ticket(s)

### kerberos::golden

Willy Wonka factory

Parameter | Description
--|--
`/ptt` |
`/user:` |
`/domain:` |
`/des:` |
`/rc4:` |
`/aes128:` |
`/aes256:` |
`/service:` |
`/target:` |
`/krbtgt:` |
`/startoffset:` |
`/endin:` |
`/renewmax:` |
`/sid:` |
`/id:` |
`/groups:` |
`/sids:` |
`/claims:` |
`/rodc:` |
`/ticket:` |

### kerberos::hash

Hash password to&nbsp;keys

Parameter | Description
--|--
`/password:` |
`/user:` |
`/domain:` |
`/count:` |

### kerberos::ptc

Pass-the-ccache

### kerberos::clist

Command | Description
--|--
`kerberos::clist` | List tickets in&nbsp;MIT/Heimdall ccache
`kerberos::clist /export` |

## NGC Module

ext Generation Cryptography module (kiwi use only)  [Some commands to&nbsp;enumerate credentials...]

### ngc::logondata

### ngc::pin

Try do&nbsp;decrypt a&nbsp;PIN Protector

### ngc::sign

### ngc::decrypt

### ngc::enum

## Privileges Module

### privilege::debug

Command | Description
--|--
`privilege::debug` | Ask debug privilege

#### Example

```
mimikatz # privilege::debug
Privilege '20' OK
```

### privilege::driver

Ask load driver privilege

#### Example

```
mimikatz # privilege::driver
Privilege '10' OK
```

### privilege::security

Ask security privilege

#### Example

```
mimikatz # privilege::security
Privilege '8' OK
```

### privilege::tcb

Ask tcb privilege

#### Example

```
mimikatz # privilege::tcb
Privilege '7' OK
```

### privilege::backup

Ask backup privilege

#### Example

```
mimikatz # privilege::backup
Privilege '17' OK
```

### privilege::restore

Ask restore privilege

#### Example

```
mimikatz # privilege::restore
Privilege '18' OK
```

### privilege::sysenv

Ask system environment privilege

#### Example

```
mimikatz # privilege::sysenv
Privilege '22' OK
```

### privilege::id

Command | Description
--|--
`privilege::id <Privilege ID>` | Asks for&nbsp;a&nbsp;privilege by&nbsp;its id.

#### Example

```
mimikatz # privilege::id 20
Privilege '20' OK
```

### privilege::name

Command | Description
--|--
`privilege::name <Privilege name>` | Asks for&nbsp;a&nbsp;privilege by&nbsp;its name.

#### Example

```
mimikatz # privilege::name SeBackupPrivilege
Privilege '17' OK
```

## Processes Module

### process::list

List process

#### Example

```
mimikatz # process::list
0       (null)
4       System
100     Registry
344     smss.exe
456     csrss.exe
536     wininit.exe
544     csrss.exe
604     winlogon.exe
672     services.exe
692     lsass.exe
900     svchost.exe
3596    win32calc.exe
5756    WmiPrvSE.exe
6940    mimikatz.exe
4508    conhost.exe
...
```

### process::exports

List exports

/pid:

### process::imports

List imports

/pid:

### process::start

Start a&nbsp;process

### process::stop

Terminate a&nbsp;process

/pid:

### process::suspend

Suspend a&nbsp;process

/pid:

### process::resume

Resume a&nbsp;process

/pid:

### process::run

### process::runp

/run: /ppid: /token

## Service Module

### service::start

Start service

### service::remove

Remove service

### service::stop

Stop service

### service::suspend

Suspend service

### service::resume

Resume service

### service::preshutdown

Preshutdown service

### service::shutdown

Shutdown service

### service::list

List services

### service::+

Install Me!

### service::-

Uninstall Me!

### service::me

Me!

## LsaDump Module

### lsadump::sam

Get the&nbsp;SysKey to&nbsp;decrypt SAM entries (from registry or&nbsp;hives)

/system: /sam:

### lsadump::secrets

Get the&nbsp;SysKey to&nbsp;decrypt SECRETS entries (from registry or&nbsp;hives)

/system: /security:

### lsadump::cache

Get the&nbsp;SysKey to&nbsp;decrypt NL$KM then MSCache(v2) (from registry or&nbsp;hives)

### lsadump::lsa

Ask LSA Server to&nbsp;retrieve SAM/AD entries (normal, patch on the&nbsp;fly or&nbsp;inject)

/patch /inject /id: /user:

### lsadump::trust

Ask LSA Server to&nbsp;retrieve Trust Auth Information (normal or&nbsp;patch on the&nbsp;fly)

/system: /patch

### lsadump::backupkeys

/system: /export /secret /guid:

### lsadump::rpdata

/system: /name: /export /secret

### lsadump::dcsync

Ask a&nbsp;DC to&nbsp;synchronize an&nbsp;object

/all /user: /guid: /domain: /dc: /altservice: /export /csv

/altservice: examples: 'cifs', 'ldap', 'host', 'rpcss', 'http', 'mssql', 'wsman'

### lsadump::dcshadow

They told me I&nbsp;could be&nbsp;anything I&nbsp;wanted, so&nbsp;I&nbsp;became a&nbsp;domain controller

/object: /domain: /attribute: /value: /clean /multiple /replOriginatingUid: /replOriginatingUsn: /replOriginatingTime: /dynamic /dc: /computer: /push /stack /viewstack /clearstack /manualregister /manualpush /manualunregister /addentry /remotemodify /viewreplication /kill: /config /schema /root

### lsadump::setntlm

Ask a&nbsp;server to&nbsp;set a&nbsp;new password/ntlm for&nbsp;one user

/password: /ntlm: /server: /user: /rid:

### lsadump::changentlm

Ask a&nbsp;server to&nbsp;set a&nbsp;new password/ntlm for&nbsp;one user

/oldpassword: /oldntlm: /newpassword: /newntlm: /server: /user: /rid:

### lsadump::netsync

Ask a&nbsp;DC to&nbsp;send current and&nbsp;previous NTLM hash of&nbsp;DC/SRV/WKS

/dc: /user: /ntlm: /account: /computer:

### lsadump::packages

### lsadump::mbc

### lsadump::zerologon

### lsadump::postzerologon

## Terminal Server Module

### ts::multirdp

patch Terminal Server service to&nbsp;allow multiples users

### ts::sessions

/server:

### ts::remote

/id: /target: /password:

### ts::logonpasswords

try to&nbsp;get passwords from&nbsp;running sessions

### ts::mstsc

try to&nbsp;get passwords from&nbsp;mstsc process

## Event Module

### evcent::drop

Patch Events service to&nbsp;avoid new events

### event::clear

Clears an&nbsp;event log

Command | Description
---|---
`event::clear` |
`event::clear /log:` |

## Miscellaneous Module

### misc::cmd

Command Prompt          (without DisableCMD)

### misc::regedit

Registry Editor         (without DisableRegistryTools)

### misc::taskmgr

Task Manager            (without DisableTaskMgr)

### misc::ncroutemon

Juniper Network Connect (without route monitoring)

### misc::detours

Try to&nbsp;enumerate all modules with&nbsp;Detours-like hooks

### misc::memssp

### misc::skeleton

/letaes

### misc::compress

### misc::lock

/process:

### misc::wp

/file: /process:

### misc::mflt

#### Example

```
mimikatz # misc::mflt
0 0     409800 bindflt
0 0     405000 DfsDriver
0 0     261100 DfsrRo
0 0     244000 storqosflt
0 0     189900 wcifs
0 0     180451 CldFlt
0 0     141100 FileCrypt
0 1      46000 npsvctrig
0 1      40700 Wof
```

### misc::easyntlmchall

### misc::clip

### misc::xor

### misc::aadcookie

### misc::ngcsign

### misc::spooler

### misc::efs

### misc::printnightmare

### misc::sccm

### misc::shadowcopies

### misc::djoin

### misc::citrix

## Process Token Manipulation Module

### token::whoami

Display current identity

### token::list

List all tokens of&nbsp;the&nbsp;system

Parameter | Description
--|--
`/user:` |
`/id:` |
`/system` |
`/admin` |
`/domainadmin` |
`/enterpriseadmin` |

### token::elevate

Impersonate a&nbsp;token

/user: /id: /system /admin /domainadmin /enterpriseadmin

### token::run

/process: /user: /id:

### token::revert

Revert to&nbsp;proces token

## Windows Vault/Credential Module

### vault::list

/attributes

### vault::cred

/patch

## MineSweeper Module

### minesweeper::infos

## Net Module

### net::user

### net::group

### net::alias

### net::session

### net::wsession

### net::tod

### net::stats

### net::share

### net::serverinfo

### net::trust

/server:

### net::deleg

/dns /server:

### net::if

## DPAPI Module
DPAPI Module (by API or&nbsp;RAW access)  [Data Protection application programming interface]

### dpapi::blob

Describe a&nbsp;DPAPI blob, unprotect it&nbsp;with&nbsp;API or&nbsp;Masterkey

'dpapi::blob' = '/in: /raw: /out: /ascii /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::protect

Protect a&nbsp;data via a&nbsp;DPAPI call
'dpapi::protect' = '/data: /description: /entropy: /machine /system /prompt /c /out:'

### dpapi::masterkey

Describe a&nbsp;Masterkey file, unprotect each Masterkey (key depending)
'dpapi::masterkey' = '/in: /protected /sid: /hash: /system: /password: /pvk: /rpc /dc: /domain:'

### dpapi::credhist

Describe a&nbsp;Credhist file

'dpapi::credhist' = '/in: /sid: /password: /sha1:'


### dpapi::create

Create a&nbsp;Masterkey file from&nbsp;raw key and&nbsp;metadata

### dpapi::capi

CAPI key test
'dpapi::capi' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::cng

CNG key test

'dpapi::cng' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::tpm

TPM key test

### dpapi::cred

'dpapi::cred' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::vault

'dpapi::vault' = '/cred: /policy: /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::wifi

'dpapi::wifi' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::wwan

'dpapi::wwan' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::chrome

'dpapi::chrome' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::ssh

SSH Agent registry cache
'dpapi::ssh' = '/hive: /impersonate /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::rdg

RDG saved passwords
'dpapi::rdg' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::ps

PowerShell credentials (PSCredentials or&nbsp;SecureString)

'dpapi::ps' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::luna

Safenet LunaHSM KSP

'dpapi::luna' = '/client: /hive: /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::cloudapkd

### dpapi::cloudapreg

### dpapi::sccm

### dpapi::citrix

### dpapi::cache

Command | Description
--|--
`dpapi::cache` |
`dpapi::cache /flush` |
`dpapi::cache /load [/file:]` |
`dpapi::cache /save [/file:]` |

TODO:
/user: /password: /ntlm: /subject: /system: /security: /dcc:

#### Example 1

```
mimikatz # dpapi::cache

CREDENTIALS cache
=================
SID:S-1-5-21-4191072367-501804341-2791600538-1000;;MD4:92937945b518814341de3f726500d4ff;SHA1:e99089abfd8d6af75c2c45dc4321ac7f28f7ed9d;

MASTERKEYS cache
================

DOMAINKEYS cache
================

```

#### Example 2

```
mimikatz # dpapi::cache /save

CREDENTIALS cache
=================
SID:S-1-5-21-4191072367-501804341-2791600538-1000;;MD4:92937945b518814341de3f726500d4ff;SHA1:e99089abfd8d6af75c2c45dc4321ac7f28f7ed9d;

MASTERKEYS cache
================

DOMAINKEYS cache
================

SAVE cache
==========
Will encode:
 *   0 MasterKey(s)
 *   1 Credential(s)
 *   0 DomainKey(s)
Encoded:
 * addr: 0x0000000000A36B50
 * size: 288
Write file 'mimikatz_dpapi_cache.ndr': OK

```

#### Example 3

```
mimikatz # dpapi::cache /flush

!!! FLUSH cache !!!

CREDENTIALS cache
=================

MASTERKEYS cache
================

DOMAINKEYS cache
================

```


## BusyLight Module

### busylight::list

### busylight::status

### busylight::single

Parameter | Description
--|--
`/sound` |
`/color:` | 0xFF0000 0x00FF00 0x0000FF

### busylight::off

Command | Description
--|--
busylight::off | 

### busylight::test

Command | Description
--|--
busylight::test | 

## System Environment Values Module

### sysenv::list

Command | Description
--|--
`sysenv::list` |

### sysenv::get

Parameter | Description
--|--
`/name:` |
`/guid:` |

'name' = { 'Kernel_Lsa_Ppl_Config' } 
'guid' = { '{77fa9abd-0359-4d32-bd60-28f4e78f784b}' }

### sysenv::set

Parameter | Description
--|--
`/name:` |
`/guid:` |
`/attributes:` |
`/data:` |

'name' = { 'Kernel_Lsa_Ppl_Config' } 
'guid' = { '{77fa9abd-0359-4d32-bd60-28f4e78f784b}' }
'attributes' = { '07' }
'data' = { '04' }

### sysenv::del

Parameter | Description
--|--
`/name:` |
`/guid:` |
`/attributes:` |

'name' = { 'Kernel_Lsa_Ppl_Config' } 
'guid' = { '{77fa9abd-0359-4d32-bd60-28f4e78f784b}' }
'attributes' = { '07' }

## Security Identifiers Module

### sid::lookup

Name or&nbsp;SID lookup

Parameter | Description
--|--
`/sid:` |
`/name:` |
`/system:` |

### sid::query

Query object by&nbsp;SID or&nbsp;name

Parameter | Description
--|--
`/sam:` |
`/sid:` |
`/system:` |

### sid::modify

Modify object SID of&nbsp;an&nbsp;object

Parameter | Description
--|--
`/sam:` |
`/sid:` |
`/new:` |
`/system:` |

### sid::add

Add a&nbsp;SID to&nbsp;sIDHistory of&nbsp;an&nbsp;object

Parameter | Description
--|--
`/sam:` |
`/sid:` |
`/new:` |
`/system:` |

### sid::clear

Clear sIDHistory of&nbsp;an&nbsp;object

Parameter | Description
--|--
`/sam:` |
`/sid:` |
`/system:` |

### sid::patch

Command | Description
--|--
`sid::patch` | Patch NTDS Service

## IIS XML Config Module

### iis::apphost

Command | Description
--|--
`iis::apphost /in:<applicationHost.config>` | TODO


| Parameter  | Description |
|------------|-------------|
| `/live`    |
| `/in:`     |
| `/pvk:`    |

## RPC Control of&nbsp;Mimikatz

### rpc::server

| Parameter    | Description |
|--------------|-------------|
| `/stop`      |
| `/protseq:`  | `ncacn_ip_tcp`, `ncacn_http`, `ncacn_nb_tcp`, `ncacn_np`
| `/endpoint:` |
| `/service:`  |
| `/noauth`    |
| `/ntlm`      |
| `/kerberos`  |
| `/noreg`     |
| `/secure`    |
| `/guid:`     |

### rpc::connect

/server: /protseq: /endpoint: /service: /alg: /noauth /ntlm /kerberos /null /guid:

protseq: 'ncacn_ip_tcp', 'ncacn_http', 'ncacn_nb_tcp', 'ncacn_np'
alg: 3DES

### rpc::close

### rpc::enum

## RF module for&nbsp;SR98 Devices and&nbsp;T5577 Targets

### sr98::beep

### sr98::raw

Parameter | Description
--|--
`/wipe` | TODO
`/b0:` | TODO
`/b1:` | TODO
`/b2:` | TODO
`/b3:` | TODO
`/b4:` | TODO
`/b5:` | TODO
`/b6:` | TODO
`/b7:` | TODO

### sr98::b0

Parameter | Description
--|--
`/b0:` | TODO

### sr98::list

### sr98::hid

Parameter | Description
--|--
`/fc:` | TODO
`/cn:` | TODO

### sr98::em4100

Parameter | Description
--|--
`/read` | TODO
`/id:` | TODO

### sr98::noralsy

Parameter | Description
--|--
`/year:` | TODO
`/id:` | TODO

### sr98::nedap

| Parameter | Description |
|-----------|-------------|
| `/long`   | TODO        |
| `/sub:`   | TODO        |
| `/cc:`    | TODO        |
| `/cn:`    | TODO        |

## RF Module for&nbsp;RDM (830 AL) Device Devices

### rdm::version

### rdm::list

## ACR Module

### acr::open

Parameter | Description
--|--
`/trace` | TODO

### acr::close

### acr::firmware

### acr::info
