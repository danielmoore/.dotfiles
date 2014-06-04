function Reinstall-Package {

    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Id,

        [Parameter(Mandatory = $true)]
        [string]
        $Version,

        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $ProjectName,

        [switch]
        $Force
    )

    if (-not $ProjectName) {
        $ProjectName = (get-project).ProjectName
    }

    Uninstall-Package -ProjectName $ProjectName -Id $Id -Force:$Force
    Install-Package -ProjectName $ProjectName -Id $Id -Version $Version

}