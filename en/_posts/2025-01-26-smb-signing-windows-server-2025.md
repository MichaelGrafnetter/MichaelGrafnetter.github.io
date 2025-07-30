---
ref: smb-signing-2025
title: Changes to SMB Signing Enforcement Defaults in Windows 24H2
date: '2025-01-26T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/cover/smb-signing-defaults.png
permalink: /en/smb-signing-windows-server-2025-client-11-24h2-defaults/
---

In the&nbsp;recently released Windows Server 2025 and&nbsp;Windows 11 24H2,
several network protocols have been reconfigured to&nbsp;be&nbsp;more secure by&nbsp;default.
One of&nbsp;the&nbsp;affected protocols is&nbsp;the&nbsp;Server Message Block (SMB),
where [message signing is&nbsp;now&nbsp;required under most circumstances](https://techcommunity.microsoft.com/blog/filecab/smb-security-hardening-in-windows-server-2025--windows-11/4226591).
These changes eliminate some&nbsp;[NTLM Relay Attack](https://www.semperis.com/blog/how-to-defend-against-ntlm-relay-attack/)
vectors, but&nbsp;do&nbsp;not mitigate this&nbsp;hacking technique completely.

The following table summarizes the&nbsp;old and&nbsp;new SMB signing enforcement defaults:

| Operating System           | SMB Client | SMB Server |
|----------------------------|------------|------------|
| Windows Server 2022 DC     | ❌*        | ✅        |
| Windows Server 2022 Member | ❌*        | ❌        |
| Windows 11 23H2            | ❌*        | ❌        |
| Windows Server 2025 DC     | ✅         | ✅        |
| Windows Server 2025 Member | ✅         | ❌        |
| Windows 11 24H2            | ✅         | ✅        |

Legend:

✅ SMB signing is&nbsp;required.

❌ SMB signing is&nbsp;not required.

❌* SMB signing is&nbsp;only mandated when&nbsp;connecting to&nbsp;`SYSVOL` and&nbsp;`NETLOGON` shares
that contain Group Policy Objects (GPOs) and&nbsp;logon scripts.
