---
ref: aad-claims-xray-ng
title: Registering Claims X-Ray&nbsp;NG in&nbsp;Entra&nbsp;ID Using PowerShell
date: '2025-03-28T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/claims-xray-claims.png
permalink: /en/entra-id-claims-xray-ng-saml-powershell-graph-api/
---

## Introduction

*[ADFS]: Active Directory Federation Services
*[SAML]: Security Assertion Markup Language
*[AAD]: Azure Active Directory
*[AD]: Active Directory
*[MFA]: Multi-Factor Authentication
*[EID]: Entra ID

In this&nbsp;article you will learn how the&nbsp;[Claims X-Ray NG](https://claimsxray.net) application can&nbsp;be&nbsp;registered in&nbsp;Microsoft Entra ID
using the&nbsp;[Microsoft Graph PowerShell SDK](https://learn.microsoft.com/en-us/powershell/microsoftgraph).
With&nbsp;only minor modifications, this&nbsp;guide can&nbsp;be&nbsp;used to&nbsp;register almost any&nbsp;SAML-based application in&nbsp;Entra ID using PowerShell.

The Claims X-Ray NG app is&nbsp;a&nbsp;free tool that&nbsp;can&nbsp;be&nbsp;used to&nbsp;test federated identity providers and&nbsp;simulate application migration scenarios.
It can&nbsp;be&nbsp;deployed as&nbsp;a&nbsp;drop-in replacement of&nbsp;the&nbsp;now-defunct original Claims X-Ray application from&nbsp;Microsoft.

![Claims X-Ray NG](/assets/images/claims-xray-ng-claims.png)

## App Registration

We will first need to&nbsp;install the&nbsp;[Microsoft.Graph.Applications](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.applications/) and&nbsp;[Microsoft.Graph.Identity.SignIns](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.identity.signins/) PowerShell modules, including their dependencies:

```powershell
Install-Module -Name Microsoft.Graph.Applications,Microsoft.Graph.Identity.SignIns -Scope AllUsers -Force
```

We can&nbsp;then connect to&nbsp;Microsoft Graph API while&nbsp;specifying all permissions required by&nbsp;the&nbsp;registration process:

```powershell
Connect-MgGraph -NoWelcome -ContextScope Process -Scopes @(
   'User.Read',
   'Application.ReadWrite.All',
   'AppRoleAssignment.ReadWrite.All',
   'DelegatedPermissionGrant.ReadWrite.All',
   'Policy.Read.All',
   'Policy.ReadWrite.ApplicationConfiguration'
)
```

We are&nbsp;now&nbsp;ready to&nbsp;register the&nbsp;Claims X-Ray NG application in&nbsp;Entra ID:

```powershell
[string] $appName = 'Claims X-Ray NG'
[string] $appDescription = 'Use the Claims X-Ray NG service to debug and troubleshoot problems with claims issuance.'
[string] $redirectUrl = 'https://claimsxray.net/api/sso'
[hashtable] $infoUrls = @{
    MarketingUrl      = 'https://claimsxray.net/#about'
    TermsOfServiceUrl = 'https://github.com/marcusca10/claimsxray-ng?tab=MIT-1-ov-file'
}

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApplication] $registeredApp =
   New-MgApplication -DisplayName $appName `
                     -Description $appDescription `
                     -Web @{ RedirectUris = $redirectUrl } `
                     -DefaultRedirectUri $redirectUrl `
                     -GroupMembershipClaims All `
                     -Info $infoUrls
```
<!--more-->

The previous command would always fail when&nbsp;used with&nbsp;the&nbsp;`-SignInAudience` and&nbsp;`-IdentifierUris` parameters. These application properties thus need to&nbsp;be&nbsp;configured separately, making the&nbsp;application single-tenant:

```powershell
Update-MgApplication -ApplicationId $registeredApp.Id `
                     -SignInAudience 'AzureADMyOrg' `
                     -IdentifierUris 'urn:claimsxrayng'
```

## Application Logo

It is&nbsp;time to&nbsp;configure the&nbsp;application logo. As&nbsp;the&nbsp;Claims X-Ray website only contains a&nbsp;logo in&nbsp;the&nbsp;SVG format, which&nbsp;is&nbsp;not supported by&nbsp;Entra ID, I&nbsp;had to&nbsp;first convert it&nbsp;to&nbsp;PNG:

[![Claims X-Ray Logo](/assets/images/claims-xray-logo.png){:width="150px"}](/assets/images/claims-xray-logo.png)

The logo must be&nbsp;downloaded locally before&nbsp;it&nbsp;can&nbsp;be&nbsp;uploaded to&nbsp;Entra ID.
Upon success, the&nbsp;temporary local copy of&nbsp;the&nbsp;logo can&nbsp;be&nbsp;deleted:

```powershell
[string] $logoUrl = 'https://www.dsinternals.com/assets/images/claims-xray-logo.png'
[string] $tempLogoPath = New-TemporaryFile
Invoke-WebRequest -Uri $logoUrl -OutFile $tempLogoPath -UseBasicParsing -ErrorAction Stop
try {
    Set-MgApplicationLogo -ApplicationId $registeredApp.Id -ContentType 'image/png' -InFile $tempLogoPath
}
finally {
    # Cleanup
    Remove-Item -Path $tempLogoPath
}
```

## Service Principal

Now that&nbsp;the&nbsp;application itself is&nbsp;registered, we can&nbsp;now&nbsp;register the&nbsp;corresponding service principal, which&nbsp;will appear in&nbsp;the&nbsp;Enterprise Applications section of&nbsp;the&nbsp;Microsoft Entra Admin Center:

```powershell
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphServicePrincipal] $servicePrincipal =
   New-MgServicePrincipal -DisplayName $appName `
                          -AppId $registeredApp.AppId `
                          -AccountEnabled `
                          -ServicePrincipalType Application `
                          -PreferredSingleSignOnMode saml `
                          -ReplyUrls $redirectUrl `
                          -Notes $appDescription `
                          -Tags 'WindowsAzureActiveDirectoryIntegratedApp','WindowsAzureActiveDirectoryCustomSingleSignOnApplication'
```

## Token-Signing Certificate

One of&nbsp;the&nbsp;requirements for&nbsp;a&nbsp;functional relying party trust is&nbsp;a&nbsp;[token-signing certificate](https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/design/token-signing-certificates). For&nbsp;the&nbsp;sake of&nbsp;simplicity, we can&nbsp;generate a&nbsp;self-signed one, that&nbsp;will be&nbsp;valid for&nbsp;2 years:

```powershell
[datetime] $now = Get-Date
[string] $certificateDisplayName = 'CN={0} Entra ID Token Signing {1:yyyy}' -f $appName,$now
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSelfSignedCertificate] $tokenSigningCertificate =
   Add-MgServicePrincipalTokenSigningCertificate -ServicePrincipalId $servicePrincipal.Id `
                                                 -DisplayName $certificateDisplayName `
                                                 -EndDateTime $now.AddYears(2)
```

The result will look like this&nbsp;in&nbsp;Entra Admin Center:

![SAML Signing Certificate Screenshot](/assets/images/claims-xray-certificate.png)

## Application Permissions

> **NOTE:**
> While&nbsp;the&nbsp;*User.Read* permission is&nbsp;needed in&nbsp;some&nbsp;tenants for&nbsp;SAML sign-in to&nbsp;work,
> the&nbsp;application works fine without any permission scopes in&nbsp;other tenants.

As we want the&nbsp;Claims X-Ray NG app to&nbsp;receive information about signed-in users, we need to&nbsp;delegate the&nbsp;[User.Read](https://learn.microsoft.com/en-us/graph/permissions-reference#user-permissions) permission:

```powershell
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphServicePrincipal] $microsoftGraph =
    Get-MgServicePrincipal -Filter "DisplayName eq 'Microsoft Graph'"

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPermissionScope] $userReadScope =
    $microsoftGraph.Oauth2PermissionScopes | Where-Object Value -eq 'User.Read'

Update-MgApplication -ApplicationId $registeredApp.Id -RequiredResourceAccess @{
    ResourceAppId = $microsoftGraph.AppId
    ResourceAccess = @(@{
        id = $userReadScope.Id
        type = 'Scope'
    })
}
```

It would make sense to&nbsp;hide the&nbsp;corresponding consent prompt from&nbsp;end-users accessing the&nbsp;app:

![ Screenshot](/assets/images/claims-xray-user-consent.png)

We can&nbsp;therefore give the&nbsp;required consent on behalf of&nbsp;the&nbsp;entire Entra ID Tenant in&nbsp;advance:

```powershell
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOAuth2PermissionGrant] $adminConsent =
    New-MgOauth2PermissionGrant -ClientId $servicePrincipal.Id `
                                -ConsentType AllPrincipals `
                                -ResourceId $microsoftGraph.Id `
                                -Scope 'User.Read'
```

This is&nbsp;how the&nbsp;results should look in&nbsp;the&nbsp;Entra Admin Center:

![Admin Consent Screenshot](/assets/images/claims-xray-admin-consent.png)

## User Assignment

For users to&nbsp;see the&nbsp;application in&nbsp;the&nbsp;[My Apps portal](https://myapps.microsoft.com/),
they need to&nbsp;be&nbsp;assigned to&nbsp;the&nbsp;application. This&nbsp;is&nbsp;how we can&nbsp;assign ourselves to&nbsp;the&nbsp;app:

```powershell
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject] $currentUser =
    Invoke-GraphRequest -Method GET -Uri '/v1.0/me'

[string] $defaultAppAccessRole = [Guid]::Empty
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment] $appAssignment =
   New-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $servicePrincipal.Id `
                                           -ResourceId $servicePrincipal.Id `
                                           -AppRoleId $defaultAppAccessRole `
                                           -PrincipalType User `
                                           -PrincipalId $currentUser.Id
```

Note that&nbsp;we have not declared any custom roles for&nbsp;the&nbsp;application, so&nbsp;we had to&nbsp;reference the&nbsp;default app role ID of&nbsp;`00000000-0000-0000-0000-000000000000`.

The result can&nbsp;again be&nbsp;verified through the&nbsp;Entra Admin Center:

![User Assignment Screenshot](/assets/images/claims-xray-assignment.png)

For apps with&nbsp;role-based access control, custom roles can&nbsp;be&nbsp;defined instead of&nbsp;using the&nbsp;default one:

```powershell
[hashtable] $adminRole = @{
    Id = '0125b1e2-4ed5-4994-b95e-e910ef068d69'
    DisplayName = 'Admin'
    Value = 'Admin'
    Description = 'Administrators of the app'
    AllowedMemberTypes = @('User')
    IsEnabled = $true
}

[hashtable] $userRole = @{
    Id = '8930568d-3a48-42a0-8dc0-8bcd56200954'
    DisplayName = 'User'
    Value = 'User'
    Description = 'Standard users of the app'
    AllowedMemberTypes = @('User')
    IsEnabled = $true
}

Update-MgApplication -ApplicationId $registeredApp.Id -AppRoles $adminRole,$userRole

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment] $adminAssignment =
   New-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $servicePrincipal.Id `
                                           -ResourceId $servicePrincipal.Id `
                                           -AppRoleId $adminRole.Id `
                                           -PrincipalType User `
                                           -PrincipalId $currentUser.Id

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment] $userAssignment =
   New-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $servicePrincipal.Id `
                                           -ResourceId $servicePrincipal.Id `
                                           -AppRoleId $userRole.Id `
                                           -PrincipalType User `
                                           -PrincipalId $currentUser.Id
```

As you can&nbsp;see in&nbsp;this&nbsp;example, each user can&nbsp;be&nbsp;assigned more than&nbsp;one role:

![Custom Role Assignment](/assets/images/claims-xray-custom-role-assignment.png)

## App Ownership

We can&nbsp;optionally configure the&nbsp;current user as&nbsp;the&nbsp;application owner:

```powershell
[string] $currentUserOdataId = "https://graph.microsoft.com/v1.0/users/{$($currentUser.Id)}"
New-MgApplicationOwnerByRef -ApplicationId $registeredApp.Id -OdataId $currentUserOdataId
New-MgServicePrincipalOwnerByRef -ServicePrincipalId $servicePrincipal.Id -OdataId $currentUserOdataId
```

Assigning owners is&nbsp;a&nbsp;simple way to&nbsp;grant the&nbsp;ability to&nbsp;manage all aspects of&nbsp;the&nbsp;application:

![Application Registration Owner](/assets/images/claims-xray-owner.png)

## SAML Token Configuration

The built-in `acct` and&nbsp;`groups` claims [are optional](https://learn.microsoft.com/en-us/azure/active-directory/develop/active-directory-optional-claims#v10-and-v20-optional-claims-set), so&nbsp;we need to&nbsp;explicitly enable them:

```powershell
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOptionalClaims] $optionalClaims = [Microsoft.Graph.PowerShell.Models.MicrosoftGraphOptionalClaims]::DeserializeFromDictionary(@{
   Saml2Token = @(
      @{ Name = 'acct' },
      @{ Name = 'groups' }
   )
})

Update-MgApplication -ApplicationId $registeredApp.Id -OptionalClaims $optionalClaims
```

Here is&nbsp;how the&nbsp;change will show up in&nbsp;the&nbsp;UI:

![Optional Claims Screenshot](/assets/images/claims-xray-optional-claims.png)

Contrary to&nbsp;[what the&nbsp;documentation says](
https://learn.microsoft.com/en-us/azure/active-directory/develop/active-directory-saml-claims-customization#add-the-upn-claim-to-saml-tokens), the&nbsp;`email` and&nbsp;`upn` do&nbsp;not need to&nbsp;be&nbsp;configured here to&nbsp;appear in&nbsp;SAML tokens. Even&nbsp;the&nbsp;`groups` claim does not need to&nbsp;be&nbsp;specified if&nbsp;the&nbsp;default group identifier settings are&nbsp;sufficient.

It is&nbsp;also possible to&nbsp;define custom SAML claims for&nbsp;an&nbsp;application:

![Custom Claims Screenshot](/assets/images/claims-xray-custom-claims.png)

I have decided to&nbsp;map the&nbsp;Entra ID attributes to&nbsp;SAML claims as&nbsp;follows:

|Claim Type                                                                      | Value                         |
|--------------------------------------------------------------------------------|-------------------------------|
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier           | user.userprincipalname        |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name                     | user.userprincipalname        |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn                      | user.userprincipalname        |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress             | user.mail                     |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname                | user.givenname                |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname                  | user.surname                  |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress            | user.streetaddress            |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality                 | user.city                     |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode               | user.postalcode               |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince          | user.state                    |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country                  | user.country                  |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/mobilephone              | user.mobilephone              |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone                | user.telephonenumber          |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/otherphone               | user.facsimiletelephonenumber |
| http://schemas.xmlsoap.org/ws/2005/05/identity/claims/employeeid               | user.employeeid               |
| http://schemas.microsoft.com/LiveID/Federation/2008/05/ImmutableID             | user.onpremisesimmutableid    |
| http://schemas.microsoft.com/ws/2008/06/identity/claims/role                   | user.assignedroles            |
| http://schemas.microsoft.com/2012/01/requestcontext/claims/relyingpartytrustid | application.objectid          |

Unfortunately, I&nbsp;have not found a&nbsp;way to&nbsp;configure these rules through the&nbsp;Graph API. Please let me know in&nbsp;case you were more successful than&nbsp;me.

As a&nbsp;workaround, we can&nbsp;override the&nbsp;application-specific claim issuance configuration by&nbsp;creating a&nbsp;[Claims Mapping Policy](https://learn.microsoft.com/en-us/azure/active-directory/develop/reference-claims-mapping-policy-type#table-3-valid-id-values-per-source) and&nbsp;assigning it&nbsp;to&nbsp;the&nbsp;Claims X-Ray application:

```powershell
[string] $allClaimsMapping = @'
{
   "ClaimsMappingPolicy": {
       "Version": 1,
       "IncludeBasicClaimSet": "true",
       "ClaimsSchema": [
           {
               "Source": "user",
               "ID": "userprincipalname",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"
           },
           {
               "Source": "user",
               "ID": "userprincipalname",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
           },
           {
               "Source": "user",
               "ID": "userprincipalname",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn"
           },
           {
               "Source": "user",
               "ID": "mail",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
           },
           {
               "Source": "user",
               "ID": "givenname",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
           },
           {
               "Source": "user",
               "ID": "surname",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"
           },
           {
               "Source": "user",
               "ID": "streetaddress",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress"
           },
           {
               "Source": "user",
               "ID": "city",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality"
           },
           {
               "Source": "user",
               "ID": "postalcode",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode"
           },
           {
               "Source": "user",
               "ID": "state",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince"
           },
           {
               "Source": "user",
               "ID": "country",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country"
           },
           {
               "Source": "user",
               "ID": "mobilephone",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/mobilephone"
           },
           {
               "Source": "user",
               "ID": "telephonenumber",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone"
           },
           {
               "Source": "user",
               "ID": "facsimiletelephonenumber",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/otherphone"
           },
           {
               "Source": "user",
               "ID": "employeeid",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/employeeid"
           },
           {
               "Source": "user",
               "ID": "onpremisesimmutableid",
               "SamlClaimType": "http://schemas.microsoft.com/LiveID/Federation/2008/05/ImmutableID"
           },
           {
               "Source": "application",
               "ID": "objectid",
               "SamlClaimType": "http://schemas.microsoft.com/2012/01/requestcontext/claims/relyingpartytrustid"
           },
           {
               "Source": "user",
               "ID": "assignedroles",
               "SamlClaimType": "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"
           }
       ],
       "ClaimsTransformation": []
   }
}
'@

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphClaimsMappingPolicy] $allClaimsPolicy =
   New-MgPolicyClaimMappingPolicy -DisplayName 'Issue All Claims' -Definition $allClaimsMapping

New-MgServicePrincipalClaimMappingPolicyByRef -ServicePrincipalId $servicePrincipal.Id -OdataId "https://graph.microsoft.com/v1.0/policies/claimsMappingPolicies/$($allClaimsPolicy.Id)"
```

> **NOTE:**
> The&nbsp;`New-MgPolicyClaimMappingPolicy` cmdlet appears to&nbsp;be&nbsp;broken
> in&nbsp;several recent versions of&nbsp;the&nbsp;PowerShell Graph SDK.

Unfortunately, there is&nbsp;currently no user interface for&nbsp;viewing/editing the&nbsp;policies:

![Claims Mapping Policy Screenshot](/assets/images/claims-xray-mapping-policy.png)

## Testing the&nbsp;Sign-In

We are&nbsp;finally ready to&nbsp;log into the&nbsp;Claims X-Ray NG application and&nbsp;test the&nbsp;SAML claim issuance.
This&nbsp;can&nbsp;be&nbsp;done by&nbsp;visiting the&nbsp;[My Apps portal](https://myapps.microsoft.com):

![My Apps Portal Screenshot](/assets/images/claims-xray-myapps.png)

Or we can&nbsp;simply run this&nbsp;PowerShell command, which&nbsp;will automatically open the&nbsp;Claims X-Ray NG application in&nbsp;the&nbsp;default browser:

```powershell
Start-Process ('https://myapps.microsoft.com/signin/{0}?tenantId={1}' -f $servicePrincipal.AppId,$servicePrincipal.AppOwnerOrganizationId)
```

## Limitations

- Unlike production applications, the&nbsp;Claims X-Ray does not validate the&nbsp;**token-signing certificates**.
- This&nbsp;article does not cover the&nbsp;assignment of&nbsp;a&nbsp;**Conditional Access Policy**, which&nbsp;could enforce MFA.

## Fetching the&nbsp;New Objects

This is&nbsp;how we can&nbsp;list all Entra ID objects created by&nbsp;the&nbsp;PowerShell commands above:

```powershell
Get-MgApplication -Filter "DisplayName eq 'Claims X-Ray NG'" | Format-List
Get-MgServicePrincipal -Filter "DisplayName eq 'Claims X-Ray NG'" | Format-List
Get-MgPolicyClaimMappingPolicy -Filter "DisplayName eq 'Issue All Claims'" | Format-List
```

## End-to-End Script

To wrap things up, here is&nbsp;the&nbsp;full PowerShell script, concatenated from&nbsp;the&nbsp;code snippets above:

```powershell
#Requires -Version 5
#Requires -Modules Microsoft.Graph.Applications,Microsoft.Graph.Identity.SignIns

# Note: The required modules can be installed using the following command:
# Install-Module -Name Microsoft.Graph.Applications,Microsoft.Graph.Identity.SignIns -Scope AllUsers -Force

# Connect to Entra ID
# Note: The -TenantId parameter is also required when using a Microsoft Account.
Connect-MgGraph -NoWelcome -ContextScope Process -Scopes @(
   'User.Read',
   'Application.ReadWrite.All',
   'AppRoleAssignment.ReadWrite.All',
   'DelegatedPermissionGrant.ReadWrite.All',
   'Policy.Read.All',
   'Policy.ReadWrite.ApplicationConfiguration'
)

# Register the application
[string] $appName = 'Claims X-Ray NG'
[string] $appDescription = 'Use the Claims X-Ray NG service to debug and troubleshoot problems with claims issuance.'
[string] $redirectUrl = 'https://claimsxray.net/api/sso'
[hashtable] $infoUrls = @{
    MarketingUrl      = 'https://claimsxray.net/#about'
    TermsOfServiceUrl = 'https://github.com/marcusca10/claimsxray-ng?tab=MIT-1-ov-file'
}

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApplication] $registeredApp =
   New-MgApplication -DisplayName $appName `
                     -Description $appDescription `
                     -Web @{ RedirectUris = $redirectUrl } `
                     -DefaultRedirectUri $redirectUrl `
                     -GroupMembershipClaims All `
                     -Info $infoUrls

Update-MgApplication -ApplicationId $registeredApp.Id `
                     -SignInAudience 'AzureADMyOrg' `
                     -IdentifierUris 'urn:claimsxrayng'

# Configure application logo
[string] $logoUrl = 'https://www.dsinternals.com/assets/images/claims-xray-logo.png'
[string] $tempLogoPath = New-TemporaryFile
Invoke-WebRequest -Uri $logoUrl -OutFile $tempLogoPath -UseBasicParsing -ErrorAction Stop
try {
    Set-MgApplicationLogo -ApplicationId $registeredApp.Id -ContentType 'image/png' -InFile $tempLogoPath
}
finally {
    # Cleanup
    Remove-Item -Path $tempLogoPath
}

# Create the service principal
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphServicePrincipal] $servicePrincipal =
   New-MgServicePrincipal -DisplayName $appName `
                          -AppId $registeredApp.AppId `
                          -AccountEnabled `
                          -ServicePrincipalType Application `
                          -PreferredSingleSignOnMode saml `
                          -ReplyUrls $redirectUrl `
                          -Notes $appDescription `
                          -Tags 'WindowsAzureActiveDirectoryIntegratedApp','WindowsAzureActiveDirectoryCustomSingleSignOnApplication'

# Generate a new token-signing certificate
[datetime] $now = Get-Date
[string] $certificateDisplayName = 'CN={0} Entra ID Token Signing {1:yyyy}' -f $appName,$now
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSelfSignedCertificate] $tokenSigningCertificate =
   Add-MgServicePrincipalTokenSigningCertificate -ServicePrincipalId $servicePrincipal.Id `
                                                 -DisplayName $certificateDisplayName `
                                                 -EndDateTime $now.AddYears(2)

# Delegate the User.Read permission
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphServicePrincipal] $microsoftGraph =
    Get-MgServicePrincipal -Filter "DisplayName eq 'Microsoft Graph'"

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPermissionScope] $userReadScope =
    $microsoftGraph.Oauth2PermissionScopes | Where-Object Value -eq 'User.Read'

Update-MgApplication -ApplicationId $registeredApp.Id -RequiredResourceAccess @{
    ResourceAppId = $microsoftGraph.AppId
    ResourceAccess = @(@{
        id = $userReadScope.Id
        type = 'Scope'
    })
}

# Approve the User.Read permission on behalf of all tenant users
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOAuth2PermissionGrant] $adminConsent =
    New-MgOauth2PermissionGrant -ClientId $servicePrincipal.Id `
                                -ConsentType AllPrincipals `
                                -ResourceId $microsoftGraph.Id `
                                -Scope 'User.Read'

# Assign the application to the current user
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject] $currentUser =
    Invoke-GraphRequest -Method GET -Uri '/v1.0/me'

[string] $defaultAppAccessRole = [Guid]::Empty
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment] $appAssignment =
   New-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $servicePrincipal.Id `
                                           -ResourceId $servicePrincipal.Id `
                                           -AppRoleId $defaultAppAccessRole `
                                           -PrincipalType User `
                                           -PrincipalId $currentUser.Id

# Define custom application roles
[hashtable] $adminRole = @{
    Id = '0125b1e2-4ed5-4994-b95e-e910ef068d69'
    DisplayName = 'Admin'
    Value = 'Admin'
    Description = 'Administrators of the app'
    AllowedMemberTypes = @('User')
    IsEnabled = $true
}

[hashtable] $userRole = @{
    Id = '8930568d-3a48-42a0-8dc0-8bcd56200954'
    DisplayName = 'User'
    Value = 'User'
    Description = 'Standard users of the app'
    AllowedMemberTypes = @('User')
    IsEnabled = $true
}

Update-MgApplication -ApplicationId $registeredApp.Id -AppRoles $adminRole,$userRole

# Assign the custom roles to the current user
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment] $adminAssignment =
   New-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $servicePrincipal.Id `
                                           -ResourceId $servicePrincipal.Id `
                                           -AppRoleId $adminRole.Id `
                                           -PrincipalType User `
                                           -PrincipalId $currentUser.Id

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment] $userAssignment =
   New-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $servicePrincipal.Id `
                                           -ResourceId $servicePrincipal.Id `
                                           -AppRoleId $userRole.Id `
                                           -PrincipalType User `
                                           -PrincipalId $currentUser.Id

# Configure application object owners
[string] $currentUserOdataId = "https://graph.microsoft.com/v1.0/users/{$($currentUser.Id)}"
New-MgApplicationOwnerByRef -ApplicationId $registeredApp.Id -OdataId $currentUserOdataId
New-MgServicePrincipalOwnerByRef -ServicePrincipalId $servicePrincipal.Id -OdataId $currentUserOdataId

# Configure optional claims
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOptionalClaims] $optionalClaims = [Microsoft.Graph.PowerShell.Models.MicrosoftGraphOptionalClaims]::DeserializeFromDictionary(@{
   Saml2Token = @(
      @{ Name = 'acct' },
      @{ Name = 'groups' }
   )
})

Update-MgApplication -ApplicationId $registeredApp.Id -OptionalClaims $optionalClaims

# Create a new claims mapping policy
[string] $allClaimsMapping = @'
{
   "ClaimsMappingPolicy": {
       "Version": 1,
       "IncludeBasicClaimSet": "true",
       "ClaimsSchema": [
           {
               "Source": "user",
               "ID": "userprincipalname",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"
           },
           {
               "Source": "user",
               "ID": "userprincipalname",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
           },
           {
               "Source": "user",
               "ID": "userprincipalname",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn"
           },
           {
               "Source": "user",
               "ID": "mail",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
           },
           {
               "Source": "user",
               "ID": "givenname",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
           },
           {
               "Source": "user",
               "ID": "surname",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"
           },
           {
               "Source": "user",
               "ID": "streetaddress",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress"
           },
           {
               "Source": "user",
               "ID": "city",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality"
           },
           {
               "Source": "user",
               "ID": "postalcode",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode"
           },
           {
               "Source": "user",
               "ID": "state",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince"
           },
           {
               "Source": "user",
               "ID": "country",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country"
           },
           {
               "Source": "user",
               "ID": "mobilephone",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/mobilephone"
           },
           {
               "Source": "user",
               "ID": "telephonenumber",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone"
           },
           {
               "Source": "user",
               "ID": "facsimiletelephonenumber",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/otherphone"
           },
           {
               "Source": "user",
               "ID": "employeeid",
               "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/employeeid"
           },
           {
               "Source": "user",
               "ID": "onpremisesimmutableid",
               "SamlClaimType": "http://schemas.microsoft.com/LiveID/Federation/2008/05/ImmutableID"
           },
           {
               "Source": "application",
               "ID": "objectid",
               "SamlClaimType": "http://schemas.microsoft.com/2012/01/requestcontext/claims/relyingpartytrustid"
           },
           {
               "Source": "user",
               "ID": "assignedroles",
               "SamlClaimType": "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"
           }
       ],
       "ClaimsTransformation": []
   }
}
'@

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphClaimsMappingPolicy] $allClaimsPolicy =
   New-MgPolicyClaimMappingPolicy -DisplayName 'Issue All Claims' -Definition $allClaimsMapping

# Assign the claims mapping policy to the application
New-MgServicePrincipalClaimMappingPolicyByRef -ServicePrincipalId $servicePrincipal.Id -OdataId "https://graph.microsoft.com/v1.0/policies/claimsMappingPolicies/$($allClaimsPolicy.Id)"

# Open the Claims X-Ray app in a browser
# Note that it might take a minute for the application to become accessible.
Start-Process ('https://myapps.microsoft.com/signin/{0}?tenantId={1}' -f $servicePrincipal.AppId,$servicePrincipal.AppOwnerOrganizationId)
```
