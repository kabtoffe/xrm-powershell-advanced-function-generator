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
        [Parameter(Position=0, ParameterSetName="Guid", Mandatory=`$true, ValueFromPipelineByPropertyName=`$true)]
        [guid]`$$($EntityDisplayName)Id,

        $(
            $Pos = 1
            foreach ($attribute in $Attributes){
                
                switch ($attribute.AttributeType){

                    "string" {
                        if ($Attribute.DisplayName -ne $Attribute.SchemaName){
                            "`t[alias(`"$($Attribute.SchemaName)`")]"
                        }
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
                        "`n "
                        
                        "`n`t[ValidateSet("
                        $Pos++
                        $Attribute.Options.Keys -join ","
                        ")]"
                        "`n`t[Parameter(Position=$Pos, ParameterSetName=`"Guid`")]"
                        if ($Attribute.DisplayName -ne $Attribute.SchemaName){
                            "`n`t[alias(`"$($Attribute.SchemaName)`")]"
                        }
                        "`n`t[int]`$$($Attribute.DisplayName)Value,`n"
                    }
                }

                $Pos++
            }

            
        )

        [Parameter(Position=999, ParameterSetName="Guid")]
        [hashtable]`$Fields=@{}
        
    )

    BEGIN {

        $(
            foreach ($attribute in $Attributes | Where-Object AttributeType -eq "Picklist"){
                @"

                if (`$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)") -and `$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)Value"))    {
                   throw "Provide only one of $($attribute.DisplayName) and $($attribute.DisplayName)Value not both"
                }

                switch (`$$($attribute.DisplayName)){
                    
                    $(
                        foreach ($OptionKey in $Attribute.Options.Keys){
                            "`n`t`t`"$($Attribute.Options[$OptionKey])`" { `$$($attribute.DisplayName)Value = $OptionKey }"
                        }
                    )
                    `tdefault {
                        #Let's not change potentially provided specific value
                    }
                }
"@
            }
            foreach ($attribute in $Attributes){

                switch ($attribute.AttributeType){

                    "Picklist"{
                        "`n`tif (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName)Value)){"
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
    }
    PROCESS{
        Set-CrmRecord -EntityLogicalName $EntityLogicalName -Id `$$($EntityDisplayName)Id -Fields `$Fields
    }
}