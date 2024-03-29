Function Get-LogicalDiskInventory
{
    <#
    .Synopsis
    Gets the local disks on the local and remote computers.

    .Description
    The Get-LogicalDiskInventory function gets information about the local, 
    non-removable logical disks on the local computer and remote computers.

    .Parameter ComputerName
    Enter the names of local and remote computers. The default is the
    local computer ("localhost").

    .Notes
    Get-LogicalDiskInventory uses the Win32_LogicalDisk WMI class and
    then selects only local disks.

    .Example
    Get-LogicalDiskInventory

    DeviceID     : C:
    DriveType    : 3
    ProviderName :
    FreeSpace    : 38379925504
    Size         : 73339588608
    VolumeName   :

    .Example
    get-logicalDiskInventory –computerName server01

    .Example
    get-logicalDiskInventory –computerName localhost, server01, server12
    #>

    param(
    # The Computer Name to connect to.  Default is localhost
    $computername="Localhost"
    )
    Get-WmiObject -Class Win32_LogicalDisk -filter "drivetype = 3" `
        -ComputerName $computername -Impersonation Impersonate -Authentication PacketPrivacy
} 
