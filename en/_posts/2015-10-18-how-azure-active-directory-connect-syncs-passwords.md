---
ref: how-azure-active-directory-connect-syncs-passwords
title: How Azure Active Directory Connect Syncs Passwords
date: 2015-10-18T12:28:41+00:00
layout: post
lang: en
permalink: /en/how-azure-active-directory-connect-syncs-passwords/
---
<p style="text-align: justify;">
  Many people have asked me about the&nbsp;security implications of&nbsp;synchronizing passwords from&nbsp;Active Directory to&nbsp;Azure Active Directory using the&nbsp;<a href="https://www.microsoft.com/en-us/download/details.aspx?id=47594">Azure AD Connect</a> tool. Although&nbsp;there is&nbsp;an article on Technet that&nbsp;<a href="https://technet.microsoft.com/en-us/library/dn246918.aspx">claims</a> that&nbsp;the&nbsp;passwords are synced in&nbsp;a very secure hashed form that&nbsp;cannot be misused for&nbsp;authentication against the&nbsp;on-premise Active Directory, it lacks any detail about the&nbsp;exact information being sent to&nbsp;Microsoft&#8217;s servers.
</p>

<p style="text-align: justify;">
  A&nbsp;<a href="http://blogs.technet.com/b/ad/archive/2014/06/28/aad-password-sync-encryption-and-and-fips-compliance.aspx">post</a> at the&nbsp;Active Directory Team Blog hints that&nbsp;the&nbsp;Password Sync agent retrieves pre-existing password hashes from&nbsp;AD and&nbsp;secures them by&nbsp;re-hashing them using SHA256 hash per <a href="https://www.ietf.org/rfc/rfc2898.txt">RFC 2898</a> (aka PBKDF2) before&nbsp;uploading them to&nbsp;the cloud. This sheds some light on the&nbsp;functionality, but&nbsp;some important implementation details are still missing, including the&nbsp;number of&nbsp;SHA256 iterations, salt length and&nbsp;the&nbsp;type of&nbsp;hash that&nbsp;is&nbsp;extracted from&nbsp;AD. Some <a href="https://www.cogmotive.com/blog/office-365-tips/how-secure-is-dirsync-with-password-synchronisation">research</a> on this topic has been done by&nbsp;Alan Byrne, but&nbsp;it is&nbsp;inconclusive. Therefore, I&nbsp;have decided to&nbsp;do my own research and&nbsp;to&nbsp;share my results.
</p>

<!--more-->

## How Azure AD Connect retrieves passwords from&nbsp;AD

<p style="text-align: justify;" align="justify">
  AD password synchronization is&nbsp;often implemented using <a href="https://msdn.microsoft.com/en-us/library/windows/desktop/ms721882(v=vs.85).aspx">password filters</a>, but&nbsp;this is&nbsp;not the&nbsp;case. Instead, the&nbsp;<a title="MS-DRSR" href="http://msdn.microsoft.com/en-us/library/cc228086.aspx">MS-DRSR</a> protocol is&nbsp;used to&nbsp;remotely retrieve password hashes from&nbsp;DCs. In&nbsp;other words, it basically does the&nbsp;same as&nbsp;the&nbsp;<a href="https://www.dsinternals.com/en/retrieving-active-directory-passwords-remotely/">Get-ADReplAccount</a> cmdlet I&nbsp;have recently created. The&nbsp;only sensitive information that&nbsp;the&nbsp;AD Connect pulls from&nbsp;AD is&nbsp;the <a href="https://msdn.microsoft.com/en-us/library/cc220961.aspx">unicodePwd</a> attribute, which&nbsp;contains MD4 hash (aka NT hash) of&nbsp;the password.
</p>

<p style="text-align: justify;" align="justify">
  You should also know that&nbsp;the&nbsp;password synchronization service connects to&nbsp;AD using a&nbsp;<a href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-aadconnect-accounts-permissions/#custom-settings-installation">special account</a> whose default name starts with <strong>MSOL_</strong>. This account is&nbsp;automatically created during the&nbsp;installation process and&nbsp;is&nbsp;delegated the&nbsp;<strong>Replicating Directory Changes All</strong> right. It would be a&nbsp;bad idea to&nbsp;replicate its password to&nbsp;a RODC. Furthermore, its cleartext password is&nbsp;also stored in&nbsp;the&nbsp;SQL Server database that&nbsp;the&nbsp;sync agent uses. It is&nbsp;therefore crucial to&nbsp;ensure that&nbsp;only Domain Admins have access to&nbsp;this DB.
</p>

<p align="justify">
  <a href="https://www.dsinternals.com/wp-content/uploads/msol_account.png"><img class="aligncenter wp-image-5281 size-medium" src="https://www.dsinternals.com/wp-content/uploads/msol_account-300x173.png" alt="MSOL Account" width="300" height="173" srcset="https://www.dsinternals.com/wp-content/uploads/msol_account-300x173.png 300w, https://www.dsinternals.com/wp-content/uploads/msol_account.png 544w" sizes="(max-width: 300px) 100vw, 300px" /></a>
</p>

## How Azure AD Connect sends passwords to&nbsp;the Cloud

<p style="text-align: justify;" align="justify">
  As&nbsp;already mentioned, a&nbsp;few cryptographic transformations are applied to&nbsp;the MD4 hash by&nbsp;the sync server before&nbsp;it is&nbsp;sent to&nbsp;the cloud:
</p>

<li style="text-align: justify;">
  The&nbsp;binary form of&nbsp;the MD4 hash, which&nbsp;has 16B, is&nbsp;converted to&nbsp;a 32B uppercase hexadecimal string.
</li>
<li style="text-align: justify;">
  This string is&nbsp;then converted back to&nbsp;binary form using the&nbsp;UTF-16 encoding, which&nbsp;extends the&nbsp;result into 64B.
</li>
<li style="text-align: justify;">
  Ten random bytes are generated to&nbsp;be used as&nbsp;salt.
</li>
<li style="text-align: justify;">
  The&nbsp;data generated in&nbsp;steps 2 and&nbsp;3 is&nbsp;then used as&nbsp;input to&nbsp;the <a title="PBKDF2" href="http://en.wikipedia.org/wiki/PBKDF2">PBKDF2</a> (Password-based Key Derivation Function 2) function with <del>100</del> 1000 (new since&nbsp;2016) iterations of&nbsp;<strong>HMAC-SHA256</strong>. The&nbsp;output is&nbsp;32B long.
</li>

This cryptographic transformation is&nbsp;internally called OrgId hash. A&nbsp;more formal definition could look as&nbsp;follows:

**OrgId Hash(NTHash)&nbsp;:= PBKDF2( UTF-16( ToUpper( ToHex(NTHash)))), RND(10), 1000, HMAC-SHA256, 32)  
** 

When&nbsp;a&nbsp;password is&nbsp;changed in&nbsp;Active Directory, the&nbsp;DC calculates its NT hash (among a&nbsp;few other kinds of&nbsp;hashes) and&nbsp;stores it in&nbsp;the&nbsp;database:

**NT Hash(plaintext)&nbsp;:= MD4(UTF-16(plaintext))**

After&nbsp;combining the&nbsp;2 former definitions, we get this complete transformation of&nbsp;the plaintext password, that&nbsp;is&nbsp;sent to&nbsp;Azure AD:

**OrgId Hash(plaintext)&nbsp;:= PBKDF2( UTF-16( ToUpper( ToHex( MD4( UTF-16(plaintext))))), RND(10), 1000, HMAC-SHA256, 32)**

<p align="justify">
  <strong>Example:</strong> MD4 hash of&nbsp;<strong>Pa$$w0rd</strong> is&nbsp;<strong>92937945B518814341DE3F726500D4FF</strong>. Let <strong>317ee9d1dec6508fa510</strong> be the&nbsp;randomly generated salt. The&nbsp;resulting OrgId hash would then be<br /> <strong>f4a257ffec53809081a605ce8ddedfbc9df9777b80256763bc0a6dd895ef404f</strong>. The&nbsp;hash is&nbsp;then concatenated with the&nbsp;salt and&nbsp;number of&nbsp;iterations into this final string that&nbsp;is&nbsp;sent to&nbsp;Azure AD in&nbsp;this exact form:
</p>

**v1;PPH1_MD4,<span class="blob-code-inner"><span class="pl-s"><span class="x x-first x-last">181a3024085fcee2f70e,1000,b39525c3bc72a1136fcf7c8a338e0c14313d0450d1a4c98ef0a6ddada3bc5b0a</span></span></span>;**

<p align="justify">
  Note that&nbsp;the&nbsp;string contains the&nbsp;iteration count and&nbsp;version number equal to&nbsp;1. This means that&nbsp;the&nbsp;protocol has been designed with a&nbsp;potential change in&nbsp;mind.
</p>

## Security analysis

<p style="text-align: justify;">
  Here are my thoughts on the&nbsp;security of&nbsp;the OrgId hash:
</p>

### + Proven algorithm

<p style="text-align: justify;">
  I&nbsp;really praise Microsoft for&nbsp;using the&nbsp;standardized and&nbsp;proven PBKDF2 function instead of&nbsp;reinventing the&nbsp;wheel.
</p>

### + Unusable for&nbsp;PTH attacks

<p style="text-align: justify;">
  The&nbsp;hash that&nbsp;gets sent to&nbsp;the cloud cannot be used in&nbsp;any pass-the-hash attack on Active Directory. The&nbsp;original NT hash cannot be calculated from&nbsp;OrgId hash in&nbsp;reasonable time.
</p>

### + Resistant against rainbow table attacks

<p style="text-align: justify;">
  Thanks to&nbsp;using a&nbsp;random salt, PBKDF2 is&nbsp;immune to&nbsp;rainbow table attacks. The&nbsp;salt is&nbsp;10B long, which&nbsp;is&nbsp;more than&nbsp;the&nbsp;recommended 8B minimum.
</p>

### + <del>Very few</del> Enough iterations

<p style="text-align: justify;">
  While&nbsp;the&nbsp;<a title="PKCS #5: Password-Based Cryptography Specification" href="https://www.ietf.org/rfc/rfc2898.txt">RFC document</a> from&nbsp;year 2000 contains a&nbsp;recommendation to&nbsp;use PBKDF2 with at least 1000 iterations, only 100 iterations of&nbsp;HMAC-SHA256 were performed by&nbsp;the sync agent back in&nbsp;2015. Luckily, this has been changed sometime in&nbsp;2016.
</p>

### &#8211; Unconventional expansion

<p style="text-align: justify;">
  The&nbsp;method of&nbsp;expanding the&nbsp;16B NT hash into 64B by&nbsp;converting it to&nbsp;hexadecimal string and&nbsp;re-encoding it using UTF-16 is&nbsp;rather unorthodox. It took me some time to&nbsp;figure this out. Fortunately, it probably does not have any impact on security.
</p>

<h2 style="text-align: justify;">
  Update 2015-10-19
</h2>

<p style="text-align: justify;">
  Just hours after&nbsp;I&nbsp;released information about OrgId hashes, support for&nbsp;this algorithm <a href="https://hashcat.net/trac/ticket/669">has been added</a> to&nbsp;<a href="http://hashcat.net/oclhashcat/">oclHashcat</a>, which&nbsp;is&nbsp;a popular password cracking tool that&nbsp;utilizes GPUs.
</p>

<h2 style="text-align: justify;">
  Update 2016-11-08
</h2>

<p style="text-align: justify;">
  Recent versions of&nbsp;Azure AD Connect started using 1000 iterations instead of&nbsp;just 100, as&nbsp;recommended by&nbsp;the <a title="PKCS #5: Password-Based Cryptography Specification" href="https://www.ietf.org/rfc/rfc2898.txt">RFC document</a>. This is&nbsp;great news, because&nbsp;this change renders brute-force attacks and&nbsp;even&nbsp;mask or&nbsp;dictionary attacks against OrgId hashes unfeasible.
</p>

<p style="text-align: justify;">
  I&nbsp;just wonder if&nbsp;my blog post influenced this decision.&nbsp;😉
</p>

## Conclusion

<p style="text-align: justify;">
  I&nbsp;would <del></del>say that&nbsp;the&nbsp;Password Sync feature is&nbsp;<strong>very</strong> <strong>secure <del>enough</del></strong><del>, despite the&nbsp;relatively low iteration count</del>. Even&nbsp;if&nbsp;someone hacked Microsoft and&nbsp;leaked these hashes, only weak passwords like &#8220;November2016&#8221; would be crackable using specialized software. But&nbsp;if&nbsp;you really want to&nbsp;play it safe, you should follow these recommendations:
</p>

  1. <p style="text-align: justify;">
      Implement a&nbsp;reasonable <strong>password policy</strong> to&nbsp;prevent dictionary attacks being successful.
    </p>

  2. <p style="text-align: justify;">
      Secure remote access to&nbsp;your network by&nbsp;using <strong>multi-factor authentication</strong>, so&nbsp;that&nbsp;the knowledge of&nbsp;someone&#8217;s password is&nbsp;not enough to&nbsp;get access to corporate resources.
    </p>

  3. <p style="text-align: justify;">
      Never, ever, under no circumstances, sync passwords of&nbsp;<strong>administrative accounts</strong> (Domain Admins, Schema Admins, etc.) to&nbsp;ANY cloud service.
    </p>

<p style="text-align: justify;">
  And&nbsp;for those who&nbsp;are still in&nbsp;doubt, Microsoft offers an alternative, the&nbsp;so-called <a href="https://support.office.com/en-us/article/Understanding-Office-365-identity-and-Azure-Active-Directory-06a189e7-5ec6-4af2-94bf-a22ea225a7a9#BK_Federated">Federated Identity</a>. The&nbsp;difference is&nbsp;that passwords are verified by&nbsp;the on-premises Active Directory, which&nbsp;means that&nbsp;the&nbsp;password hashes do&nbsp;not need to&nbsp;be synchronized to&nbsp;Azure AD.
</p>

## Sample implementation

<p style="text-align: justify;">
  For&nbsp;demonstration purposes, I&nbsp;have created my own implementation of&nbsp;the OrgId hash function that&nbsp;returns the&nbsp;same results as&nbsp;the&nbsp;original one. It can be played with using the&nbsp;<strong>ConvertTo-OrgIdHash</strong> cmdlet from&nbsp;the&nbsp;<a title="Na stiahnutie" href="https://www.dsinternals.com/en/downloads/">DSInternals</a> PowerShell module. Here is&nbsp;an example of&nbsp;its usage:
</p>

[<img class="aligncenter wp-image-811 size-large" src="https://www.dsinternals.com/wp-content/uploads/2015/01/ps_orgidhash-1024x325.png" alt="PowerShell OrgId Hash Calculation" width="540" height="171" srcset="https://www.dsinternals.com/wp-content/uploads/2015/01/ps_orgidhash-1024x325.png 1024w, https://www.dsinternals.com/wp-content/uploads/2015/01/ps_orgidhash-300x95.png 300w, https://www.dsinternals.com/wp-content/uploads/2015/01/ps_orgidhash.png 1170w" sizes="(max-width: 540px) 100vw, 540px" />](https://www.dsinternals.com/wp-content/uploads/2015/01/ps_orgidhash.png)