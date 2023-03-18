---
ref: aad-claims-xray
title: Registrácia Claims X-Ray v&nbsp;Azure Active&nbsp;Directory pomocou PowerShellu
date: '2023-02-12T00:00:00+00:00'
layout: post
lang: sk
image: /assets/images/claims-xray-claims.png
permalink: /sk/azure-ad-claims-xray-powershell-microsoft-graph-api/
---

*[ADFS]: Active Directory Federation Services
*[SAML]: Security Assertion Markup Language
*[AAD]: Azure Active Directory
*[AD]: Active Directory
*[MFA]: Multi-Factor Authentication

Väčšina správcov ADFS pravdepodobne pozná webovú aplikáciu [Claims X-Ray](https://adfshelp.microsoft.com/ClaimsXray) od&nbsp;Microsoftu, ktorá&nbsp;sa&nbsp;môže hodiť pri ladení SAML tokenov:

![Claims X-Ray UI Screenshot](/assets/images/claims-xray-claims.png) 

Aplikáciu Claims X-Ray je&nbsp;možné zaregistrovať aj&nbsp;v&nbsp;v&nbsp;Azure Active Directory, i&nbsp;keď to&nbsp;nie je&nbsp;oficiálne podporované:

![Claims X-Ray Application Registration Screenshot](/assets/images/claims-xray-registration.png) 

Čím ďalej, tým viac je&nbsp;možné vnímať snahu Microsoftu presvedčiť svojich zákazníkov, aby [premigrovali svoje aplikácie z&nbsp;ADFS do&nbsp;AAD](https://learn.microsoft.com/en-us/azure/active-directory/reports-monitoring/recommendation-migrate-apps-from-adfs-to-azure-ad). Preto si&nbsp;myslím, že&nbsp;Claims X-Ray ešte môže nadobudnúť na&nbsp;význame.

Registrácia tejto aplikácie v&nbsp;[Azure AD portáli](https://aad.portal.azure.com) je&nbsp;[relatívne priamočiara](https://tristanwatkins.com/start-using-claims-x-ray-with-azure-ad/). Čo&nbsp;je&nbsp;ale&nbsp;výrazne náročnejšie, je&nbsp;spraviť všetky nastavenia výhradne pomocou
[Microsoft Graph PowerShell SDK](https://learn.microsoft.com/en-us/powershell/microsoftgraph). Keďže mi trvalo celý deň, než sa&nbsp;mi podarilo popasovať s&nbsp;nedostatočnou dokumentáciou a&nbsp;viacerými chybami v&nbsp;oficiálnom PowerShell module, rozhodol som o&nbsp;svoj výsledný skript podeliť. Možno tým&nbsp;niekomu ušetrím drahocenný čas. S&nbsp;drobnými zmenami je&nbsp;možné tento postup použiť k&nbsp;registrácii ľubovoľnej SAML aplikácie v&nbsp;Azure AD.

Podrobný popis nasledujúceho skriptu je&nbsp;[dostupný v&nbsp;anglickej verzii tohoto článku](/en/azure-ad-claims-xray-powershell-microsoft-graph-api).

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
                     -Web @{ RedirectUris = $redirectUrl } `
                     -DefaultRedirectUri $redirectUrl `
                     -GroupMembershipClaims All `
                     -Info $infoUrls

Update-MgApplication -ApplicationId $registeredApp.Id `
                     -SignInAudience 'AzureADMyOrg' `
                     -IdentifierUris 'urn:microsoft:adfs:claimsxray'
```
<!--more-->
```powershell
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
