function Get-$EntityDisplayName {
    [CmdletBinding()]

    param(

        [Parameter(Position=0, ParameterSetName="Guid", Mandatory=`$true)]
        [guid]`$$($EntityDisplayName)Id,

        $(
            $Position = 0
            foreach ($attribute in $Attributes){
                . ".\Templates\Get\$($attribute.AttributeType)Parameter.ps1"
                $Position++
            }
        )

        [Parameter(Position=999, ParameterSetName="Query")]
        [Parameter(Position=999, ParameterSetName="Guid")]
        [string[]]`$Fields = "*"
    )

    switch (`$PSCmdlet.ParameterSetName){

        "Guid" {
            Get-CrmRecord -EntityLogicalName $EntityLogicalName -Id `$$($EntityDisplayName)Id -Fields `$Fields
        }

        default {

            $(
                foreach ($attribute in $attributes | Where-Object AttributeType -eq "Picklist") {
                    . ".\Templates\Common\PicklistValue.ps1"
                }
            )
               

            (Get-CrmRecords -EntityLogicalName $EntityLogicalName -FilterAttribute name -FilterOperator eq -FilterValue `$Name -Fields `$Fields).CrmRecords
        }

    }

}