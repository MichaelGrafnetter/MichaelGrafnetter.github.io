---
ref: 3101
title: 'Moje slajdy z&nbsp;TechEd 2015'
date: '2015-05-31T17:27:07+00:00'
lang: sk
layout: post
permalink: /sk/moje-slajdy-z-teched-2015/
tags:
    - 'Active Directory'
    - PowerShell
    - Prednášky
    - Security
---

Ešte raz ďakujem všetkým účastníkom mojich prednášok na konferencii **TechEd 2015**, plné kinosály ma príjemne prekvapili. Tu sú slajdy, ktoré som premietal:

- [Obrana proti pass-the-hash útokom](../../assets/documents/teched2015_pth.pdf)
- [Ako funguje Active Directory databáza](../../assets/documents/teched2015_addb.pdf)
- [Novinky v PowerShell 5 Preview](../../assets/documents/teched2015_ps5.pdf)

A tu sú príklady, na ktorých som ukazoval novinky v PowerShell 5:

```powershell
#region Init
function prompt()
{
    'PS 5 > '
}
cls
#endregion Init

#region Links

# Create file symbolic link
New-Item -ItemType SymbolicLink -Path .\picture2.jpg -Target .\picture.jpg

# Create file hard link
New-Item -ItemType HardLink -Path .\picture3.jpg -Target .\picture.jpg

# Create directory symbolic link
New-Item -ItemType SymbolicLink -Name Win -Target $env:windir

# List links
Get-ChildItem | select Name,Mode,LinkType,Target | Format-Table

# Cleanup
Remove-Item .\picture2.jpg, .\picture3.jpg

Remove-Item .\Win

cmd /c rmdir .\Win


#endregion Links

#region ZIP

# Zip
Compress-Archive -Path .\ZipTest -DestinationPath .\test.zip -CompressionLevel Optimal

# Unzip
Expand-Archive -Path .\test.zip -DestinationPath .\ZipTest2

# Cleanup
Remove-Item .\ZipTest2 -Force
Remove-Item .\test.zip

#endregion ZIP

#region Machine Learning

"Lee Holmes", "Steve Lee", "Jeffrey Snover" |
    Convert-String -Example @{Before = 'Bill Gates'; After = 'Gates, B.'}

"123456789", "987654321" | Convert-String -Example `
        @{Before = '608352094'; After = '+420 608 352 094'},
        @{Before = '786457324'; After = '+420 786 457 324'}


notepad .\Parsing\data.txt
notepad .\Parsing\template.txt

Get-Content .\Parsing\data.txt |
    ConvertFrom-String -TemplateFile .\Parsing\template.txt | Out-GridView
    # -IncludeExtent # -UpdateTemplate

#endregion Machine Learning


#region OData
$uri = "https://services.odata.org/V3/(S(readwrite))/OData/OData.svc/"

Export-ODataEndpointProxy -Uri $uri -OutputModule .\Service -Force -AllowUnSecureConnection -AllowClobber

Import-Module .\Service -Force

Get-Command -Module Service

Get-Product -AllowUnsecureConnection -AllowAdditionalData

Get-Product -OrderBy Price -Top 1 -AllowUnsecureConnection -AllowAdditionalData

Set-Product -ID 0 -Price 3 -AllowUnsecureConnection -Force


Remove-Module Service
Remove-Item .\Service -Force

#endregion OData

#region OneGet

Get-Command -Module OneGet

Get-PackageProvider
Get-PackageSource

Get-Package -ProviderName msi

Find-Package -ProviderName Chocolatey -Name firefox

Install-Package vlc -Force -ForceBootstrap
Install-Package firefox -Force -ForceBootstrap

Get-Package -ProviderName Chocolatey | Uninstall-Package -Force -ForceBootstrap

#endregion OneGet


#region Enums

# Define an enumerated type
enum Color
{
    Green
    Red
    Blue
}

# Test the enum
[Color]::Blue

# Define a function that uses it
function Get-ColorCode([Color] $Color)
{
    switch($Color)
    {
        ([Color]::Red) { '#FF0000' }
        ([Color]::Green) { '#00FF00' }
        ([Color]::Blue) { '#0000FF' }
    }
}

# Call the function
Get-ColorCode -Color Blue

#endregion Enums

#region Classes

# Define a class
class Pet
{
    Pet([string] $Name)
    {
        $this.Name = $Name
    }
    [string] $Name
    [string] Greet()
    {
        return 'Hello'
    }
}

class Dog : Pet
{
    Dog([string] $Name) : base($Name)
    {
    }
    
    [string] Greet()
    {
        return 'Bark'
    }
}

# Use the class
[Pet] $pet = [Dog]::new('Rex')
$pet.Name
$pet.Greet()

#endregion Classes
```