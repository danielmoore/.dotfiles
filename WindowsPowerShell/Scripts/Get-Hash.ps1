function Get-Hash {
    [CmdletBinding(DefaultParameterSetName='file:sha1')]
    param(
        [Parameter(ParameterSetName='file:md5')]
        [Parameter(ParameterSetName='string:md5')]
        [Switch]
        $MD5,
        [Parameter(ParameterSetName='file:sha1')]
        [Parameter(ParameterSetName='string:sha1')]
        [Switch]        
        $SHA1,
        [Parameter(ParameterSetName='file:sha256')]
        [Parameter(ParameterSetName='string:sha256')]
        [Switch]    
        $SHA256,
        [Parameter(ParameterSetName='file:sha384')]
        [Parameter(ParameterSetName='string:sha384')]
        [Switch]   
        $SHA384,
        [Parameter(ParameterSetName='file:sha512')]
        [Parameter(ParameterSetName='string:sha512')]
        [Switch]    
        $SHA512,
        [Parameter(Position=0, ParameterSetName='file:md5')]
        [Parameter(Position=0, ParameterSetName='file:sha1')]
        [Parameter(Position=0, ParameterSetName='file:sha256')]
        [Parameter(Position=0, ParameterSetName='file:sha384')]
        [Parameter(Position=0, ParameterSetName='file:sha512')]
        [string]
        $FilePath,
        [Parameter(ParameterSetName='string:md5')]
        [Parameter(ParameterSetName='string:sha1')]
        [Parameter(ParameterSetName='string:sha256')]
        [Parameter(ParameterSetName='string:sha384')]
        [Parameter(ParameterSetName='string:sha512')]
        [string]
        $String,
        [Parameter(ParameterSetName='string:md5')]
        [Parameter(ParameterSetName='string:sha1')]
        [Parameter(ParameterSetName='string:sha256')]
        [Parameter(ParameterSetName='string:sha384')]
        [Parameter(ParameterSetName='string:sha512')]
        [Text.Encoding]
        $Encoding = [Text.Encoding]::Default
    )
        
    $input, $hashName = $PsCmdlet.ParameterSetName -split ':'
    
    $algo = [Security.Cryptography.HashAlgorithm]::Create($hashName)
    
    switch ($input) {
        'file' {
            $stream = [IO.File]::OpenRead($FilePath)
            
            try { $result = $algo.ComputeHash($stream) }
            finally { $stream.Dispose() }
        }
        
        'string' {
            $result = $algo.ComputeHash($Encoding.GetBytes($String))
        }
    }
    
    $builder = New-Object System.Text.StringBuilder
    
    foreach($b in $result) {
        [void]$builder.AppendFormat("{0:x2}", $b)
    }
     
    $builder.ToString()   
}

foreach($hashName in 'md5','sha1','sha256','sha384','sha512') {
    $functionName = "Get-" + $hashName.ToUpper()
    iex @"
function $functionName {
    [CmdletBinding(DefaultParameterSetName='FilePath')]
    param(
        [Parameter(Position=0, ParameterSetName='FilePath')]
        [string]
        `$FilePath,
        [Parameter(ParameterSetName='String')]
        [string]
        `$String
    )

    `$param = `$PsCmdlet.ParameterSetName
    `$args = @{ 
        $hashName = `$true
        `$param = `(Get-Variable `$param).Value
    }

    Get-Hash @args
}

Set-Alias $hashName $functionName
"@
}