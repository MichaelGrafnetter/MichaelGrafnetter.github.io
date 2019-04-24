---
id: 8631
title: Impersonating Any Office 365 User With Mimikatz
date: 2017-01-15T10:27:16+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/8561-revision-v1/
permalink: /8561-revision-v1/
---
### Introduction

Last month, Microsoft has introduced a&nbsp;new feature of&nbsp;Azure AD Connect called [Single Sign On](https://docs.microsoft.com/en-us/azure/active-directory/connect/active-directory-aadconnect-sso). It allows companies to&nbsp;configure SSO between AD and&nbsp;AAD without the&nbsp;need to&nbsp;deploy [ADFS](https://technet.microsoft.com/en-us/library/hh831502(v=ws.11).aspx), which&nbsp;makes it an ideal solution for&nbsp;SMEs. Here is&nbsp;a high-level diagram of&nbsp;this functionality:

[<img class="aligncenter" src="https://docs.microsoft.com/en-us/azure/active-directory/connect/media/active-directory-aadconnect-sso/sso2.png" width="350" />](https://docs.microsoft.com/en-us/azure/active-directory/connect/media/active-directory-aadconnect-sso/sso2.png)As&nbsp;we can see from&nbsp;the&nbsp;diagram above, Azure AD exposes a&nbsp;[publicly available endpoint](https://autologon.microsoftazuread-sso.com) that&nbsp;accepts Kerberos tickets and&nbsp;translates them into SAML and&nbsp;JWT tokens, which&nbsp;are understood and&nbsp;trusted by&nbsp;other cloud services like Office 365, Azure or&nbsp;Salesforce. And&nbsp;wherever you have Kerberos-based authentication, it can be attacked using [Silver Tickets](https://adsecurity.org/?p=2011).

Under usual circumstances this attack can only be performed from&nbsp;the&nbsp;intranet. But&nbsp;what really caught my attention is&nbsp;the fact that&nbsp;with this new SSO feature, Silver Tickets could be used from&nbsp;the&nbsp;entire internet. Let&#8217;s give it a&nbsp;try then!

The&nbsp;Nasty Stuff

Countermeasures

Conclusion