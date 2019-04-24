---
id: 7471
title: 'How the&nbsp;Active Directory Expiring Links Feature Really Works'
date: 2016-04-04T10:50:20+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/7261-revision-v1/
permalink: /7261-revision-v1/
---
<p style="text-align: justify;">
  One of&nbsp;the new features in&nbsp;Windows Server 2016 will be the&nbsp;Active Directory Expiring Links feature, which&nbsp;enables time-bound group membership, expressed by&nbsp;a time-to-live (TTL) value. Here is&nbsp;how it works:
</p>

### Enabling the&nbsp;Expiring Links Feature

<p style="text-align: justify;">
  The&nbsp;Expiring Links feature had been a&nbsp;standalone feature in&nbsp;early Windows Server 2016 builds, but&nbsp;as&nbsp;of&nbsp;TP4, it is&nbsp;a part of&nbsp;the broader <a href="https://technet.microsoft.com/en-us/library/dn903243.aspx">Privileged Access Management (PAM)</a> feature. It is&nbsp;disabled by&nbsp;default, because&nbsp;it requires <strong>Windows Server 2016 forest functional level</strong>. One of&nbsp;the ways to&nbsp;enable the&nbsp;PAM feature is&nbsp;running this PowerShell cmdlet:
</p>

<pre class="lang:ps decode:true ">Enable-ADOptionalFeature -Identity 'Privileged Access Management Feature' -Target (Get-ADForest) -Scope ForestOrConfigurationSet</pre>

<p style="text-align: justify;">
  Note that&nbsp;once&nbsp;this feature is&nbsp;enabled in&nbsp;a forest, it can never be disabled again.
</p>

### Creating Expiring Links using PowerShell

<p style="text-align: justify;">
  Unfortunately, this feature is&nbsp;not exposed in&nbsp;any GUI (yet), so&nbsp;you cannot create expiring links, nor&nbsp;can you tell the&nbsp;difference between a&nbsp;regular link and&nbsp;an expiring one. We will therefore use PowerShell to&nbsp;do the&nbsp;job:
</p>

<pre class="lang:ps decode:true"># Add user PatColeman to&nbsp;the Domain Admins group for&nbsp;the&nbsp;next 2 hours
$ttl = New-TimeSpan -Hours 2
Add-ADGroupMember -Identity 'Domain Admins' -Members PatColeman -MemberTimeToLive $ttl

# Show group membership with TTL
Get-ADGroup -Identity 'Domain Admins' -ShowMemberTimeToLive -Properties member | Select-Object -ExpandProperty member
&lt;#
Output:
&lt;TTL=6987&gt;,CN=PatColeman,CN=Users,DC=adatum,DC=com
CN=Administrator,CN=Users,DC=adatum,DC=com
#&gt;</pre>

<p style="text-align: justify;">
  As&nbsp;we can see, the&nbsp;TTL value in&nbsp;the&nbsp;output is&nbsp;in seconds (2h = 7200s). As&nbsp;soon&nbsp;as&nbsp;the TTL expires, the&nbsp;DCs will automatically remove user PatColeman from&nbsp;the&nbsp;Domain Admins group and&nbsp;his current <strong>Kerberos tickets will also expire</strong>.
</p>

### Creating Expiring Links using LDAP

<p style="text-align: justify;">
  PowerShell is&nbsp;great, but&nbsp;what if&nbsp;we needed to&nbsp;stick with pure LDAP? Well, if&nbsp;you want to&nbsp;add a&nbsp;user into a&nbsp;group for&nbsp;a&nbsp;limited amount of&nbsp;time, you do&nbsp;it exactly as&nbsp;you are used to, but&nbsp;you have to&nbsp;specify his distinguished name (DN) in&nbsp;the&nbsp;new <a href="https://msdn.microsoft.com/en-us/library/cc223126.aspx#gt_2188fc83-e53b-4464-867d-9ab1c62e1619">TTL-DN form</a>: <TTL=TimeToLive,DN>. In&nbsp;our sample case, it would look like this:
</p>

**<TTL=7200,CN=PatColeman,CN=Users,DC=adatum,DC=com>**

<p style="text-align: justify;">
  To&nbsp;view the&nbsp;group membership with TTLs, the&nbsp;corresponding LDAP search operation has to&nbsp;contain the&nbsp;<a href="https://msdn.microsoft.com/en-us/library/mt220506.aspx">LDAP_SERVER_LINK_TTL</a> extended control (OID = 1.2.840.113556.1.4.2309). Here is&nbsp;a screenshot from&nbsp;the&nbsp;<strong>ldp.exe</strong> tool with this control enabled:
</p>

<a href="https://www.dsinternals.com/wp-content/uploads/link_ttl.png" rel="attachment wp-att-7311"><img class="aligncenter size-medium wp-image-7311" src="https://www.dsinternals.com/wp-content/uploads/link_ttl-300x202.png" alt="Link TTL" width="300" height="202" srcset="https://www.dsinternals.com/wp-content/uploads/link_ttl-300x202.png 300w, https://www.dsinternals.com/wp-content/uploads/link_ttl-768x518.png 768w, https://www.dsinternals.com/wp-content/uploads/link_ttl.png 775w" sizes="(max-width: 300px) 100vw, 300px" /></a>

### Implementation Details (Very Advanced Stuff)

<p style="text-align: justify;">
  I&nbsp;was also quite interested in&nbsp;how this feature is&nbsp;implemented in&nbsp;the&nbsp;<strong>ntds.dit</strong> file. I&nbsp;have found out that&nbsp;as&nbsp;soon&nbsp;as&nbsp;you enable the&nbsp;PAM feature, the&nbsp;DCs automatically extend their database schemas in&nbsp;the&nbsp;following way:
</p>

<li style="text-align: justify;">
  The&nbsp;<strong>expiration_time_col</strong> column is&nbsp;added to&nbsp;the <strong>link_table</strong> table. It contains timestamps (in the&nbsp;UTC <a href="https://msdn.microsoft.com/en-us/library/windows/desktop/ms724284%28v=vs.85%29.aspx">FILETIME</a> / 10<sup>7</sup> format), after&nbsp;which the&nbsp;links get deactivated. This is&nbsp;yet another reason for&nbsp;the&nbsp;time to&nbsp;be in&nbsp;sync between DCs.
</li>
<li style="text-align: justify;">
  The&nbsp;<strong>link_expiration_time_index</strong> index is&nbsp;added to&nbsp;the <strong>link_table</strong> table. It is&nbsp;created over these columns: <strong>expiration_time_col</strong>, <strong>link_DNT</strong>, <strong>backlink_DNT</strong>. Thanks to&nbsp;this index, DCs can find expired links very quickly.
</li>