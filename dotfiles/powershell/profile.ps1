$dir = (Split-Path $MyInvocation.MyCommand.Path)

$env:PSMODULEPATH += ":$(Join-Path $dir modules)"
