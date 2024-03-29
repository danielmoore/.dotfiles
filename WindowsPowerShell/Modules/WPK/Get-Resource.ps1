function Get-Resource
{
    <#
    .Synopsis
        Finds a Resource in a visual control or the controls parents
    .Description
        Retrieves a resource stored in the Resources property of a UIElement.
        If the UIElement does not contain the resource, the parent will be checked.
        If no more parents exist, then nothing will be returned.
    .Parameter Visual
        The UI element to start looking for resources.
    .Parameter Name
        The name of the resource to find
    .Example
        New-Grid -Rows '1*', 'Auto' {
            New-ListBox -On_Loaded {
                Set-Resource "List" $this -1
            }
            New-Button -Row 1 "_Add" -On_Click {
                $list = Get-Resource "List"
                $list.ItemsSource += @(Get-Random)
            } 
        } -Show
    #>
    param(
    [String]
    $Name,
    
    $Visual    
    )
    
    process {
        $item = $Visual
        if (-not $item) { $item = $this } 
        while ($item) {
            foreach ($k in $item.Resources.Keys) {
                if ($k -ceq $Name) {
                    return $item.Resources.$k
                }
            }
            $item = $item.Parent
        }
    }
}
