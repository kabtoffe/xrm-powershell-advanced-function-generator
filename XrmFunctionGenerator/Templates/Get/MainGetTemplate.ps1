#Requires -modules Microsoft.Xrm.Data.PowerShell
#Generated using https://github.com/kabtoffe/xrm-powershell-advanced-function-generator
function Get-$Prefix$EntityDisplayName {
    [CmdletBinding()]

    param(

        [Parameter(Position=0, ParameterSetName="Guid", Mandatory=`$true, ValueFromPipeline=`$true)]
        [guid]`$$($EntityDisplayName)Id,
        $(
            $AttributeValueFromPipeline = $false
            . "$ModuleRootDir\Templates\Common\CommonAttributes.ps1"
        )
        [Parameter(Position=999, ParameterSetName="Common")]
        [Parameter(Position=999, ParameterSetName="Guid")]
        [string[]]`$Fields = "*"
    )

    switch (`$PSCmdlet.ParameterSetName){

        "Guid" {
            Get-CrmRecord -EntityLogicalName $EntityLogicalName -Id `$$($EntityDisplayName)Id -Fields `$Fields
        }

        default {

            $(
                . "$ModuleRootDir\Templates\Common\ParameterValueLogic.ps1"
            )

            `$conditions = @()

            $(
                . "$ModuleRootDir\Templates\Get\FilteringLogic.ps1"
            )

            `$FetchXml = Get-FetchXml -EntityLogicalName $EntityLogicalName -Conditions `$conditions -Fields `$Fields

            (Get-CrmRecordsByFetch -Fetch `$FetchXml -AllRows).CrmRecords
        }

    }
    
}