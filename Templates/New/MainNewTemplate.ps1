#Requires -modules Microsoft.Xrm.Data.PowerShell
#Generated using https://github.com/kabtoffe/xrm-powershell-advanced-function-generator
$(
    Write-Verbose $attributes.Count
)
function New-$Prefix$EntityDisplayName {
    [CmdletBinding()]

    param(

        $(
            $Pos = 1
            foreach ($attribute in $Attributes){
                
                switch ($attribute.AttributeType){

                    "string" {
                        "`n`t[Parameter(Position=$Pos, ParameterSetName=`"Guid`")]"
                        "`n`t[string]`$$($Attribute.DisplayName),`n"
                    }

                    "picklist" {
                        "`n`t[ValidateSet("
                        ($Attribute.Options.Values | ForEach-Object {
                                "`"$_`""
                            }) -join ","
                        ")]"
                        "`n`t[Parameter(Position=$Pos, ParameterSetName=`"Guid`")]"
                        "`n`t[string]`$$($Attribute.DisplayName),`n"
                    }
                }

                $Pos++
            }

            
        )

        [Parameter(Position=999, ParameterSetName="Guid")]
        [hashtable]`$Fields=@{}
        
    )

    $(
        foreach ($attribute in $Attributes | Where-Object AttributeType -eq "Picklist"){
            @"
            `$$($attribute.DisplayName)Value = `$null

            switch (`$$($attribute.DisplayName)){
                $(
                    foreach ($OptionKey in $Attribute.Options.Keys){
                        "`n`t`t`"$($Attribute.Options[$OptionKey])`" { `$$($attribute.DisplayName)Value = $OptionKey }"
                    }
                )
                `tdefault {}
            }
"@
        }
        foreach ($attribute in $Attributes){

            switch ($attribute.AttributeType){

                "Picklist"{
                    "`n`tif (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName))){"
                    "`n`t`t`$Fields.Add(`"$($attribute.SchemaName.ToLower())`",(New-CrmOptionSetValue -Value `$$($attribute.DisplayName)Value))"
                    "`n`t}"
                }

                default {
                    "`n`tif (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName))){"
                    "`n`t`t`$Fields.Add(`"$($attribute.SchemaName.ToLower())`",`$$($attribute.DisplayName))"
                    "`n`t}"
                }
            }
        }
    )

    New-CrmRecord -EntityLogicalName $EntityLogicalName -Fields `$Fields
}