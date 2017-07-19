#Requires -modules Microsoft.Xrm.Data.PowerShell
#Generated using https://github.com/kabtoffe/xrm-powershell-advanced-function-generator
$(
    Write-Verbose $attributes.Count
)
function New-$Prefix$EntityDisplayName {
    [CmdletBinding()]

    param(

        $(
            . ".\Templates\Common\CommonAttributes.ps1"
        )

        [Parameter(Position=999, ParameterSetName="Common")]
        [hashtable]`$Fields=@{}
        
    )

    $(
        . ".\Templates\Common\CommonLogic.ps1"
    )

    New-CrmRecord -EntityLogicalName $EntityLogicalName -Fields `$Fields
}