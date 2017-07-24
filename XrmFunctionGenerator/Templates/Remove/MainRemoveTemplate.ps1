#Requires -modules Microsoft.Xrm.Data.PowerShell
#Generated using https://github.com/kabtoffe/xrm-powershell-advanced-function-generator

function Remove-$Prefix$EntityDisplayName {
    [CmdletBinding()]

    param(
    $(
        if ($EntityLogicalName -ne $EntityDisplayName){
            "`t `t[alias(`"$($EntityLogicalName)id`")]"
        }
    )
        [Parameter(Position=0, Mandatory=`$true, ValueFromPipelineByPropertyName=`$true, ValueFromPipeline=`$true)]
        [guid]`$$($EntityDisplayName)Id

    )

    PROCESS{
        Remove-CrmRecord -EntityLogicalName $EntityLogicalName -Id `$$($EntityDisplayName)Id
    }
    
}