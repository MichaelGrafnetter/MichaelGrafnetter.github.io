<#
.SYNOPSIS
Finds assets that are not referenced by any MD file.
#>

[string] $assetsDir = Join-Path $PSScriptRoot assets
[string[]] $assetFileNames = Get-ChildItem -Path $assetsDir -File -Recurse -Exclude *.scss |
    Sort-Object -Property Name |
    Select-Object -ExpandProperty Name
[string[]] $contentFilePaths = Get-ChildItem -Path $PSScriptRoot -File -Recurse -Include *.md |
    Select-Object -ExpandProperty FullName

[string[]] $referencedAssets = Select-String -Path $contentFilePaths -Pattern $assetFileNames -SimpleMatch |
    Sort-Object -Property Pattern -Unique |
    Select-Object -ExpandProperty Pattern

Compare-Object -ReferenceObject $assetFileNames -DifferenceObject $referencedAssets |
    Select-Object -ExpandProperty InputObject

pause