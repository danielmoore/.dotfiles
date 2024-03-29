function Blend-Colors (
    [string] $background = '#FFFFFFFF',
    [Parameter(ValueFromPipeline = $true)] [string[]] $colors = $null) {
    begin {
        # $argbHexColorRegex should recognize all 4-byte hex color strings prefixed with a '#'
        # and assign them to groups named a, r, g, and b for each channel, respectively.
        Set-Variable argbHexColorRegex -Option Constant `
            -Value "(?i)^#(?'a'[0-9A-F]{2})(?'r'[0-9A-F]{2})(?'g'[0-9A-F]{2})(?'b'[0-9A-F]{2})$"
        
        Set-Variable argb -Option Constant -Value 'a','r','g','b'
        Set-Variable rgb -Option Constant -Value 'r','g','b'

        function Parse-Color ([string] $hex) {
            if($hex -match $argbHexColorRegex) {
                $argb | % { $color = @{} } { $color.$_ =  [int]::Parse($matches.$_, 'AllowHexSpecifier') }
                return $color;
            } else {
                return $null;
            }
        }

        function Merge-Channel ($c0, $c1, $c) {
            $a0 = $c0.a / 255
            $a1 = $c1.a / 255
            return $a0 * $c0.$c + $a1 * $c1.$c * (1 - $a0)
        }
        
        $outColor = Parse-Color $background
        if(-not $outColor) {
            throw (New-Object ArgumentException -ArgumentList "Invalid color: '$background'", 'background')
        }
    }
    process {
        @($colors) | % {
            $addColor = Parse-Color $_
            if(-not $addColor) {
                Write-Error "Invalid input color: $_"
                break
            }
            
            $rgb | % `
                { $mergeColor = @{ a = [Math]::Min(255, $outColor.a + $addColor.a) } } `
                { $mergeColor.$_ = Merge-Channel $addColor $outColor $_ }
                
            $outColor = $mergeColor
        }
    }
    end {
        return '#{0:x2}{1:x2}{2:x2}{3:x2}' -f ($argb | % { [int][Math]::Round($outColor.$_, 0) })
    }
}
