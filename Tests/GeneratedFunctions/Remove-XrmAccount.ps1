#Requires -modules Microsoft.Xrm.Data.PowerShell
#Generated using https://github.com/kabtoffe/xrm-powershell-advanced-function-generator

function Remove-XrmAccount {
    [CmdletBinding()]

    param(
    
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true)]
        [guid]$AccountId

    )

    PROCESS{
        Remove-CrmRecord -EntityLogicalName account -Id $AccountId
    }
    
}
