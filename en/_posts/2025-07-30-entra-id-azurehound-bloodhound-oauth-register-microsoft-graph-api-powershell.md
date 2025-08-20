---
ref: azurehound-powershell
title: Registering OAuth Applications in&nbsp;Entra&nbsp;ID Using PowerShell
date: '2025-07-30T00:00:00+00:00'
layout: post
lang: en
image: /assets/images/azurehound-app-properties.png
permalink: /en/entra-id-azurehound-bloodhound-oauth-register-microsoft-graph-api-powershell/
---

## Introduction

It is&nbsp;best practice to&nbsp;register applications in&nbsp;Entra ID using PowerShell (or another automation tool that&nbsp;utilizes the&nbsp;Microsoft Graph API), rather than&nbsp;adding them manually through the&nbsp;Microsoft Entra Admin Center. This&nbsp;approach offers several advantages:

1. **Repeatable Deployment Process**: Automating the&nbsp;registration helps prevent human errors that&nbsp;could lead to&nbsp;misconfigurations or&nbsp;security issues.
2. **Fast Cross-Tenant Migration**: Scripting allows for&nbsp;quick migration between development, testing, and&nbsp;production environments. (You do&nbsp;have at least one pre-production Entra ID tenant, right?)
3. **Access to&nbsp;Advanced Settings**: Some&nbsp;advanced settings are&nbsp;only available through the&nbsp;Microsoft Graph API and&nbsp;not exposed in&nbsp;the&nbsp;Microsoft Entra Admin Center.
4. **Improved Customer Experience**: Providing customers with&nbsp;reliable scripts can&nbsp;enhance their product experience and&nbsp;may also reduce support costs for&nbsp;software vendors.
5. **Documentation**: PowerShell scripts can&nbsp;serve as&nbsp;definitive and&nbsp;up-to-date documentation for&nbsp;the&nbsp;correct configuration of&nbsp;applications.
6. **Infrastructure as&nbsp;Code**: All the&nbsp;advantages associated with&nbsp;the&nbsp;broader Infrastructure as&nbsp;Code (IaC) practice apply as&nbsp;well.

In this&nbsp;article, you will learn how to&nbsp;automate the&nbsp;[registration process](https://bloodhound.specterops.io/install-data-collector/install-azurehound/azure-configuration)
for [AzureHound](https://github.com/SpecterOps/AzureHound), the&nbsp;data collector application for&nbsp;[BloodHound Enterprise](https://specterops.io/bloodhound-enterprise).
With&nbsp;only minor modifications, this&nbsp;guide can&nbsp;be&nbsp;applied to&nbsp;automatically register almost any&nbsp;service or&nbsp;daemon application that&nbsp;is&nbsp;using the&nbsp;OAuth 2.0 client credentials grant flow in&nbsp;Entra ID.

![Entra ID Enterprise Applications Screenshot](/assets/images/azurehound-enterprise-applications.png)

## Required User Permissions

To register applications with Microsoft Graph permissions in Entra ID, non-trivial user permissions are required.
As an alternative to the almighty [Global Administrator] role, the following role assignments should be sufficient:

- [Cloud Application Administrator] or [Application Administrator], for creating the app registration.
- [Privileged Role Administrator], for assigning the required directory role and granting admin consent for the Microsoft Graph permissions.

The [User Access Administrator] role is additionally needed for delegating permissions in Azure.

[User Access Administrator]: https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/privileged#user-access-administrator

[Global Administrator]: https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference#global-administrator

[Privileged Role Administrator]: https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference#privileged-role-administrator

[Cloud Application Administrator]: https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference#cloud-application-administrator

[Application Administrator]: https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference#application-administrator

## App Registration

First, we need to&nbsp;install the&nbsp;required official `Microsoft.Graph.*` and&nbsp;`Az.*` PowerShell modules:

```powershell
Install-Module -Scope AllUsers -Repository PSGallery -Force -Name @(
    Microsoft.Graph.Applications,
    Microsoft.Graph.Authentication,
    Microsoft.Graph.Identity.DirectoryManagement,
    Az.Resources,
    Az.Accounts
)
```

Next, we can&nbsp;connect to&nbsp;the&nbsp;Microsoft Graph API while&nbsp;specifying all necessary permissions for&nbsp;the&nbsp;app registration process:

```powershell
Connect-MgGraph -NoWelcome -ContextScope Process -Scopes @(
   'User.Read',
   'Application.ReadWrite.All',
   'AppRoleAssignment.ReadWrite.All',
   'RoleManagement.ReadWrite.Directory'
)
```

We are&nbsp;now&nbsp;ready to&nbsp;register the&nbsp;BloodHound Enterprise Collector application in&nbsp;Entra ID:

```powershell
[string] $appName = 'BloodHound Enterprise Collector'
[string] $appDescription = 'Azure Data Exporter for BloodHound Enterprise (AzureHound)'
[string] $homePage = 'https://specterops.io/bloodhound-enterprise'
[hashtable] $infoUrls = @{
    MarketingUrl      = 'https://specterops.io/bloodhound-enterprise'
    TermsOfServiceUrl = 'https://specterops.io/terms-of-service'
    PrivacyStatementUrl = 'https://specterops.io/privacy-policy'
    SupportUrl = 'https://support.bloodhoundenterprise.io/'
}
[hashtable] $webUrls = @{
    HomePageUrl = $homePage
}

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApplication] $registeredApp =
   New-MgApplication -DisplayName $appName `
                     -Description $appDescription `
                     -Info $infoUrls `
                     -Web $webUrls `
                     -SignInAudience 'AzureADMyOrg'
```
<!--more-->

> **NOTE:**
> In&nbsp;this&nbsp;article, we use strongly-typed PowerShell variables,
> which&nbsp;is&nbsp;a&nbsp;matter of&nbsp;personal preference.

## Application Logo

It is&nbsp;time to&nbsp;configure the&nbsp;application logo:

![BloodHound Enterprise Collector Branding and&nbsp;Properties Screenshot](/assets/images/azurehound-app-properties.png)

The following script will&nbsp;first download the&nbsp;logo to&nbsp;the&nbsp;local computer before&nbsp;uploading it&nbsp;to&nbsp;Entra ID:

```powershell
[string] $logoUrl = 'https://www.dsinternals.com/assets/images/bloodhound-enterprise-logo-square.png'
[string] $tempLogoPath = New-TemporaryFile
Invoke-WebRequest -Uri $logoUrl -OutFile $tempLogoPath -UseBasicParsing -ErrorAction Stop
try {
    Set-MgApplicationLogo -ApplicationId $registeredApp.Id -ContentType 'image/png' -InFile $tempLogoPath
}
finally {
    # Delete the local copy of the logo from temp
    Remove-Item -Path $tempLogoPath
}
```
> **NOTE:**
> The&nbsp;image dimensions should be&nbsp;215 x 215 pixels.
> Supported file types include `.png`, `.jpg`, and&nbsp;`.bmp`, and&nbsp;the&nbsp;file size must be&nbsp;less than&nbsp;100 KB.

## App Instance Property Lock

We should also [lock sensitive application properties](https://learn.microsoft.com/en-us/entra/identity-platform/howto-configure-app-instance-property-locks) for&nbsp;modification:

![BloodHound Enterprise Collector App Instance Property Lock Screenshot](/assets/images/azurehound-app-instance-property-lock.png)

This prevents the&nbsp;creation of&nbsp;secrets on the&nbsp;associated service principal objects,
which is&nbsp;crucial for&nbsp;safeguarding multi-tenant applications;
however, single-tenant applications, like AzureHound, can&nbsp;also benefit.

The corresponding PowerShell command is&nbsp;simple:

```powershell
Update-MgApplication -ApplicationId $registeredApp.Id -ServicePrincipalLockConfiguration @{
    IsEnabled = $true
    AllProperties = $true
}
```

## Service Principal

Once the&nbsp;application itself is&nbsp;registered, we can&nbsp;create the&nbsp;corresponding service principal object:

```powershell
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphServicePrincipal] $servicePrincipal =
   New-MgServicePrincipal -DisplayName $appName `
                          -AppId $registeredApp.AppId `
                          -AccountEnabled `
                          -ServicePrincipalType Application `
                          -Notes $appDescription `
                          -Homepage $homePage `
                          -Tags 'WindowsAzureActiveDirectoryIntegratedApp','HideApp'
```

Note that&nbsp;we have applied the&nbsp;`HideApp` tag to&nbsp;ensure that&nbsp;the&nbsp;application does not clutter the&nbsp;[My Apps dashboard](https://myapps.microsoft.com/) unnecessarily. The&nbsp;outcome&nbsp;should appear in&nbsp;the&nbsp;Enterprise Applications section of&nbsp;the&nbsp;Microsoft Entra Admin Center:

![BloodHound Enterprise Collector Service Principal Properties Screenshot](/assets/images/azurehound-service-principal.png)

## Application Permissions

The BloodHound Collector [requires](https://bloodhound.specterops.io/install-data-collector/install-azurehound/system-requirements#service-principal-requirements) the&nbsp;following Entra ID read-only permissions:

| Permission                | Type        | Identifier                             |
|---------------------------|-------------|----------------------------------------|
| [Directory.Read.All]      | Application | `7ab1d382-f21e-4acd-a863-ba3e13f7da61` |
| [RoleManagement.Read.All] | Application | `c7fbd983-d9aa-4fa7-84b8-17382c103bc4` |

[Directory.Read.All]: https://learn.microsoft.com/en-us/graph/permissions-reference#directoryreadall
[RoleManagement.Read.All]: https://learn.microsoft.com/en-us/graph/permissions-reference#rolemanagementreadall

> **NOTE:**
> When&nbsp;registering an&nbsp;application manually, the&nbsp;*User.Read* delegated permission is&nbsp;automatically assigned.
> However, the&nbsp;BloodHound Enterprise Collector app does not actually require this&nbsp;permission.

![BloodHound Enterprise Collector Microsoft Graph API Permissions Screenshot](/assets/images/azurehound-api-permissions.png)

When configuring Microsoft Graph API permissions through the&nbsp;API itself,
we need to&nbsp;use their identifiers instead of&nbsp;their human-readable names:

```powershell
# Fetch the Microsoft Graph applicaton ID, which should be 00000003-0000-0000-c000-000000000000
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphServicePrincipal] $microsoftGraph =
    Get-MgServicePrincipal -Filter "DisplayName eq 'Microsoft Graph'"

# Fetch the Directory.Read.All scope ID, which should be 7ab1d382-f21e-4acd-a863-ba3e13f7da61
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRole] $readDirectoryScope =
    $microsoftGraph.AppRoles | Where-Object Value -eq 'Directory.Read.All'

# Fetch the RoleManagement.Read.All scope ID, which should be c7fbd983-d9aa-4fa7-84b8-17382c103bc4
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRole] $readRolesScope =
    $microsoftGraph.AppRoles | Where-Object Value -eq 'RoleManagement.Read.All'

# Delegate the required API permissions
Update-MgApplication -ApplicationId $registeredApp.Id -RequiredResourceAccess @{
    ResourceAppId = $microsoftGraph.AppId # 00000003-0000-0000-c000-000000000000
    ResourceAccess = @(@{
        id = $readDirectoryScope.Id       # 7ab1d382-f21e-4acd-a863-ba3e13f7da61
        type = 'Role'
    },@{
        id = $readRolesScope.Id           # c7fbd983-d9aa-4fa7-84b8-17382c103bc4
        type = 'Role'
    })
}
```

The permissions then need to&nbsp;be&nbsp;approved through administrative consent:

```powershell
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment] $readRolesAdminConsent =
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipal.Id `
                                            -PrincipalId $servicePrincipal.Id `
                                            -ResourceId $microsoftGraph.Id `
                                            -AppRoleId $readRolesScope.Id

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment] $readDirectoryAdminConsent =
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipal.Id `
                                            -PrincipalId $servicePrincipal.Id `
                                            -ResourceId $microsoftGraph.Id `
                                            -AppRoleId $readDirectoryScope.Id
```

## Directory Role

In addition to&nbsp;the&nbsp;Graph API permissions listed above, the&nbsp;[application must be&nbsp;assigned](https://bloodhound.specterops.io/install-data-collector/install-azurehound/system-requirements#service-principal-requirements)
the [Directory Readers](https://docs.azure.cn/en-us/entra/identity/role-based-access-control/permissions-reference#directory-readers) role as&nbsp;well:

![BloodHound Enterprise Collector Role Assignment Screenshot](/assets/images/azurehound-role-assignment.png)

When assigning directory roles using the&nbsp;Microsoft Graph API,
security principal OData identifiers must be&nbsp;used rather than&nbsp;their names:

```powershell
# Fetch the template ID of the Directory Readers role, which should be 88d8e3e3-8f55-4a1e-953a-9b9898b8876b
[Microsoft.Graph.PowerShell.Models.MicrosoftGraphDirectoryRole] $directoryReadersRole =
    Get-MgDirectoryRole -Filter "displayName eq 'Directory Readers'"

# Get the environment-specific Microsoft Graph API endpoint
# Azure Global: https://graph.microsoft.com
# Azure USGov:  https://graph.microsoft.us 
[string] $graphEndpoint =
    (Get-MgEnvironment -Name (Get-MgContext).Environment).GraphEndpoint

# OData IDs need to be used when assigning role membership,
# e.g., https://graph.microsoft.com/v1.0/serviceprincipals/{46615ae4-da39-4403-8de2-606e10774ae0}
[string] $servicePrincipalOdataId = "$graphEndpoint/v1.0/serviceprincipals/{$($servicePrincipal.Id)}"

# Assign the Directory Readers Entra ID Role to the service principal
New-MgDirectoryRoleMemberByRef -DirectoryRoleId $directoryReadersRole.Id -OdataId $servicePrincipalOdataId
```

## App Ownership

We can&nbsp;optionally configure the&nbsp;current user as&nbsp;the&nbsp;application owner:

```powershell
# Fetch the info about the current user
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject] $currentUser =
    Invoke-MgGraphRequest -Method GET -Uri '/v1.0/me'

# OData IDs need to be used when assigning application ownership,
# e.g., https://graph.microsoft.com/v1.0/users/{bca3617a-4c54-45eb-9a32-744c1938242e}
[string] $currentUserOdataId = "$graphEndpoint/v1.0/users/{$($currentUser.Id)}"

# Assign the current user as the application object owner
New-MgApplicationOwnerByRef -ApplicationId $registeredApp.Id -OdataId $currentUserOdataId

# Assign the current user as the service principal owner
New-MgServicePrincipalOwnerByRef -ServicePrincipalId $servicePrincipal.Id -OdataId $currentUserOdataId
```

Assigning owners is&nbsp;a&nbsp;straightforward way to&nbsp;provide the&nbsp;ability to&nbsp;manage all aspects of&nbsp;the&nbsp;application:

![BloodHound Enterprise Collector Service Principal Owner Screenshot](/assets/images/azurehound-app-owner.png)

However, it&nbsp;is&nbsp;important to&nbsp;note that&nbsp;application object ownership can&nbsp;be&nbsp;exploited by&nbsp;malicious actors in&nbsp;privilege escalation attacks. Therefore, this&nbsp;permission should be&nbsp;handled with&nbsp;caution. (And you can&nbsp;use BloodHound to discover possible attack paths.)

## Azure Permissions

If an&nbsp;organization is&nbsp;using Microsoft Azure,
BloodHound Enterprise [should be&nbsp;assigned](https://bloodhound.specterops.io/install-data-collector/install-azurehound/azure-configuration#grant-%E2%80%9Creader%E2%80%9D-role-on-all-subscriptions)
the [Reader](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/general#reader)
role on all Azure Subscriptions. Ideally, this&nbsp;assignment should be&nbsp;done at the&nbsp;[Tenant Root Group](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#hierarchy-of-management-groups-and-subscriptions) level:

![BloodHound Enterprise Collector Azure Role Assignment Screenshot](/assets/images/azurehound-azure-role.png)

Since a&nbsp;different set of&nbsp;PowerShell modules is&nbsp;used for&nbsp;Azure management,
the corresponding PowerShell script needs to&nbsp;re-authenticate the&nbsp;user before&nbsp;assigning the&nbsp;required role membership:

```powershell
# Optionally enable browser-based login on Windows 10 and later
Update-AzConfig -EnableLoginByWam $false

# Authenticate against Azure Resource Manager
Connect-AzAccount -Environment AzureCloud -Scope Process

# Fetch the identifier of the Reader role
[string] $rootScope = '/'
[Microsoft.Azure.Commands.Resources.Models.Authorization.PSRoleDefinition] $azureReaderRole =
    Get-AzRoleDefinition -Scope $rootScope -Name 'Reader'

# Fetch the identifier of the BloodHound Enterprise Collector Service Principal
[Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphServicePrincipal] $servicePrincipal = 
        Get-AzADServicePrincipal -DisplayName 'BloodHound Enterprise Collector'

# Fetch the Tenant Root Group
[guid] $currentTenantId = (Get-AzContext).Tenant.Id
[Microsoft.Azure.Commands.Resources.Models.ManagementGroups.PSManagementGroup] $rootManagementGroup =
    Get-AzManagementGroup -GroupName $currentTenantId

# Assign the Reader role on all Azure subscriptions to AzureHound
[Microsoft.Azure.Commands.Resources.Models.Authorization.PSRoleAssignment] $readerRoleAssignment = 
    New-AzRoleAssignment -ObjectId $servicePrincipal.Id -Scope $rootManagementGroup.Id -RoleDefinitionId $azureReaderRole.Id
```

## Authentication Certificate

As a&nbsp;final step, the&nbsp;authentication certificate must be&nbsp;created and&nbsp;associated with&nbsp;the&nbsp;application object.
Although the&nbsp;certificate is&nbsp;automatically generated by&nbsp;the&nbsp;AzureHound server-side application, as&nbsp;it&nbsp;should be,
it is&nbsp;typically uploaded manually through the&nbsp;Entra Admin Center:

![Authentication Certificate Upload Screenshot](https://mintlify.s3.us-west-1.amazonaws.com/specterops/assets/image-141.png)

## End-to-End Script

To wrap things up, here is&nbsp;the&nbsp;complete PowerShell script, compiled from&nbsp;the&nbsp;above code snippets:

```powershell
<#
.SYNOPSIS
Registers the Azure Data Exporter for BloodHound Enterprise (AzureHound) in Entra ID.

.DESCRIPTION
This script registers the Azure Data Exporter for BloodHound Enterprise (AzureHound)
as an on-prem application in Microsoft Entra ID and Azure,
including all the necessary read permissions.

The required modules can be installed from the PowerShell Gallery using the following command:

Install-Module -Scope AllUsers -Repository PSGallery -Force -Name @(
    Microsoft.Graph.Applications,
    Microsoft.Graph.Authentication,
    Microsoft.Graph.Identity.DirectoryManagement,
    Az.Resources,
    Az.Accounts
)

More details at https://bloodhound.specterops.io/install-data-collector/install-azurehound/azure-configuration 

.NOTES
Version: 1.0
Author:  Michael Grafnetter
#>

#Requires -Version 5
#Requires -Modules Microsoft.Graph.Applications,Microsoft.Graph.Authentication,Microsoft.Graph.Identity.DirectoryManagement,Az.Resources,Az.Accounts  

#region Entra ID

# Connect to Microsoft Entra ID through the Microsoft Graph API
# Note: The -TenantId parameter is also required when using an External ID.
Connect-MgGraph -NoWelcome -ContextScope Process -Scopes @(
   'User.Read',
   'Application.ReadWrite.All',
   'AppRoleAssignment.ReadWrite.All',
   'RoleManagement.ReadWrite.Directory'
)

# Register the AzureHound application
[string] $appName = 'BloodHound Enterprise Collector'
[string] $appDescription = 'Azure Data Exporter for BloodHound Enterprise (AzureHound)'
[string] $homePage = 'https://specterops.io/bloodhound-enterprise'
[hashtable] $infoUrls = @{
    MarketingUrl      = 'https://specterops.io/bloodhound-enterprise'
    TermsOfServiceUrl = 'https://specterops.io/terms-of-service'
    PrivacyStatementUrl = 'https://specterops.io/privacy-policy'
    SupportUrl = 'https://support.bloodhoundenterprise.io/'
}
[hashtable] $webUrls = @{
    HomePageUrl = $homePage
}

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApplication] $registeredApp =
   New-MgApplication -DisplayName $appName `
                     -Description $appDescription `
                     -Info $infoUrls `
                     -Web $webUrls `
                     -SignInAudience 'AzureADMyOrg'

# Configure the application logo
[string] $logoUrl = 'https://www.dsinternals.com/assets/images/bloodhound-enterprise-logo-square.png'
[string] $tempLogoPath = New-TemporaryFile
Invoke-WebRequest -Uri $logoUrl -OutFile $tempLogoPath -UseBasicParsing -ErrorAction Stop
try {
    Set-MgApplicationLogo -ApplicationId $registeredApp.Id -ContentType 'image/png' -InFile $tempLogoPath
}
finally {
    # Delete the local copy of the logo from temp
    Remove-Item -Path $tempLogoPath
}

# Make sure the app instance property lock is enabled
Update-MgApplication -ApplicationId $registeredApp.Id -ServicePrincipalLockConfiguration @{
    IsEnabled = $true
    AllProperties = $true
}

# Create the associated service principal object
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphServicePrincipal] $servicePrincipal =
   New-MgServicePrincipal -DisplayName $appName `
                          -AppId $registeredApp.AppId `
                          -AccountEnabled `
                          -ServicePrincipalType Application `
                          -Notes $appDescription `
                          -Homepage $homePage `
                          -Tags 'WindowsAzureActiveDirectoryIntegratedApp','HideApp'

# Fetch the Microsoft Graph applicaton ID, which should be 00000003-0000-0000-c000-000000000000
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphServicePrincipal] $microsoftGraph =
    Get-MgServicePrincipal -Filter "DisplayName eq 'Microsoft Graph'"

# Fetch the Directory.Read.All scope ID, which should be 7ab1d382-f21e-4acd-a863-ba3e13f7da61
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRole] $readDirectoryScope =
    $microsoftGraph.AppRoles | Where-Object Value -eq 'Directory.Read.All'

# Fetch the RoleManagement.Read.All scope ID, which should be c7fbd983-d9aa-4fa7-84b8-17382c103bc4
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRole] $readRolesScope =
    $microsoftGraph.AppRoles | Where-Object Value -eq 'RoleManagement.Read.All'

# Delegate the required API permissions
Update-MgApplication -ApplicationId $registeredApp.Id -RequiredResourceAccess @{
    ResourceAppId = $microsoftGraph.AppId # 00000003-0000-0000-c000-000000000000
    ResourceAccess = @(@{
        id = $readDirectoryScope.Id       # 7ab1d382-f21e-4acd-a863-ba3e13f7da61
        type = 'Role'
    },@{
        id = $readRolesScope.Id           # c7fbd983-d9aa-4fa7-84b8-17382c103bc4
        type = 'Role'
    })
}

# Approve the permissions on the tenant
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment] $readRolesAdminConsent =
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipal.Id `
                                            -PrincipalId $servicePrincipal.Id `
                                            -ResourceId $microsoftGraph.Id `
                                            -AppRoleId $readRolesScope.Id

[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment] $readDirectoryAdminConsent =
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipal.Id `
                                            -PrincipalId $servicePrincipal.Id `
                                            -ResourceId $microsoftGraph.Id `
                                            -AppRoleId $readDirectoryScope.Id

# Fetch the template ID of the Directory Readers role, which should be 88d8e3e3-8f55-4a1e-953a-9b9898b8876b
[Microsoft.Graph.PowerShell.Models.MicrosoftGraphDirectoryRole] $directoryReadersRole =
    Get-MgDirectoryRole -Filter "displayName eq 'Directory Readers'"

# Get the environment-specific Microsoft Graph API endpoint
# Azure Global: https://graph.microsoft.com
# Azure USGov:  https://graph.microsoft.us 
[string] $graphEndpoint =
    (Get-MgEnvironment -Name (Get-MgContext).Environment).GraphEndpoint

# OData IDs need to be used when assigning role membership,
# e.g., https://graph.microsoft.com/v1.0/serviceprincipals/{46615ae4-da39-4403-8de2-606e10774ae0}
[string] $servicePrincipalOdataId = "$graphEndpoint/v1.0/serviceprincipals/{$($servicePrincipal.Id)}"

# Assign the Directory Readers Entra ID Role to the service principal
New-MgDirectoryRoleMemberByRef -DirectoryRoleId $directoryReadersRole.Id -OdataId $servicePrincipalOdataId

# Fetch the info about the current user
[Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject] $currentUser =
    Invoke-MgGraphRequest -Method GET -Uri '/v1.0/me'

# OData IDs need to be used when assigning application ownership,
# e.g., https://graph.microsoft.com/v1.0/users/{bca3617a-4c54-45eb-9a32-744c1938242e}
[string] $currentUserOdataId = "$graphEndpoint/v1.0/users/{$($currentUser.Id)}"

# Assign the current user as the application object owner
New-MgApplicationOwnerByRef -ApplicationId $registeredApp.Id -OdataId $currentUserOdataId

# Assign the current user as the service principal owner
New-MgServicePrincipalOwnerByRef -ServicePrincipalId $servicePrincipal.Id -OdataId $currentUserOdataId

# Sign out from Microsoft Graph
Disconnect-MgGraph

#endregion Entra ID

#region Azure (Optional)

# Optionally enable browser-based login on Windows 10 and later
Update-AzConfig -EnableLoginByWam $false

# Authenticate against Azure Resource Manager
Connect-AzAccount -Environment AzureCloud -Scope Process

# Fetch the identifier of the Reader role
[string] $rootScope = '/'
[Microsoft.Azure.Commands.Resources.Models.Authorization.PSRoleDefinition] $azureReaderRole =
    Get-AzRoleDefinition -Scope $rootScope -Name 'Reader'

if (-not (Test-Path -Path 'variable:servicePrincipal')) {
    # Fetch the service principal if the Azure part of the script is executed independently
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphServicePrincipal] $servicePrincipal = 
        Get-AzADServicePrincipal -DisplayName 'BloodHound Enterprise Collector'
}

# Fetch the Tenant Root Group
[guid] $currentTenantId = (Get-AzContext).Tenant.Id
[Microsoft.Azure.Commands.Resources.Models.ManagementGroups.PSManagementGroup] $rootManagementGroup =
    Get-AzManagementGroup -GroupName $currentTenantId

# Assign the Reader role on all Azure subscriptions to AzureHound
[Microsoft.Azure.Commands.Resources.Models.Authorization.PSRoleAssignment] $readerRoleAssignment = 
    New-AzRoleAssignment -ObjectId $servicePrincipal.Id -Scope $rootManagementGroup.Id -RoleDefinitionId $azureReaderRole.Id

# Sign out from Azure Resource Manager
Disconnect-AzAccount -Scope Process

#endregion Azure (Optional)
```
