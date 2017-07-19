#Requires -modules Microsoft.Xrm.Data.PowerShell
#Generated using https://github.com/kabtoffe/xrm-powershell-advanced-function-generator

function Remove-$Prefix$EntityDisplayName {
    [CmdletBinding()]

    param(

    [Parameter(Position=0, ParameterSetName="Guid", Mandatory=`$true)]
    [guid]`$$($EntityDisplayName)Id

    )
            
    Remove-CrmRecord -EntityLogicalName $EntityLogicalName -Id `$$($EntityDisplayName)Id
    
}