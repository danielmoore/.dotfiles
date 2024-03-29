function Export-FormatView
{
    <#
    .Synopsis
        Exports a View Definition for a particular type
    .Description
        Creates a ViewDefinition element to show only a few properties of any type
    .Example
        [Windows.Controls.ContentControl] | Export-FormatPs1Xml
    .Parameter Type        
        The type to create a view definition for
    .Parameter Property
        One or more properties to display for the type
    .Parameter Label
        Alternative labels to display for each column
    .Parameter Width
        Specific widths of each column
    #>
    param(
    [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
    [Type]$Type,

    [Parameter(Mandatory=$true,
        HelpMessage="Enter the name of one or more properties to show for the type.")]    
    [string[]]$Property,
    
    [string[]]$Label = @(),
    
    [int[]]$Width = @()
    )
    
    
    process {
        $headers = ""
        $columnItems = ""
        for ($i = 0; $i -lt $property.Count; $i++) {
            if ($width[$i] -or $label[$i]) {
                $headers += "<TableColumnHeader>
                    "
                if ($width[$i]) {
                    $headers += "    <Width>$($width[$i])</Width>
                    "
                }
                if ($label[$i]) {
                    $headers += "    <Label>$($label[$i])</Label>
                    "
                }
                $headers += "</TableColumnHeader>
                    "
            } else {
                $headers += "<TableColumnHeader/>
                    "
            }
            $columnItems += "
                            <TableColumnItem>
                                 <PropertyName>$($property[$i])</PropertyName>
                            </TableColumnItem>"
        }
@"
        <View>
            <Name>$($type.Fullname)</Name>
            <ViewSelectedBy>
                <TypeName>$($type.FullName)</TypeName>
            </ViewSelectedBy>        
            <TableControl>
                <TableHeaders>
                    $($headers.Trim())
                </TableHeaders>
                <TableRowEntries>
                    <TableRowEntry>
                        <TableColumnItems>
                            $($columnItems.Trim())
                        </TableColumnItems>
                    </TableRowEntry>
                </TableRowEntries>
            </TableControl>
        </View>
"@
    }
}
