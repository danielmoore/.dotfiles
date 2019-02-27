
New-Task |
    Add-TaskTrigger -At "3:00 PM" -DayOfMonth 1,2,3,4,5 -MonthOfYear January, April, December |
    Add-TaskAction -Path calc.exe |
    Register-ScheduledTask (Get-Random)
