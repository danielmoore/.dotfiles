function prompt {
    $historyId = (get-history -Count 1).Id + 1
    Write-Host "PS $(pwd)>" -ForegroundColor Gray
    Write-Host "$historyId >" -ForegroundColor Gray -NoNewline
    return ' '
}

function Find-File {
    [CmdletBinding(DefaultParameterSetName = 'Count')]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name,
        [Parameter(Position = 1)] 
        [string]$Directory = '.', 
        [Parameter(ParameterSetName = 'Count')]
        [int]$MaxResults = 1,
        [Parameter(ParameterSetName = 'All')]
        [Switch]$All
    )

    $selectArgs = @{ ExpandProperty = 'FullName' }
    
    if (-not $All) { $selectArgs['First'] = $MaxResults }

    ls $Directory $Name -Recurse | select @selectArgs
}

Set-Alias find Find-File

Set-Alias npp "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe"

Import-Module Clipboard

Set-Alias sct Set-ClipboardText
