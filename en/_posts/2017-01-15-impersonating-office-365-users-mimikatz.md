---
title: Impersonating Office 365 Users With Mimikatz
date: 2017-01-15T19:35:43+00:00
layout: post
lang: en
permalink: /en/impersonating-office-365-users-mimikatz/
---

## Introduction

<p style="text-align: justify;">
  Last month, Microsoft has introduced a&nbsp;new feature of&nbsp;Azure AD Connect called <a href="https://docs.microsoft.com/en-us/azure/active-directory/connect/active-directory-aadconnect-sso">Single Sign On</a>. It allows companies to&nbsp;configure SSO between AD and&nbsp;AAD without the&nbsp;need to&nbsp;deploy <a href="https://technet.microsoft.com/en-us/library/hh831502(v=ws.11).aspx">ADFS</a>, which&nbsp;makes it an ideal solution for&nbsp;SMEs. Here is&nbsp;a high-level diagram of&nbsp;this functionality:
</p>

<p style="text-align: justify;">
  <a href="https://docs.microsoft.com/en-us/azure/active-directory/connect/media/active-directory-aadconnect-sso/sso2.png"><img class="aligncenter" src="https://docs.microsoft.com/en-us/azure/active-directory/connect/media/active-directory-aadconnect-sso/sso2.png" width="500" /></a>As&nbsp;we can see from&nbsp;the&nbsp;diagram above, Azure AD exposes a&nbsp;<a href="https://autologon.microsoftazuread-sso.com">publicly available endpoint</a> that&nbsp;accepts Kerberos tickets and&nbsp;translates them into SAML and&nbsp;JWT tokens, which&nbsp;are understood and&nbsp;trusted by&nbsp;other cloud services like Office 365, Azure or&nbsp;Salesforce. And&nbsp;wherever you have Kerberos-based authentication, it can be attacked using <a href="https://adsecurity.org/?p=2011">Silver Tickets</a>.
</p>

<p style="text-align: justify;">
  In&nbsp;usual circumstances this attack can only be performed from&nbsp;the&nbsp;intranet. But&nbsp;what really caught my attention is&nbsp;the fact that&nbsp;with this new SSO feature, <strong>Silver Tickets could be used from&nbsp;the&nbsp;entire internet</strong>. Let&#8217;s give it a&nbsp;try then!
</p>

## The&nbsp;Nasty Stuff

To&nbsp;test this technique, we need to&nbsp;retrieve some information from&nbsp;Active Directory first:

<li style="text-align: left;">
  NTLM password hash of&nbsp;the <a href="https://docs.microsoft.com/en-us/azure/active-directory/connect/active-directory-aadconnect-sso#how-single-sign-on-works">AZUREADSSOACC</a> account, e.g.&nbsp;<em>f9969e088b2c13d93833d0ce436c76dd</em>. This value can be retrieved from&nbsp;AD using <a href="https://github.com/gentilkiwi/mimikatz">mimikatz</a>: <pre class="nums:false lang:sh decode:true">mimikatz.exe "lsadump::dcsync /user:AZUREADSSOACC$" exit</pre>
  
  <p>
    My own <a href="https://github.com/MichaelGrafnetter/DSInternals">DSInternals PowerShell Module</a> could do&nbsp;the same job:
  </p>
  
  <pre class="nums:false lang:ps decode:true">Get-ADReplAccount -SamAccountName 'AZUREADSSOACC$' -Domain contoso `
-Server lon-dc1.contoso.local</pre>
  
  <p>
    Both of&nbsp;these commands need <em>Domain Admins</em> permissions.</li> 
    
    <li>
      Name of&nbsp;the AD domain, e.g.&nbsp;<em>contoso.local</em>.
    </li>
    <li style="text-align: justify;">
      AAD logon name of&nbsp;the user we want to&nbsp;impersonate, e.g.&nbsp;elrond@contoso.com. This is&nbsp;typically either his <em>userPrincipalName</em> or&nbsp;<em>mail</em> attribute from&nbsp;the&nbsp;on-prem AD.
    </li>
    <li>
      SID of&nbsp;the user we want to&nbsp;impersonate, e.g.&nbsp;<em>S-1-5-21-2121516926-2695913149-3163778339-1234</em>.
    </li></ol> 
    
    <p style="text-align: justify;">
      Having this information we can now&nbsp;create and&nbsp;use the&nbsp;Silver Ticket on any Windows computer connected to&nbsp;the internet. It does not even&nbsp;matter whether&nbsp;it is&nbsp;joined to&nbsp;a domain or&nbsp;a&nbsp;workgroup:
    </p>
    
    <ol>
      <li>
        Create the&nbsp;Silver Ticket and&nbsp;inject it into Kerberos cache: <pre class="nums:false lang:sh decode:true ">mimikatz.exe "kerberos::golden /user:elrond
/sid:S-1-5-21-2121516926-2695913149-3163778339 /id:1234
/domain:contoso.local /rc4:f9969e088b2c13d93833d0ce436c76dd
/target:aadg.windows.net.nsatc.net /service:HTTP /ptt" exit</pre>
      </li>
      
      <li>
        Launch <em>Mozilla Firefox</em>.
      </li>
      <li style="text-align: justify;">
        Go to&nbsp;<a href="about:config">about:config</a> and&nbsp;set the&nbsp;<a href="https://developer.mozilla.org/en-US/docs/Mozilla/Integrated_authentication">network.negotiate-auth.trusted-uris</a> preference to&nbsp;<a href="https://docs.microsoft.com/en-us/azure/active-directory/connect/active-directory-aadconnect-sso#ensuring-clients-sign-in-automatically">value</a> &#8220;https://aadg.windows.net.nsatc.net,https://autologon.microsoftazuread-sso.com&#8221;.
      </li>
      <li style="text-align: justify;">
        Navigate to&nbsp;any web application that&nbsp;is&nbsp;integrated with our AAD domain. We will use <a href="https://portal.office.com">Office 365</a>, which&nbsp;is&nbsp;the most commonly used one.
      </li>
      <li style="text-align: justify;">
        Once&nbsp;at the&nbsp;logon screen, fill in&nbsp;the&nbsp;user name, while&nbsp;leaving the&nbsp;password field empty. Then press TAB or&nbsp;ENTER.<br /> <img class="aligncenter size-full wp-image-8681" src="https://www.dsinternals.com/wp-content/uploads/aad_sso1.png" alt="" width="296" height="289" />
      </li>
      <li>
        That&#8217;s it, we&#8217;re in!<a href="https://www.dsinternals.com/wp-content/uploads/aad_sso2.png"><img class="aligncenter wp-image-8691 size-medium" src="https://www.dsinternals.com/wp-content/uploads/aad_sso2-300x178.png" width="300" height="178" srcset="https://www.dsinternals.com/wp-content/uploads/aad_sso2-300x178.png 300w, https://www.dsinternals.com/wp-content/uploads/aad_sso2.png 553w" sizes="(max-width: 300px) 100vw, 300px" /></a>
      </li>
      <li>
        To&nbsp;log in&nbsp;as another user, run the&nbsp;command below and&nbsp;repeat steps 1-6. <pre class="nums:false lang:sh decode:true">klist purge</pre>
      </li>
    </ol>
    
    <p style="text-align: justify;">
      It is&nbsp;also worth noting that&nbsp;the&nbsp;password of&nbsp;the <em>AZUREADSSOACC</em> account never changes, so&nbsp;the&nbsp;stolen hash/key will work forever. It could therefore be misused by&nbsp;highly privileged employees to&nbsp;retain access to&nbsp;the IT environment after&nbsp;leaving the&nbsp;company. Dealing with such situations is&nbsp;a much broader problem, which&nbsp;is&nbsp;aptly depicted by&nbsp;the following old Narnian saying:
    </p>
    
    <p>
      <a href="https://www.dsinternals.com/wp-content/uploads/narnia.png"><img class="aligncenter wp-image-8741" src="https://www.dsinternals.com/wp-content/uploads/narnia-300x128.png" width="500" height="213" srcset="https://www.dsinternals.com/wp-content/uploads/narnia-300x128.png 300w, https://www.dsinternals.com/wp-content/uploads/narnia.png 715w" sizes="(max-width: 500px) 100vw, 500px" /></a>
    </p>
    
    <h3>
      Countermeasures
    </h3>
    
    <p style="text-align: justify;">
      First of&nbsp;all, I&nbsp;have to&nbsp;point out that&nbsp;this technique would not be very practical in&nbsp;real-world situations due to&nbsp;these reasons:
    </p>
    
    <ul>
      <li style="text-align: justify;">
        The&nbsp;SSO feature is&nbsp;in Preview and&nbsp;has to&nbsp;be explicitly enabled by&nbsp;an AD admin. Just a&nbsp;handful of&nbsp;companies probably use it at the&nbsp;time of&nbsp;writing this article and&nbsp;enterprises will quite surely stick to&nbsp;their proven ADFS deployments even&nbsp;after this feature reaches GA.
      </li>
      <li style="text-align: justify;">
        The&nbsp;hash/key of&nbsp;the <em>AZUREADSSOACC</em> account can only be retrieved by&nbsp;Domain Admins from&nbsp;DCs by&nbsp;default. But&nbsp;if&nbsp;an attacker had such highly privileged access to&nbsp;an Active Directory domain, he/she would be able to&nbsp;do some way nastier stuff than&nbsp;just replicating a&nbsp;single hash.
      </li>
      <li style="text-align: justify;">
        The&nbsp;password of&nbsp;the <em>AZUREADSSOACC</em> account is&nbsp;randomly generated during the&nbsp;deployment of&nbsp;<em>Azure AD Connect</em>. It would therefore be impossible to&nbsp;guess this password.
      </li>
    </ul>
    
    <p style="text-align: justify;">
      As&nbsp;you can see, there is&nbsp;simply no need to&nbsp;panic. But&nbsp;just to&nbsp;be safe, I&nbsp;would recommend these generic security measures:
    </p>
    
    <ul>
      <li style="text-align: justify;">
        Only delegate administrative access to&nbsp;trusted individuals and&nbsp;keep the&nbsp;number of&nbsp;members of&nbsp;the <em>Domain Admins</em> group (and other privileged groups) as&nbsp;low as&nbsp;possible.
      </li>
      <li style="text-align: justify;">
        Protect backups of&nbsp;Domain Controllers, so&nbsp;no-one could <a href="https://www.dsinternals.com/en/dumping-ntds-dit-files-using-powershell/">extract sensitive information</a> from&nbsp;them.
      </li>
      <li style="text-align: justify;">
        Enable and&nbsp;enforce <a href="https://docs.microsoft.com/en-us/azure/multi-factor-authentication/multi-factor-authentication">Azure MFA</a> for&nbsp;users authenticating from&nbsp;external IP addresses. It is&nbsp;very straightforward and&nbsp;effective against many kinds of&nbsp;attacks.
      </li>
      <li style="text-align: justify;">
        Consider implementing <a href="https://docs.microsoft.com/cs-cz/azure/active-directory/active-directory-conditional-access">Azure AD conditional access</a>.
      </li>
      <li style="text-align: justify;">
        Deploy <a href="https://www.microsoft.com/en-us/cloud-platform/advanced-threat-analytics">Microsoft Advanced Threat Analytics</a> to&nbsp;detect malicious replication and&nbsp;other threats to&nbsp;your AD infrastructure.<br /> <a href="https://msdnshared.blob.core.windows.net/media/2016/11/Malicious-2.png"><img class="aligncenter" src="https://msdnshared.blob.core.windows.net/media/2016/11/Malicious-2.png" alt="ATA" width="400" /></a>
      </li>
      <li style="text-align: justify;">
        Force a&nbsp;password change on the&nbsp;<em>AZUREADSSOACC</em> account by&nbsp;<del>re-deploying Azure AD Connect SSO</del> <a href="https://docs.microsoft.com/en-us/azure/active-directory/connect/active-directory-aadconnect-sso-faq#how-can-i-roll-over-the-kerberos-decryption-key-of-the-azureadssoacc-computer-account">running the&nbsp;Update-AzureSSOForest cmdlet</a> after&nbsp;a&nbsp;highly privileged employee leaves the&nbsp;company and/or on a&nbsp;regular basis. This should be done together with resetting the&nbsp;password of&nbsp;<em>krbtgt</em> and&nbsp;other sensitive accounts.
      </li>
    </ul>
    
    <h3>
      Conclusion
    </h3>
    
    <p style="text-align: justify;">
      Although&nbsp;the&nbsp;Silver Ticket attack has been here for&nbsp;some years, it is&nbsp;now probably the&nbsp;first time it can be used over the&nbsp;internet against a&nbsp;cloud service, which&nbsp;theoretically makes it even&nbsp;more potent. On the&nbsp;other hand, it would be quite hard to  perform this technique in&nbsp;a real-world environment due to&nbsp;impracticalities discussed in&nbsp;the&nbsp;previous section, so&nbsp;there is&nbsp;no need to&nbsp;worry. The&nbsp;new Seamless SSO feature of&nbsp;Azure AD Connect can therefore be considered safe and&nbsp;preferred solution for&nbsp;SSO to&nbsp;Office 365 .
    </p>