---
ref: active-directory-expiring-links
title: 'How the&nbsp;Active Directory Expiring Links Feature Really Works'
date: 2016-04-03T07:00:53+00:00
layout: post
lang: en
permalink: /en/how-the-active-directory-expiring-links-feature-really-works/
tags:
    - 'Active Directory'
    - LDAP
    - PowerShell
    - Security
---

One of the new features in Windows Server 2016 will be the Active Directory Expiring Links feature, which enables time-bound group membership, expressed by a time-to-live (TTL) value. Here is how it works:

## Enabling the Expiring Links Feature

The Expiring Links feature had been a standalone feature in early Windows Server 2016 builds, but as of TP4, it is a part of the broader [Privileged Access Management (PAM)](https://technet.microsoft.com/en-us/library/dn903243.aspx) feature. It is disabled by default, because it requires **Windows Server 2016 forest functional level**. One of the ways to enable the PAM feature is running this PowerShell cmdlet:

```powershell
Enable-ADOptionalFeature -Identity 'Privileged Access Management Feature' -Target (Get-ADForest) -Scope ForestOrConfigurationSet
```

Note that once this feature is enabled in a forest, it can never be disabled again.

## Creating Expiring Links using PowerShell

Unfortunately, this feature is not exposed in any GUI (yet), so you cannot create expiring links, nor can you tell the difference between a regular link and an expiring one. We will therefore use PowerShell to do the job:

```powershell
# Add user PatColeman to the Domain Admins group for the next 2 hours
$ttl = New-TimeSpan -Hours 2
Add-ADGroupMember -Identity 'Domain Admins' -Members PatColeman -MemberTimeToLive $ttl

# Show group membership with TTL
Get-ADGroup -Identity 'Domain Admins' -ShowMemberTimeToLive -Properties member | Select-Object -ExpandProperty member
<#
Output:
<TTL=6987>,CN=PatColeman,CN=Users,DC=adatum,DC=com
CN=Administrator,CN=Users,DC=adatum,DC=com
#>
```

As we can see, the TTL value in the output is in seconds (2h = 7200s). As soon as the TTL expires, the DCs will automatically remove user PatColeman from the Domain Admins group and his current **Kerberos tickets will also expire**.

## Creating Expiring Links using LDAP

PowerShell is great, but what if we needed to stick with pure LDAP? Well, if you want to add a user into a group for a limited amount of time, you do it exactly as you are used to, but you have to specify his distinguished name (DN) in the new [TTL-DN form](https://msdn.microsoft.com/en-us/library/cc223126.aspx#gt_2188fc83-e53b-4464-867d-9ab1c62e1619): &lt;TTL=TimeToLive,DN&gt;. In our sample case, it would look like this:

**&lt;TTL=7200,CN=PatColeman,CN=Users,DC=adatum,DC=com&gt;**

To view the group membership with TTLs, the corresponding LDAP search operation has to contain the [LDAP\_SERVER\_LINK\_TTL](https://msdn.microsoft.com/en-us/library/mt220506.aspx) extended control (OID = 1.2.840.113556.1.4.2309). Here is a screenshot from the **ldp.exe** tool with this control enabled:

![Link TTL](../../assets/images/link_ttl.png)

## Implementation Details (Very Advanced Stuff)

I was also quite interested in how this feature is implemented in the **ntds.dit** file. I have found out that as soon as you enable the PAM feature, the DCs automatically extend their database schemas in the following way:

1. The **expiration\_time\_col** column is added to the **link\_table** table. It contains timestamps (in the UTC [FILETIME](https://msdn.microsoft.com/en-us/library/windows/desktop/ms724284%28v=vs.85%29.aspx) / 10<sup>7</sup> format), after which the links get deactivated. This is yet another reason for the time to be in sync between DCs.
2. The **link\_expiration\_time\_index** index is added to the **link\_table** table. It is created over these columns: **expiration\_time\_col**, **link\_DNT**, **backlink\_DNT**. Thanks to this index, DCs can find expired links very quickly.