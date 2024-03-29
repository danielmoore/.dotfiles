function Rename-Drive {
    <#
    .Synopsis
    Renames a file system drive.

    .Description 
    The Rename-Drive function provides a new volume name for
    a drive on the local computer. 

    To use this function, start Windows PowerShell with the "Run as
    administrator" option.

    .Parameter Drive
    
    Enter the drive letter of the drive to be renamed. 

    .Parameter Name

    Enter a new volume name for the drive. The default is
    $null (no volume name).
    
    .Notes
    This function uses the Win32_LogicalDisk WMI class and
    the VolumeName property of the object that it returns. 

    .Example    
    Rename-Drive –drive C: -name MainDrive

    .Example
    Resets the name of C:
    Rename-Drive  -drive C: 

    #>     
     
    param(
    [String]$Drive = "C:", 
    [String]$Name)
    $wmiDrive = Get-WmiObject "Win32_LogicalDisk WHERE DeviceID='$drive'"
    if (-not $wmiDrive) { return }                      
    $wmiDrive.VolumeName = $name
    $null = $wmiDrive.Put()
}
