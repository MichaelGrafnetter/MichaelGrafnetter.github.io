[string[]] $rules = @(
    'an',
    'are',
    'as',
    'be',
    'so',
    'or',
    'if',
    'it',
    'is',
    'and',
    'but',
    'nor',
    'for',
    'yet',
    'now',
    'til',
    'who',
    'why',
    'his',
    'lest',
    'once',
    'even',
    'than',
    'that',
    'this',
    'when',
    'after',
    'as if',
    'since',
    'some',
    'from',
    'until',
    'which',
    'where',
    'while',
    'before',
    'though',
    'unless',
    'whoever',
    'with',
    'even if',
    'because',
    'whereas',
    'just as',
    'so that',
    'if only',
    'if when',
    'if then',
    'whether',
    'where if',
    'wherever',
    'inasmuch',
    'provided',
    'although',
    'now when',
    'now that',
    'whenever',
    'as though',
    'now since',
    'supposing',
    'as long as',
    'as much as',
    'as soon as',
    'rather than',
    'even though',
    'in order that',
    'provided that',
    'by',
    'the',
    'in',
    'of',
    'z',
    'k',
    's',
    'aj',
    'i',
    'v',
    'vo',
    'od',
    'do',
    'a',
    'že',
    'so',
    'na',
    'si',
    'sa',
    'lebo',
    'sú',
    'ale',
    'už',
    'to',
    'pod',
    'ho',
    'len',
    'o',
    'je',
    'za',
    'pre',
    'cez',
    'či'
)

[bool] $inCode = $false
[bool] $inFrontMatter = $false

Get-ChildItem -Path $PSScriptRoot -Filter *.md -File -Recurse | ForEach-Object {
    $newContent = Get-Content -Path $PSItem.FullName -Encoding UTF8 | ForEach-Object {
        [string] $line = $PSItem

        # Detect code blocks
        [bool] $inlineCode = $false
        switch -Wildcard ($line)
        {
            '``````*' { $inCode = -not $inCode }
            '---' { $inFrontMatter = -not $inFrontMatter }
            '{*' { $inlineCode = $true }
        }

        if(-not ($inFrontMatter -or $inCode -or $inlineCode))
        {
            # Do not touch code blocks and front matter
            foreach($rule in $rules)
            {
                $line = $line -replace "( $rule) ",'$1&nbsp;'
                $line = $line -replace "(&nbsp;$rule) ",'$1&nbsp;'
            }
        }

        # Output
        $line
    }

    Set-Content -Path $PSItem.FullName -Value $newContent -Encoding UTF8 -Verbose -Force
}