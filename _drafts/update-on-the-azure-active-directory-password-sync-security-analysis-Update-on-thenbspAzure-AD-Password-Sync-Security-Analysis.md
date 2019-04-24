---
id: 5911
title: 'Update on the&nbsp;Azure AD Password Sync Security Analysis'
date: 2015-10-21T22:23:36+00:00
author: Michael Grafnetter
layout: post
guid: https://www.dsinternals.com/?p=5911
permalink: /en/?p=5911
categories:
  - Uncategorized
---
<p style="text-align: justify;">
  A&nbsp;few days ago, I&nbsp;have published a&nbsp;<a href="https://www.dsinternals.com/en/how-azure-active-directory-connect-syncs-passwords/">security analysis of&nbsp;the Azure Active Directory Password Sync feature</a>. Today, a&nbsp;<a href="https://twitter.com/Alex_A_Simons/status/656644938126352385">discussion</a> between <a href="https://www.linkedin.com/pub/alex-simons/0/a4a/9ab">Alex Simons</a> (Director of&nbsp;Program Management, Microsoft Identity and&nbsp;Security Services Division), Paul Bendall and&nbsp;me concerning the&nbsp;security of&nbsp;OrgId hashes took place on Twitter. Unfortunately, the&nbsp;Tweet length limit took its toll, because&nbsp;you simply cannot fit sophisticated thoughts on cryptography into 140 characters. Our statements might have therefore been slightly misinterpreted.
</p>

<p style="text-align: justify;">
  Here are Alex&#8217;s Tweets I&nbsp;could not fully agree with, even&nbsp;though&nbsp;I know that&nbsp;they are a&nbsp;little bit exaggerated and&nbsp;cannot be considered to&nbsp;be his official statement:
</p>

<blockquote class="twitter-tweet" lang="en" data-conversation="none">
  <p dir="ltr" lang="en">
    <a href="https://twitter.com/MGrafnetter">@MGrafnetter</a> <a href="https://twitter.com/paulbendall">@paulbendall</a> Contents is&nbsp;a non-reversible hash. We hash it again with SHA256 before&nbsp;passing it over SSL.
  </p>
  
  <p>
    — Alex Simons (@Alex_A_Simons) <a href="https://twitter.com/Alex_A_Simons/status/656892662448959488">October 21, 2015</a>
  </p>
</blockquote>

<p style="text-align: justify;">
  The&nbsp;contents Alex is&nbsp;referring to&nbsp;is MD4 (aka NT or&nbsp;NTLM) hash of&nbsp;user&#8217;s password and it is&nbsp;true that&nbsp;MD4 is&nbsp;irreversible in&nbsp;the&nbsp;general case. But specialized tools like <a href="http://hashcat.net/oclhashcat/">oclHashcat</a> can crack any 9-character alphanumeric password hashed using MD4 in&nbsp;<strong>less than 4 hours</strong> using brute force on a&nbsp;computer equipped with 8 high-end GPUs. Adding one more character would prolong this operation to&nbsp;2 weeks, which&nbsp;would still not discourage a&nbsp;determined attacker. And&nbsp;even&nbsp;better results can be achieved using dictionary or&nbsp;hybrid attacks.
</p>

<p style="text-align: justify;">
  Of&nbsp;course, this would not have been a&nbsp;problem if&nbsp;everybody used at least 14 characters long and&nbsp;random passwords, but&nbsp;the&nbsp;reality is&nbsp;quite different from&nbsp;this ideal.
</p>

<blockquote class="twitter-tweet" lang="en" data-conversation="none">
  <p dir="ltr" lang="en">
    <a href="https://twitter.com/paulbendall">@paulbendall</a> Since&nbsp;SHA256 is&nbsp;strong and&nbsp;not reversible, we don&#8217;t do&nbsp;anything extra here, it is&nbsp;sent over SSL to&nbsp;avoid MITM attacks.
  </p>
  
  <p>
    — Alex Simons (@Alex_A_Simons) <a href="https://twitter.com/Alex_A_Simons/status/656644938126352385">October 21, 2015</a>
  </p>
</blockquote>

<p style="text-align: justify;">
  One can only agree that&nbsp;SHA256 is&nbsp;much better than&nbsp;MD4, but&nbsp;even&nbsp;moderately strong passwords hashed with SHA256 can be cracked in&nbsp;reasonable time on crackstations. It is&nbsp;obvious that the person at Microsoft who&nbsp;designed the&nbsp;password sync functionality was fully aware of&nbsp;this fact, as&nbsp;the&nbsp;OrgId hash consists of&nbsp;100 SHA256 rounds rather&nbsp;than&nbsp;just one. My whole point was that&nbsp;increasing this number to&nbsp;&#8211; let&#8217;s say &#8211; 2048 would make many not-so-strong passwords much more secure. Because&nbsp;<strong>there are hackers out there</strong>, who&nbsp;would like to&nbsp;get hands on these hashes stored on Microsoft&#8217;s servers. No matter how improbable it is, they might succeed someday.
</p>

<p style="text-align: justify;">
  On the&nbsp;other hand, I&nbsp;must admit that&nbsp;a&nbsp;practical <strong>MITM attack wouldn&#8217;t be possible</strong> in&nbsp;this case. I&nbsp;am therefore sorry for&nbsp;unintentionally spreading FUD. Although&nbsp;the sync agent does not use certificate pinning and <a href="https://www.cogmotive.com/blog/office-365-tips/how-secure-is-dirsync-with-password-synchronisation">Fiddler can be used to&nbsp;monitor the&nbsp;traffic</a>, this couldn&#8217;t have been done without making the&nbsp;server trust Fiddler&#8217;s root certificate.
</p>

<blockquote class="twitter-tweet" lang="en" data-conversation="none">
  <p dir="ltr" lang="en">
    <a href="https://twitter.com/paulbendall">@paulbendall</a> <a href="https://twitter.com/MGrafnetter">@MGrafnetter</a> Paul &#8211; what do&nbsp;you guys keep in&nbsp;your directory that&nbsp;needs so&nbsp;much protection? Bank account numbers?&nbsp;😉
  </p>
  
  <p>
    — Alex Simons (@Alex_A_Simons) <a href="https://twitter.com/Alex_A_Simons/status/656893420032557056">October 21, 2015</a>
  </p>
</blockquote>

<p style="text-align: justify;">
  Perhaps no one stores bank account numbers in&nbsp;Active Directory. But&nbsp;is&nbsp;AD used to&nbsp;protect corporate or&nbsp;government resources that&nbsp;are whole lot more sensitive than&nbsp;just bank account numbers? Definitely!
</p>

<p style="text-align: justify;">
  Despite this minor disagreement, I&nbsp;still think that&nbsp;<strong>Azure is&nbsp;a great service</strong> and&nbsp;I&nbsp;simply love it. Did I&nbsp;mention my blog was<strong> hosted on Azure</strong>?
</p>