function Mount-SpecialFolder {
    <#
    .Synopsis
    Creates a PSDrive for special folders in the system.

    .Description
    The Mount-SpecialFolder function creates a Windows
    PowerShell drive (PSDrive) for a specified special
    folder or all special folders in the system.

    The Mount-SpecialFolder function is run automatically
    when you import the FileSystem module. To see the PSDrives
    in your session, type "get-psdrive".
    
    .Parameter Folder
    
    Mounts only the specified special folders. Enter the name
    of a special folder or a name pattern, such as *desktop*.
    By default, Mount-SpecialFolder creates a PSDrive for every
    special folder in the system.        
    
    .Parameter PassThru
    
    Returns an object that represents the new PSDrives. By
    default, this function does not generate any output.

    .Example
    Mount-SpecialFolder

    .Example
    Mount-SpecialFolder –folder SendTo –PassThru

    .Notes
    To get a list of the special folders on your system, 
    type "[Enum]::GetValues([System.Environment+SpecialFolder])".

    .Link
    http://blogs.msdn.com/powershell/archive/2008/12/13/explore-your-environment.aspx

    .Link
    http://msdn.microsoft.com/en-us/library/system.environment.specialfolder.aspx

    .Link
    Get-PSDrive

    .Link
    New-PSDrive

    .Link
    Remove-PSDrive
    #>

    param(
    [String]$Folder="*",
    [Switch]$PassThru) 
    
    process {
        $null = $psBoundParameters.Remove("PassThru")
        $null = $psBoundParameters.Remove("Folder")
        [Enum]::GetValues([Environment+SpecialFolder]) | 
            Where-Object { $_ -like $Folder }| 
            ForEach-Object {
                $NewDriveParameters = $psBoundParameters + @{
                    Name = $_
                    PSProvider = "FileSystem"
                    Root = [Environment]::GetFolderPath($_)
                    Scope = "Global"
                }
                New-PSDrive @NewDriveParameters -ErrorAction SilentlyContinue | 
                    Where-Object { $PassThru } 
            }
    }
}
