function Group-ImageOnDisk
{
    <#
    .Synopsis
        Groups images into folders on disk. using one or more properties or script blocks
    .Description
        Groups images into folders on disk using one or more properties or script blocks
    .Example
        # Groups all the current user's photos into a directory by Month and Year
        Group-ImageOnDisk $env:UserProfile\Pictures -ScriptBlock {$_.DateTime.Month}, {$_.DateTime.Year } -Recurse     
    .Example
        # Groups all the current users's photos into a directory by Camera Make and Model
        Group-ImageOnDisk -Path $env:UserProfile\Pictures -Property "EquipMake","EquipModel"
    #>
    [CmdletBinding(DefaultParameterSetName='Property')]
    param(
    [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [String[]]
    $Path,
    
    [Parameter(ParameterSetName='Property',
        Mandatory=$true,
        Position=1)]
    [String[]]
    $Property,


    [Parameter(ParameterSetName='ScriptBlock',
        Mandatory=$true,
        Position=1)]
    [ScriptBlock[]]
    $ScriptBlock,

    [String]
    $Filter,

    [String[]]
    $Include,

    [String[]]
    $Exclude,

    [Switch]
    $Recurse,

    [Switch]
    $HideProgress)
    
    process {
        $GetChildItemParameters = @{
            Path = $psBoundParameters.Path
            Filter = $psBoundParameters.Filter
            Include = $psBoundParameters.Include
            Exclude = $psBoundParameters.Exclude
            Recurse = $psBoundParameters.Recurse
        }
        Get-ChildItem @GetChildItemParameters |
            Get-Image | 
            Get-ImageProperty |
            Copy-Item -Path { $_.FullName } -Destination {
                $newPath = ""
                $item  = $_
                if ($psCmdlet.ParameterSetName -eq "Property") {
                    foreach ($p in $property) {
                        $newPath = $newPath + ' ' + $_.$p
                    }                                        
                } else {
                    if ($psCmdlet.ParameterSetName -eq "ScriptBlock") {
                        foreach ($s in $scriptBlock) {
                            $newPath = $newPath + ' ' + (& $s)
                        }                    
                    }
                }
                if (-not $newPath.Trim()) { return }
                $newPath = $newPath.Trim() 
                $destPath = Join-Path $path $newPath
                if (-not (Test-Path $destPath)) { 
                    $null = New-Item $destPath -Force -Type Directory
                }
                $leaf = Split-Path $_.FullName -Leaf
                $fullPath = Join-Path $destPath $leaf
                if (-not $HideProgress) { 
                    $script:percent += 5
                    if ($script:percent -gt 100) { $script:percent = 0 } 
                    Write-Progress $_.FullName $fullPath -PercentComplete $percent
                }
                $fullPath
            } -ErrorAction SilentlyContinue
        
    }
}
