<#
    .SYNOPSIS
    Takes a list of ARGB hex values and blends them in order against a white background.
    
    .PARAMETER colors
    A list of ARGB hex color strings.
    
    .EXAMPLE
    Blend-Colors '#ff121212', '#705F6A87'
    
    .LINK
    http://en.wikipedia.org/wiki/Alpha_compositing
#>
function Blend-Colors ([Parameter(Mandatory=$true)][string[]]$colors) {
    # $argbHexColorRegex should recognize all 4-byte hex color strings prefixed with a '#'
    # and assign them to groups named a, r, g, and b for each channel, respectively.
    Set-Variable argbHexColorRegex -Option Constant -Value '(?i)^#(?<a>[0-9A-F]{2})(?<r>[0-9A-F]{2})(?<g>[0-9A-F]{2})(?<b>[0-9A-F]{2})$'
    Set-Variable argb -Option Constant -Value 'a','r','g','b'
    Set-Variable rgb -Option Constant -Value 'r','g','b'

    function Merge-Channel ($c0, $c1, $c) {
        $a0 = $c0.a / 255
        $a1 = $c1.a / 255
        return $a0 * $c0.$c + $a1 * $c1.$c * (1 - $a0)
    }

    $argb | % { $baseColor = @{} } { $baseColor.$_ = 255 } # set $baseColor to white (#FFFFFFFF)

    foreach($color in $colors) {
        if(-not $color -match $argbHexColorRegex) {
            throw 'Invalid color: ' + $_
        }
        
        $argb | % { $addColor = @{} } { $addColor.$_ =  [int]::Parse($matches.$_, 'AllowHexSpecifier') }
                
        $rgb | % `
            { $mergeColor = @{ a = [Math]::Min(255, $baseColor.a + $addColor.a) } } `
            { $mergeColor.$_ = Merge-Channel $addColor $baseColor $_ }
            
        $baseColor = $mergeColor
    }

    return '#{0:x2}{1:x2}{2:x2}{3:x2}' -f ($argb | % { [int][Math]::Round($baseColor.$_, 0) })
}
