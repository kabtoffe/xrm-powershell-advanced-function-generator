function Get-IndentedString{

    param(
        [string[]]$StringToIndent,
        [int]$Steps,
        [string]$Indentor = "`t"
    )

    $Indentation = (1..$Steps | ForEach-Object { "$Indentor" }) -join ""

    foreach ($string in $StringToIndent){
        ($string -split "`r`n" | ForEach-Object {
            "$Indentation$_"
        }) -join "`n"
    }
}