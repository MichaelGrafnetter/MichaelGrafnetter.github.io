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
-  Sean Metcalf's [Unofficial Guide to&nbsp;Mimikatz & Command Reference](https://adsecurity.org/?page_id=1821)
- Charlie Bromberg's [The Hacker Recipes](https://tools.thehacker.recipes/mimikatz/modules)

## Mimikatz 101

Command | Description
--|--
`::` | List all mimikatz modules
`standard::` | List all commands in&nbsp;the&nbsp;`standard` module.
`standard::answer` | Run the&nbsp;`answer` command from&nbsp;the&nbsp;standard module.
`answer` | Run the&nbsp;`answer` command from&nbsp;the&nbsp;standard module. Note that&nbsp;commands in&nbsp;the&nbsp;`standard` module do&nbsp;not need to&nbsp;be&nbsp;prefixed by&nbsp;module name with&nbsp;double colons. 

<!--more-->

## Standard Module

Basic mimikatz commands that&nbsp;do&nbsp;not require the&nbsp;module name to&nbsp;be&nbsp;specified.

### standard::exit

Command | Description
--|--
`exit` | Quit mimikatz

#### Example

```
mimikatz # exit
Bye!
```

### standard::cls

Command | Description
--|--
`cls` | Clear the&nbsp;screen (doesn't work with&nbsp;redirections, like PsExec)

### standard::answer

Command | Description
--|--
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

Command | Description
--|--
`sleep` | Sleep for&nbsp;1 second.
`sleep <N>` | Sleep for&nbsp;the&nbsp;specified amount of&nbsp;milliseconds.

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

Command | Description
--|--
`log` | Start logging mimikatz input and&nbsp;output into a&nbsp;file called mimikatz.log.
`log <Log file path>` | Start logging mimikatz input and&nbsp;output into the&nbsp;specified file.
`log /stop` | Stop logging.

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

Command | Description
--|--
`version` | Displays some&nbsp;version information
`version /full` | TODO
`version /cab` | TODO

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

Command | Description
--|--
`cd` | Displays the&nbsp;current working directory.
`cd <PATH>` | Changes the&nbsp;working directory. 

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

Command | Description
--|--
localtime | Displays system local date and&nbsp;time (OJ command)

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

Command | Description
--|--
`!+` | TODO

#### Example

```
mimikatz # !+
[*] 'mimidrv' service not present
[+] 'mimidrv' service successfully registered
[+] 'mimidrv' service ACL to everyone
[+] 'mimidrv' service started
```

### !-

Command | Description
--|--
`!-` | TODO

#### Example

```
mimikatz # !-
[+] 'mimidrv' service stopped
[+] 'mimidrv' service removed
```

### !ping

Command | Description
--|--
`!ping` | TODO

#### Example

```
mimikatz # !ping
Input  : (null)
Output : pong
```

### !bsod

Command | Description
--|--
`!bsod` | TODO

### !filters

Command | Description
--|--
`!filters` | TODO

#### Example

```
mimikatz # !filters
[00] \FileSystem\FltMgr
```

### !minifilters

Command | Description
--|--
`!minifilters` | TODO

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

Command | Description
--|--
`!modules` | TODO

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
0xFFFFF801812E0000 - 69632      werkernel.sys
0xFFFFF80181300000 - 49152      ntosext.sys
0xFFFFF80181310000 - 933888     CI.dll
0xFFFFF80181400000 - 765952     cng.sys
0xFFFFF801814C0000 - 905216     Wdf01000.sys
0xFFFFF801815A0000 - 81920      WDFLDR.SYS
0xFFFFF801815C0000 - 53248      PRM.sys
0xFFFFF801815D0000 - 155648     acpiex.sys
0xFFFFF80181600000 - 69632      WppRecorder.sys
0xFFFFF80181620000 - 389120     mssecflt.sys
0xFFFFF80181680000 - 110592     SgrmAgent.sys
0xFFFFF801816A0000 - 831488     ACPI.sys
0xFFFFF80181770000 - 49152      WMILIB.SYS
0xFFFFF80181780000 - 94208      WindowsTrustedRT.sys
0xFFFFF801817A0000 - 438272     intelpep.sys
0xFFFFF80181810000 - 45056      WindowsTrustedRTProxy.sys
0xFFFFF80181820000 - 45056      IntelPMT.sys
0xFFFFF80181830000 - 86016      pcw.sys
0xFFFFF80181910000 - 1556480    NDIS.SYS
0xFFFFF80181870000 - 634880     NETIO.SYS
0xFFFFF80181A90000 - 90112      vdrvroot.sys
0xFFFFF80181AB0000 - 192512     pdc.sys
0xFFFFF80181AE0000 - 98304      CEA.sys
0xFFFFF80181B00000 - 200704     partmgr.sys
0xFFFFF80181B40000 - 831488     spaceport.sys
0xFFFFF80181C10000 - 106496     volmgr.sys
0xFFFFF80181C30000 - 405504     volmgrx.sys
0xFFFFF80181CA0000 - 204800     vmbus.sys
0xFFFFF80181CE0000 - 172032     hvsocket.sys
0xFFFFF80181D10000 - 155648     vmbkmcl.sys
0xFFFFF80181D40000 - 81920      winhv.sys
0xFFFFF80181D60000 - 122880     mountmgr.sys
0xFFFFF80181D80000 - 139264     EhStorClass.sys
0xFFFFF80181DB0000 - 270336     Wof.sys
0xFFFFF80181E00000 - 86016      dfsrro.sys
0xFFFFF80181E20000 - 3215360    Ntfs.sys
0xFFFFF80182140000 - 73728      storvsc.sys
0xFFFFF80182160000 - 831488     storport.sys
0xFFFFF80182230000 - 53248      Fs_Rec.sys
0xFFFFF80182240000 - 208896     ksecpkg.sys
0xFFFFF80182280000 - 3260416    tcpip.sys
0xFFFFF801825A0000 - 528384     fwpkclnt.sys
0xFFFFF80182630000 - 196608     wfplwfs.sys
0xFFFFF80182670000 - 45056      volume.sys
0xFFFFF80182680000 - 475136     volsnap.sys
0xFFFFF80182700000 - 155648     mup.sys
0xFFFFF80182750000 - 126976     disk.sys
0xFFFFF80182770000 - 462848     CLASSPNP.SYS
0xFFFFF80183230000 - 139264     crashdmp.sys
0xFFFFF80183310000 - 196608     cdrom.sys
0xFFFFF80183350000 - 86016      filecrypt.sys
0xFFFFF80183370000 - 57344      tbs.sys
0xFFFFF80183380000 - 86016      dfs.sys
0xFFFFF801833A0000 - 40960      Null.SYS
0xFFFFF80182C00000 - 4530176    dxgkrnl.sys
0xFFFFF80183060000 - 110592     watchdog.sys
0xFFFFF80183080000 - 86016      BasicDisplay.sys
0xFFFFF801830A0000 - 69632      BasicRender.sys
0xFFFFF801830C0000 - 114688     Npfs.SYS
0xFFFFF801830E0000 - 69632      Msfs.SYS
0xFFFFF80183100000 - 147456     CimFS.SYS
0xFFFFF80183130000 - 143360     tdx.sys
0xFFFFF80183160000 - 65536      TDI.SYS
0xFFFFF80183180000 - 368640     netbt.sys
0xFFFFF801831E0000 - 81920      afunix.sys
0xFFFFF80185BE0000 - 675840     afd.sys
0xFFFFF80185C90000 - 176128     pacer.sys
0xFFFFF80185CC0000 - 77824      ndiscap.sys
0xFFFFF80185CE0000 - 81920      netbios.sys
0xFFFFF80185D00000 - 503808     rdbss.sys
0xFFFFF80185D80000 - 73728      nsiproxy.sys
0xFFFFF80185DA0000 - 61440      npsvctrig.sys
0xFFFFF80185DB0000 - 65536      mssmbios.sys
0xFFFFF80185DD0000 - 180224     dfsc.sys
0xFFFFF80185230000 - 442368     fastfat.SYS
0xFFFFF801852A0000 - 94208      bam.sys
0xFFFFF801852C0000 - 331776     ahcache.sys
0xFFFFF80185320000 - 77824      CompositeBus.sys
0xFFFFF80185340000 - 57344      kdnic.sys
0xFFFFF80185350000 - 90112      umbus.sys
0xFFFFF80185370000 - 86016      dmvsc.sys
0xFFFFF80185390000 - 57344      VMBusHID.sys
0xFFFFF801853A0000 - 270336     HIDCLASS.SYS
0xFFFFF801853F0000 - 77824      HIDPARSE.SYS
0xFFFFF80185410000 - 49152      hyperkbd.sys
0xFFFFF80185420000 - 81920      kbdclass.sys
0xFFFFF80185440000 - 65536      HyperVideo.sys
0xFFFFF80185460000 - 319488     netvsc.sys
0xFFFFF801854B0000 - 45056      vmgencounter.sys
0xFFFFF801854C0000 - 303104     intelppm.sys
0xFFFFF80185510000 - 53248      NdisVirtualBus.sys
0xFFFFF80185520000 - 49152      swenum.sys
0xFFFFF80185530000 - 512000     ks.sys
0xFFFFF801855B0000 - 61440      rdpbus.sys
0xFFFFF801855C0000 - 65536      mouhid.sys
0xFFFFF801855E0000 - 81920      mouclass.sys
0xFFFFF80185620000 - 65536      dump_diskdump.sys
0xFFFFF80185660000 - 73728      dump_storvsc.sys
0xFFFFF80185680000 - 155648     dump_vmbkmcl.sys
0xFFFFF629223E0000 - 696320     win32k.sys
0xFFFFF62923460000 - 3010560    win32kbase.sys
0xFFFFF62922600000 - 3874816    win32kfull.sys
0xFFFFF801856B0000 - 114688     monitor.sys
0xFFFFF801856D0000 - 1036288    dxgmms2.sys
0xFFFFF629229C0000 - 274432     cdd.dll
0xFFFFF801857D0000 - 45056      vmgid.sys
0xFFFFF80185810000 - 229376     wcifs.sys
0xFFFFF80185850000 - 540672     cldflt.sys
0xFFFFF801858E0000 - 106496     storqosflt.sys
0xFFFFF80185900000 - 159744     bindflt.sys
0xFFFFF80185930000 - 53248      rdpvideominiport.sys
0xFFFFF80185940000 - 98304      lltdio.sys
0xFFFFF80185960000 - 98304      mslldp.sys
0xFFFFF80185980000 - 110592     rspndr.sys
0xFFFFF801859A0000 - 151552     bowser.sys
0xFFFFF801859D0000 - 401408     msquic.sys
0xFFFFF80185A40000 - 634880     mrxsmb.sys
0xFFFFF80185AE0000 - 110592     mpsdrv.sys
0xFFFFF80185B00000 - 311296     mrxsmb20.sys
0xFFFFF80185B50000 - 192512     rdpdr.sys
0xFFFFF80185B80000 - 364544     srvnet.sys
0xFFFFF8019CAE0000 - 847872     srv2.sys
0xFFFFF8019CBB0000 - 77824      condrv.sys
0xFFFFF8019C600000 - 1662976    HTTP.sys
0xFFFFF8019C7A0000 - 843776     peauth.sys
0xFFFFF8019C870000 - 81920      tcpipreg.sys
0xFFFFF8019C890000 - 61440      terminpt.sys
0xFFFFF8019CA20000 - 49152      PROCEXP152.SYS
0xFFFFF8019C9A0000 - 339968     WUDFRd.sys
0xFFFFF8019CA00000 - 69632      IndirectKmd.sys
0xFFFFF8019CA50000 - 57344      mimidrv.sys
```

### !notifImage

### !notifObject

#### Example

```
mimikatz # !notifobject

 * TmTm
        Open        - 0xFFFFF8017FDCF8E0 [tm.sys + 0xf8e0]
        Close       - 0xFFFFF8017FDCE050 [tm.sys + 0xe050]
        Delete      - 0xFFFFF8017FDCE120 [tm.sys + 0xe120]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

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

 * DebugObject
        Close       - 0xFFFFF8018070EF20 [ntoskrnl.exe + 0x8fff20]
        Delete      - 0xFFFFF801805E1070 [ntoskrnl.exe + 0x7d2070]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * VRegConfigurationContext
        Delete      - 0xFFFFF8018070DA80 [ntoskrnl.exe + 0x8fea80]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * TpWorkerFactory
        Close       - 0xFFFFF801805B5570 [ntoskrnl.exe + 0x7a6570]
        Delete      - 0xFFFFF801801747C0 [ntoskrnl.exe + 0x3657c0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Adapter
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Token
        Delete      - 0xFFFFF801805484F0 [ntoskrnl.exe + 0x7394f0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * DxgkSharedResource
        Open        - 0xFFFFF80182D707F0 [dxgkrnl.sys + 0x1707f0]
        Delete      - 0xFFFFF80182DD07E0 [dxgkrnl.sys + 0x1d07e0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * PsSiloContextPaged
        Delete      - 0xFFFFF801805E8030 [ntoskrnl.exe + 0x7d9030]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * NdisCmState
        Delete      - 0xFFFFF80181919FD0 [NDIS.SYS + 0x9fd0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * ActivityReference
        Close       - 0xFFFFF80180527090 [ntoskrnl.exe + 0x718090]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * PcwObject
        Open        - 0xFFFFF80181839270 [pcw.sys + 0x9270]
        Close       - 0xFFFFF80181839290 [pcw.sys + 0x9290]
        Delete      - 0xFFFFF801818392C0 [pcw.sys + 0x92c0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * WmiGuid
        Delete      - 0xFFFFF801805A7240 [ntoskrnl.exe + 0x798240]
        Security    - 0xFFFFF801804F7370 [ntoskrnl.exe + 0x6e8370]

 * DmaAdapter
        Delete      - 0xFFFFF801803148B0 [ntoskrnl.exe + 0x5058b0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * EtwRegistration
        Open        - 0xFFFFF80180500E30 [ntoskrnl.exe + 0x6f1e30]
        Close       - 0xFFFFF801804F4B50 [ntoskrnl.exe + 0x6e5b50]
        Delete      - 0xFFFFF80180589C50 [ntoskrnl.exe + 0x77ac50]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * DxgkSharedBundleObject
        Open        - 0xFFFFF80182D707F0 [dxgkrnl.sys + 0x1707f0]
        Delete      - 0xFFFFF80182F0EB50 [dxgkrnl.sys + 0x30eb50]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Session
        Delete      - 0xFFFFF80180753F80 [ntoskrnl.exe + 0x944f80]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * RawInputManager
        Open        - 0xFFFFF801804810B0 [ntoskrnl.exe + 0x6720b0]
        Close       - 0xFFFFF80180500240 [ntoskrnl.exe + 0x6f1240]
        Delete      - 0xFFFFF8018050F510 [ntoskrnl.exe + 0x700510]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]
        OkayToClose - 0xFFFFF801804FF320 [ntoskrnl.exe + 0x6f0320]

 * Timer
        Delete      - 0xFFFFF801800AB1B0 [ntoskrnl.exe + 0x29c1b0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Mutant
        Delete      - 0xFFFFF80180033D30 [ntoskrnl.exe + 0x224d30]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * IRTimer
        Delete      - 0xFFFFF801805B5590 [ntoskrnl.exe + 0x7a6590]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * IoCompletion
        Close       - 0xFFFFF80180469890 [ntoskrnl.exe + 0x65a890]
        Delete      - 0xFFFFF80180469870 [ntoskrnl.exe + 0x65a870]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * DxgkSharedProtectedSessionObject
        Open        - 0xFFFFF80182D707F0 [dxgkrnl.sys + 0x1707f0]
        Delete      - 0xFFFFF80182F0ECC0 [dxgkrnl.sys + 0x30ecc0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * DxgkSharedSyncObject
        Open        - 0xFFFFF80182D707F0 [dxgkrnl.sys + 0x1707f0]
        Delete      - 0xFFFFF80182D6FD50 [dxgkrnl.sys + 0x16fd50]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * WindowStation
        Open        - 0xFFFFF801804810B0 [ntoskrnl.exe + 0x6720b0]
        Close       - 0xFFFFF80180500240 [ntoskrnl.exe + 0x6f1240]
        Delete      - 0xFFFFF8018050F510 [ntoskrnl.exe + 0x700510]
        Parse       - 0xFFFFF801805097A0 [ntoskrnl.exe + 0x6fa7a0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]
        OkayToClose - 0xFFFFF801804FF320 [ntoskrnl.exe + 0x6f0320]

 * Profile
        Delete      - 0xFFFFF801807EB200 [ntoskrnl.exe + 0x9dc200]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * File
        Close       - 0xFFFFF8018055AF80 [ntoskrnl.exe + 0x74bf80]
        Delete      - 0xFFFFF8018055AD00 [ntoskrnl.exe + 0x74bd00]
        Parse       - 0xFFFFF801804F3E80 [ntoskrnl.exe + 0x6e4e80]
        Security    - 0xFFFFF80180465410 [ntoskrnl.exe + 0x656410]
        QueryName   - 0xFFFFF80180466A50 [ntoskrnl.exe + 0x657a50]

 * Partition
        Open        - 0xFFFFF8018064B3E0 [ntoskrnl.exe + 0x83c3e0]
        Close       - 0xFFFFF80180796480 [ntoskrnl.exe + 0x987480]
        Delete      - 0xFFFFF801807965B0 [ntoskrnl.exe + 0x9875b0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * DxgkSharedKeyedMutexObject
        Open        - 0xFFFFF80182D707F0 [dxgkrnl.sys + 0x1707f0]
        Delete      - 0xFFFFF80182F0EC20 [dxgkrnl.sys + 0x30ec20]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * ActivationObject
        Open        - 0xFFFFF801804810B0 [ntoskrnl.exe + 0x6720b0]
        Close       - 0xFFFFF80180500240 [ntoskrnl.exe + 0x6f1240]
        Delete      - 0xFFFFF8018050F510 [ntoskrnl.exe + 0x700510]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]
        OkayToClose - 0xFFFFF801804FF320 [ntoskrnl.exe + 0x6f0320]

 * Semaphore
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * PsSiloContextNonPaged
        Delete      - 0xFFFFF801805E8030 [ntoskrnl.exe + 0x7d9030]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * EtwConsumer
        Open        - 0xFFFFF80180500E30 [ntoskrnl.exe + 0x6f1e30]
        Close       - 0xFFFFF80180512AF0 [ntoskrnl.exe + 0x703af0]
        Delete      - 0xFFFFF801805257C0 [ntoskrnl.exe + 0x7167c0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Composition
        Open        - 0xFFFFF801804810B0 [ntoskrnl.exe + 0x6720b0]
        Close       - 0xFFFFF80180500240 [ntoskrnl.exe + 0x6f1240]
        Delete      - 0xFFFFF8018050F510 [ntoskrnl.exe + 0x700510]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]
        OkayToClose - 0xFFFFF801804FF320 [ntoskrnl.exe + 0x6f0320]

 * CoverageSampler
        Close       - 0xFFFFF801807D7A00 [ntoskrnl.exe + 0x9c8a00]
        Delete      - 0xFFFFF801807D7AD0 [ntoskrnl.exe + 0x9c8ad0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * EtwSessionDemuxEntry
        Open        - 0xFFFFF80180500E30 [ntoskrnl.exe + 0x6f1e30]
        Delete      - 0xFFFFF801807D0290 [ntoskrnl.exe + 0x9c1290]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * CoreMessaging
        Open        - 0xFFFFF801804810B0 [ntoskrnl.exe + 0x6720b0]
        Close       - 0xFFFFF80180500240 [ntoskrnl.exe + 0x6f1240]
        Delete      - 0xFFFFF8018050F510 [ntoskrnl.exe + 0x700510]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]
        OkayToClose - 0xFFFFF801804FF320 [ntoskrnl.exe + 0x6f0320]

 * TmTx
        Close       - 0xFFFFF8017FDD6930 [tm.sys + 0x16930]
        Delete      - 0xFFFFF8017FDD6960 [tm.sys + 0x16960]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * SymbolicLink
        Delete      - 0xFFFFF80180521800 [ntoskrnl.exe + 0x712800]
        Parse       - 0xFFFFF801805A6CC0 [ntoskrnl.exe + 0x797cc0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * FilterConnectionPort
        Close       - 0xFFFFF80181208630 [FLTMGR.SYS + 0x58630]
        Delete      - 0xFFFFF801812086C0 [FLTMGR.SYS + 0x586c0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Key
        Close       - 0xFFFFF80180540FD0 [ntoskrnl.exe + 0x731fd0]
        Delete      - 0xFFFFF8018057CB20 [ntoskrnl.exe + 0x76db20]
        Parse       - 0xFFFFF801805772C0 [ntoskrnl.exe + 0x7682c0]
        Security    - 0xFFFFF80180590AD0 [ntoskrnl.exe + 0x781ad0]
        QueryName   - 0xFFFFF8018054DB50 [ntoskrnl.exe + 0x73eb50]

 * KeyedEvent
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Callback
        Delete      - 0xFFFFF80180525800 [ntoskrnl.exe + 0x716800]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * WaitCompletionPacket
        Close       - 0xFFFFF80180094D80 [ntoskrnl.exe + 0x285d80]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * ProcessStateChange
        Delete      - 0xFFFFF801807926C0 [ntoskrnl.exe + 0x9836c0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * UserApcReserve
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Job
        Close       - 0xFFFFF8018046AAF0 [ntoskrnl.exe + 0x65baf0]
        Delete      - 0xFFFFF801800351F0 [ntoskrnl.exe + 0x2261f0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * DxgkCurrentDxgThreadObject
        Delete      - 0xFFFFF80182D5E160 [dxgkrnl.sys + 0x15e160]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * DxgkDisplayManagerObject
        Open        - 0xFFFFF80182D707F0 [dxgkrnl.sys + 0x1707f0]
        Delete      - 0xFFFFF80182D677B0 [dxgkrnl.sys + 0x1677b0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * DxgkSharedSwapChainObject
        Open        - 0xFFFFF80182D707F0 [dxgkrnl.sys + 0x1707f0]
        Close       - 0xFFFFF80182F3E510 [dxgkrnl.sys + 0x33e510]
        Delete      - 0xFFFFF80182F3E560 [dxgkrnl.sys + 0x33e560]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Controller
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * IoCompletionReserve
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Device
        Delete      - 0xFFFFF801805D0F00 [ntoskrnl.exe + 0x7c1f00]
        Parse       - 0xFFFFF8018055B230 [ntoskrnl.exe + 0x74c230]
        Security    - 0xFFFFF80180465410 [ntoskrnl.exe + 0x656410]

 * ThreadStateChange
        Delete      - 0xFFFFF801805E6D10 [ntoskrnl.exe + 0x7d7d10]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Directory
        Close       - 0xFFFFF801804FC660 [ntoskrnl.exe + 0x6ed660]
        Delete      - 0xFFFFF80180514290 [ntoskrnl.exe + 0x705290]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Section
        Open        - 0xFFFFF8018056D680 [ntoskrnl.exe + 0x75e680]
        Close       - 0xFFFFF8018056D650 [ntoskrnl.exe + 0x75e650]
        Delete      - 0xFFFFF8018056D450 [ntoskrnl.exe + 0x75e450]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * TmEn
        Close       - 0xFFFFF8017FDD4BA0 [tm.sys + 0x14ba0]
        Delete      - 0xFFFFF8017FDD4CF0 [tm.sys + 0x14cf0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Thread
        Open        - 0xFFFFF801805B7C60 [ntoskrnl.exe + 0x7a8c60]
        Delete      - 0xFFFFF8018047AC30 [ntoskrnl.exe + 0x66bc30]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * DxgkCompositionObject
        Open        - 0xFFFFF80182C09C30 [dxgkrnl.sys + 0x9c30]
        Close       - 0xFFFFF80182C0ABB0 [dxgkrnl.sys + 0xabb0]
        Delete      - 0xFFFFF80182C0C2F0 [dxgkrnl.sys + 0xc2f0]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]
        OkayToClose - 0xFFFFF80182C0A3D0 [dxgkrnl.sys + 0xa3d0]

 * Type
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * FilterCommunicationPort
        Close       - 0xFFFFF801811F4760 [FLTMGR.SYS + 0x44760]
        Delete      - 0xFFFFF801811F4A60 [FLTMGR.SYS + 0x44a60]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * PowerRequest
        Close       - 0xFFFFF801804C97E0 [ntoskrnl.exe + 0x6ba7e0]
        Delete      - 0xFFFFF801804CA410 [ntoskrnl.exe + 0x6bb410]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * TmRm
        Open        - 0xFFFFF8017FDCF840 [tm.sys + 0xf840]
        Close       - 0xFFFFF8017FDCF580 [tm.sys + 0xf580]
        Delete      - 0xFFFFF8017FDCF710 [tm.sys + 0xf710]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Event
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * ALPC Port
        Open        - 0xFFFFF801804FA900 [ntoskrnl.exe + 0x6eb900]
        Close       - 0xFFFFF8018049C300 [ntoskrnl.exe + 0x68d300]
        Delete      - 0xFFFFF80180499F30 [ntoskrnl.exe + 0x68af30]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]

 * Driver
        Delete      - 0xFFFFF80180646D70 [ntoskrnl.exe + 0x837d70]
        Security    - 0xFFFFF8018058BB80 [ntoskrnl.exe + 0x77cb80]
```

### !notifProcess

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

### !notifThread

### !process

Command | Description
--|--
`!process` | TODO

#### Example

```
mimikatz # !process
4       System          F-Tok   Sig 1e/1c [2-0-7]
100     Registry        F-Tok   Sig 00/00 [2-0-7]
344     smss.exe        F-Tok   Sig 3e/0c [1-0-6]
456     csrss.exe       F-Tok   Sig 3e/0c [1-0-6]
536     wininit.exe     F-Tok   Sig 3e/0c [1-0-6]
544     csrss.exe       F-Tok   Sig 3e/0c [1-0-6]
604     winlogon.exe    F-Tok   Sig 0c/00 [0-0-0]
672     services.exe    F-Tok   Sig 3e/0c [1-0-6]
692     lsass.exe       F-Tok   Sig 0c/00 [0-0-0]
900     svchost.exe     F-Tok   Sig 00/00 [0-0-0]
924     fontdrvhost.ex  F-Tok   Sig 08/08 [0-0-0]
932     fontdrvhost.ex  F-Tok   Sig 08/08 [0-0-0]
1000    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
828     dwm.exe         F-Tok   Sig 00/00 [0-0-0]
708     svchost.exe     F-Tok   Sig 00/00 [0-0-0]
1016    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
548     svchost.exe     F-Tok   Sig 00/00 [0-0-0]
1036    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
1120    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
1136    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
1228    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
1344    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
1476    VSSVC.exe       F-Tok   Sig 00/00 [0-0-0]
1484    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
1604    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
1652    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
1404    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
1544    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
2636    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
2756    svchost.exe     F-Tok   Sig 08/08 [0-0-0]
2772    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
2796    dfsrs.exe       F-Tok   Sig 08/08 [0-0-0]
2804    Microsoft.Acti  F-Tok   Sig 00/00 [0-0-0]
2812    ismserv.exe     F-Tok   Sig 00/00 [0-0-0]
2832    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
2924    dfssvc.exe      F-Tok   Sig 08/08 [0-0-0]
2428    vds.exe         F-Tok   Sig 00/00 [0-0-0]
2748    AggregatorHost  F-Tok   Sig 00/00 [0-0-0]
3960    sihost.exe      F-Tok   Sig 00/00 [0-0-0]
3976    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
4008    taskhostw.exe   F-Tok   Sig 00/00 [0-0-0]
3228    ctfmon.exe      F-Tok   Sig 00/00 [0-0-0]
3168    userinit.exe    F-Tok   Sig 0c/00 [0-0-0]
3644    explorer.exe    F-Tok   Sig 00/00 [0-0-0]
2416    TextInputHost.  F-Tok   Sig 08/00 [0-0-0]
3788    StartMenuExper  F-Tok   Sig 08/00 [0-0-0]
4176    RuntimeBroker.  F-Tok   Sig 00/00 [0-0-0]
4296    SearchApp.exe   F-Tok   Sig 08/00 [0-0-0]
4408    RuntimeBroker.  F-Tok   Sig 00/00 [0-0-0]
4580    RuntimeBroker.  F-Tok   Sig 00/00 [0-0-0]
4748    taskhostw.exe   F-Tok   Sig 00/00 [0-0-0]
4716    msdtc.exe       F-Tok   Sig 00/00 [0-0-0]
4744    svchost.exe     F-Tok   Sig 00/00 [0-0-0]
4168    svchost.exe     F-Tok   Sig 3c/0c [1-0-5]
4348    csrss.exe       F-Tok   Sig 3e/0c [1-0-6]
5024    winlogon.exe    F-Tok   Sig 0c/00 [0-0-0]
780     fontdrvhost.ex  F-Tok   Sig 08/08 [0-0-0]
4460    LogonUI.exe     F-Tok   Sig 00/00 [0-0-0]
4928    dwm.exe         F-Tok   Sig 00/00 [0-0-0]
2948    rdpclip.exe     F-Tok   Sig 00/00 [0-0-0]
2544    TabTip.exe      F-Tok   Sig 00/00 [0-0-0]
4840    TabTip32.exe    F-Tok   Sig 00/00 [0-0-0]
3864    msedge.exe      F-Tok   Sig 00/00 [0-0-0]
2908    dllhost.exe     F-Tok   Sig 08/08 [0-0-0]
2120    ApplicationFra  F-Tok   Sig 00/00 [0-0-0]
1064    dns.exe         F-Tok   Sig 00/00 [0-0-0]
3032    plasrv.exe      F-Tok   Sig 00/00 [0-0-0]
3596    win32calc.exe   F-Tok   Sig 00/00 [0-0-0]
5756    WmiPrvSE.exe    F-Tok   Sig 00/00 [0-0-0]
1264    WUDFHost.exe    F-Tok   Sig 00/00 [0-0-0]
5344    WUDFHost.exe    F-Tok   Sig 00/00 [0-0-0]
4284    ShellExperienc  F-Tok   Sig 08/00 [0-0-0]
7044    RuntimeBroker.  F-Tok   Sig 00/00 [0-0-0]
3916    powershell_ise  F-Tok   Sig 00/00 [0-0-0]
3504    msedge.exe      F-Tok   Sig 00/00 [0-0-0]
6920    msedge.exe      F-Tok   Sig 00/00 [0-0-0]
7384    msedge.exe      F-Tok   Sig 08/08 [0-0-0]
3540    msedge.exe      F-Tok   Sig 00/00 [0-0-0]
6932    msedge.exe      F-Tok   Sig 08/08 [0-0-0]
7120    msedge.exe      F-Tok   Sig 08/08 [0-0-0]
6940    mimikatz.exe    F-Tok   Sig 00/00 [0-0-0]
4508    conhost.exe     F-Tok   Sig 00/00 [0-0-0]
```

### !processPrivilege

Default: mimikatz.exe process
/pid:

### !processProtect

/process: /pid: /remove

### !processToken

/from: /to:

### !sysenvdel

/name: /guid: /attributes:

### !sysenvset

/name: /guid: /attributes: /data:

### !ssdt

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
[    9] 0xFFFFF80180572610 [ntoskrnl.exe + 0x763610]
[   10] 0xFFFFF8018056E9F0 [ntoskrnl.exe + 0x75f9f0]
[   11] 0xFFFFF8018049C590 [ntoskrnl.exe + 0x68d590]
[   12] 0xFFFFF801804A1B60 [ntoskrnl.exe + 0x692b60]
[   13] 0xFFFFF8018056EB20 [ntoskrnl.exe + 0x75fb20]
[   14] 0xFFFFF801804DB580 [ntoskrnl.exe + 0x6cc580]
[   15] 0xFFFFF80180580BB0 [ntoskrnl.exe + 0x771bb0]
[   16] 0xFFFFF80180467540 [ntoskrnl.exe + 0x658540]
[   17] 0xFFFFF8018055F0B0 [ntoskrnl.exe + 0x7500b0]
[   18] 0xFFFFF801804E2630 [ntoskrnl.exe + 0x6d3630]
[   19] 0xFFFFF801804DC360 [ntoskrnl.exe + 0x6cd360]
[   20] 0xFFFFF8018047DF40 [ntoskrnl.exe + 0x66ef40]
[   21] 0xFFFFF801804FE8E0 [ntoskrnl.exe + 0x6ef8e0]
[   22] 0xFFFFF801805769E0 [ntoskrnl.exe + 0x7679e0]
[   23] 0xFFFFF80180575F60 [ntoskrnl.exe + 0x766f60]
[   24] 0xFFFFF80180569BB0 [ntoskrnl.exe + 0x75abb0]
[   25] 0xFFFFF801804597F0 [ntoskrnl.exe + 0x64a7f0]
[   26] 0xFFFFF801804E64C0 [ntoskrnl.exe + 0x6d74c0]
[   27] 0xFFFFF801804DEC00 [ntoskrnl.exe + 0x6cfc00]
[   28] 0xFFFFF801804A9770 [ntoskrnl.exe + 0x69a770]
[   29] 0xFFFFF801804D3880 [ntoskrnl.exe + 0x6c4880]
[   30] 0xFFFFF80180568EB0 [ntoskrnl.exe + 0x759eb0]
[   31] 0xFFFFF8018074C0E0 [ntoskrnl.exe + 0x93d0e0]
[   32] 0xFFFFF8018054DE70 [ntoskrnl.exe + 0x73ee70]
[   33] 0xFFFFF8018054E450 [ntoskrnl.exe + 0x73f450]
[   34] 0xFFFFF8018049EF20 [ntoskrnl.exe + 0x68ff20]
[   35] 0xFFFFF8018056A540 [ntoskrnl.exe + 0x75b540]
[   36] 0xFFFFF8018054B8C0 [ntoskrnl.exe + 0x73c8c0]
[   37] 0xFFFFF801805486D0 [ntoskrnl.exe + 0x7396d0]
[   38] 0xFFFFF8018054A020 [ntoskrnl.exe + 0x73b020]
[   39] 0xFFFFF8018014AE40 [ntoskrnl.exe + 0x33be40]
[   40] 0xFFFFF8018056E4F0 [ntoskrnl.exe + 0x75f4f0]
[   41] 0xFFFFF801804F3AF0 [ntoskrnl.exe + 0x6e4af0]
[   42] 0xFFFFF8018049DB70 [ntoskrnl.exe + 0x68eb70]
[   43] 0xFFFFF8018049C5B0 [ntoskrnl.exe + 0x68d5b0]
[   44] 0xFFFFF80180505520 [ntoskrnl.exe + 0x6f6520]
[   45] 0xFFFFF801807E04F0 [ntoskrnl.exe + 0x9d14f0]
[   46] 0xFFFFF801804DE5E0 [ntoskrnl.exe + 0x6cf5e0]
[   47] 0xFFFFF8018054B8E0 [ntoskrnl.exe + 0x73c8e0]
[   48] 0xFFFFF8018057E470 [ntoskrnl.exe + 0x76f470]
[   49] 0xFFFFF801804F1E40 [ntoskrnl.exe + 0x6e2e40]
[   50] 0xFFFFF8018057D7E0 [ntoskrnl.exe + 0x76e7e0]
[   51] 0xFFFFF801804985D0 [ntoskrnl.exe + 0x6895d0]
[   52] 0xFFFFF801805493A0 [ntoskrnl.exe + 0x73a3a0]
[   53] 0xFFFFF801804A6810 [ntoskrnl.exe + 0x697810]
[   54] 0xFFFFF80180556A90 [ntoskrnl.exe + 0x747a90]
[   55] 0xFFFFF801804D47A0 [ntoskrnl.exe + 0x6c57a0]
[   56] 0xFFFFF801807E02E0 [ntoskrnl.exe + 0x9d12e0]
[   57] 0xFFFFF801804EEC00 [ntoskrnl.exe + 0x6dfc00]
[   58] 0xFFFFF80180507B50 [ntoskrnl.exe + 0x6f8b50]
[   59] 0xFFFFF801804FD350 [ntoskrnl.exe + 0x6ee350]
[   60] 0xFFFFF8018047CB20 [ntoskrnl.exe + 0x66db20]
[   61] 0xFFFFF8018049ADA0 [ntoskrnl.exe + 0x68bda0]
[   62] 0xFFFFF801804DFCC0 [ntoskrnl.exe + 0x6d0cc0]
[   63] 0xFFFFF801805607C0 [ntoskrnl.exe + 0x7517c0]
[   64] 0xFFFFF801804D46D0 [ntoskrnl.exe + 0x6c56d0]
[   65] 0xFFFFF80180480590 [ntoskrnl.exe + 0x671590]
[   66] 0xFFFFF8018055EC20 [ntoskrnl.exe + 0x74fc20]
[   67] 0xFFFFF80180227BA0 [ntoskrnl.exe + 0x418ba0]
[   68] 0xFFFFF801805E0D70 [ntoskrnl.exe + 0x7d1d70]
[   69] 0xFFFFF80180503AA0 [ntoskrnl.exe + 0x6f4aa0]
[   70] 0xFFFFF801800E5590 [ntoskrnl.exe + 0x2d6590]
[   71] 0xFFFFF801807E7580 [ntoskrnl.exe + 0x9d8580]
[   72] 0xFFFFF8018055FA30 [ntoskrnl.exe + 0x750a30]
[   73] 0xFFFFF801805709B0 [ntoskrnl.exe + 0x7619b0]
[   74] 0xFFFFF80180546300 [ntoskrnl.exe + 0x737300]
[   75] 0xFFFFF80180500A90 [ntoskrnl.exe + 0x6f1a90]
[   76] 0xFFFFF801804DD930 [ntoskrnl.exe + 0x6ce930]
[   77] 0xFFFFF80180515C40 [ntoskrnl.exe + 0x706c40]
[   78] 0xFFFFF80180790550 [ntoskrnl.exe + 0x981550]
[   79] 0xFFFFF8018046ACA0 [ntoskrnl.exe + 0x65bca0]
[   80] 0xFFFFF8018056BBF0 [ntoskrnl.exe + 0x75cbf0]
[   81] 0xFFFFF801804F2680 [ntoskrnl.exe + 0x6e3680]
[   82] 0xFFFFF801804F4CF0 [ntoskrnl.exe + 0x6e5cf0]
[   83] 0xFFFFF801804A8960 [ntoskrnl.exe + 0x699960]
[   84] 0xFFFFF8018074C1E0 [ntoskrnl.exe + 0x93d1e0]
[   85] 0xFFFFF80180498640 [ntoskrnl.exe + 0x689640]
[   86] 0xFFFFF801805057A0 [ntoskrnl.exe + 0x6f67a0]
[   87] 0xFFFFF8018074C360 [ntoskrnl.exe + 0x93d360]
[   88] 0xFFFFF801804E0F80 [ntoskrnl.exe + 0x6d1f80]
[   89] 0xFFFFF801804F3A40 [ntoskrnl.exe + 0x6e4a40]
[   90] 0xFFFFF801807DD2D0 [ntoskrnl.exe + 0x9ce2d0]
[   91] 0xFFFFF801804DB6E0 [ntoskrnl.exe + 0x6cc6e0]
[   92] 0xFFFFF801804D8730 [ntoskrnl.exe + 0x6c9730]
[   93] 0xFFFFF801804FD3B0 [ntoskrnl.exe + 0x6ee3b0]
[   94] 0xFFFFF801800F3020 [ntoskrnl.exe + 0x2e4020]
[   95] 0xFFFFF801805B8160 [ntoskrnl.exe + 0x7a9160]
[   96] 0xFFFFF8018058F8E0 [ntoskrnl.exe + 0x7808e0]
[   97] 0xFFFFF80180144030 [ntoskrnl.exe + 0x335030]
[   98] 0xFFFFF8018018EE80 [ntoskrnl.exe + 0x37fe80]
[   99] 0xFFFFF801800A3A00 [ntoskrnl.exe + 0x294a00]
[  100] 0xFFFFF801803E92A0 [ntoskrnl.exe + 0x5da2a0]
[  101] 0xFFFFF801807ADBA0 [ntoskrnl.exe + 0x99eba0]
[  102] 0xFFFFF801807ADC50 [ntoskrnl.exe + 0x99ec50]
[  103] 0xFFFFF801807E76A0 [ntoskrnl.exe + 0x9d86a0]
[  104] 0xFFFFF8018051DEE0 [ntoskrnl.exe + 0x70eee0]
[  105] 0xFFFFF801804FBE20 [ntoskrnl.exe + 0x6ece20]
[  106] 0xFFFFF801807E4010 [ntoskrnl.exe + 0x9d5010]
[  107] 0xFFFFF801807E4040 [ntoskrnl.exe + 0x9d5040]
[  108] 0xFFFFF80180500350 [ntoskrnl.exe + 0x6f1350]
[  109] 0xFFFFF801805E11E0 [ntoskrnl.exe + 0x7d21e0]
[  110] 0xFFFFF80180795DB0 [ntoskrnl.exe + 0x986db0]
[  111] 0xFFFFF80180795ED0 [ntoskrnl.exe + 0x986ed0]
[  112] 0xFFFFF80180594D40 [ntoskrnl.exe + 0x785d40]
[  113] 0xFFFFF801804DDD00 [ntoskrnl.exe + 0x6ced00]
[  114] 0xFFFFF80180510A20 [ntoskrnl.exe + 0x701a20]
[  115] 0xFFFFF80180762F30 [ntoskrnl.exe + 0x953f30]
[  116] 0xFFFFF80180762F50 [ntoskrnl.exe + 0x953f50]
[  117] 0xFFFFF801805151A0 [ntoskrnl.exe + 0x7061a0]
[  118] 0xFFFFF801804A8DB0 [ntoskrnl.exe + 0x699db0]
[  119] 0xFFFFF801804A0C30 [ntoskrnl.exe + 0x691c30]
[  120] 0xFFFFF80180521530 [ntoskrnl.exe + 0x712530]
[  121] 0xFFFFF801804A19B0 [ntoskrnl.exe + 0x6929b0]
[  122] 0xFFFFF801804A1620 [ntoskrnl.exe + 0x692620]
[  123] 0xFFFFF801805043D0 [ntoskrnl.exe + 0x6f53d0]
[  124] 0xFFFFF80180497030 [ntoskrnl.exe + 0x688030]
[  125] 0xFFFFF80180508E90 [ntoskrnl.exe + 0x6f9e90]
[  126] 0xFFFFF80180498290 [ntoskrnl.exe + 0x689290]
[  127] 0xFFFFF8018049A810 [ntoskrnl.exe + 0x68b810]
[  128] 0xFFFFF80180496F40 [ntoskrnl.exe + 0x687f40]
[  129] 0xFFFFF80180666E80 [ntoskrnl.exe + 0x857e80]
[  130] 0xFFFFF80180496D00 [ntoskrnl.exe + 0x687d00]
[  131] 0xFFFFF8018049ACA0 [ntoskrnl.exe + 0x68bca0]
[  132] 0xFFFFF80180508900 [ntoskrnl.exe + 0x6f9900]
[  133] 0xFFFFF8018074C4F0 [ntoskrnl.exe + 0x93d4f0]
[  134] 0xFFFFF80180550E10 [ntoskrnl.exe + 0x741e10]
[  135] 0xFFFFF8018049F030 [ntoskrnl.exe + 0x690030]
[  136] 0xFFFFF80180506A50 [ntoskrnl.exe + 0x6f7a50]
[  137] 0xFFFFF8018048FEC0 [ntoskrnl.exe + 0x680ec0]
[  138] 0xFFFFF8018049C380 [ntoskrnl.exe + 0x68d380]
[  139] 0xFFFFF8018074C740 [ntoskrnl.exe + 0x93d740]
[  140] 0xFFFFF80180554FF0 [ntoskrnl.exe + 0x745ff0]
[  141] 0xFFFFF801804692D0 [ntoskrnl.exe + 0x65a2d0]
[  142] 0xFFFFF801804E1440 [ntoskrnl.exe + 0x6d2440]
[  143] 0xFFFFF8018046BA10 [ntoskrnl.exe + 0x65ca10]
[  144] 0xFFFFF80180032D40 [ntoskrnl.exe + 0x223d40]
[  145] 0xFFFFF801802309C0 [ntoskrnl.exe + 0x4219c0]
[  146] 0xFFFFF801804FD560 [ntoskrnl.exe + 0x6ee560]
[  147] 0xFFFFF8018071E5F0 [ntoskrnl.exe + 0x90f5f0]
[  148] 0xFFFFF801800BFDA0 [ntoskrnl.exe + 0x2b0da0]
[  149] 0xFFFFF80180094E90 [ntoskrnl.exe + 0x285e90]
[  150] 0xFFFFF80180791F90 [ntoskrnl.exe + 0x982f90]
[  151] 0xFFFFF801805E5DB0 [ntoskrnl.exe + 0x7d6db0]
[  152] 0xFFFFF801801E79F0 [ntoskrnl.exe + 0x3d89f0]
[  153] 0xFFFFF801801E7A10 [ntoskrnl.exe + 0x3d8a10]
[  154] 0xFFFFF8018050D0D0 [ntoskrnl.exe + 0x6fe0d0]
[  155] 0xFFFFF801801E7A30 [ntoskrnl.exe + 0x3d8a30]
[  156] 0xFFFFF801806F2130 [ntoskrnl.exe + 0x8e3130]
[  157] 0xFFFFF801804F44D0 [ntoskrnl.exe + 0x6e54d0]
[  158] 0xFFFFF801805212B0 [ntoskrnl.exe + 0x7122b0]
[  159] 0xFFFFF8018046B4D0 [ntoskrnl.exe + 0x65c4d0]
[  160] 0xFFFFF80180516540 [ntoskrnl.exe + 0x707540]
[  161] 0xFFFFF801806F2400 [ntoskrnl.exe + 0x8e3400]
[  162] 0xFFFFF801804A3550 [ntoskrnl.exe + 0x694550]
[  163] 0xFFFFF80180227BB0 [ntoskrnl.exe + 0x418bb0]
[  164] 0xFFFFF801807EB260 [ntoskrnl.exe + 0x9dc260]
[  165] 0xFFFFF801807E0440 [ntoskrnl.exe + 0x9d1440]
[  166] 0xFFFFF801807E7770 [ntoskrnl.exe + 0x9d8770]
[  167] 0xFFFFF801807102A0 [ntoskrnl.exe + 0x9012a0]
[  168] 0xFFFFF80180507030 [ntoskrnl.exe + 0x6f8030]
[  169] 0xFFFFF80180507010 [ntoskrnl.exe + 0x6f8010]
[  170] 0xFFFFF80180760450 [ntoskrnl.exe + 0x951450]
[  171] 0xFFFFF801801E7A50 [ntoskrnl.exe + 0x3d8a50]
[  172] 0xFFFFF801805E11E0 [ntoskrnl.exe + 0x7d21e0]
[  173] 0xFFFFF80180527110 [ntoskrnl.exe + 0x718110]
[  174] 0xFFFFF801804F7250 [ntoskrnl.exe + 0x6e8250]
[  175] 0xFFFFF8018046A470 [ntoskrnl.exe + 0x65b470]
[  176] 0xFFFFF801805E1040 [ntoskrnl.exe + 0x7d2040]
[  177] 0xFFFFF801804D3710 [ntoskrnl.exe + 0x6c4710]
[  178] 0xFFFFF8018063E390 [ntoskrnl.exe + 0x82f390]
[  179] 0xFFFFF801804C0720 [ntoskrnl.exe + 0x6b1720]
[  180] 0xFFFFF80180452780 [ntoskrnl.exe + 0x643780]
[  181] 0xFFFFF8018052A2D0 [ntoskrnl.exe + 0x71b2d0]
[  182] 0xFFFFF801805095A0 [ntoskrnl.exe + 0x6fa5a0]
[  183] 0xFFFFF80180634940 [ntoskrnl.exe + 0x825940]
[  184] 0xFFFFF80180796450 [ntoskrnl.exe + 0x987450]
[  185] 0xFFFFF80180504380 [ntoskrnl.exe + 0x6f5380]
[  186] 0xFFFFF801804BF900 [ntoskrnl.exe + 0x6b0900]
[  187] 0xFFFFF801807904C0 [ntoskrnl.exe + 0x9814c0]
[  188] 0xFFFFF80180792180 [ntoskrnl.exe + 0x983180]
[  189] 0xFFFFF801807EB390 [ntoskrnl.exe + 0x9dc390]
[  190] 0xFFFFF801807EB470 [ntoskrnl.exe + 0x9dc470]
[  191] 0xFFFFF80180514830 [ntoskrnl.exe + 0x705830]
[  192] 0xFFFFF801801E7A70 [ntoskrnl.exe + 0x3d8a70]
[  193] 0xFFFFF80180752350 [ntoskrnl.exe + 0x943350]
[  194] 0xFFFFF8018055F8F0 [ntoskrnl.exe + 0x7508f0]
[  195] 0xFFFFF80180501A80 [ntoskrnl.exe + 0x6f2a80]
[  196] 0xFFFFF801804787B0 [ntoskrnl.exe + 0x6697b0]
[  197] 0xFFFFF801805E60C0 [ntoskrnl.exe + 0x7d70c0]
[  198] 0xFFFFF801805BF3D0 [ntoskrnl.exe + 0x7b03d0]
[  199] 0xFFFFF80180468E20 [ntoskrnl.exe + 0x659e20]
[  200] 0xFFFFF801807AF230 [ntoskrnl.exe + 0x9a0230]
[  201] 0xFFFFF801804A2470 [ntoskrnl.exe + 0x693470]
[  202] 0xFFFFF801801E7A90 [ntoskrnl.exe + 0x3d8a90]
[  203] 0xFFFFF801801E7AB0 [ntoskrnl.exe + 0x3d8ab0]
[  204] 0xFFFFF801805B47E0 [ntoskrnl.exe + 0x7a57e0]
[  205] 0xFFFFF801804E9C50 [ntoskrnl.exe + 0x6dac50]
[  206] 0xFFFFF80180504330 [ntoskrnl.exe + 0x6f5330]
[  207] 0xFFFFF801804AFA90 [ntoskrnl.exe + 0x6a0a90]
[  208] 0xFFFFF80180468A70 [ntoskrnl.exe + 0x659a70]
[  209] 0xFFFFF801807104B0 [ntoskrnl.exe + 0x9014b0]
[  210] 0xFFFFF801807106D0 [ntoskrnl.exe + 0x9016d0]
[  211] 0xFFFFF80180516550 [ntoskrnl.exe + 0x707550]
[  212] 0xFFFFF801807E4070 [ntoskrnl.exe + 0x9d5070]
[  213] 0xFFFFF801807E4200 [ntoskrnl.exe + 0x9d5200]
[  214] 0xFFFFF80180607F50 [ntoskrnl.exe + 0x7f8f50]
[  215] 0xFFFFF8018053F360 [ntoskrnl.exe + 0x730360]
[  216] 0xFFFFF801807ADD10 [ntoskrnl.exe + 0x99ed10]
[  217] 0xFFFFF80180450270 [ntoskrnl.exe + 0x641270]
[  218] 0xFFFFF8018053F7E0 [ntoskrnl.exe + 0x7307e0]
[  219] 0xFFFFF80180646710 [ntoskrnl.exe + 0x837710]
[  220] 0xFFFFF801804AF4D0 [ntoskrnl.exe + 0x6a04d0]
[  221] 0xFFFFF801805E11E0 [ntoskrnl.exe + 0x7d21e0]
[  222] 0xFFFFF80180603E80 [ntoskrnl.exe + 0x7f4e80]
[  223] 0xFFFFF801807DDAC0 [ntoskrnl.exe + 0x9ceac0]
[  224] 0xFFFFF8018042B9B0 [ntoskrnl.exe + 0x61c9b0]
[  225] 0xFFFFF80180602C50 [ntoskrnl.exe + 0x7f3c50]
[  226] 0xFFFFF801807E4390 [ntoskrnl.exe + 0x9d5390]
[  227] 0xFFFFF801807E49F0 [ntoskrnl.exe + 0x9d59f0]
[  228] 0xFFFFF801807E4EB0 [ntoskrnl.exe + 0x9d5eb0]
[  229] 0xFFFFF801801E7AD0 [ntoskrnl.exe + 0x3d8ad0]
[  230] 0xFFFFF801804C82F0 [ntoskrnl.exe + 0x6b92f0]
[  231] 0xFFFFF801807B0760 [ntoskrnl.exe + 0x9a1760]
[  232] 0xFFFFF801804C5430 [ntoskrnl.exe + 0x6b6430]
[  233] 0xFFFFF801805E11E0 [ntoskrnl.exe + 0x7d21e0]
[  234] 0xFFFFF80180500AC0 [ntoskrnl.exe + 0x6f1ac0]
[  235] 0xFFFFF80180648A20 [ntoskrnl.exe + 0x839a20]
[  236] 0xFFFFF80180516540 [ntoskrnl.exe + 0x707540]
[  237] 0xFFFFF801804E26A0 [ntoskrnl.exe + 0x6d36a0]
[  238] 0xFFFFF80180040F40 [ntoskrnl.exe + 0x231f40]
[  239] 0xFFFFF801804C9A00 [ntoskrnl.exe + 0x6baa00]
[  240] 0xFFFFF80180516540 [ntoskrnl.exe + 0x707540]
[  241] 0xFFFFF80180762F70 [ntoskrnl.exe + 0x953f70]
[  242] 0xFFFFF801806F25C0 [ntoskrnl.exe + 0x8e35c0]
[  243] 0xFFFFF801801E7AF0 [ntoskrnl.exe + 0x3d8af0]
[  244] 0xFFFFF801804FC350 [ntoskrnl.exe + 0x6ed350]
[  245] 0xFFFFF801804B0200 [ntoskrnl.exe + 0x6a1200]
[  246] 0xFFFFF8018051B730 [ntoskrnl.exe + 0x70c730]
[  247] 0xFFFFF80180790D90 [ntoskrnl.exe + 0x981d90]
[  248] 0xFFFFF80180790DF0 [ntoskrnl.exe + 0x981df0]
[  249] 0xFFFFF8018077B8C0 [ntoskrnl.exe + 0x96c8c0]
[  250] 0xFFFFF801804FE520 [ntoskrnl.exe + 0x6ef520]
[  251] 0xFFFFF80180511AF0 [ntoskrnl.exe + 0x702af0]
[  252] 0xFFFFF80180510510 [ntoskrnl.exe + 0x701510]
[  253] 0xFFFFF801804A4270 [ntoskrnl.exe + 0x695270]
[  254] 0xFFFFF801801E7B10 [ntoskrnl.exe + 0x3d8b10]
[  255] 0xFFFFF80180030320 [ntoskrnl.exe + 0x221320]
[  256] 0xFFFFF8018046B000 [ntoskrnl.exe + 0x65c000]
[  257] 0xFFFFF801804F99E0 [ntoskrnl.exe + 0x6ea9e0]
[  258] 0xFFFFF80180760920 [ntoskrnl.exe + 0x951920]
[  259] 0xFFFFF801805021F0 [ntoskrnl.exe + 0x6f31f0]
[  260] 0xFFFFF80180525510 [ntoskrnl.exe + 0x716510]
[  261] 0xFFFFF801805ED440 [ntoskrnl.exe + 0x7de440]
[  262] 0xFFFFF801805F9260 [ntoskrnl.exe + 0x7ea260]
[  263] 0xFFFFF80180524430 [ntoskrnl.exe + 0x715430]
[  264] 0xFFFFF8018064D2F0 [ntoskrnl.exe + 0x83e2f0]
[  265] 0xFFFFF801804BB140 [ntoskrnl.exe + 0x6ac140]
[  266] 0xFFFFF80180760C00 [ntoskrnl.exe + 0x951c00]
[  267] 0xFFFFF801805270E0 [ntoskrnl.exe + 0x7180e0]
[  268] 0xFFFFF80180526A50 [ntoskrnl.exe + 0x717a50]
[  269] 0xFFFFF80180524840 [ntoskrnl.exe + 0x715840]
[  270] 0xFFFFF801804D2AD0 [ntoskrnl.exe + 0x6c3ad0]
[  271] 0xFFFFF80180545CE0 [ntoskrnl.exe + 0x736ce0]
[  272] 0xFFFFF80180604EC0 [ntoskrnl.exe + 0x7f5ec0]
[  273] 0xFFFFF801806075A0 [ntoskrnl.exe + 0x7f85a0]
[  274] 0xFFFFF8018001C750 [ntoskrnl.exe + 0x20d750]
[  275] 0xFFFFF80180525C90 [ntoskrnl.exe + 0x716c90]
[  276] 0xFFFFF8018051E180 [ntoskrnl.exe + 0x70f180]
[  277] 0xFFFFF801805B6AE0 [ntoskrnl.exe + 0x7a7ae0]
[  278] 0xFFFFF801805C0680 [ntoskrnl.exe + 0x7b1680]
[  279] 0xFFFFF801807EA250 [ntoskrnl.exe + 0x9db250]
[  280] 0xFFFFF80180763470 [ntoskrnl.exe + 0x954470]
[  281] 0xFFFFF8018051EAC0 [ntoskrnl.exe + 0x70fac0]
[  282] 0xFFFFF801807E5170 [ntoskrnl.exe + 0x9d6170]
[  283] 0xFFFFF801807E51A0 [ntoskrnl.exe + 0x9d61a0]
[  284] 0xFFFFF80180504FF0 [ntoskrnl.exe + 0x6f5ff0]
[  285] 0xFFFFF80180505050 [ntoskrnl.exe + 0x6f6050]
[  286] 0xFFFFF801804641F0 [ntoskrnl.exe + 0x6551f0]
[  287] 0xFFFFF80180464260 [ntoskrnl.exe + 0x655260]
[  288] 0xFFFFF801804E3FD0 [ntoskrnl.exe + 0x6d4fd0]
[  289] 0xFFFFF801801E7B30 [ntoskrnl.exe + 0x3d8b30]
[  290] 0xFFFFF801805E11E0 [ntoskrnl.exe + 0x7d21e0]
[  291] 0xFFFFF8018071E340 [ntoskrnl.exe + 0x90f340]
[  292] 0xFFFFF801805E6C60 [ntoskrnl.exe + 0x7d7c60]
[  293] 0xFFFFF80180572CD0 [ntoskrnl.exe + 0x763cd0]
[  294] 0xFFFFF801806F2680 [ntoskrnl.exe + 0x8e3680]
[  295] 0xFFFFF80180506C80 [ntoskrnl.exe + 0x6f7c80]
[  296] 0xFFFFF801807EB8C0 [ntoskrnl.exe + 0x9dc8c0]
[  297] 0xFFFFF801804D4550 [ntoskrnl.exe + 0x6c5550]
[  298] 0xFFFFF801804F5CA0 [ntoskrnl.exe + 0x6e6ca0]
[  299] 0xFFFFF8018064AD70 [ntoskrnl.exe + 0x83bd70]
[  300] 0xFFFFF801804BF730 [ntoskrnl.exe + 0x6b0730]
[  301] 0xFFFFF801804FA790 [ntoskrnl.exe + 0x6eb790]
[  302] 0xFFFFF801806F26A0 [ntoskrnl.exe + 0x8e36a0]
[  303] 0xFFFFF801801E7B50 [ntoskrnl.exe + 0x3d8b50]
[  304] 0xFFFFF801804D4620 [ntoskrnl.exe + 0x6c5620]
[  305] 0xFFFFF801804D58C0 [ntoskrnl.exe + 0x6c68c0]
[  306] 0xFFFFF801804DB9B0 [ntoskrnl.exe + 0x6cc9b0]
[  307] 0xFFFFF80180594D10 [ntoskrnl.exe + 0x785d10]
[  308] 0xFFFFF801807E0230 [ntoskrnl.exe + 0x9d1230]
[  309] 0xFFFFF801801E7B70 [ntoskrnl.exe + 0x3d8b70]
[  310] 0xFFFFF801801E7B90 [ntoskrnl.exe + 0x3d8b90]
[  311] 0xFFFFF801805A4900 [ntoskrnl.exe + 0x795900]
[  312] 0xFFFFF801801E7BB0 [ntoskrnl.exe + 0x3d8bb0]
[  313] 0xFFFFF801801E7BD0 [ntoskrnl.exe + 0x3d8bd0]
[  314] 0xFFFFF801801E7BF0 [ntoskrnl.exe + 0x3d8bf0]
[  315] 0xFFFFF801801E7C10 [ntoskrnl.exe + 0x3d8c10]
[  316] 0xFFFFF80180480DC0 [ntoskrnl.exe + 0x671dc0]
[  317] 0xFFFFF801805FC6B0 [ntoskrnl.exe + 0x7ed6b0]
[  318] 0xFFFFF801804F5A20 [ntoskrnl.exe + 0x6e6a20]
[  319] 0xFFFFF801801E7C30 [ntoskrnl.exe + 0x3d8c30]
[  320] 0xFFFFF801801E7C50 [ntoskrnl.exe + 0x3d8c50]
[  321] 0xFFFFF801807EC150 [ntoskrnl.exe + 0x9dd150]
[  322] 0xFFFFF801805BEB40 [ntoskrnl.exe + 0x7afb40]
[  323] 0xFFFFF801807EB4E0 [ntoskrnl.exe + 0x9dc4e0]
[  324] 0xFFFFF801807E51D0 [ntoskrnl.exe + 0x9d61d0]
[  325] 0xFFFFF801807E5450 [ntoskrnl.exe + 0x9d6450]
[  326] 0xFFFFF8018007A920 [ntoskrnl.exe + 0x26b920]
[  327] 0xFFFFF801804A68A0 [ntoskrnl.exe + 0x6978a0]
[  328] 0xFFFFF80180592240 [ntoskrnl.exe + 0x783240]
[  329] 0xFFFFF801807E5750 [ntoskrnl.exe + 0x9d6750]
[  330] 0xFFFFF801804F4E90 [ntoskrnl.exe + 0x6e5e90]
[  331] 0xFFFFF8018049AA10 [ntoskrnl.exe + 0x68ba10]
[  332] 0xFFFFF801804FF000 [ntoskrnl.exe + 0x6f0000]
[  333] 0xFFFFF8018071E6E0 [ntoskrnl.exe + 0x90f6e0]
[  334] 0xFFFFF801801E7C70 [ntoskrnl.exe + 0x3d8c70]
[  335] 0xFFFFF8018046FC80 [ntoskrnl.exe + 0x660c80]
[  336] 0xFFFFF8018074C110 [ntoskrnl.exe + 0x93d110]
[  337] 0xFFFFF801801E7C90 [ntoskrnl.exe + 0x3d8c90]
[  338] 0xFFFFF801801E7CB0 [ntoskrnl.exe + 0x3d8cb0]
[  339] 0xFFFFF801801E7CD0 [ntoskrnl.exe + 0x3d8cd0]
[  340] 0xFFFFF80180433B80 [ntoskrnl.exe + 0x624b80]
[  341] 0xFFFFF801805E0D90 [ntoskrnl.exe + 0x7d1d90]
[  342] 0xFFFFF801805E7790 [ntoskrnl.exe + 0x7d8790]
[  343] 0xFFFFF8018071E460 [ntoskrnl.exe + 0x90f460]
[  344] 0xFFFFF801804DD3B0 [ntoskrnl.exe + 0x6ce3b0]
[  345] 0xFFFFF801804DBDF0 [ntoskrnl.exe + 0x6ccdf0]
[  346] 0xFFFFF801805E5B30 [ntoskrnl.exe + 0x7d6b30]
[  347] 0xFFFFF801806F27E0 [ntoskrnl.exe + 0x8e37e0]
[  348] 0xFFFFF801806F2A20 [ntoskrnl.exe + 0x8e3a20]
[  349] 0xFFFFF801805E1050 [ntoskrnl.exe + 0x7d2050]
[  350] 0xFFFFF8018071FE70 [ntoskrnl.exe + 0x910e70]
[  351] 0xFFFFF8018054D6E0 [ntoskrnl.exe + 0x73e6e0]
[  352] 0xFFFFF801804DFAB0 [ntoskrnl.exe + 0x6d0ab0]
[  353] 0xFFFFF8018050A950 [ntoskrnl.exe + 0x6fb950]
[  354] 0xFFFFF801805E5F90 [ntoskrnl.exe + 0x7d6f90]
[  355] 0xFFFFF8018054D930 [ntoskrnl.exe + 0x73e930]
[  356] 0xFFFFF801807E5A80 [ntoskrnl.exe + 0x9d6a80]
[  357] 0xFFFFF80180518160 [ntoskrnl.exe + 0x709160]
[  358] 0xFFFFF801804F53F0 [ntoskrnl.exe + 0x6e63f0]
[  359] 0xFFFFF8018051FB10 [ntoskrnl.exe + 0x710b10]
[  360] 0xFFFFF801804B12E0 [ntoskrnl.exe + 0x6a22e0]
[  361] 0xFFFFF801804AECA0 [ntoskrnl.exe + 0x69fca0]
[  362] 0xFFFFF80180503A50 [ntoskrnl.exe + 0x6f4a50]
[  363] 0xFFFFF80180503AE0 [ntoskrnl.exe + 0x6f4ae0]
[  364] 0xFFFFF80180227EB0 [ntoskrnl.exe + 0x418eb0]
[  365] 0xFFFFF801805240A0 [ntoskrnl.exe + 0x7150a0]
[  366] 0xFFFFF801801E7CF0 [ntoskrnl.exe + 0x3d8cf0]
[  367] 0xFFFFF80180221360 [ntoskrnl.exe + 0x412360]
[  368] 0xFFFFF801801E7D10 [ntoskrnl.exe + 0x3d8d10]
[  369] 0xFFFFF801801E7D30 [ntoskrnl.exe + 0x3d8d30]
[  370] 0xFFFFF801801E7D50 [ntoskrnl.exe + 0x3d8d50]
[  371] 0xFFFFF801801E8270 [ntoskrnl.exe + 0x3d9270]
[  372] 0xFFFFF8018051D850 [ntoskrnl.exe + 0x70e850]
[  373] 0xFFFFF801807EB9C0 [ntoskrnl.exe + 0x9dc9c0]
[  374] 0xFFFFF801800F73F0 [ntoskrnl.exe + 0x2e83f0]
[  375] 0xFFFFF80180571CC0 [ntoskrnl.exe + 0x762cc0]
[  376] 0xFFFFF801807108D0 [ntoskrnl.exe + 0x9018d0]
[  377] 0xFFFFF801806F2D80 [ntoskrnl.exe + 0x8e3d80]
[  378] 0xFFFFF801801E8290 [ntoskrnl.exe + 0x3d9290]
[  379] 0xFFFFF801806F3200 [ntoskrnl.exe + 0x8e4200]
[  380] 0xFFFFF80180445C10 [ntoskrnl.exe + 0x636c10]
[  381] 0xFFFFF8018074C240 [ntoskrnl.exe + 0x93d240]
[  382] 0xFFFFF80180509230 [ntoskrnl.exe + 0x6fa230]
[  383] 0xFFFFF80180466980 [ntoskrnl.exe + 0x657980]
[  384] 0xFFFFF80180568D30 [ntoskrnl.exe + 0x759d30]
[  385] 0xFFFFF801806F3560 [ntoskrnl.exe + 0x8e4560]
[  386] 0xFFFFF80180795F50 [ntoskrnl.exe + 0x986f50]
[  387] 0xFFFFF801800AB190 [ntoskrnl.exe + 0x29c190]
[  388] 0xFFFFF801801E7D70 [ntoskrnl.exe + 0x3d8d70]
[  389] 0xFFFFF801801E7D90 [ntoskrnl.exe + 0x3d8d90]
[  390] 0xFFFFF801804517E0 [ntoskrnl.exe + 0x6427e0]
[  391] 0xFFFFF801801E7DB0 [ntoskrnl.exe + 0x3d8db0]
[  392] 0xFFFFF801801E82F0 [ntoskrnl.exe + 0x3d92f0]
[  393] 0xFFFFF801806F37A0 [ntoskrnl.exe + 0x8e47a0]
[  394] 0xFFFFF801806F37C0 [ntoskrnl.exe + 0x8e47c0]
[  395] 0xFFFFF801806F3A50 [ntoskrnl.exe + 0x8e4a50]
[  396] 0xFFFFF801804A1D80 [ntoskrnl.exe + 0x692d80]
[  397] 0xFFFFF8018064BDB0 [ntoskrnl.exe + 0x83cdb0]
[  398] 0xFFFFF801807E5DA0 [ntoskrnl.exe + 0x9d6da0]
[  399] 0xFFFFF801807E5FB0 [ntoskrnl.exe + 0x9d6fb0]
[  400] 0xFFFFF80180523A10 [ntoskrnl.exe + 0x714a10]
[  401] 0xFFFFF80180523A40 [ntoskrnl.exe + 0x714a40]
[  402] 0xFFFFF80180794B80 [ntoskrnl.exe + 0x985b80]
[  403] 0xFFFFF80180627D30 [ntoskrnl.exe + 0x818d30]
[  404] 0xFFFFF8018064B8B0 [ntoskrnl.exe + 0x83c8b0]
[  405] 0xFFFFF801805E0650 [ntoskrnl.exe + 0x7d1650]
[  406] 0xFFFFF801805E0630 [ntoskrnl.exe + 0x7d1630]
[  407] 0xFFFFF801807E61C0 [ntoskrnl.exe + 0x9d71c0]
[  408] 0xFFFFF8018071F7A0 [ntoskrnl.exe + 0x9107a0]
[  409] 0xFFFFF801805E11E0 [ntoskrnl.exe + 0x7d21e0]
[  410] 0xFFFFF801805E11E0 [ntoskrnl.exe + 0x7d21e0]
[  411] 0xFFFFF801800C2FB0 [ntoskrnl.exe + 0x2b3fb0]
[  412] 0xFFFFF80180710A40 [ntoskrnl.exe + 0x901a40]
[  413] 0xFFFFF801801E7DD0 [ntoskrnl.exe + 0x3d8dd0]
[  414] 0xFFFFF8018046DD60 [ntoskrnl.exe + 0x65ed60]
[  415] 0xFFFFF8018054CE70 [ntoskrnl.exe + 0x73de70]
[  416] 0xFFFFF801801E7DF0 [ntoskrnl.exe + 0x3d8df0]
[  417] 0xFFFFF80180768D40 [ntoskrnl.exe + 0x959d40]
[  418] 0xFFFFF801804C2060 [ntoskrnl.exe + 0x6b3060]
[  419] 0xFFFFF801801E7E10 [ntoskrnl.exe + 0x3d8e10]
[  420] 0xFFFFF801801E82B0 [ntoskrnl.exe + 0x3d92b0]
[  421] 0xFFFFF801805277D0 [ntoskrnl.exe + 0x7187d0]
[  422] 0xFFFFF80180174890 [ntoskrnl.exe + 0x365890]
[  423] 0xFFFFF801805E7980 [ntoskrnl.exe + 0x7d8980]
[  424] 0xFFFFF80180469140 [ntoskrnl.exe + 0x65a140]
[  425] 0xFFFFF80180469CC0 [ntoskrnl.exe + 0x65acc0]
[  426] 0xFFFFF801801E7730 [ntoskrnl.exe + 0x3d8730]
[  427] 0xFFFFF801805E11E0 [ntoskrnl.exe + 0x7d21e0]
[  428] 0xFFFFF801805E11E0 [ntoskrnl.exe + 0x7d21e0]
[  429] 0xFFFFF80180720590 [ntoskrnl.exe + 0x911590]
[  430] 0xFFFFF801804F32A0 [ntoskrnl.exe + 0x6e42a0]
[  431] 0xFFFFF801807E63D0 [ntoskrnl.exe + 0x9d73d0]
[  432] 0xFFFFF801807E66F0 [ntoskrnl.exe + 0x9d76f0]
[  433] 0xFFFFF8018052B1F0 [ntoskrnl.exe + 0x71c1f0]
[  434] 0xFFFFF801808372D0 [ntoskrnl.exe + 0xa282d0]
[  435] 0xFFFFF801807DD350 [ntoskrnl.exe + 0x9ce350]
[  436] 0xFFFFF801804C9400 [ntoskrnl.exe + 0x6ba400]
[  437] 0xFFFFF801800F2550 [ntoskrnl.exe + 0x2e3550]
[  438] 0xFFFFF80180142770 [ntoskrnl.exe + 0x333770]
[  439] 0xFFFFF8018052AF80 [ntoskrnl.exe + 0x71bf80]
[  440] 0xFFFFF8018063F8A0 [ntoskrnl.exe + 0x8308a0]
[  441] 0xFFFFF801805E9BD0 [ntoskrnl.exe + 0x7dabd0]
[  442] 0xFFFFF801804ADF20 [ntoskrnl.exe + 0x69ef20]
[  443] 0xFFFFF8018042BB30 [ntoskrnl.exe + 0x61cb30]
[  444] 0xFFFFF801800B5DD0 [ntoskrnl.exe + 0x2a6dd0]
[  445] 0xFFFFF801803BAC00 [ntoskrnl.exe + 0x5abc00]
[  446] 0xFFFFF801801E82D0 [ntoskrnl.exe + 0x3d92d0]
[  447] 0xFFFFF801807EB550 [ntoskrnl.exe + 0x9dc550]
[  448] 0xFFFFF801807EB7C0 [ntoskrnl.exe + 0x9dc7c0]
[  449] 0xFFFFF801804B0E80 [ntoskrnl.exe + 0x6a1e80]
[  450] 0xFFFFF80180795FD0 [ntoskrnl.exe + 0x986fd0]
[  451] 0xFFFFF8018050F9B0 [ntoskrnl.exe + 0x7009b0]
[  452] 0xFFFFF80180517E10 [ntoskrnl.exe + 0x708e10]
[  453] 0xFFFFF80180761230 [ntoskrnl.exe + 0x952230]
[  454] 0xFFFFF801805165A0 [ntoskrnl.exe + 0x7075a0]
[  455] 0xFFFFF80180505E10 [ntoskrnl.exe + 0x6f6e10]
[  456] 0xFFFFF801806F3CE0 [ntoskrnl.exe + 0x8e4ce0]
[  457] 0xFFFFF801801E7E30 [ntoskrnl.exe + 0x3d8e30]
[  458] 0xFFFFF8018058A0F0 [ntoskrnl.exe + 0x77b0f0]
[  459] 0xFFFFF801807E69A0 [ntoskrnl.exe + 0x9d79a0]
[  460] 0xFFFFF8018018E350 [ntoskrnl.exe + 0x37f350]
[  461] 0xFFFFF80180726400 [ntoskrnl.exe + 0x917400]
[  462] 0xFFFFF801804D84A0 [ntoskrnl.exe + 0x6c94a0]
[  463] 0xFFFFF801804D86E0 [ntoskrnl.exe + 0x6c96e0]
[  464] 0xFFFFF801804D7E50 [ntoskrnl.exe + 0x6c8e50]
[  465] 0xFFFFF80180545930 [ntoskrnl.exe + 0x736930]
[  466] 0xFFFFF8018011E0C0 [ntoskrnl.exe + 0x30f0c0]
[  467] 0xFFFFF8018049E420 [ntoskrnl.exe + 0x68f420]
[  468] 0xFFFFF801804AF7F0 [ntoskrnl.exe + 0x6a07f0]
[  469] 0xFFFFF801804B0900 [ntoskrnl.exe + 0x6a1900]
[  470] 0xFFFFF801805E11E0 [ntoskrnl.exe + 0x7d21e0]
[  471] 0xFFFFF801804E6EB0 [ntoskrnl.exe + 0x6d7eb0]
[  472] 0xFFFFF80180710BD0 [ntoskrnl.exe + 0x901bd0]
[  473] 0xFFFFF801807EBD80 [ntoskrnl.exe + 0x9dcd80]
[  474] 0xFFFFF8018014BA20 [ntoskrnl.exe + 0x33ca20]
[  475] 0xFFFFF801805E11E0 [ntoskrnl.exe + 0x7d21e0]
[  476] 0xFFFFF801805E11E0 [ntoskrnl.exe + 0x7d21e0]
```

## Crypto Module

### crypto::providers

List cryptographic providers

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

List (or export) certificates

/export /systemstore: /store: /silent /nokey

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

List (or export) keys containers

/export /provider: /providerype: /cngprovider: /machine /silent

CNG providers: Microsoft Software Key Storage Provider',
        'Microsoft Smart Card Key Storage Provider',
        'Microsoft Platform Crypto Provider',
        'Microsoft Key Protection Provider',
        'Microsoft Passport Key Storage Provider',
        'Microsoft Primitive Provider',
        'Microsoft SSL Protocol Provider',
        'Windows Client Key Protection Provider'

CAPI Providers:
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

CAPI Provider types: 'PROV_RSA_FULL',
        'PROV_RSA_AES',
        'PROV_RSA_SIG',
        'PROV_RSA_SCHANNEL',
        'PROV_DSS',
        'PROV_DSS_DH',
        'PROV_DH_SCHANNEL',
        'PROV_FORTEZZA',
        'PROV_MS_EXCHANGE',
        'PROV_SSL'

### crypto::sc

List smartcard readers

### crypto::hash

Hash a&nbsp;password with&nbsp;optional username

/password: /user: /count:

### crypto::system

Describe a&nbsp;Windows System Certificate (file, registry or&nbsp;hive)

/export /file:

### crypto::scauth

Create an&nbsp;authentication certitifate (smartcard like) from&nbsp;a&nbsp;CA

/caname: /upn: /pfx: /castore: /hw /csp: /pin: /nostore /crldp: /keysize: /cahash: /cn: /o: /ou: /c:

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

/store: /name: /csp: /pin:

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

Patch CryptoAPI layer for&nbsp;easy export

### crypto::cng

Patch CNG service for&nbsp;easy export

### crypto::extract

Extract keys from&nbsp;CAPI RSA/AES provider

### crypto::kutil

### crypto::tpminfo

## SekurLsa Module

Some commands to&nbsp;enumerate credentials...

### sekurlsa::msv

Lists LM & NTLM credentials

### sekurlsa::wdigest

Lists WDigest credentials

### sekurlsa::kerberos

Lists Kerberos credentials

### sekurlsa::tspkg

Lists TsPkg credentials

### sekurlsa::livessp

Lists LiveSSP credentials

### sekurlsa::cloudap

Lists CloudAp credentials

### sekurlsa::ssp

Lists SSP credentials

### sekurlsa::logonPasswords

Lists all available providers credentials

### sekurlsa::process

Switch (or reinit) to&nbsp;LSASS process  context

### sekurlsa::minidump

Switch (or reinit) to&nbsp;LSASS minidump context

### sekurlsa::bootkey

Set the&nbsp;SecureKernel Boot Key to&nbsp;attempt to&nbsp;decrypt LSA Isolated credentials

### sekurlsa::pth

Pass-the-hash

/user: /domain: /luid: /ntlm: /aes128: /aes256: /impersonate /run:

### sekurlsa::krbtgt

### sekurlsa::dpapisystem

DPAPI_SYSTEM secret

### sekurlsa::trust

Antisocial

### sekurlsa::backupkeys

Preferred Backup Master keys

/export

### sekurlsa::tickets

List Kerberos tickets

/export

### sekurlsa::ekeys

List Kerberos Encryption Keys

### sekurlsa::dpapi

List Cached MasterKeys

### sekurlsa::credman

List Credentials Manager

## Kerberos Authenticatin Package Module

### kerberos::ptt

Pass-the-ticket

### kerberos::list

List ticket(s)

/export

### kerberos::ask

Ask or&nbsp;get TGS tickets

/target: /rc4 /des /aes128 /aes256 /tkt /export /nocache

/target examples: 'cifs', 'ldap', 'host', 'rpcss', 'http', 'mssql', 'wsman'

### kerberos::tgt

Retrieve current TGT

### kerberos::purge

Purge ticket(s)

### kerberos::golden

Willy Wonka factory

/ptt /user: /domain: /des: /rc4: /aes128: /aes256: /service: /target: /krbtgt: /startoffset: /endin: /renewmax: /sid: /id: /groups: /sids: /claims: /rodc: /ticket:

### kerberos::hash

Hash password to&nbsp;keys

/password: /user: /domain: /count:

### kerberos::ptc

Pass-the-ccache

### kerberos::clist

List tickets in&nbsp;MIT/Heimdall ccache

/export

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

Ask debug privilege

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
924     fontdrvhost.exe
932     fontdrvhost.exe
1000    svchost.exe
828     dwm.exe
708     svchost.exe
1016    svchost.exe
548     svchost.exe
1036    svchost.exe
1120    svchost.exe
1136    svchost.exe
1228    svchost.exe
1344    svchost.exe
1476    VSSVC.exe
1484    svchost.exe
1604    svchost.exe
1652    svchost.exe
1404    svchost.exe
1544    svchost.exe
2636    svchost.exe
2756    svchost.exe
2772    svchost.exe
2796    dfsrs.exe
2804    Microsoft.ActiveDirectory.WebServices.exe
2812    ismserv.exe
2832    svchost.exe
2924    dfssvc.exe
2428    vds.exe
2748    AggregatorHost.exe
3960    sihost.exe
3976    svchost.exe
4008    taskhostw.exe
3228    ctfmon.exe
3644    explorer.exe
2416    TextInputHost.exe
3788    StartMenuExperienceHost.exe
4176    RuntimeBroker.exe
4296    SearchApp.exe
4408    RuntimeBroker.exe
4580    RuntimeBroker.exe
4748    taskhostw.exe
4716    msdtc.exe
4744    svchost.exe
4168    svchost.exe
4348    csrss.exe
5024    winlogon.exe
780     fontdrvhost.exe
4460    LogonUI.exe
4928    dwm.exe
2948    rdpclip.exe
2544    TabTip.exe
4840    TabTip32.exe
2908    dllhost.exe
2120    ApplicationFrameHost.exe
1064    dns.exe
3032    plasrv.exe
3596    win32calc.exe
5756    WmiPrvSE.exe
1264    WUDFHost.exe
5344    WUDFHost.exe
4284    ShellExperienceHost.exe
7044    RuntimeBroker.exe
6940    mimikatz.exe
4508    conhost.exe
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

/log:

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

/user: /id: /system /admin /domainadmin /enterpriseadmin

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

'dpapi::blob' = '/in: /raw: /out: /ascii /unprotect /masterkey: /password: /entropy: /prompt /machine'
'dpapi::cache' = '/file: /flush /load /save'
'dpapi::capi' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'
'dpapi::chrome' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'
'dpapi::cng' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'
'dpapi::cred' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'
'dpapi::credhist' = '/in: /sid: /password: /sha1:'
'dpapi::luna' = '/client: /hive: /unprotect /masterkey: /password: /entropy: /prompt /machine'
'dpapi::masterkey' = '/in: /protected /sid: /hash: /system: /password: /pvk: /rpc /dc: /domain:'
'dpapi::protect' = '/data: /description: /entropy: /machine /system /prompt /c /out:'
'dpapi::ps' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'
'dpapi::rdg' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'
'dpapi::ssh' = '/hive: /impersonate /unprotect /masterkey: /password: /entropy: /prompt /machine'
'dpapi::vault' = '/cred: /policy: /unprotect /masterkey: /password: /entropy: /prompt /machine'
'dpapi::wifi' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'
'dpapi::wwan' = '/in: /unprotect /masterkey: /password: /entropy: /prompt /machine'

### dpapi::blob

Describe a&nbsp;DPAPI blob, unprotect it&nbsp;with&nbsp;API or&nbsp;Masterkey

### dpapi::protect

Protect a&nbsp;data via a&nbsp;DPAPI call

### dpapi::masterkey

Describe a&nbsp;Masterkey file, unprotect each Masterkey (key depending)

### dpapi::credhist

Describe a&nbsp;Credhist file

### dpapi::create

Create a&nbsp;Masterkey file from&nbsp;raw key and&nbsp;metadata

### dpapi::capi

CAPI key test

### dpapi::cng

CNG key test

### dpapi::tpm

TPM key test

### dpapi::cred

### dpapi::vault

### dpapi::wifi

### dpapi::wwan

### dpapi::chrome

### dpapi::ssh

SSH Agent registry cache

### dpapi::rdg

RDG saved passwords

### dpapi::ps

PowerShell credentials (PSCredentials or&nbsp;SecureString)

### dpapi::lun

Safenet LunaHSM KSP

### dpapi::cloudapkd

### dpapi::cloudapreg

### dpapi::sccm

### dpapi::citrix

### dpapi::cache

/user: /password: /ntlm: /subject: /system: /security: /dcc:

## BusyLight Module

### busylight::list

### busylight::status

### busylight::single

/sound

/color: 0xFF0000 0x00FF00 0x0000FF

### busylight::off

### busylight::test

## System Environment Values Module

### sysenv::list

### sysenv::get

/name: /guid:

'name' = { 'Kernel_Lsa_Ppl_Config' } 
'guid' = { '{77fa9abd-0359-4d32-bd60-28f4e78f784b}' }

### sysenv::set

/name: /guid: /attributes: /data:

'name' = { 'Kernel_Lsa_Ppl_Config' } 
'guid' = { '{77fa9abd-0359-4d32-bd60-28f4e78f784b}' }
'attributes' = { '07' }
'data' = { '04' }

### sysenv::del

/name: /guid: /attributes:

'name' = { 'Kernel_Lsa_Ppl_Config' } 
'guid' = { '{77fa9abd-0359-4d32-bd60-28f4e78f784b}' }
'attributes' = { '07' }

## Security Identifiers Module

### sid::lookup

Name or&nbsp;SID lookup

/sid: /name: /system:

### sid::query

Query object by&nbsp;SID or&nbsp;name

/sam: /sid: /system:

### sid::modify

Modify object SID of&nbsp;an&nbsp;object

/sam: /sid: /new: /system:

### sid::add

Add a&nbsp;SID to&nbsp;sIDHistory of&nbsp;an&nbsp;object

/sam: /sid: /new: /system:

### sid::clear

Clear sIDHistory of&nbsp;an&nbsp;object

/sam: /sid: /system:

### sid::patch

Patch NTDS Service

## IIS XML Config Module

### iis::apphost

Command | Description
--|--
`iis::apphost /in:<applicationHost.config>` | TODO

/live /in: /pvk:

## RPC Control of&nbsp;Mimikatz

### rpc::server

/stop /protseq: /endpoint: /service: /noauth /ntlm /kerberos /noreg /secure /guid:

protseq: 'ncacn_ip_tcp', 'ncacn_http', 'ncacn_nb_tcp', 'ncacn_np'

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

Parameter | Description
--|--
`/long` | TODO
`/sub:` | TODO
`/cc:` | TODO
`/cn:` | TODO

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
