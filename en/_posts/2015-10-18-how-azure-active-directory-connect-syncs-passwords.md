---
ref: how-azure-active-directory-connect-syncs-passwords
title: How Azure Active Directory Connect Syncs Passwords
date: 2015-10-18T12:28:41+00:00
layout: post
lang: en
permalink: /en/how-azure-active-directory-connect-syncs-passwords/
tags:
    - 'Active Directory'
    - 'Microsoft Azure'
    - 'Office 365'
    - PowerShell
    - Security
---

# Introduction 

Many people have asked me about the&nbsp;security implications of&nbsp;synchronizing passwords from&nbsp;Active Directory to Azure Active Directory using the [Azure AD Connect](https://www.microsoft.com/en-us/download/details.aspx?id=47594) tool. Although there is an article on Technet that [claims](https://technet.microsoft.com/en-us/library/dn246918.aspx) that the&nbsp;passwords are synced in&nbsp;a very secure hashed form&nbsp;that cannot be misused for authentication against the on-premise Active Directory, it lacks any detail about the exact information being sent to Microsoft’s servers.

A [post](http://blogs.technet.com/b/ad/archive/2014/06/28/aad-password-sync-encryption-and-and-fips-compliance.aspx) at the Active Directory Team Blog hints that the Password Sync agent retrieves pre-existing password hashes from AD and secures them by re-hashing them using SHA256 hash per [RFC 2898](https://www.ietf.org/rfc/rfc2898.txt) (aka PBKDF2) before uploading them to the cloud. This sheds some light on the functionality, but some important implementation details are still missing, including the number of SHA256 iterations, salt length and the type of hash that is extracted from AD. Some [research](https://www.cogmotive.com/blog/office-365-tips/how-secure-is-dirsync-with-password-synchronisation) on this topic has been done by Alan Byrne, but it is inconclusive. Therefore, I have decided to do my own research and to share my results.

# How Azure AD Connect retrieves passwords from AD

AD password synchronization is often implemented using [password filters](https://msdn.microsoft.com/en-us/library/windows/desktop/ms721882(v=vs.85).aspx), but this is not the case. Instead, the [MS-DRSR](http://msdn.microsoft.com/en-us/library/cc228086.aspx "MS-DRSR") protocol is used to remotely retrieve password hashes from DCs. In other words, it basically does the same as the [Get-ADReplAccount](https://www.dsinternals.com/en/retrieving-active-directory-passwords-remotely/) cmdlet I have recently created. The only sensitive information that the AD Connect pulls from AD is the [unicodePwd](https://msdn.microsoft.com/en-us/library/cc220961.aspx) attribute, which contains MD4 hash (aka NT hash) of the password.

You should also know that the password synchronization service connects to AD using a [special account](https://azure.microsoft.com/en-us/documentation/articles/active-directory-aadconnect-accounts-permissions/#custom-settings-installation) whose default name starts with **MSOL\_**. This account is automatically created during the installation process and is delegated the **Replicating Directory Changes All** right. It would be a bad idea to replicate its password to a RODC. Furthermore, its cleartext password is also stored in the SQL Server database that the sync agent uses. It is therefore crucial to ensure that only Domain Admins have access to this DB.

[![MSOL Account](https://www.dsinternals.com/wp-content/uploads/msol_account-300x173.png)](https://www.dsinternals.com/wp-content/uploads/msol_account.png)

# How Azure AD Connect sends passwords to the Cloud

As already mentioned, a few cryptographic transformations are applied to the MD4 hash by the sync server before it is sent to the cloud:

1. The binary form of the MD4 hash, which has 16B, is converted to a 32B uppercase hexadecimal string.
2. This string is then converted back to binary form using the UTF-16 encoding, which extends the result into 64B.
3. Ten random bytes are generated to be used as salt.
4. The data generated in steps 2 and 3 is then used as input to the [PBKDF2](http://en.wikipedia.org/wiki/PBKDF2 "PBKDF2") (Password-based Key Derivation Function 2) function with <del>100</del> 1000 (new since 2016) iterations of **HMAC-SHA256**. The output is 32B long.

This cryptographic transformation is internally called OrgId hash. A more formal definition could look as follows:

**OrgId Hash(NTHash) := PBKDF2( UTF-16( ToUpper( ToHex(NTHash)))), RND(10), 1000, HMAC-SHA256, 32)**

When a password is changed in Active Directory, the DC calculates its NT hash (among a few other kinds of hashes) and stores it in the database:

**NT Hash(plaintext) := MD4(UTF-16(plaintext))**

After combining the 2 former definitions, we get this complete transformation of the plaintext password, that is sent to Azure AD:

**OrgId Hash(plaintext) := PBKDF2( UTF-16( ToUpper( ToHex( MD4( UTF-16(plaintext))))), RND(10), 1000, HMAC-SHA256, 32)**

**Example:** MD4 hash of **Pa$$w0rd** is **92937945B518814341DE3F726500D4FF**. Let **317ee9d1dec6508fa510** be the randomly generated salt. The resulting OrgId hash would then be  
**f4a257ffec53809081a605ce8ddedfbc9df9777b80256763bc0a6dd895ef404f**. The hash is then concatenated with the salt and number of iterations into this final string that is sent to Azure AD in this exact form:

**v1;PPH1\_MD4,181a3024085fcee2f70e,1000,b39525c3bc72a1136fcf7c8a338e0c14313d0450d1a4c98ef0a6ddada3bc5b0a;**

Note that the string contains the iteration count and version number equal to 1. This means that the protocol has been designed with a potential change in mind.

# Security analysis

Here are my thoughts on the security of the OrgId hash:

## + Proven algorithm

I really praise Microsoft for using the standardized and proven PBKDF2 function instead of reinventing the wheel.

## + Unusable for PTH attacks

The hash that gets sent to the cloud cannot be used in any pass-the-hash attack on Active Directory. The original NT hash cannot be calculated from OrgId hash in reasonable time.

## + Resistant against rainbow table attacks

Thanks to using a random salt, PBKDF2 is immune to rainbow table attacks. The salt is 10B long, which is more than the recommended 8B minimum.

## + <del>Very few</del> Enough iterations

While the [RFC document](https://www.ietf.org/rfc/rfc2898.txt "PKCS #5: Password-Based Cryptography Specification") from year 2000 contains a recommendation to use PBKDF2 with at least 1000 iterations, only 100 iterations of HMAC-SHA256 were performed by the sync agent back in 2015. Luckily, this has been changed sometime in 2016.

## – Unconventional expansion

The method of expanding the 16B NT hash into 64B by converting it to hexadecimal string and re-encoding it using UTF-16 is rather unorthodox. It took me some time to figure this out. Fortunately, it probably does not have any impact on security.

# Update 2015-10-19

Just hours after I released information about OrgId hashes, support for this algorithm [has been added](https://hashcat.net/trac/ticket/669) to [oclHashcat](http://hashcat.net/oclhashcat/), which is a popular password cracking tool that utilizes GPUs.

# Update 2016-11-08

Recent versions of Azure AD Connect started using 1000 iterations instead of just 100, as recommended by the [RFC document](https://www.ietf.org/rfc/rfc2898.txt "PKCS #5: Password-Based Cryptography Specification"). This is great news, because this change renders brute-force attacks and even mask or dictionary attacks against OrgId hashes unfeasible.

I just wonder if my blog post influenced this decision. 😉

# Conclusion

I would say that the Password Sync feature is **very** **secure <del>enough</del>**<del>, despite the relatively low iteration count</del>. Even if someone hacked Microsoft and leaked these hashes, only weak passwords like “November2016” would be crackable using specialized software. But if you really want to play it safe, you should follow these recommendations:

1. Implement a reasonable **password policy** to prevent dictionary attacks being successful.
2. Secure remote access to your network by using **multi-factor authentication**, so that the knowledge of someone’s password is not enough to get access to corporate resources.
3. Never, ever, under no circumstances, sync passwords of **administrative accounts** (Domain Admins, Schema Admins, etc.) to ANY cloud service.

And for those who are still in doubt, Microsoft offers an alternative, the so-called [Federated Identity](https://support.office.com/en-us/article/Understanding-Office-365-identity-and-Azure-Active-Directory-06a189e7-5ec6-4af2-94bf-a22ea225a7a9#BK_Federated). The difference is that passwords are verified by the on-premises Active Directory, which means that the password hashes do not need to be synchronized to Azure AD.

# Sample implementation

For demonstration purposes, I have created my own implementation of the OrgId hash function that returns the same results as the original one. It can be played with using the **ConvertTo-OrgIdHash** cmdlet from the [DSInternals](https://www.dsinternals.com/en/downloads/) PowerShell module. Here is an example of its usage:

![PowerShell OrgId Hash Calculation](https://www.dsinternals.com/wp-content/uploads/2015/01/ps_orgidhash.png)