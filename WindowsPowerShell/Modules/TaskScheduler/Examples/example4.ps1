New-Task |
    Add-TaskTrigger -At "3:00 PM" -WeekOfMonth 2,4 `
        -DayOfWeek Monday, Wednesday, Friday -MonthOfYear August, April, December |
    Add-TaskAction -Path calc.exe |
    Register-ScheduledTask "$(Get-Random)"
