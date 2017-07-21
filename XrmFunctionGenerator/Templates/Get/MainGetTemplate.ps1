#Requires -modules Microsoft.Xrm.Data.PowerShell
#Generated using https://github.com/kabtoffe/xrm-powershell-advanced-function-generator
function Get-$Prefix$EntityDisplayName {
    [CmdletBinding()]

    param(

        [Parameter(Position=0, ParameterSetName="Guid", Mandatory=`$true)]
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
            
            #Superslow filtering mechanism. To be replaced with a FetchXML-generated version.
            if (`$Fields -ne "*"){
            `$AdditionalFieldsToGet = @()
            
             $(
                . "$ModuleRootDir\Templates\Get\FieldsToGetLogic.ps1"
                
                
            )

                `$Fields = (`$Fields + `$AdditionalFieldsToGet) | Select-Object -Unique
                Write-Verbose (`$Fields -join " ")

            }

            $(
                . "$ModuleRootDir\Templates\Common\ParameterValueLogic.ps1"
            )

            `$conditions = @()

            $(
                . "$ModuleRootDir\Templates\Get\FilteringLogic.ps1"
            )

            `$FetchXml = Get-FetchXml -EntityLogicalName $EntityLogicalName -Conditions `$conditions

            (Get-CrmRecordsByFetch -Fetch `$FetchXml -AllRows).CrmRecords
        }

    }
    
}