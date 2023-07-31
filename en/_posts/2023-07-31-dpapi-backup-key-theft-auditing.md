---
ref: dpapi-backup-key-theft-auditing
title: Detecting DPAPI Backup Key Theft
date: '2023-07-31T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/dpapi_backupkey_event.png
permalink: /en/dpapi-backup-key-theft-auditing/
---

## Introduction

The [Data Protection API (DPAPI)](https://learn.microsoft.com/en-us/windows/win32/api/dpapi/) in Windows is used to encrypt passwords saved by browsers, certificate private keys, and other sensitive data. Domain controllers (DCs) [hold backup master keys](https://learn.microsoft.com/en-us/windows/win32/seccng/cng-dpapi-backup-keys-on-ad-domain-controllers) that can be used to decrypt all such secrets encrypted with DPAPI on domain-joined computers. These backup keys are stored as self-signed certificates in Active Directory (AD) objects of type `secret` called `BCKUPKEY_*`:

![DPAPI Backup Key Screenshot](/assets/images/dpapi_backup_key.png)

![DPAPI Backup Key Location in Active Directory Screenshot](/assets/images/backupkeys_storage.png)

Attackers with sufficient permissions can [fetch these backup keys from AD](/en/retrieving-dpapi-backup-keys-from-active-directory/) through the [Local Security Authority (Domain Policy) Remote Protocol (MS-LSAD / LSARPC)](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-lsad/1b5471ef-4c33-4a91-b079-dfcbb82f05cc) and use them to decrypt any secrets protected by DPAPI on all domain-joined Windows machines.

It is therefore important for organizations to be able to detect the theft of DPAPI backup keys from AD by malicious actors. This article describes various ways of discovering this attack technique.

## Attack Classification

|----------------------------------------|-------------------------------------------------------------------------------------------|
| MITRE ATT&CK® Tactic                   | [Credential Access (TA0006)](https://attack.mitre.org/tactics/TA0006/)                    |
| MITRE ATT&CK® Technique                | [Credentials from Password Stores (T1555)](https://attack.mitre.org/techniques/T1555/)    |
| MITRE ATT&CK® Sub-Technique            | [Unsecured Credentials: Private Keys (T1552.004)](https://attack.mitre.org/techniques/T1552/004/)     |
| Tenable® Indicator of Attack           | [DPAPI Domain Backup Key Extraction](https://www.tenable.com/indicators/ioa/I-AdDpapiKey) |
| Microsoft® Defender for Identity Alert | [Malicious request of Data Protection API master key (alert ID 2020)](https://learn.microsoft.com/en-us/defender-for-identity/credential-access-alerts#malicious-request-of-data-protection-api-master-key-external-id-2020) |

## Detection on Domain Controllers

The most reliable way of detecting this attack technique is to monitor domain controllers for suspicious operations.

### Domain Controller Security Event Logs

When a DPAPI backup key is retrieved from a domain controller (DC) through the MS-LSAD protocol, an&nbsp;[undocumented](https://learn.microsoft.com/en-us/windows/security/threat-protection/auditing/audit-other-object-access-events) event with the following properties is generated on that DC:

|---------------|-----------------------------|
| Log Name      | Security                    |
| Event ID      | 4662                        |
| Keywords      | Audit Success               |
| Task Category | Other Object Access Events  |
| Object Server | LSA                         |
| Object Type   | SecretObject                |
| Accesses      | Query secret value          |
| Object Name   | Policy\Secrets\G$BCKUPKEY_* |

![Domain controller query secret value event screenshot](/assets/images/dpapi_backupkey_event.png)

<!--more-->

Auditing of `Success` events of type `Audit Other Object Access Events` from the `Object Access` category in `Advanced Audit Policy Configuration` must first be enabled on all DCs.

### Domain Controller Network Traffic

The misuse of the MS-LSAD / LSARPC protocol can also be detected through deep packet inspection of domain controller traffic:

|----------------------|--------------------------------------|
| RPC protocol UUID    | 12345778-1234-ABCD-EF00-0123456789AB |
| RPC operation name   | [LsarRetrievePrivateData](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-lsad/b46f3725-d3de-46b7-8245-a14edeb278a1) |
| RPC operation number | 43                                   |

Both `RPC/TCP` (TCP port 135 + ephemeral port) and `RPC/NP` (TCP port 445) bindings can be used by clients. In WireShark, the `lsarpc.opnum == 43` display filter can be used to identify this type of traffic:

![LSARPC WireShark Screenshot](/assets/images/dpapi_lsarpc_smb.png)

This detection technique is most probably [used by Microsoft Defender for Identity](https://learn.microsoft.com/en-us/defender-for-identity/credential-access-alerts#malicious-request-of-data-protection-api-master-key-external-id-2020) and the already discontinued Advanced Threat Analytics (ATA):

![Malicious request of Data Protection API master key event screenshot](/assets/images/dpapi_ata_event.png)

(Un)Fortunately, some organizations are slowly deploying SMB3 encryption even on DCs, which breaks this detection method, when the `RPC/NP` binding is used. IPSec tunneling would additionally break the detection at the network level for the `RPC/TCP` binding, but IPSec is rarely used.

## Detection on Endpoints

EDR solutions could theoretically be used to detect when corporate endpoints are misused to retrieve DPAPI backup keys from remote domain controllers. Unfortunately, all detection techniques listed in this section can easily be bypassed by obfuscation.

### Malicious Commands

Execution the the following off-the-shelf hacktools should raise an alert:

- `mimikatz.exe` tool with the `lsadump::backupkeys` parameter.
- `SharpDPAPI.exe` tool with the `backupkey` parameter.
- `Get-LsaBackupKey` PowerShell cmdlet from the DSInternals module.

This detection technique [is used by Microsoft Defender for Endpoint](https://learn.microsoft.com/en-us/azure/defender-for-cloud/alerts-reference), among others.

### Suspicious File Names

Both Mimikatz and DSInternals export stolen DPAPI backup keys into files with the following name format:
- `ntds_capi_*.pfx`
- `ntds_capi_*.pvk`

The presence of these files should thus be considered an indicator of compromise. This detection technique [is utilized by Elastic Security for endpoint](https://www.elastic.co/guide/en/security/current/creation-or-modification-of-domain-backup-dpapi-private-key.html), among others.

### Suspicious Win32 API Calls

All 3 hacktools mentioned in this chapter perform calls to the `LsaRetrievePrivateData`function from `advapi32.dll`, which can also be picked up by EDRs. This appears to be the most reliable detection method on endpoints, but it could still be bypassed by directly performing the respective RPC calls.

## Alternative Attack Techniques

Usage of the MS-LSAD protocol is [one of many ways](/en/retrieving-dpapi-backup-keys-from-active-directory) of extracting DPAPI backup keys from domain controllers. Other techniques include, but are not limited to:

- Fetching the keys through the directory replication protocol.
- Extracting the keys from `ntds.dit` database files.

The detection of these techniques is out-of-scope of this article.

## Additional Resources

- [Microsoft: DPAPI backup keys on Active Directory domain controllers](https://learn.microsoft.com/en-us/windows/win32/seccng/cng-dpapi-backup-keys-on-ad-domain-controllers)
- [DSInternals: Retrieving DPAPI Backup Keys from Active Directory](/en/retrieving-dpapi-backup-keys-from-active-directory)
- [CQURE: Extracting Roamed Private Keys from Active Directory](https://cqureacademy.com/blog/extracting-roamed-private-keys)
- [SpecterOps: HomeOperational Guidance for Offensive User DPAPI Abuse](https://posts.specterops.io/operational-guidance-for-offensive-user-dpapi-abuse-1fb7fac8b107)
- [Sygnia: The Downfall Of Dpapi Top Secret Weapon](https://blog.sygnia.co/the-downfall-of-dpapis-top-secret-weapon)
