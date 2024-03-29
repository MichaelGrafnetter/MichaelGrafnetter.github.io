---
ref: domain-controller-tls
title: Enforcing TLS 1.2+ for LDAPS on Domain Controllers
date: '2024-03-15T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/ad-dc-tls-ldaps-settings.png
permalink: /en/active-directory-domain-controller-tls-ldaps/
---

If LDAP over SSL (LDAPS) is running on your domain controllers (properly formatted certificates are installed on them), it is worth checking whether the legacy TLS 1.0 and TLS 1.1 protocols with 64-bit block ciphers are enabled on these DCs.

Although [Microsoft is planning to disable TLS 1.0 and TLS 1.1](https://techcommunity.microsoft.com/t5/windows-it-pro-blog/tls-1-0-and-tls-1-1-soon-to-be-disabled-in-windows/ba-p/3887947) in the near future, these protocols are still enabled by default on Windows Server 2022.

The [Nmap](https://nmap.org/) tool does a good job at checking LDAPS configuration remotely:

```bash
nmap --script ssl-enum-ciphers -p 636 'contoso-dc.contoso.com'
```
<!--more-->
```txt
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-03-15 07:02 CET
Nmap scan report for contoso-dc.contoso.com (10.213.0.3)
Host is up (0.00088s latency).
rDNS record for 10.213.0.3: CONTOSO-DC.contoso.com

PORT    STATE SERVICE
636/tcp open  ldapssl
| ssl-enum-ciphers:
|   TLSv1.0:
|     ciphers:
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA (secp384r1) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA (ecdh_x25519) - A
|       TLS_RSA_WITH_AES_256_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_3DES_EDE_CBC_SHA (rsa 2048) - C
|     compressors:
|       NULL
|     cipher preference: server
|     warnings:
|       64-bit block cipher 3DES vulnerable to SWEET32 attack
|   TLSv1.1:
|     ciphers:
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA (secp384r1) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA (ecdh_x25519) - A
|       TLS_RSA_WITH_AES_256_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_3DES_EDE_CBC_SHA (rsa 2048) - C
|     compressors:
|       NULL
|     cipher preference: server
|     warnings:
|       64-bit block cipher 3DES vulnerable to SWEET32 attack
|   TLSv1.2:
|     ciphers:
|       TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (secp384r1) - A
|       TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (ecdh_x25519) - A
|       TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 (dh 2048) - A
|       TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 (dh 2048) - A
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384 (secp384r1) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA (secp384r1) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA (ecdh_x25519) - A
|       TLS_RSA_WITH_AES_256_GCM_SHA384 (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_GCM_SHA256 (rsa 2048) - A
|       TLS_RSA_WITH_AES_256_CBC_SHA256 (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_CBC_SHA256 (rsa 2048) - A
|       TLS_RSA_WITH_AES_256_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_3DES_EDE_CBC_SHA (rsa 2048) - C
|     compressors:
|       NULL
|     cipher preference: server
|     warnings:
|       64-bit block cipher 3DES vulnerable to SWEET32 attack
|   TLSv1.3:
|     ciphers:
|       TLS_AKE_WITH_AES_256_GCM_SHA384 (secp384r1) - A
|       TLS_AKE_WITH_AES_128_GCM_SHA256 (ecdh_x25519) - A
|     cipher preference: server
|_  least strength: C
MAC Address: 00:17:FB:00:00:00 (FA)

Nmap done: 1 IP address (1 host up) scanned in 1.21 seconds
```

The preferred way of remediating these findings is to distribute the respective registry settings using a Group Policy Object (GPO). Here is a PowerShell script that does the required configuration:

```powershell
# Pre-existing Group Policy Object that is linked onto the Domain Controllers organizational unit
[string] $gpoName = 'Domain Controller Security Baseline'

# Disable TLS 1.0 for LDAPS and HTTPS servers
Set-GPRegistryValue `
    -Name $gpoName `
    -Key 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' `
    -ValueName Enabled `
    -Value 0 `
    -Type DWord

# Disable TLS 1.1 for LDAPS and HTTPS servers
Set-GPRegistryValue `
    -Name $gpoName `
    -Key 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' `
    -ValueName Enabled `
    -Value 0 `
    -Type DWord

# Disable 3DES (SWEET32 vulnerability) for LDAPS and HTTPS servers
Set-GPRegistryValue `
    -Name $gpoName `
    -Key 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168' `
    -ValueName Enabled `
    -Value 0 `
    -Type DWord

# Make sure that TLS 1.2 support is enabled. This is turned on by default in the newer Windows versions.
Set-GPRegistryValue `
    -Name $gpoName `
    -Key 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' `
    -ValueName Enabled `
    -Value 1 `
    -Type DWord

Set-GPRegistryValue `
    -Name $gpoName `
    -Key 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' `
    -ValueName DisabledByDefault `
    -Value 0 `
    -Type DWord

# Make sure that SSL 3.0 has not been accidentally enabled for LDAPS and HTTPS servers.
Set-GPRegistryValue `
    -Name $gpoName `
    -Key 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server' `
    -ValueName Enabled `
    -Value 0 `
    -Type DWord
```

The resulting GPO settings should look like this:

![Screenshot of Active Directory Domain Controller TLS Settings in a Group Policy Object](/assets/images/ad-dc-tls-ldaps-settings.png)

For the new settings to be applied, either the servers need to be rebooted, or the NTDS services must be restarted:

```powershell
gpupdate.exe /Target:Computer
Restart-Service -Name ntds -Force
```

A subsequent check using the `Nmap` tool should show the desired results:

```bash
nmap --script ssl-enum-ciphers -p 636 'contoso-dc.contoso.com'
```

```txt
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-03-15 07:03 CET
Nmap scan report for contoso-dc.contoso.com (10.213.0.3)
Host is up (0.0026s latency).
rDNS record for 10.213.0.3: CONTOSO-DC.contoso.com

PORT    STATE SERVICE
636/tcp open  ldapssl
| ssl-enum-ciphers:
|   TLSv1.2:
|     ciphers:
|       TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (secp384r1) - A
|       TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (ecdh_x25519) - A
|       TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 (dh 2048) - A
|       TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 (dh 2048) - A
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384 (secp384r1) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA (secp384r1) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA (ecdh_x25519) - A
|       TLS_RSA_WITH_AES_256_GCM_SHA384 (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_GCM_SHA256 (rsa 2048) - A
|       TLS_RSA_WITH_AES_256_CBC_SHA256 (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_CBC_SHA256 (rsa 2048) - A
|       TLS_RSA_WITH_AES_256_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_CBC_SHA (rsa 2048) - A
|     compressors:
|       NULL
|     cipher preference: server
|   TLSv1.3:
|     ciphers:
|       TLS_AKE_WITH_AES_256_GCM_SHA384 (secp384r1) - A
|       TLS_AKE_WITH_AES_128_GCM_SHA256 (ecdh_x25519) - A
|     cipher preference: server
|_  least strength: A
MAC Address: 00:17:FB:00:00:00 (FA)

Nmap done: 1 IP address (1 host up) scanned in 3.40 seconds
```
