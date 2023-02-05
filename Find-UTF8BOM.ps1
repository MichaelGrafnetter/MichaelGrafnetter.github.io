Function ContainsBOM
{   
    return $input | where {
        $contents = new-object byte[] 3
        $stream = [System.IO.File]::OpenRead($_.FullName)
        $stream.Read($contents, 0, 3) | Out-Null
        $stream.Close()
        $contents[0] -eq 0xEF -and $contents[1] -eq 0xBB -and $contents[2] -eq 0xBF }
}

Get-ChildItem -Path $PSScriptRoot -Recurse -File | where Length -gt 2 | ContainsBOM

pause