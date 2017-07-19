#Requires -modules Microsoft.Xrm.Data.PowerShell
#Generated using https://github.com/kabtoffe/xrm-powershell-advanced-function-generator
$(
    Write-Verbose $attributes.Count
)
function Set-$Prefix$EntityDisplayName {
    [CmdletBinding()]

    param(

        $(
            if ($EntityLogicalName -ne $EntityDisplayName){
                "`t[alias(`"$($EntityLogicalName)id`")]"
            }
        )
        [Parameter(Position=0, ParameterSetName="Common", Mandatory=`$true, ValueFromPipelineByPropertyName=`$true)]
        [guid]`$$($EntityDisplayName)Id,

        $(
            . ".\Templates\Common\CommonAttributes.ps1"
        )

        [Parameter(Position=999, ParameterSetName="Common")]
        [hashtable]`$Fields=@{}
        
    )

    BEGIN {

        $(
            . ".\Templates\Common\CommonLogic.ps1"
        )
    }
    PROCESS{
        Set-CrmRecord -EntityLogicalName $EntityLogicalName -Id `$$($EntityDisplayName)Id -Fields `$Fields
    }
}