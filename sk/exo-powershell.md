---
ref: exo-powershell-demos
title: Exchange Online PowerShell Course
date: 2023-10-15T00:00:00+00:00
layout: page
lang: sk
permalink: /exo/
sitemap: false
---

## Agenda
{:.no_toc}

1. This is a TOC placeholder.
{:toc}

## PowerShell Introduction

### PowerShell Versions

### Command Line vs. Scripts

### PowerShell Terminals and Editors

### Service Health Status REST API

- [Service Health Status Web](https://status.office365.com/api/feed/)
- Microsoft 365 Admin Center Status RSS: `https://status.office365.com/api/feed/mac`
- Power Platform Admin Center RSS: `https://status.office365.com/api/feed/ppac`

### Basic Syntax

#### Cmdlets

```powershell
Invoke-RestMethod -Name 'https://status.office365.com/api/feed/mac' -UseBasicParsing
```

#### Parameters

#### Aliases

#### Comments

#### Help System

## Working with Pipeline

### Measure-Object

### Formatting Cmdlets

### Select-Object

### Where-Object

### Foreach-Object

## File Input/Output

## Variables, Data Types, and Arithmetics

### Numbers

### Strings

### Date and Time

### Arrays

### Hash Tables

### JSON

### XML

## PowerShell Modules for Exchange Online

## Exchange Online PowerShell

### Basics

```powershell
Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force

Import-Module -Name ExchangeOnlineManagement

Get-Command -Module ExchangeOnlineManagement

Connect-ExchangeOnline -ShowBanner:$false -AzureADAuthorizationEndpointUri https://login.microsoftonline.com/aadcourse.onmicrosoft.com

Get-ConnectionInformation

Get-Command -Module tmpEXO_*

Get-EXOMailbox -ResultSize Unlimited

Get-User -ResultSize Unlimited

Get-User -ResultSize Unlimited | Format-Table -Auto -Property Name,DisplayName,RemotePowerShellEnabled

Set-User -Identity chris@contoso.onmicrosoft.com -RemotePowerShellEnabled $true

Disconnect-ExchangeOnline -Confirm:$false
```

### Filtering

### Mailbox Creation

### Mailbox Permission Reporting

### Role-Based Access Control

## Microsoft Graph API

## PowerShell Scripts

### Naming Conventions

### Execution Policy

### Script Parameters

### Functions

### Loops

## Error Handling

## Further Reading
