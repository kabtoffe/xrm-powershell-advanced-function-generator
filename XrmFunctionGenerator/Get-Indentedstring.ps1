
function Add-Indentation{
    [CmdletBinding()]

    param(
        [Parameter(ValueFromPipeline=$true)]
        [string[]]$StringToIndent,
        
        [int]$Steps = 1,
        
        [string]$Indentor = "`t"
    )

    BEGIN {
        $Indentation = (1..$Steps | ForEach-Object { "$Indentor" }) -join ""
    }

    PROCESS {
        foreach ($string in $StringToIndent){
            ($string -split "`n" | ForEach-Object {
                "$Indentation$_"
            }) -join "`n"
        }
    }
}