New-Task -Disabled |
    Add-TaskTrigger  $EVT[0] |
    Add-TaskAction -Path Calc |
    Register-ScheduledTask "$(Get-Random)"
