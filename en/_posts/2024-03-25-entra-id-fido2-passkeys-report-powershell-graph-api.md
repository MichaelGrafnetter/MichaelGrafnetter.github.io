---
ref: entra-fido2-report
title: Listing FIDO2 Security Keys Registered in&nbsp;Entra&nbsp;ID
date: '2024-03-25T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/entra-id-fido2-security-key-report.png
permalink: /en/entra-id-fido2-passkeys-report-powershell-graph-api/
---

As passwordless authentication using Passkeys is finding its way into more and more Entra ID tenants, it is crucial for security auditors to get more than familiar with this technology. Although the [FIDO2 security key management plane](https://learn.microsoft.com/en-us/entra/identity/authentication/howto-authentication-passwordless-security-key) in the Entra ID Portal is continually improving, any security assessment of FIDO2 key usage still involves a lot of clicking:

![View FIDO2 security details](/assets/images/entra-id-security-key-view-details.png)

That is one of the reasons why I added the [capability to retrieve the list of all FIDO2 security keys](https://github.com/MichaelGrafnetter/DSInternals/blob/master/Documentation/PowerShell/Get-AzureADUserEx.md#example-2) registered in an Entra ID tenant into the [DSInternals PowerShell module](https://www.powershellgallery.com/packages/DSInternals) some years ago. Since then, the same capability [has been added](https://learn.microsoft.com/en-us/graph/api/fido2authenticationmethod-list?view=graph-rest-1.0&tabs=powershell) to the official Microsoft Graph API, making FIDO2-related PowerShell queries easier than ever:

```powershell
# Microsoft Graph API PowerShell modules must be already installed on the computer
Import-Module -Name Microsoft.Graph.Authentication,
                    Microsoft.Graph.Users,
                    Microsoft.Graph.Identity.SignIns `
              -ErrorAction Stop

# Authenticate against Entra ID
Connect-MgGraph -Scopes UserAuthenticationMethod.Read `
                -ContextScope Process `
                -NoWelcome `
                -ErrorAction Stop

# Fetch FIDO2 security key details for all users
Get-MgUser -All -Property Id,UserPrincipalName | ForEach-Object {
    Get-MgUserAuthenticationFido2Method -UserId $PSItem.Id |
        Add-Member -MemberType NoteProperty -Name UserPrincipalName -Value $PSItem.UserPrincipalName -PassThru
} | Format-Table -Property UserPrincipalName,CreatedDateTime,DisplayName,Model,AttestationLevel,AaGuid

# Logout
Disconnect-MgGraph
```

The output of the above script should look similar to the following example:

```txt
UserPrincipalName       CreatedDateTime        DisplayName       Model                                 AttestationLevel AaGuid
-----------------       ---------------        -----------       -----                                 ---------------- ------
michael@dsinternals.com 10/29/2023 12:40:57 PM AWSC Passkey Test                                       notAttested      01020304-0506-0708-0102-030405060708
michael@dsinternals.com 6/13/2023 8:47:47 PM   Feitian NFC       Feitian ePass FIDO2-NFC Authenticator attested         ee041bce-25e5-4cdb-8f86-897fd6418464
michael@dsinternals.com 4/15/2023 6:55:15 AM   Feitian Combi     Feitian iePass FIDO Authenticator     attested         3e22415d-7fdf-4ea4-8a0c-dd60c4249b9d
michael@dsinternals.com 12/12/2019 9:42:21 AM  YubiKey 5         YubiKey 5 Series                      attested         cb69481e-8ff7-4039-93ec-0a2729a154a8
michael@dsinternals.com 1/14/2022 3:25:27 PM   Feitian USB FP    Feitian BioPass FIDO2 Authenticator   attested         77010bd7-212a-4fc9-b236-d2ca5e9d4084
```

Additionally, the `Format-Table` cmdlet can also be replaced with `Out-GridView`:

```powershell
Get-MgUser -All -Property Id,UserPrincipalName | ForEach-Object {
    Get-MgUserAuthenticationFido2Method -UserId $PSItem.Id |
        Add-Member -MemberType NoteProperty -Name UserPrincipalName -Value $PSItem.UserPrincipalName -PassThru
} | Select-Object -Property UserPrincipalName,CreatedDateTime,DisplayName,Model,AttestationLevel,AaGuid |
    Out-GridView -Title 'FIDO2 Security Keys Registered in Entra ID Tenant' -Wait
```

This should produce a nice table with searchable and sortable data:

![Entra ID FIDO2 report screenshot](/assets/images/entra-id-fido2-security-key-report.png)
