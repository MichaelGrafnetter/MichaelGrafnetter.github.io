---
id: 3151
title: 'Moje slajdy z&nbsp;TechEd 2015'
date: 2015-05-31T17:29:04+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/3101-revision-v1/
permalink: /3101-revision-v1/
---
<p style="text-align: justify;">
  Ešte raz ďakujem všetkým účastníkom mojich prednášok na&nbsp;konferencii <a title="TechEd" href="http://www.teched.cz/">TechEd 2015</a>, plné kinosály ma príjemne prekvapili. Tu sú slajdy, ktoré som premietal:
</p>

  * [Obrana proti pass-the-hash útokom](https://www.dsinternals.com/wp-content/uploads/teched2015_pth.pdf)
  * [Ako funguje Active Directory databáza](https://www.dsinternals.com/wp-content/uploads/teched2015_addb.pdf)
  * [Novinky v&nbsp;PowerShell 5 Preview](https://www.dsinternals.com/wp-content/uploads/teched2015_ps5.pdf)

<p style="text-align: justify;">
  A&nbsp;tu sú príklady, na&nbsp;ktorých som ukazoval novinky v&nbsp;PowerShell 5:
</p>

<p style="text-align: justify;">
  <!--more-->
</p>

<pre title="PowerShell 5 Demos" class="lang:ps decode:true">#region Init
function prompt()
{
    'PS 5 &gt; '
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
    Convert-String -Example @{Before = 'Bill Gates'; After&nbsp;= 'Gates, B.'}

"123456789", "987654321" | Convert-String -Example `
        @{Before = '608352094'; After&nbsp;= '+420 608 352 094'},
        @{Before = '786457324'; After&nbsp;= '+420 786 457 324'}


notepad .\Parsing\data.txt
notepad .\Parsing\template.txt

Get-Content .\Parsing\data.txt |
    ConvertFrom-String -TemplateFile .\Parsing\template.txt | Out-GridView
    # -IncludeExtent # -UpdateTemplate

#endregion Machine Learning


#region OData
$uri = "http://services.odata.org/V3/(S(readwrite))/OData/OData.svc/"

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

# Test the&nbsp;enum
[Color]::Blue

# Define a&nbsp;function that&nbsp;uses it
function Get-ColorCode([Color] $Color)
{
    switch($Color)
    {
        ([Color]::Red) { '#FF0000' }
        ([Color]::Green) { '#00FF00' }
        ([Color]::Blue) { '#0000FF' }
    }
}

# Call the&nbsp;function
Get-ColorCode -Color Blue

#endregion Enums

#region Classes

# Define a&nbsp;class
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

class Dog&nbsp;: Pet
{
    Dog([string] $Name)&nbsp;: base($Name)
    {
    }
    
    [string] Greet()
    {
        return 'Bark'
    }
}

# Use the&nbsp;class
[Pet] $pet = [Dog]::new('Rex')
$pet.Name
$pet.Greet()

#endregion Classes</pre>

&nbsp;