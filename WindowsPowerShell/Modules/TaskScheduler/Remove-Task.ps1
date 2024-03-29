function Remove-Task
{
    <#
    .Synopsis
        Removes a scheduled task
    .Description
        Removes a scheduled task from the computer.
    .Example
        New-Task | 
            Add-TaskAction -Script { 
                Get-Process | Out-GridView
                Start-Sleep 100
            } | 
            Register-ScheduledTask (Get-Random) |
            Remove-Task
    #>
    [CmdletBinding(DefaultParameterSetName="Task")]
    param(
    # The Name of the task to remove
    [Parameter(Mandatory=$true, 
        ParameterSetName="Name")]
    [String]
    $Name,
    
    # The scheduled task to remove.  This value can be supplied with the output of Get-ScheduledTask
    [Parameter(ParameterSetName="Task", 
        ValueFromPipeline=$true)]
    $Task,
        
    # The folder the scheduled task is in
    [Parameter()]
    [String[]]
    $Folder = "",
    
    # If this is set, hidden tasks will also be shown.  
    # By default, only tasks that are not marked by Task Scheduler as hidden are shown.
    [Switch]
    $Hidden,    
    
    # The name of the computer to connect to.
    $ComputerName,
    
    # The credential used to connect
    [Management.Automation.PSCredential]
    $Credential,
    
    # If set, will get tasks recursively beneath the specified folder
    [switch]
    $Recurse
    )
    
    process {
        switch ($psCmdlet.ParameterSetName) {
            Task { 
                $scheduler = Connect-ToTaskScheduler -ComputerName $ComputerName -Credential $Credential
                $folder =$scheduler.GetFolder("")
                $folder.DeleteTask($task.Path, 0)
            }
            Name {
                Get-ScheduledTask @PSBoundParameters | 
                    Remove-Task
            }
        }
    }
}
