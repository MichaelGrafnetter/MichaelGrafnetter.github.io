---
ref: aad-claims-xray
title: Registering Claims X-Ray in&nbsp;Azure Active&nbsp;Directory Using PowerShell
date: '2023-02-12T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/claims-xray-claims.png
permalink: /en/azure-ad-claims-xray-powershell-microsoft-graph-api/
---

## Introduction

*[ADFS]: Active Directory Federation Services
*[SAML]: Security Assertion Markup Language
*[AAD]: Azure Active Directory
*[AD]: Active Directory
*[MFA]: Multi-Factor Authentication

Most ADFS admins would probably know the&nbsp;[Claims X-Ray](https://adfshelp.microsoft.com/ClaimsXray) web application from&nbsp;Microsoft, which&nbsp;can&nbsp;be&nbsp;used to&nbsp;troubleshoot SAML token issuance:

![Claims X-Ray UI Screenshot](/assets/images/claims-xray-claims.png) 

Although not officially supported, it&nbsp;is&nbsp;also possible to&nbsp;use Claims X-Ray with&nbsp;Azure Active Directory:

![Claims X-Ray Application Registration Screenshot](/assets/images/claims-xray-registration.png) 

As Microsoft is&nbsp;[pushing Azure AD customers to&nbsp;migrate applications from&nbsp;ADFS to&nbsp;AAD](https://learn.microsoft.com/en-us/azure/active-directory/reports-monitoring/recommendation-migrate-apps-from-adfs-to-azure-ad), this&nbsp;utility might become more useful than&nbsp;ever.

Claims X-Ray app registration through the&nbsp;[Azure AD Portal](https://aad.portal.azure.com) is&nbsp;[pretty straightforward](https://tristanwatkins.com/start-using-claims-x-ray-with-azure-ad/). But&nbsp;what is&nbsp;more challenging, is&nbsp;
doing the&nbsp;entire configuration with
[Microsoft Graph PowerShell SDK](https://learn.microsoft.com/en-us/powershell/microsoftgraph). As&nbsp;it&nbsp;took me an&nbsp;entire day to&nbsp;figure out some&nbsp;details, while&nbsp;struggling with&nbsp;several bugs in&nbsp;the&nbsp;PowerShell module, I&nbsp;have decided to&nbsp;publish my solution to&nbsp;this&nbsp;task. With&nbsp;only minor modifications, this&nbsp;guide can&nbsp;be&nbsp;used to&nbsp;register almost any&nbsp;SAML-based application to&nbsp;Azure AD using PowerShell.

## App Registration

We will first need to&nbsp;install the&nbsp;[Microsoft.Graph.Applications](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.applications/) PowerShell module and&nbsp;its dependencies:

```powershell
Install-Module -Name Microsoft.Graph.Applications -Scope AllUsers -Force
```

We can&nbsp;then connect to&nbsp;Azure Active Directory while&nbsp;specifying all permissions required by&nbsp;the&nbsp;registration process: 

```powershell
Connect-MgGraph -Scopes @(
   'Application.ReadWrite.All',
   'AppRoleAssignment.ReadWrite.All',
   'DelegatedPermissionGrant.ReadWrite.All',
   'Policy.Read.All',
   'Policy.ReadWrite.ApplicationConfiguration'
)
```
We are&nbsp;now&nbsp;ready to&nbsp;register the&nbsp;Claims X-Ray application in&nbsp;Azure AD:

```powershell
[string] $appName = 'Claims X-Ray'
[string] $appDescription = 'Use the Claims X-ray service to debug and troubleshoot problems with claims issuance.'
[string] $redirectUrl = 'https://adfshelp.microsoft.com/ClaimsXray/TokenResponse'
[hashtable] $infoUrls = @{
    MarketingUrl =        'https://adfshelp.microsoft.com/Tools/ShowTools'
    PrivacyStatementUrl = 'https://privacy.microsoft.com/en-us/privacystatement'
    TermsOfServiceUrl   = 'https://learn.microsoft.com/en-us/legal/mdsa'
    SupportUrl          = 'https://adfshelp.microsoft.com/Feedback/ProvideFeedback'
}

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApplication] $registeredApp =
   New-MgApplication -DisplayName $appName `
                     -Description $appDescription `
                     -Web @{RedirectUris = $redirectUrl } `
                     -DefaultRedirectUri $redirectUrl `
                     -GroupMembershipClaims All `
                     -Info $infoUrls
```
<!--more-->

The previous command would always fail when&nbsp;used with&nbsp;the&nbsp;`-SignInAudience` and&nbsp;`-IdentifierUris` parameters. These application properties thus need to&nbsp;be&nbsp;configured separately, making the&nbsp;application single-tenant:

```powershell
Update-MgApplication -ApplicationId $registeredApp.Id `
                     -SignInAudience 'AzureADMyOrg' `
                     -IdentifierUris 'urn:microsoft:adfs:claimsxray'
```

## Application Logo

It is&nbsp;time to&nbsp;configure the&nbsp;application logo. As&nbsp;the&nbsp;Claims X-Ray website only contains a&nbsp;logo in&nbsp;the&nbsp;SVG format, which&nbsp;is&nbsp;not supported by&nbsp;AAD, I&nbsp;had to&nbsp;first convert it&nbsp;to&nbsp;PNG:

[![Claims X-Ray Logo](/assets/images/claims-xray-logo.png){:width="150px"}](/assets/images/claims-xray-logo.png)

The logo must be&nbsp;downloaded locally before&nbsp;it&nbsp;can&nbsp;be&nbsp;uploaded to&nbsp;AAD:

```powershell
[string] $logoUrl = 'https://www.dsinternals.com/assets/images/claims-xray-logo.png'
[string] $tempLogoPath = New-TemporaryFile
Invoke-WebRequest -Uri $logoUrl -OutFile $tempLogoPath -UseBasicParsing
```
Due to&nbsp;a&nbsp;[bug in&nbsp;Microsoft Graph PowerShell](https://github.com/microsoftgraph/msgraph-metadata/issues/148), the&nbsp;following command would fail:

```powershell
Set-MgApplicationLogo -ApplicationId $registeredApp.Id -InFile $tempLogoPath
```
We thus need to&nbsp;upload the&nbsp;image to&nbsp;Azure AD by&nbsp;calling the&nbsp;raw Graph API:

```powershell
Invoke-GraphRequest -Method PUT -Uri "https://graph.microsoft.com/v1.0/applications/$($registeredApp.Id)/logo" `
                    -InputFilePath $tempLogoPath `
                    -ContentType 'image/*'
```

Upon success, the&nbsp;temporary local copy of&nbsp;the&nbsp;logo can&nbsp;be&nbsp;deleted:

```powershell
Remove-Item -Path $tempLogoPath
```

## Service Principal

Now that&nbsp;the&nbsp;application itself is&nbsp;registered, we can&nbsp;now&nbsp;register the&nbsp;corresponding service principal, which&nbsp;will appear in&nbsp;the&nbsp;Enterprise Applications section of&nbsp;the&nbsp;Azure AD Portal:

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

One of&nbsp;the&nbsp;requirements for&nbsp;a&nbsp;functional relying party trust is&nbsp;a&nbsp;[token-signing certificate](https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/design/token-signing-certificates). For&nbsp;the&nbsp;sake of&nbsp;simplicity, we can&nbsp;generate a&nbsp;self-signed one, that&nbsp;will be&nbsp;valid for&nbsp;3 years:

```powershell
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSelfSignedCertificate] $tokenSigningCertificate =
   Add-MgServicePrincipalTokenSigningCertificate -ServicePrincipalId $servicePrincipal.Id `
                                                 -DisplayName "CN=$appName AAD Token Signing" `
                                                 -EndDateTime (Get-Date).AddYears(3)
```

The result will look like this&nbsp;in&nbsp;Azure AD Portal:

![SAML Signing Certificate Screenshot](/assets/images/claims-xray-certificate.png)

## Application Permissions

As we want the&nbsp;Claims X-Ray app to&nbsp;receive information about signed-in users, we need to&nbsp;delegate the&nbsp;[User.Read](https://learn.microsoft.com/en-us/graph/permissions-reference#user-permissions) permission:

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

We can&nbsp;therefore give the&nbsp;required consent on behalf of&nbsp;the&nbsp;entire AAD Tenant in&nbsp;advance: 

```powershell
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOAuth2PermissionGrant] $adminConsent =
    New-MgOauth2PermissionGrant -ClientId $servicePrincipal.Id `
                                -ConsentType AllPrincipals `
                                -ResourceId $microsoftGraph.Id `
                                -Scope $userReadScope.Value
```

This is&nbsp;how the&nbsp;results should look in&nbsp;the&nbsp;AAD Portal:

![Admin Consent Screenshot](/assets/images/claims-xray-admin-consent.png)

## User Assignment

For users to&nbsp;see the&nbsp;application in&nbsp;the&nbsp;[My Apps portal](https://myapps.microsoft.com/), they need to&nbsp;be&nbsp;assigned to&nbsp;the&nbsp;application. This&nbsp;is&nbsp;how we can&nbsp;assign ourselves to&nbsp;the&nbsp;app: 

```powershell
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject] $currentUser =
    Get-MgApplicationOwner -ApplicationId $registeredApp.Id  

[string] $defaultAppAccessRole = [Guid]::Empty
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment] $appAssignment =
   New-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $servicePrincipal.Id `
                                           -ResourceId $servicePrincipal.Id `
                                           -AppRoleId $defaultAppAccessRole `
                                           -PrincipalType User `
                                           -PrincipalId $currentUser.Id
```

Note that&nbsp;we have not declared any custom roles for&nbsp;the&nbsp;application, so&nbsp;we had to&nbsp;reference the&nbsp;default app role ID of&nbsp;`00000000-0000-0000-0000-000000000000`.

The result can&nbsp;again be&nbsp;verified through the&nbsp;AAD Portal:

![User Assignment Screenshot](/assets/images/claims-xray-assignment.png)

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

I have decided to&nbsp;map the&nbsp;AAD attributes to&nbsp;SAML claims as&nbsp;follows:

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

Unfortunately, there is&nbsp;currently no user interface for&nbsp;viewing/editing the&nbsp;policies:

![Claims Mapping Policy Screenshot](/assets/images/claims-xray-mapping-policy.png)

## Testing the&nbsp;Sign-In

We are&nbsp;finally ready to&nbsp;log into the&nbsp;Claims X-Ray application and&nbsp;test the&nbsp;SAML claim issuance. This&nbsp;can&nbsp;be&nbsp;done by&nbsp;visiting the&nbsp;[My Apps portal](https://myapps.microsoft.com):

![My Apps Portal Screenshot](/assets/images/claims-xray-myapps.png)

Or we can&nbsp;simply run this&nbsp;PowerShell command, which&nbsp;will automatically open the&nbsp;Claims X-Ray application in&nbsp;the&nbsp;default browser:

```powershell
Start-Process ('https://myapps.microsoft.com/signin/{0}?tenantId={1}' -f $servicePrincipal.AppId,$servicePrincipal.AppOwnerOrganizationId)
```

## Limitations

- Because&nbsp;the&nbsp;Claims X-Ray app uses the&nbsp;`urn:microsoft:adfs:claimsxray` identifier, it&nbsp;can&nbsp;only be&nbsp;registered as&nbsp;a&nbsp;**single-tenant app**.
- As&nbsp;the&nbsp;Claims X-Ray app is&nbsp;hardcoded with&nbsp;ADFS-specific token request relative URL, only the&nbsp;**Identity Provider-Initiated Single Sign-On** can&nbsp;be&nbsp;used. 
- Unlike production applications, the&nbsp;Claims X-Ray does not validate the&nbsp;**token-signing certificates**.
- This&nbsp;article does not cover the&nbsp;assignment of&nbsp;a&nbsp;**Conditional Access Policy**, which&nbsp;could enforce MFA.

## Fetching the&nbsp;New Objects

This is&nbsp;how we can&nbsp;list all Azure AD objects created by&nbsp;the&nbsp;PowerShell commands above:

```powershell
Get-MgApplication -Filter "DisplayName eq 'Claims X-Ray'" | Format-List
Get-MgServicePrincipal -Filter "DisplayName eq 'Claims X-Ray'" | Format-List
Get-MgPolicyClaimMappingPolicy -Filter "DisplayName eq 'Issue All Claims'" | Format-List
```

## End-to-End Script

To wrap things up, here is&nbsp;the&nbsp;full PowerShell script, concatenated from&nbsp;the&nbsp;code snippets above:

```powershell
#Requires -Version 5
#Requires -Modules Microsoft.Graph.Applications

# Connect to AzureAD
# Note: The -TenantId parameter is also required when using a Microsoft Account.
Connect-MgGraph -Scopes @(
   'Application.ReadWrite.All',
   'AppRoleAssignment.ReadWrite.All',
   'DelegatedPermissionGrant.ReadWrite.All',
   'Policy.Read.All',
   'Policy.ReadWrite.ApplicationConfiguration'
)

# Register the application
[string] $appName = 'Claims X-Ray'
[string] $appDescription = 'Use the Claims X-ray service to debug and troubleshoot problems with claims issuance.'
[string] $redirectUrl = 'https://adfshelp.microsoft.com/ClaimsXray/TokenResponse'
[hashtable] $infoUrls = @{
    MarketingUrl =        'https://adfshelp.microsoft.com/Tools/ShowTools'
    PrivacyStatementUrl = 'https://privacy.microsoft.com/en-us/privacystatement'
    TermsOfServiceUrl   = 'https://learn.microsoft.com/en-us/legal/mdsa'
    SupportUrl          = 'https://adfshelp.microsoft.com/Feedback/ProvideFeedback'
}

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApplication] $registeredApp =
   New-MgApplication -DisplayName $appName `
                     -Description $appDescription `
                     -Web @{RedirectUris = $redirectUrl } `
                     -DefaultRedirectUri $redirectUrl `
                     -GroupMembershipClaims All `
                     -Info $infoUrls

Update-MgApplication -ApplicationId $registeredApp.Id `
                     -SignInAudience 'AzureADMyOrg' `
                     -IdentifierUris 'urn:microsoft:adfs:claimsxray'

# Configure application logo
[string] $logoUrl = 'https://www.dsinternals.com/assets/images/claims-xray-logo.png'
[string] $tempLogoPath = New-TemporaryFile
Invoke-WebRequest -Uri $logoUrl -OutFile $tempLogoPath -UseBasicParsing

Invoke-GraphRequest -Method PUT -Uri "https://graph.microsoft.com/v1.0/applications/$($registeredApp.Id)/logo" `
                    -InputFilePath $tempLogoPath `
                    -ContentType 'image/*'

Remove-Item -Path $tempLogoPath

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
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSelfSignedCertificate] $tokenSigningCertificate =
   Add-MgServicePrincipalTokenSigningCertificate -ServicePrincipalId $servicePrincipal.Id `
                                                 -DisplayName "CN=$appName AAD Token Signing" `
                                                 -EndDateTime (Get-Date).AddYears(3)

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
                                -Scope $userReadScope.Value

# Assign the application to the current user
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject] $currentUser =
    Get-MgApplicationOwner -ApplicationId $registeredApp.Id  

[string] $defaultAppAccessRole = [Guid]::Empty
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment] $appAssignment =
   New-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $servicePrincipal.Id `
                                           -ResourceId $servicePrincipal.Id `
                                           -AppRoleId $defaultAppAccessRole `
                                           -PrincipalType User `
                                           -PrincipalId $currentUser.Id

# Configure optional claims
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOptionalClaims] $optionalClaims = [Microsoft.Graph.PowerShell.Models.MicrosoftGraphOptionalClaims]::DeserializeFromDictionary(@{
   Saml2Token = @(
      @{ Name = 'acct' },
      @{ Name = 'groups' }
   )
})

Update-MgApplication -ApplicationId $registeredApp.Id -OptionalClaims $optionalClaims

# Creathe a new claims mapping policy
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
