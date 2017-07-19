#Requires -modules Microsoft.Xrm.Data.PowerShell
#Generated using https://github.com/kabtoffe/xrm-powershell-advanced-function-generator
function Get-$Prefix$EntityDisplayName {
    [CmdletBinding()]

    param(

        [Parameter(Position=0, ParameterSetName="Guid", Mandatory=`$true)]
        [guid]`$$($EntityDisplayName)Id,

        $(
            . ".\Templates\Common\CommonAttributes.ps1"
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
                . ".\Templates\Get\FieldsToGetLogic.ps1"
                
            )

                `$Fields = (`$Fields + `$AdditionalFieldsToGet) | Select-Object -Unique
                Write-Verbose (`$Fields -join " ")

            }

            
            `$Records = (Get-CrmRecords -EntityLogicalName $EntityLogicalName -Fields `$Fields -AllRows).CrmRecords

            Write-Verbose "`$(`$Records.Count) found"

            $(
                . ".\Templates\Get\FilteringLogic.ps1"
            )

            Write-Verbose "Filtered to `$(`$Records.Count) found"

            Write-Output `$Records
        }

    }
    
}