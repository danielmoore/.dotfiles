Add-Type -Namespace PowershellPlatformInterop -Name Core -MemberDefinition @"
[DllImport("user32.dll", SetLastError=true)]
static extern bool EmptyClipboard();
"@

function Assert-Win32CallSuccess {
    param(
        [Switch]$PassThru,
        [Switch]$NullIsError,
        [ScriptBlock]$Action)

    $result = & $Action

    if($NullIsError -and $result -eq 0 -or -not $NullIsError -and $result -ne 0) {
        [Runtime.InteropServices.Marshal]::GetLastWin32Error()
    } 
    
    if ($PassThru) {
        $result
    }
}