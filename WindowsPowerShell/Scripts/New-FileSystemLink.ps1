@"
[DllImport("kernel32.dll", SetLastError=true, CharSet=CharSet.Auto)]
static extern bool CreateHardLink(string lpFileName, string lpExistingFileName, IntPtr lpSecurityAttributes);

[DllImport("kernel32.dll")]
[return: System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.I1)]
static extern bool CreateSymbolicLink(string lpSymlinkFileName, string lpTargetFileName, SYMBOLIC_LINK_FLAG dwFlags);


"@

function New-Link {
    param(
        [Switch]$Symbolic,
        [Parameter(Mandatory=$true)]
        [string]$Link,
        [Parameter(Mandatory=$true)]
        [string]$Target
    )

    $targetInfo = ls $Target

    $isDir = $targetInfo -is [IO.DirectoryInfo]

    
}
